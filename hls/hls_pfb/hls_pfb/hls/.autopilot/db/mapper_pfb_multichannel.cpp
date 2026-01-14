#include "hls_signal_handler.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <list>
#include <map>
#include <vector>
#include "ap_fixed.h"
#include "ap_int.h"
#include "hls_stream.h"
using namespace std;

namespace hls::sim
{
  template<size_t n>
  struct Byte {
    unsigned char a[n];

    Byte()
    {
      for (size_t i = 0; i < n; ++i) {
        a[i] = 0;
      }
    }

    template<typename T>
    Byte<n>& operator= (const T &val)
    {
      std::memcpy(a, &val, n);
      return *this;
    }
  };

  struct SimException : public std::exception {
    const std::string msg;
    const size_t line;
    SimException(const std::string &msg, const size_t line)
      : msg(msg), line(line)
    {
    }
  };

  void errExit(const size_t line, const std::string &msg)
  {
    std::string s;
    s += "ERROR";
//  s += '(';
//  s += __FILE__;
//  s += ":";
//  s += std::to_string(line);
//  s += ')';
    s += ": ";
    s += msg;
    s += "\n";
    fputs(s.c_str(), stderr);
    exit(1);
  }
}


namespace hls::sim
{
  struct Buffer {
    char *first;
    Buffer(char *addr) : first(addr)
    {
    }
  };

  struct DBuffer : public Buffer {
    static const size_t total = 1<<10;
    size_t ufree;

    DBuffer(size_t usize) : Buffer(nullptr), ufree(total)
    {
      first = new char[usize*ufree];
    }

    ~DBuffer()
    {
      delete[] first;
    }
  };

  struct CStream {
    char *front;
    char *back;
    size_t num;
    size_t usize;
    std::list<Buffer*> bufs;
    bool dynamic;

    CStream() : front(nullptr), back(nullptr),
                num(0), usize(0), dynamic(true)
    {
    }

    ~CStream()
    {
      for (Buffer *p : bufs) {
        delete p;
      }
    }

    template<typename T>
    T* data()
    {
      return (T*)front;
    }

    template<typename T>
    void transfer(hls::stream<T> *param)
    {
      while (!empty()) {
        param->write(*(T*)nextRead());
      }
    }

    bool empty();
    char* nextRead();
    char* nextWrite();
  };

  bool CStream::empty()
  {
    return num == 0;
  }

  char* CStream::nextRead()
  {
    assert(num > 0);
    char *res = front;
    front += usize;
    if (dynamic) {
      if (++static_cast<DBuffer*>(bufs.front())->ufree == DBuffer::total) {
        if (bufs.size() > 1) {
          bufs.pop_front();
          front = bufs.front()->first;
        } else {
          front = back = bufs.front()->first;
        }
      }
    }
    --num;
    return res;
  }

  char* CStream::nextWrite()
  {
    if (dynamic) {
      if (static_cast<DBuffer*>(bufs.back())->ufree == 0) {
        bufs.push_back(new DBuffer(usize));
        back = bufs.back()->first;
      }
      --static_cast<DBuffer*>(bufs.back())->ufree;
    }
    char *res = back;
    back += usize;
    ++num;
    return res;
  }

  std::list<CStream> streams;
  std::map<char*, CStream*> prebuilt;

  CStream* createStream(size_t usize)
  {
    streams.emplace_front();
    CStream &s = streams.front();
    {
      s.dynamic = true;
      s.bufs.push_back(new DBuffer(usize));
      s.front = s.bufs.back()->first;
      s.back = s.front;
      s.num = 0;
      s.usize = usize;
    }
    return &s;
  }

  template<typename T>
  CStream* createStream(hls::stream<T> *param)
  {
    CStream *s = createStream(sizeof(T));
    {
      s->dynamic = true;
      while (!param->empty()) {
        T data = param->read();
        memcpy(s->nextWrite(), (char*)&data, sizeof(T));
      }
      prebuilt[s->front] = s;
    }
    return s;
  }

