/*
 * Correlator Testbench
 * Adapted from Xilinx FFT Example
 */

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <sstream>
#include <stdio.h>
#include <fstream>
#include <iomanip>
#include <cmath>

#include "correlator.h"

using namespace std;

#define BUF_SIZE 64
#define SIM_FRAMES 5 
// Note: We simulate 5 frames. Ensure you have stimulus_00.dat to stimulus_04.dat
// and matching .res files.

// --- Helper Functions to match DUT Packing ---

// Pack 2 floats (Real, Imag) into the 32-bit input format (16-bit I, 16-bit Q)
input_axis_t pack_input_data(float re, float im) {
    // Quantize to 16-bit integers
    short i_short = (short)re;
    short q_short = (short)im;
    
    input_axis_t packed;
    packed.range(31, 16) = i_short;
    packed.range(15, 0)  = q_short;
    return packed;
}

// Unpack the 64-bit DUT output (32-bit I, 32-bit Q) back to integer for comparison
void unpack_output_data(output_axis_t packed, int &re_out, int &im_out) {
    // The DUT packs Real in high bits, Imag in low bits
    // We use ap_int<32> to handle the sign correctly before casting to standard int
    ap_int<32> re_ap = packed.range(63, 32);
    ap_int<32> im_ap = packed.range(31, 0);
    
    re_out = re_ap.to_int();
    im_out = im_ap.to_int();
}

int main()
{
    int error_num = 0;
    char res_filename[BUF_SIZE]={0};
    char dat_filename[BUF_SIZE]={0};

    // Define Streams
    hls::stream<input_axis_t> din_0, din_1, din_2, din_3;
    hls::stream<output_axis_t> dout[10]; 
    // Mapping: 0=00, 1=11, 2=22, 3=33, 4=01, 5=02, 6=03, 7=12, 8=13, 9=23

    // Simulation Config
    // We set integration time to 1 so we get output every frame for validation
    int integration_time = 1; 

    for (int frame = 0; frame < SIM_FRAMES; ++frame)
    {
        int line_no = 1;
        FILE *stimfile;

        // --- 1. Read Stimulus Input File (.dat) ---
        sprintf(dat_filename, "data/stimulus_%02d.dat", frame);
        stimfile = fopen(dat_filename, "r");
        
        if (stimfile == NULL)
        {
            printf("ERROR: Can't open %s\n", dat_filename);
            exit(999);
        }
        else
        {
            printf("INFO: Reading %s\n", dat_filename);
            
            // Loop over FFT Length (1024 samples)
            // Assumes file format: Re0 Im0 Re1 Im1 Re2 Im2 Re3 Im3 (Floats or Integers)
            float re[4], im[4];
            
            for(int i = 0; i < FFT_LEN; i++) {
                // Read 4 complex pairs (8 numbers) per line
                int scan_ret = fscanf(stimfile, "%f %f %f %f %f %f %f %f", 
                    &re[0], &im[0], &re[1], &im[1], 
                    &re[2], &im[2], &re[3], &im[3]);
                
                if(scan_ret != 8) break; // Stop if file ends early

                // Pack and Write to Streams
                din_0.write(pack_input_data(re[0], im[0]));
                din_1.write(pack_input_data(re[1], im[1]));
                din_2.write(pack_input_data(re[2], im[2]));
                din_3.write(pack_input_data(re[3], im[3]));
            }
        }
        fclose(stimfile);

        // --- 2. Run the DUT ---
        printf("INFO: Running Correlator Hardware for Frame %d\n", frame);
        
        correlator(
            din_0, din_1, din_2, din_3,
            dout[0], dout[1], dout[2], dout[3], // Autos
            dout[4], dout[5], dout[6],          // Cross 0x
            dout[7], dout[8],                   // Cross 1x
            dout[9],                            // Cross 2x
            integration_time
        );

        // --- 3. Read Golden Results (.res) and Compare ---
        FILE* resfile;
        sprintf(res_filename, "data/stimulus_%02d.res", frame);
        resfile = fopen(res_filename, "r");

        if (resfile == NULL)
        {
            printf("ERROR: Can't open %s\n", res_filename);
            exit(888);
        }

        // Arrays to hold golden data
        float gold_re[10], gold_im[10];
        int dut_re, dut_im;
        
        for (int i = 0; i < FFT_LEN; i++)
        {
            // Read 10 complex pairs (20 numbers) from the golden file
            // Format: Base0_Re Base0_Im ... Base9_Re Base9_Im
            for(int b=0; b<10; b++) {
                fscanf(resfile, "%f %f", &gold_re[b], &gold_im[b]);
            }

            // Compare each baseline
            for(int b=0; b<10; b++) {
                output_axis_t dut_val = dout[b].read();
                unpack_output_data(dut_val, dut_re, dut_im);

                // Verification Logic
                // We allow a small tolerance since golden might be float calculation vs integer FPGA
                float diff_re = std::abs(gold_re[b] - (float)dut_re);
                float diff_im = std::abs(gold_im[b] - (float)dut_im);
                
                // Tolerance threshold (adjust based on your precision requirements)
                const float TOLERANCE = 1.0; 

                if (diff_re > TOLERANCE || diff_im > TOLERANCE)
                {
                    error_num++;
                    cout << "ERROR Frame:" << frame << " Bin:" << i << " Baseline:" << b << endl;
                    cout << "   Expected: " << gold_re[b] << " + j" << gold_im[b] << endl;
                    cout << "   Got:      " << dut_re    << " + j" << dut_im    << endl;
                }
            }
        }
        fclose(resfile);
    }

    cout << "------------------------------------------------" << endl;
    cout << "TOTAL ERRORS: " << error_num << endl;
    if (error_num > 0)
        cout << "TEST FAILED!!!" << endl;
    else    
        cout << "TEST PASSED!!!" << endl;

    return error_num > 0;
}