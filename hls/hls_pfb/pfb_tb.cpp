#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>
#include "pfb.h"
#include <complex>

// --------------------------------------------------------
// Software Reference Models (FFT and PFB)
// --------------------------------------------------------

void sw_fft(std::vector<std::complex<double>> &val) {
    const size_t N = val.size();
    if (N <= 1) return;

    std::vector<std::complex<double>> even(N / 2);
    std::vector<std::complex<double>> odd(N / 2);

    for (size_t i = 0; i < N / 2; ++i) {
        even[i] = val[i * 2];
        odd[i] = val[i * 2 + 1];
    }

    sw_fft(even);
    sw_fft(odd);

    for (size_t k = 0; k < N / 2; ++k) {
        std::complex<double> t = std::polar(1.0, -2 * M_PI * k / N) * odd[k];
        val[k] = even[k] + t;
        val[k + N / 2] = even[k] - t;
    }
}

void sw_pfb_single_channel(
    std::vector<std::complex<double>> &input_history,
    std::vector<std::complex<double>> &new_block,
    std::vector<std::complex<double>> &output_block,
    const std::vector<double> &coeffs
) {
    // 1. Shift History
    for (int i = 0; i < (TAPS - 1) * FFT_LEN; i++) {
        input_history[i] = input_history[i + FFT_LEN];
    }
    // 2. Insert New Block
    for (int i = 0; i < FFT_LEN; i++) {
        input_history[(TAPS - 1) * FFT_LEN + i] = new_block[i];
    }

    // 3. Polyphase Filter
    for (int k = 0; k < FFT_LEN; k++) {
        std::complex<double> acc(0.0, 0.0);

        for (int t = 0; t < TAPS; t++) {
            int sample_idx = ((TAPS - 1 - t) * FFT_LEN) + k;
            int coeff_idx  = (t * FFT_LEN) + k;

            std::complex<double> sample = input_history[sample_idx];
            double c = coeffs[coeff_idx];

            acc += sample * c;
        }
        output_block[k] = acc;
    }
    
    // 4. FFT
    sw_fft(output_block);

    // 5. Scaling
    const double SCALING_FACTOR = 2048.0;
    for(int k=0; k<FFT_LEN; k++) {
        output_block[k] /= SCALING_FACTOR;
    }
}

// --------------------------------------------------------
// Main Testbench (Batched Processing)
// --------------------------------------------------------