  template<typename T>
  CStream* createStream(T *param, size_t usize)
  {
    streams.emplace_front();
    CStream &s = streams.front();
    {
      s.dynamic = false;
      s.bufs.push_back(new Buffer((char*)param));
      s.front = s.back = s.bufs.back()->first;
      s.usize = usize;
      s.num = ~0UL;
    }
    prebuilt[s.front] = &s;
    return &s;
  }

  CStream* findStream(char *buf)
  {
    return prebuilt.at(buf);
  }
}
class AESL_RUNTIME_BC {
  public:
    AESL_RUNTIME_BC(const char* name) {
      file_token.open( name);
      if (!file_token.good()) {
        cout << "Failed to open tv file " << name << endl;
        exit (1);
      }
      file_token >> mName;//[[[runtime]]]
    }
    ~AESL_RUNTIME_BC() {
      file_token.close();
    }
    int read_size () {
      int size = 0;
      file_token >> mName;//[[transaction]]
      file_token >> mName;//transaction number
      file_token >> mName;//pop_size
      size = atoi(mName.c_str());
      file_token >> mName;//[[/transaction]]
      return size;
    }
  public:
    fstream file_token;
    string mName;
};
unsigned int ap_apatb_din_data_i0_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_i0_V_size_Reader("../tv/stream_size/stream_size_in_din_data_i0.dat");
unsigned int ap_apatb_din_data_q0_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_q0_V_size_Reader("../tv/stream_size/stream_size_in_din_data_q0.dat");
unsigned int ap_apatb_din_data_i1_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_i1_V_size_Reader("../tv/stream_size/stream_size_in_din_data_i1.dat");
unsigned int ap_apatb_din_data_q1_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_q1_V_size_Reader("../tv/stream_size/stream_size_in_din_data_q1.dat");
unsigned int ap_apatb_din_data_i2_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_i2_V_size_Reader("../tv/stream_size/stream_size_in_din_data_i2.dat");
unsigned int ap_apatb_din_data_q2_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_q2_V_size_Reader("../tv/stream_size/stream_size_in_din_data_q2.dat");
unsigned int ap_apatb_din_data_i3_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_i3_V_size_Reader("../tv/stream_size/stream_size_in_din_data_i3.dat");
unsigned int ap_apatb_din_data_q3_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_q3_V_size_Reader("../tv/stream_size/stream_size_in_din_data_q3.dat");
unsigned int ap_apatb_dout_data_0_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_0_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_0.dat");
unsigned int ap_apatb_dout_data_1_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_1_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_1.dat");
unsigned int ap_apatb_dout_data_2_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_2_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_2.dat");
unsigned int ap_apatb_dout_data_3_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_3_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_3.dat");
using hls::sim::Byte;
extern "C" void pfb_multichannel(Byte<2>*, short*, short*, short*, short*, short*, short*, short*, short*, int*, int*, int*, int*, int);
extern "C" void apatb_pfb_multichannel_hw(volatile void * __xlx_apatb_param_din_data_i0, volatile void * __xlx_apatb_param_din_data_q0, volatile void * __xlx_apatb_param_din_data_i1, volatile void * __xlx_apatb_param_din_data_q1, volatile void * __xlx_apatb_param_din_data_i2, volatile void * __xlx_apatb_param_din_data_q2, volatile void * __xlx_apatb_param_din_data_i3, volatile void * __xlx_apatb_param_din_data_q3, volatile void * __xlx_apatb_param_dout_data_0, volatile void * __xlx_apatb_param_dout_data_1, volatile void * __xlx_apatb_param_dout_data_2, volatile void * __xlx_apatb_param_dout_data_3, volatile void * __xlx_apatb_param_coeff) {
using hls::sim::createStream;
  // Collect __xlx_coeff__tmp_vec
std::vector<Byte<2>> __xlx_coeff__tmp_vec;
for (size_t i = 0; i < 4096; ++i){
__xlx_coeff__tmp_vec.push_back(((Byte<2>*)__xlx_apatb_param_coeff)[i]);
}
  int __xlx_size_param_coeff = 4096;
  int __xlx_offset_param_coeff = 0;
  int __xlx_offset_byte_param_coeff = 0*2;
auto* sdin_data_i0 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_i0);
auto* sdin_data_q0 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_q0);
auto* sdin_data_i1 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_i1);
auto* sdin_data_q1 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_q1);
auto* sdin_data_i2 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_i2);
auto* sdin_data_q2 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_q2);
auto* sdin_data_i3 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_i3);
auto* sdin_data_q3 = createStream((hls::stream<short>*)__xlx_apatb_param_din_data_q3);
  //Create input buffer for dout_data_0
  ap_apatb_dout_data_0_cap_bc = __xlx_dout_data_0_V_size_Reader.read_size();
  int* __xlx_dout_data_0_input_buffer= new int[ap_apatb_dout_data_0_cap_bc];
