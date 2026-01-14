#include "pfb.h"

void read_inputs(
    hls::stream<data_t> &din_i0, hls::stream<data_t> &din_q0,
    hls::stream<data_t> &din_i1, hls::stream<data_t> &din_q1,
    hls::stream<data_t> &din_i2, hls::stream<data_t> &din_q2,
    hls::stream<data_t> &din_i3, hls::stream<data_t> &din_q3,
    hls::stream<parallel_sample_t> &internal_out
) {
    #pragma HLS INLINE off 
    
    #pragma HLS INTERFACE ap_ctrl_hs port=return

    static int dummy_state = 0;
    dummy_state++;
    
    read_loop: for (int i = 0; i < FFT_LEN; i++) {
        #pragma HLS PIPELINE II=1
        
        parallel_sample_t pack;
        
        pack.ch[0].i = din_i0.read(); pack.ch[0].q = din_q0.read();
        pack.ch[1].i = din_i1.read(); pack.ch[1].q = din_q1.read();
        pack.ch[2].i = din_i2.read(); pack.ch[2].q = din_q2.read();
        pack.ch[3].i = din_i3.read(); pack.ch[3].q = din_q3.read();
        
        internal_out.write(pack);
    }
}

void write_outputs(
    hls::stream<parallel_sample_t> &internal_out,
    hls::stream<data_32> &dout_0,
    hls::stream<data_32> &dout_1,
    hls::stream<data_32> &dout_2,
    hls::stream<data_32> &dout_3
) {
    #pragma HLS INLINE off

    #pragma HLS INTERFACE ap_ctrl_hs port=return

    data_32 packed_val;

    static int dummy_state = 0;
    dummy_state++;

    write_loop: for (int i = 0; i < FFT_LEN; i++) {
        #pragma HLS PIPELINE II=1

        parallel_sample_t pack = internal_out.read();

        packed_val.range(31, 16) = pack.ch[0].i.range(15, 0);
        packed_val.range(15, 0)  = pack.ch[0].q.range(15, 0);
        dout_0.write(packed_val);

        packed_val.range(31, 16) = pack.ch[1].i.range(15, 0);
        packed_val.range(15, 0)  = pack.ch[1].q.range(15, 0);
        dout_1.write(packed_val);

        packed_val.range(31, 16) = pack.ch[2].i.range(15, 0);
        packed_val.range(15, 0)  = pack.ch[2].q.range(15, 0);
        dout_2.write(packed_val);

        packed_val.range(31, 16) = pack.ch[3].i.range(15, 0);
        packed_val.range(15, 0)  = pack.ch[3].q.range(15, 0);
        dout_3.write(packed_val);
    }
}

void unpack(
    hls::stream<parallel_sample_t> &in,
    hls::stream<std::complex<fft_data_t>> &ch0,
    hls::stream<std::complex<fft_data_t>> &ch1,
    hls::stream<std::complex<fft_data_t>> &ch2,
    hls::stream<std::complex<fft_data_t>> &ch3
) {
    #pragma HLS INLINE off
    
    #pragma HLS INTERFACE ap_ctrl_hs port=return

    static int dummy_state = 0;
    dummy_state++;
    
    unpack_loop: for (int i = 0; i < FFT_LEN; i++) {
        #pragma HLS PIPELINE II=1
        parallel_sample_t pack = in.read();
        
        ch0.write(std::complex<fft_data_t>(pack.ch[0].i, pack.ch[0].q));
        ch1.write(std::complex<fft_data_t>(pack.ch[1].i, pack.ch[1].q));
        ch2.write(std::complex<fft_data_t>(pack.ch[2].i, pack.ch[2].q));
        ch3.write(std::complex<fft_data_t>(pack.ch[3].i, pack.ch[3].q));
    }
}

void repack(
    hls::stream<std::complex<fft_data_t>> &ch0,
    hls::stream<std::complex<fft_data_t>> &ch1,
    hls::stream<std::complex<fft_data_t>> &ch2,
    hls::stream<std::complex<fft_data_t>> &ch3,
    hls::stream<parallel_sample_t> &out
) {
    #pragma HLS INLINE off
    
    #pragma HLS INTERFACE ap_ctrl_hs port=return

    static int dummy_state = 0;
    dummy_state++;
    
    repack_loop: for (int i = 0; i < FFT_LEN; i++) {
        #pragma HLS PIPELINE II=1
        
        std::complex<fft_data_t> val0 = ch0.read();
        std::complex<fft_data_t> val1 = ch1.read();
        std::complex<fft_data_t> val2 = ch2.read();
        std::complex<fft_data_t> val3 = ch3.read();

        parallel_sample_t out_pack;
        out_pack.ch[0].i = val0.real(); out_pack.ch[0].q = val0.imag();
        out_pack.ch[1].i = val1.real(); out_pack.ch[1].q = val1.imag();
        out_pack.ch[2].i = val2.real(); out_pack.ch[2].q = val2.imag();
        out_pack.ch[3].i = val3.real(); out_pack.ch[3].q = val3.imag();

        out.write(out_pack);
    }
}