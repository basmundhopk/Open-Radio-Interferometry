#include "correlator.h"

std::complex<data_16_t> unpack(
    input_axis_t packed
) {
    data_16_t i = packed.range(31, 16);
    data_16_t q = packed.range(15, 0);
    return std::complex<data_16_t>(i, q);
}

output_axis_t pack_output(
    complex_64_t acc
) {
    output_axis_t packed;
    
    packed.range(127, 64) = acc.real(); 
    packed.range(63, 0)   = acc.imag();
    
    return packed;
}