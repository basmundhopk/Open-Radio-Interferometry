#include <iostream>
#include <cstdlib>
#include <vector>
#include <complex>
#include <iomanip>
#include <cmath>
#include "correlator.h"

using namespace std;

// --- Helper Functions ---

// Pack float/double into the 32-bit input format (16-bit I, 16-bit Q)
input_axis_t pack_input(std::complex<double> val) {
    short i_short = (short)val.real();
    short q_short = (short)val.imag();
    input_axis_t packed;
    packed.range(31, 16) = i_short;
    packed.range(15, 0)  = q_short;
    return packed;
}

// Unpack the 64-bit DUT output to complex<long long> for comparison
std::complex<long long> unpack_output(output_axis_t packed) {
    ap_int<32> re_ap = packed.range(127, 64);
    ap_int<32> im_ap = packed.range(63, 0);
    return std::complex<long long>(re_ap.to_int(), im_ap.to_int());
}

int main() {
    int error_num = 0;
    
    // 1. Simulation Parameters
    const int TEST_FRAMES = 5;       // Total frames to simulate
    const int INTEGRATION_TIME = 2;  // Hardware integrates 2 frames before outputting
    
    // We need enough frames to trigger at least one output (Integration Time + 1)
    if (TEST_FRAMES <= INTEGRATION_TIME) {
        cout << "Error: TEST_FRAMES must be > INTEGRATION_TIME to see output." << endl;
        return 1;
    }

    // 2. Stream Declarations
    hls::stream<input_axis_t> din[4];
    hls::stream<output_axis_t> dout[10];

    // 3. Storage for Golden Verification
    // We need to accumulate software results just like the hardware does
    // Dimensions: [Baseline][Frequency Bin]
    vector<vector<complex<long long>>> golden_acc(10, vector<complex<long long>>(FFT_LEN, {0, 0}));
    
    // Mapping for the 10 baselines to input pairs (i, j)
    int bl_map_i[10] = {0, 1, 2, 3, 0, 0, 0, 1, 1, 2};
    int bl_map_j[10] = {0, 1, 2, 3, 1, 2, 3, 2, 3, 3};

    cout << "------------------------------------------------" << endl;
    cout << " Starting Self-Contained Correlator Testbench   " << endl;
    cout << " Integration Time: " << INTEGRATION_TIME << " frames" << endl;
    cout << "------------------------------------------------" << endl;

    // --- Main Simulation Loop ---
    for (int frame = 1; frame <= TEST_FRAMES; ++frame) {
        
        cout << "Processing Frame " << frame << "..." << endl;

        // A. Generate Data & Compute Golden Reference
        for (int i = 0; i < FFT_LEN; i++) {
            complex<double> inputs[4];

            // Generate simple synthetic data
            // Example: Constant + Index based to verify frequency mapping
            // Ant 0: 10 + j10
            // Ant 1: 5  - j5
            // Ant 2: Random small numbers
            // Ant 3: Loop index based
            inputs[0] = {10.0, 10.0}; 
            inputs[1] = {5.0, -5.0};
            inputs[2] = {(double)(rand() % 10), (double)(rand() % 10)}; 
            inputs[3] = {(double)(i % 16), (double)((i+1) % 16)};

            // Write to Hardware Streams
            din[0].write(pack_input(inputs[0]));
            din[1].write(pack_input(inputs[1]));
            din[2].write(pack_input(inputs[2]));
            din[3].write(pack_input(inputs[3]));

            // Compute Software Golden Reference (Accumulate)
            // Only accumulate if we are within the integration window
            // (In this simple test, we just accumulate everything until a check is triggered)
            for (int b = 0; b < 10; b++) {
                int ant_i = bl_map_i[b];
                int ant_j = bl_map_j[b];
                
                // V_i * conj(V_j)
                complex<double> prod = inputs[ant_i] * conj(inputs[ant_j]);
                
                golden_acc[b][i] += complex<long long>((long long)prod.real(), (long long)prod.imag());
            }
        }

        // B. Run Hardware Design
        correlator(
            din[0], din[1], din[2], din[3],
            dout[0], dout[1], dout[2], dout[3], 
            dout[4], dout[5], dout[6],          
            dout[7], dout[8],                   
            dout[9],                            
            INTEGRATION_TIME
        );

        // C. Check Results (Only when integration completes)
        if (frame % INTEGRATION_TIME == 0) {
            cout << "  >> Integration Complete. Verifying Output..." << endl;
            
            for (int i = 0; i < FFT_LEN; i++) {
                bool row_error = false;
                
                for (int b = 0; b < 10; b++) {
                    if (dout[b].empty()) {
                        cout << "ERROR: Stream empty at index " << i << " baseline " << b << endl;
                        error_num++;
                        break;
                    }

                    // Read Hardware Output
                    complex<long long> hw_val = unpack_output(dout[b].read());
                    complex<long long> sw_val = golden_acc[b][i];

                    // Compare
                    if (hw_val != sw_val) {
                        if (!row_error) { // Print error only once per frequency bin to avoid spam
                            cout << "ERROR at Frame " << frame << ", Bin " << i << ", Baseline " << b << endl;
                            cout << "  Expected: " << sw_val << endl;
                            cout << "  Got:      " << hw_val << endl;
                            row_error = true;
                        }
                        error_num++;
                    }

                    // Reset Golden Accumulator for next integration cycle
                    golden_acc[b][i] = {0, 0};
                }
            }
        }
    }

    // D. Final Check
    // Ensure streams are empty (no left over data)
    if (!dout[0].empty()) {
        cout << "WARNING: Unread data remains in output streams!" << endl;
    }

    cout << "------------------------------------------------" << endl;
    if (error_num == 0) {
        cout << "PASSED" << endl;
    } else {
        cout << "FAILED with " << error_num << " errors." << endl;
    }
    cout << "------------------------------------------------" << endl;

    return (error_num > 0) ? 1 : 0;
}