auto* sdout_data_0 = createStream((hls::stream<int>*)__xlx_apatb_param_dout_data_0);
  //Create input buffer for dout_data_1
  ap_apatb_dout_data_1_cap_bc = __xlx_dout_data_1_V_size_Reader.read_size();
  int* __xlx_dout_data_1_input_buffer= new int[ap_apatb_dout_data_1_cap_bc];
auto* sdout_data_1 = createStream((hls::stream<int>*)__xlx_apatb_param_dout_data_1);
  //Create input buffer for dout_data_2
  ap_apatb_dout_data_2_cap_bc = __xlx_dout_data_2_V_size_Reader.read_size();
  int* __xlx_dout_data_2_input_buffer= new int[ap_apatb_dout_data_2_cap_bc];
auto* sdout_data_2 = createStream((hls::stream<int>*)__xlx_apatb_param_dout_data_2);
  //Create input buffer for dout_data_3
  ap_apatb_dout_data_3_cap_bc = __xlx_dout_data_3_V_size_Reader.read_size();
  int* __xlx_dout_data_3_input_buffer= new int[ap_apatb_dout_data_3_cap_bc];
auto* sdout_data_3 = createStream((hls::stream<int>*)__xlx_apatb_param_dout_data_3);
  // DUT call
  pfb_multichannel(__xlx_coeff__tmp_vec.data(), sdin_data_i0->data<short>(), sdin_data_q0->data<short>(), sdin_data_i1->data<short>(), sdin_data_q1->data<short>(), sdin_data_i2->data<short>(), sdin_data_q2->data<short>(), sdin_data_i3->data<short>(), sdin_data_q3->data<short>(), sdout_data_0->data<int>(), sdout_data_1->data<int>(), sdout_data_2->data<int>(), sdout_data_3->data<int>(), __xlx_offset_byte_param_coeff);
// print __xlx_apatb_param_coeff
for (size_t i = 0; i < __xlx_size_param_coeff; ++i) {
((Byte<2>*)__xlx_apatb_param_coeff)[i] = __xlx_coeff__tmp_vec[__xlx_offset_param_coeff+i];
}
sdin_data_i0->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_i0);
sdin_data_q0->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_q0);
sdin_data_i1->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_i1);
sdin_data_q1->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_q1);
sdin_data_i2->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_i2);
sdin_data_q2->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_q2);
sdin_data_i3->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_i3);
sdin_data_q3->transfer((hls::stream<short>*)__xlx_apatb_param_din_data_q3);
sdout_data_0->transfer((hls::stream<int>*)__xlx_apatb_param_dout_data_0);
sdout_data_1->transfer((hls::stream<int>*)__xlx_apatb_param_dout_data_1);
sdout_data_2->transfer((hls::stream<int>*)__xlx_apatb_param_dout_data_2);
sdout_data_3->transfer((hls::stream<int>*)__xlx_apatb_param_dout_data_3);
}
