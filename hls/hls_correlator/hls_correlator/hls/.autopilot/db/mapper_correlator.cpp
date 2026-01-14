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
unsigned int ap_apatb_din_data_0_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_0_V_size_Reader("../tv/stream_size/stream_size_in_din_data_0.dat");
unsigned int ap_apatb_din_data_1_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_1_V_size_Reader("../tv/stream_size/stream_size_in_din_data_1.dat");
unsigned int ap_apatb_din_data_2_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_2_V_size_Reader("../tv/stream_size/stream_size_in_din_data_2.dat");
unsigned int ap_apatb_din_data_3_cap_bc;
static AESL_RUNTIME_BC __xlx_din_data_3_V_size_Reader("../tv/stream_size/stream_size_in_din_data_3.dat");
unsigned int ap_apatb_dout_data_00_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_00_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_00.dat");
unsigned int ap_apatb_dout_data_11_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_11_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_11.dat");
unsigned int ap_apatb_dout_data_22_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_22_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_22.dat");
unsigned int ap_apatb_dout_data_33_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_33_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_33.dat");
unsigned int ap_apatb_dout_data_01_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_01_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_01.dat");
unsigned int ap_apatb_dout_data_02_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_02_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_02.dat");
unsigned int ap_apatb_dout_data_03_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_03_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_03.dat");
unsigned int ap_apatb_dout_data_12_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_12_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_12.dat");
unsigned int ap_apatb_dout_data_13_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_13_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_13.dat");
unsigned int ap_apatb_dout_data_23_cap_bc;
static AESL_RUNTIME_BC __xlx_dout_data_23_V_size_Reader("../tv/stream_size/stream_size_out_dout_data_23.dat");
using hls::sim::Byte;
struct __cosim_s16__ { char data[16]; };
extern "C" void correlator(int*, int*, int*, int*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, __cosim_s16__*, int);
extern "C" void apatb_correlator_hw(volatile void * __xlx_apatb_param_din_data_0, volatile void * __xlx_apatb_param_din_data_1, volatile void * __xlx_apatb_param_din_data_2, volatile void * __xlx_apatb_param_din_data_3, volatile void * __xlx_apatb_param_dout_data_00, volatile void * __xlx_apatb_param_dout_data_11, volatile void * __xlx_apatb_param_dout_data_22, volatile void * __xlx_apatb_param_dout_data_33, volatile void * __xlx_apatb_param_dout_data_01, volatile void * __xlx_apatb_param_dout_data_02, volatile void * __xlx_apatb_param_dout_data_03, volatile void * __xlx_apatb_param_dout_data_12, volatile void * __xlx_apatb_param_dout_data_13, volatile void * __xlx_apatb_param_dout_data_23, int __xlx_apatb_param_integration_time_frames) {
using hls::sim::createStream;
auto* sdin_data_0 = createStream((hls::stream<int>*)__xlx_apatb_param_din_data_0);
auto* sdin_data_1 = createStream((hls::stream<int>*)__xlx_apatb_param_din_data_1);
auto* sdin_data_2 = createStream((hls::stream<int>*)__xlx_apatb_param_din_data_2);
auto* sdin_data_3 = createStream((hls::stream<int>*)__xlx_apatb_param_din_data_3);
  //Create input buffer for dout_data_00
  ap_apatb_dout_data_00_cap_bc = __xlx_dout_data_00_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_00_input_buffer= new __cosim_s16__[ap_apatb_dout_data_00_cap_bc];
auto* sdout_data_00 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_00);
  //Create input buffer for dout_data_11
  ap_apatb_dout_data_11_cap_bc = __xlx_dout_data_11_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_11_input_buffer= new __cosim_s16__[ap_apatb_dout_data_11_cap_bc];
auto* sdout_data_11 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_11);
  //Create input buffer for dout_data_22
  ap_apatb_dout_data_22_cap_bc = __xlx_dout_data_22_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_22_input_buffer= new __cosim_s16__[ap_apatb_dout_data_22_cap_bc];
auto* sdout_data_22 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_22);
  //Create input buffer for dout_data_33
  ap_apatb_dout_data_33_cap_bc = __xlx_dout_data_33_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_33_input_buffer= new __cosim_s16__[ap_apatb_dout_data_33_cap_bc];
auto* sdout_data_33 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_33);
  //Create input buffer for dout_data_01
  ap_apatb_dout_data_01_cap_bc = __xlx_dout_data_01_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_01_input_buffer= new __cosim_s16__[ap_apatb_dout_data_01_cap_bc];
auto* sdout_data_01 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_01);
  //Create input buffer for dout_data_02
  ap_apatb_dout_data_02_cap_bc = __xlx_dout_data_02_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_02_input_buffer= new __cosim_s16__[ap_apatb_dout_data_02_cap_bc];
auto* sdout_data_02 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_02);
  //Create input buffer for dout_data_03
  ap_apatb_dout_data_03_cap_bc = __xlx_dout_data_03_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_03_input_buffer= new __cosim_s16__[ap_apatb_dout_data_03_cap_bc];
auto* sdout_data_03 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_03);
  //Create input buffer for dout_data_12
  ap_apatb_dout_data_12_cap_bc = __xlx_dout_data_12_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_12_input_buffer= new __cosim_s16__[ap_apatb_dout_data_12_cap_bc];
auto* sdout_data_12 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_12);
  //Create input buffer for dout_data_13
  ap_apatb_dout_data_13_cap_bc = __xlx_dout_data_13_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_13_input_buffer= new __cosim_s16__[ap_apatb_dout_data_13_cap_bc];
auto* sdout_data_13 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_13);
  //Create input buffer for dout_data_23
  ap_apatb_dout_data_23_cap_bc = __xlx_dout_data_23_V_size_Reader.read_size();
  __cosim_s16__* __xlx_dout_data_23_input_buffer= new __cosim_s16__[ap_apatb_dout_data_23_cap_bc];
auto* sdout_data_23 = createStream((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_23);
  // DUT call
  correlator(sdin_data_0->data<int>(), sdin_data_1->data<int>(), sdin_data_2->data<int>(), sdin_data_3->data<int>(), sdout_data_00->data<__cosim_s16__>(), sdout_data_11->data<__cosim_s16__>(), sdout_data_22->data<__cosim_s16__>(), sdout_data_33->data<__cosim_s16__>(), sdout_data_01->data<__cosim_s16__>(), sdout_data_02->data<__cosim_s16__>(), sdout_data_03->data<__cosim_s16__>(), sdout_data_12->data<__cosim_s16__>(), sdout_data_13->data<__cosim_s16__>(), sdout_data_23->data<__cosim_s16__>(), __xlx_apatb_param_integration_time_frames);
sdin_data_0->transfer((hls::stream<int>*)__xlx_apatb_param_din_data_0);
sdin_data_1->transfer((hls::stream<int>*)__xlx_apatb_param_din_data_1);
sdin_data_2->transfer((hls::stream<int>*)__xlx_apatb_param_din_data_2);
sdin_data_3->transfer((hls::stream<int>*)__xlx_apatb_param_din_data_3);
sdout_data_00->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_00);
sdout_data_11->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_11);
sdout_data_22->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_22);
sdout_data_33->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_33);
sdout_data_01->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_01);
sdout_data_02->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_02);
sdout_data_03->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_03);
sdout_data_12->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_12);
sdout_data_13->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_13);
sdout_data_23->transfer((hls::stream<__cosim_s16__>*)__xlx_apatb_param_dout_data_23);
}