int main() {
    std::cout << "Starting Batched PFB Test..." << std::endl;

    // 1. Setup Streams
    hls::stream<data_t> din_i0("i0"), din_q0("q0");
    hls::stream<data_t> din_i1("i1"), din_q1("q1");
    hls::stream<data_t> din_i2("i2"), din_q2("q2");
    hls::stream<data_t> din_i3("i3"), din_q3("q3");

    hls::stream<data_32> dout_0("out0"), dout_1("out1"), dout_2("out2"), dout_3("out3");

    // 2. Setup Coefficients
    coeff_t coeffs_hw[TOTAL_SAMPLES];
    std::vector<double> coeffs_sw(TOTAL_SAMPLES);
    for (int i = 0; i < TOTAL_SAMPLES; i++) {
        double val = 0.25; 
        coeffs_sw[i] = val;
        coeffs_hw[i] = (coeff_t)val;
    }

    const int NUM_BLOCKS = 8;
    
    // Storage for all verification data (Batched)
    std::vector<std::vector<std::vector<std::complex<double>>>> all_sw_inputs(NUM_BLOCKS, std::vector<std::vector<std::complex<double>>>(NUM_CHANNELS, std::vector<std::complex<double>>(FFT_LEN)));

    // ============================================================
    // PHASE 1: PREPARE DATA (Fill FIFO inputs)
    // ============================================================
    std::cout << "[Phase 1] Generating all input data..." << std::endl;
    for (int block = 0; block < NUM_BLOCKS; block++) {
        for (int i = 0; i < FFT_LEN; i++) {
            double time = block * FFT_LEN + i;
            std::complex<double> ch[4];
            ch[0] = {0.8 * cos(time * 0.1), 0.8 * sin(time * 0.1)};
            ch[1] = {0.8 * cos(time * 0.2), 0.8 * sin(time * 0.2)};
            ch[2] = {0.5 * cos(time * 0.4), 0.5 * sin(time * 0.4)};
            ch[3] = {0.9 * cos(time * 0.05), 0.0};

            // Save for later verification
            for(int c=0; c<4; c++) all_sw_inputs[block][c][i] = ch[c];

            // Write to Hardware Streams immediately
            din_i0.write((data_t)ch[0].real()); din_q0.write((data_t)ch[0].imag());
            din_i1.write((data_t)ch[1].real()); din_q1.write((data_t)ch[1].imag());
            din_i2.write((data_t)ch[2].real()); din_q2.write((data_t)ch[2].imag());
            din_i3.write((data_t)ch[3].real()); din_q3.write((data_t)ch[3].imag());
        }
    }

    // ============================================================
    // PHASE 2: RUN HARDWARE (Continuous Burst)
    // ============================================================
    // The Input Streams are now full of 8 blocks of data.
    // We call the hardware 8 times back-to-back.
    // Since we are not doing SW math in between, the simulator
    // will schedule these much closer together (almost continuous).
    
    std::cout << "[Phase 2] Running Hardware for " << NUM_BLOCKS << " blocks..." << std::endl;
    for (int block = 0; block < NUM_BLOCKS; block++) {
        pfb_multichannel(
            din_i0, din_q0, din_i1, din_q1, din_i2, din_q2, din_i3, din_q3,
            dout_0, dout_1, dout_2, dout_3,
            coeffs_hw
        );
    }

    // ============================================================
    // PHASE 3: VERIFICATION (Offline)
    // ============================================================
    std::cout << "[Phase 3] Verifying results..." << std::endl;
    
    std::vector<std::vector<std::complex<double>>> history(NUM_CHANNELS, std::vector<std::complex<double>>(TOTAL_SAMPLES, {0,0}));
    int total_errors = 0;

    for (int block = 0; block < NUM_BLOCKS; block++) {
        
        // Calculate expected SW results
        std::vector<std::vector<std::complex<double>>> output_blocks_sw(NUM_CHANNELS, std::vector<std::complex<double>>(FFT_LEN));
        for(int c=0; c<NUM_CHANNELS; c++) {
            sw_pfb_single_channel(history[c], all_sw_inputs[block][c], output_blocks_sw[c], coeffs_sw);
        }

        // Read HW results from output streams
        if (block < (TAPS - 1)) {
            // Drain the transient blocks
            for(int k=0; k<FFT_LEN; k++) { dout_0.read(); dout_1.read(); dout_2.read(); dout_3.read(); }
            continue; 
        }

        // Compare
        for (int i = 0; i < FFT_LEN; i++) {
            std::complex<double> hw_out[4];
            auto unpack = [](hls::stream<data_32>& s) {
                data_32 p = s.read();
                data_t re, im; 
                re.range(15,0) = p.range(31,16); im.range(15,0) = p.range(15,0);
                return std::complex<double>(re.to_double(), im.to_double());
            };
            
            hw_out[0] = unpack(dout_0); hw_out[1] = unpack(dout_1);
            hw_out[2] = unpack(dout_2); hw_out[3] = unpack(dout_3);

            for(int c=0; c<NUM_CHANNELS; c++) {
                if (std::abs(hw_out[c].real() - output_blocks_sw[c][i].real()) > 0.002 ||
                    std::abs(hw_out[c].imag() - output_blocks_sw[c][i].imag()) > 0.002) {
                    total_errors++;
                }
            }
        }
    }

    if (total_errors == 0) std::cout << "PASS" << std::endl;
    else std::cout << "FAIL: " << total_errors << " errors" << std::endl;
    return (total_errors == 0);
}