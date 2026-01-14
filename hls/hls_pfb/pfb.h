#ifndef PFB_H
#define PFB_H

#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>
#include <complex>
#include "hls_fft.h"

#define NUM_CHANNELS 4
#define FFT_LEN 1024
#define TAPS 4
#define TOTAL_SAMPLES (FFT_LEN * TAPS)

typedef ap_fixed<16, 1, AP_TRN, AP_SAT_SYM> data_t;
typedef ap_fixed<16, 1> fft_data_t;
typedef ap_fixed<16, 1, AP_TRN, AP_WRAP> coeff_t;
typedef ap_fixed<40, 4, AP_TRN, AP_WRAP> accum_fixed_t;
typedef ap_fixed<32, 1, AP_TRN, AP_WRAP> data_32;

const char FFT_INPUT_WIDTH                     = 16;
const char FFT_OUTPUT_WIDTH                    = FFT_INPUT_WIDTH;
const char FFT_STATUS_WIDTH                    = 8;
const char FFT_CONFIG_WIDTH                    = 16;
const char FFT_CHANNELS                        = 1;
const int  FFT_LENGTH                          = 1024; 
const char FFT_NFFT_MAX                        = 10; 
const bool FFT_HAS_NFFT                        = 0;
const hls::ip_fft::arch FFT_ARCH               = hls::ip_fft::pipelined_streaming_io;
const char FFT_TWIDDLE_WIDTH                   = 16;
const hls::ip_fft::ordering FFT_OUTPUT_ORDER   = hls::ip_fft::natural_order;
const bool FFT_OVFLO                           = 1;
const bool FFT_CYCLIC_PREFIX_INSERTION         = 0;
const bool FFT_XK_INDEX                        = 0;
const hls::ip_fft::scaling FFT_SCALING         = hls::ip_fft::scaled;
const hls::ip_fft::rounding FFT_ROUNDING       = hls::ip_fft::truncation;
// not configurable yet
const hls::ip_fft::mem FFT_MEM_DATA            = hls::ip_fft::block_ram;
const hls::ip_fft::mem FFT_MEM_PHASE_FACTORS   = hls::ip_fft::block_ram;
const hls::ip_fft::mem FFT_MEM_REORDER         = hls::ip_fft::block_ram;
const char FFT_STAGES_BLOCK_RAM                = 4;
const bool FFT_MEM_OPTIONS_HYBRID              = 0;
const hls::ip_fft::opt FFT_COMPLEX_MULT_TYPE   = hls::ip_fft::use_luts;
const hls::ip_fft::opt FFT_BUTTERLY_TYPE       = hls::ip_fft::use_luts;

struct iq_sample_t {
    data_t i;
    data_t q;
};

struct parallel_sample_t {
    iq_sample_t ch[NUM_CHANNELS];
};

struct config1 : hls::ip_fft::params_t {
    static const int input_width = FFT_INPUT_WIDTH;
    static const int output_width = FFT_OUTPUT_WIDTH;
    static const int status_width = FFT_STATUS_WIDTH;
    static const int config_width = FFT_CONFIG_WIDTH;
    static const int max_nfft = FFT_NFFT_MAX;
    static const bool has_nfft = FFT_HAS_NFFT;
    static const int channels = FFT_CHANNELS;
    static const int arch_opt = FFT_ARCH;
    static const int phase_factor_width = FFT_TWIDDLE_WIDTH;
    static const int ordering_opt = FFT_OUTPUT_ORDER;
    static const bool ovflo = FFT_OVFLO; 
    static const int scaling_opt = FFT_SCALING;
    static const int rounding_opt = FFT_ROUNDING;
    static const int mem_data = FFT_MEM_DATA;
    static const int mem_phase_factors = FFT_MEM_PHASE_FACTORS;
    static const int mem_reorder = FFT_MEM_REORDER;
    static const int stages_block_ram = FFT_STAGES_BLOCK_RAM;
    static const bool mem_hybrid = FFT_MEM_OPTIONS_HYBRID;
    static const int complex_mult_type = FFT_COMPLEX_MULT_TYPE;
    static const int butterfly_type = FFT_BUTTERLY_TYPE;
};

typedef hls::ip_fft::config_t<config1> config_t;
typedef hls::ip_fft::status_t<config1> status_t;

void read_inputs(
    hls::stream<data_t> &din_i0, hls::stream<data_t> &din_q0,
    hls::stream<data_t> &din_i1, hls::stream<data_t> &din_q1,
    hls::stream<data_t> &din_i2, hls::stream<data_t> &din_q2,
    hls::stream<data_t> &din_i3, hls::stream<data_t> &din_q3,
    hls::stream<parallel_sample_t> &internal_out
);

void write_outputs(
    hls::stream<parallel_sample_t> &internal_out,
    hls::stream<data_32> &dout_0,
    hls::stream<data_32> &dout_1,
    hls::stream<data_32> &dout_2,
    hls::stream<data_32> &dout_3
);

void decimate_pfb(
    hls::stream<parallel_sample_t> &internal_in,
    hls::stream<parallel_sample_t> &internal_out,
    const coeff_t coeff[TOTAL_SAMPLES]
);

void fft(
    hls::stream<parallel_sample_t> &internal_in,
    hls::stream<parallel_sample_t> &internal_out,
    bool* status
);

void pfb_multichannel(
    hls::stream<data_t> &din_data_i0, hls::stream<data_t> &din_data_q0,
    hls::stream<data_t> &din_data_i1, hls::stream<data_t> &din_data_q1,
    hls::stream<data_t> &din_data_i2, hls::stream<data_t> &din_data_q2,
    hls::stream<data_t> &din_data_i3, hls::stream<data_t> &din_data_q3,

    hls::stream<data_32> &dout_data_0,
    hls::stream<data_32> &dout_data_1,
    hls::stream<data_32> &dout_data_2,
    hls::stream<data_32> &dout_data_3,

    const coeff_t coeff[TOTAL_SAMPLES] 
);

void unpack(
    hls::stream<parallel_sample_t> &in,
    hls::stream<std::complex<fft_data_t>> &ch0,
    hls::stream<std::complex<fft_data_t>> &ch1,
    hls::stream<std::complex<fft_data_t>> &ch2,
    hls::stream<std::complex<fft_data_t>> &ch3
);

void repack(
    hls::stream<std::complex<fft_data_t>> &ch0,
    hls::stream<std::complex<fft_data_t>> &ch1,
    hls::stream<std::complex<fft_data_t>> &ch2,
    hls::stream<std::complex<fft_data_t>> &ch3,
    hls::stream<parallel_sample_t> &out
); 

void capture_status(
    hls::stream<status_t> &s0_in,
    hls::stream<status_t> &s1_in,
    hls::stream<status_t> &s2_in,
    hls::stream<status_t> &s3_in,
    bool* status_out
);

void init_fft_config(
    hls::stream<config_t> &cfg0_s,
    hls::stream<config_t> &cfg1_s,
    hls::stream<config_t> &cfg2_s,
    hls::stream<config_t> &cfg3_s
);

#endif