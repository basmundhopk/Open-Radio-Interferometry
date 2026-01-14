#include "correlator.h"

void correlator (
    hls::stream<input_axis_t> &din_data_0,
    hls::stream<input_axis_t> &din_data_1,
    hls::stream<input_axis_t> &din_data_2,
    hls::stream<input_axis_t> &din_data_3,

    hls::stream<output_axis_t> &dout_data_00,
    hls::stream<output_axis_t> &dout_data_11,
    hls::stream<output_axis_t> &dout_data_22,
    hls::stream<output_axis_t> &dout_data_33,
    hls::stream<output_axis_t> &dout_data_01,
    hls::stream<output_axis_t> &dout_data_02,
    hls::stream<output_axis_t> &dout_data_03,
    hls::stream<output_axis_t> &dout_data_12,
    hls::stream<output_axis_t> &dout_data_13,
    hls::stream<output_axis_t> &dout_data_23,

    int integration_time_frames
) {
    #pragma HLS INTERFACE axis port=din_data_0 depth=2048
    #pragma HLS INTERFACE axis port=din_data_1 depth=2048
    #pragma HLS INTERFACE axis port=din_data_2 depth=2048
    #pragma HLS INTERFACE axis port=din_data_3 depth=2048
    
    #pragma HLS INTERFACE axis port=dout_data_00 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_11 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_22 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_33 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_01 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_02 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_03 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_12 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_13 depth=2048
    #pragma HLS INTERFACE axis port=dout_data_23 depth=2048

    #pragma HLS INTERFACE s_axilite port=integration_time_frames bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    static complex_64_t accumulator_ram[2][NUM_BASELINES][FFT_LEN];

    #pragma HLS BIND_STORAGE variable=accumulator_ram type=ram_2p impl=bram

    #pragma HLS ARRAY_PARTITION variable=accumulator_ram dim=2 complete

    static int frame_count = 0;
    static bool bank_sel = 0;
    static bool first_run = true;
    
    if (first_run) {
        for(int b=0; b<2; b++)
            for(int l=0; l<NUM_BASELINES; l++)
                for(int f=0; f<FFT_LEN; f++)
                    accumulator_ram[b][l][f] = complex_64_t(0,0);
        first_run = false;
    }

    Process_Frame_Loop: for (int i = 0; i < FFT_LEN; i++) {
        #pragma HLS PIPELINE II=1

        std::complex<data_16_t> v[4];
        v[0] = unpack(din_data_0.read());
        v[1] = unpack(din_data_1.read());
        v[2] = unpack(din_data_2.read());
        v[3] = unpack(din_data_3.read());

        std::complex<data_16_t> v_conj[4];
        v_conj[0] = std::conj(v[0]);
        v_conj[1] = std::conj(v[1]);
        v_conj[2] = std::conj(v[2]);
        v_conj[3] = std::conj(v[3]);

        int write_bank = bank_sel; 
        
        accumulator_ram[write_bank][0][i] += v[0] * v_conj[0];
        accumulator_ram[write_bank][1][i] += v[1] * v_conj[1];
        accumulator_ram[write_bank][2][i] += v[2] * v_conj[2];
        accumulator_ram[write_bank][3][i] += v[3] * v_conj[3];

        accumulator_ram[write_bank][4][i] += v[0] * v_conj[1];
        accumulator_ram[write_bank][5][i] += v[0] * v_conj[2];
        accumulator_ram[write_bank][6][i] += v[0] * v_conj[3];
        accumulator_ram[write_bank][7][i] += v[1] * v_conj[2];
        accumulator_ram[write_bank][8][i] += v[1] * v_conj[3];
        accumulator_ram[write_bank][9][i] += v[2] * v_conj[3];
    }

    frame_count++;

    if (frame_count >= integration_time_frames) {
        frame_count = 0;
        
        int read_bank = bank_sel;
        bank_sel = !bank_sel;

        Offload_Loop: for (int k = 0; k < FFT_LEN; k++) {
            #pragma HLS PIPELINE II=1
            
            dout_data_00.write(pack_output(accumulator_ram[read_bank][0][k]));
            dout_data_11.write(pack_output(accumulator_ram[read_bank][1][k]));
            dout_data_22.write(pack_output(accumulator_ram[read_bank][2][k]));
            dout_data_33.write(pack_output(accumulator_ram[read_bank][3][k]));
            
            dout_data_01.write(pack_output(accumulator_ram[read_bank][4][k]));
            dout_data_02.write(pack_output(accumulator_ram[read_bank][5][k]));
            dout_data_03.write(pack_output(accumulator_ram[read_bank][6][k]));
            dout_data_12.write(pack_output(accumulator_ram[read_bank][7][k]));
            dout_data_13.write(pack_output(accumulator_ram[read_bank][8][k]));
            dout_data_23.write(pack_output(accumulator_ram[read_bank][9][k]));

             for(int b=0; b<NUM_BASELINES; b++) {
                 accumulator_ram[read_bank][b][k] = complex_64_t(0,0);
             }
        }
    }
}