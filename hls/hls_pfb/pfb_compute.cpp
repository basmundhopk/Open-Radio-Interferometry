#include "pfb.h"

void decimate_pfb(
    hls::stream<parallel_sample_t> &internal_in,
    hls::stream<parallel_sample_t> &internal_out,
    const coeff_t coeff[TOTAL_SAMPLES]
) {
    #pragma HLS INLINE off
    #pragma HLS INTERFACE ap_ctrl_hs port=return


    static iq_sample_t branch_memory[NUM_CHANNELS][TAPS][FFT_LEN];
    
    #pragma HLS ARRAY_PARTITION variable=branch_memory complete dim=1
    #pragma HLS ARRAY_PARTITION variable=branch_memory complete dim=2
    #pragma HLS BIND_STORAGE variable=branch_memory type=RAM_1P impl=BRAM

    static ap_uint<2> write_bank_idx = 0;
    
    static coeff_t local_coeffs[TOTAL_SAMPLES];
    static bool coeff_loaded = false;

    if (!coeff_loaded) {
        load_coeffs: for(int i=0; i<TOTAL_SAMPLES; i++) {
            #pragma HLS PIPELINE II=1
            local_coeffs[i] = coeff[i];
        }
        coeff_loaded = true;
    }

    compute_loop: for (int k = 0; k < FFT_LEN; k++) {
        #pragma HLS PIPELINE II=1 
        
        parallel_sample_t input_pack = internal_in.read();
        parallel_sample_t result_pack;

        channel_loop: for (int c = 0; c < NUM_CHANNELS; c++) {
            #pragma HLS UNROLL

            branch_memory[c][write_bank_idx][k] = input_pack.ch[c];

            accum_fixed_t acc_i = 0;
            accum_fixed_t acc_q = 0;


            iq_sample_t current_val = input_pack.ch[c];

            tap_loop: for (int t = 0; t < TAPS; t++) {
                #pragma HLS UNROLL 
                
                iq_sample_t sample;
                
                if (t == 0) {
                    sample = current_val; 
                } else {
                    ap_uint<2> bank_selector = (write_bank_idx - t) & 0x3;
                    sample = branch_memory[c][bank_selector][k];
                }

                coeff_t w = local_coeffs[t * FFT_LEN + k];

                acc_i += sample.i * w;
                acc_q += sample.q * w;
            }
            
            result_pack.ch[c].i = (data_t)acc_i;
            result_pack.ch[c].q = (data_t)acc_q;
        }

        internal_out.write(result_pack);
    }
    
    write_bank_idx++;
}