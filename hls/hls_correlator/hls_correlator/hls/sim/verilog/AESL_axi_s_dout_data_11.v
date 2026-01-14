// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================

`timescale 1 ns / 1 ps

`define TV_OUT_dout_data_11_TDATA "../tv/rtldatafile/rtl.correlator.autotvout_dout_data_11.dat"

`define AUTOTB_TRANSACTION_NUM 5

module AESL_axi_s_dout_data_11 (
    input clk,
    input reset,
    input [128 - 1:0] TRAN_dout_data_11_TDATA,
    input TRAN_dout_data_11_TVALID,
    output TRAN_dout_data_11_TREADY,
    input ready,
    input done,
    output [31:0] transaction);

    wire TRAN_dout_data_11_TVALID_temp;
    wire dout_data_11_TDATA_full;
    wire dout_data_11_TDATA_empty;
    reg dout_data_11_TDATA_write_en;
    reg [128 - 1:0] dout_data_11_TDATA_write_data;
    reg dout_data_11_TDATA_read_en;
    wire [128 - 1:0] dout_data_11_TDATA_read_data;
    
    fifo #(1024, 128) fifo_dout_data_11_TDATA (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(dout_data_11_TDATA_write_en),
        .write_data(dout_data_11_TDATA_write_data),
        .read_clock(clk),
        .read_en(dout_data_11_TDATA_read_en),
        .read_data(dout_data_11_TDATA_read_data),
        .full(dout_data_11_TDATA_full),
        .empty(dout_data_11_TDATA_empty));
    
    always @ (*) begin
        dout_data_11_TDATA_write_en <= TRAN_dout_data_11_TVALID;
        dout_data_11_TDATA_write_data <= TRAN_dout_data_11_TDATA;
        dout_data_11_TDATA_read_en <= 0;
    end
    assign TRAN_dout_data_11_TVALID = TRAN_dout_data_11_TVALID_temp;

    
    assign TRAN_dout_data_11_TREADY = ~(dout_data_11_TDATA_full);
    
    function is_blank_char(input [7:0] in_char);
        if (in_char == " " || in_char == "\011" || in_char == "\012" || in_char == "\015") begin
            is_blank_char = 1;
        end else begin
            is_blank_char = 0;
        end
    endfunction
    
    function [279:0] read_token(input integer fp);
        integer ret;
        begin
            read_token = "";
                    ret = 0;
                    ret = $fscanf(fp,"%s",read_token);
        end
    endfunction
    
    function [279:0] rm_0x(input [279:0] token);
        reg [279:0] token_tmp;
        integer i;
        begin
            token_tmp = "";
            for (i = 0; token[15:0] != "0x"; token = token >> 8) begin
                token_tmp = (token[7:0] << (8 * i)) | token_tmp;
                i = i + 1;
            end
            rm_0x = token_tmp;
        end
    endfunction
    
    reg done_1;
    
    always @ (posedge clk or reset) begin
        if (~reset) begin
            done_1 <= 0;
        end else begin
            done_1 <= done;
        end
    end
    
    reg [31:0] transaction_save_dout_data_11_TDATA;
    
    assign transaction = transaction_save_dout_data_11_TDATA;
    
    initial begin : AXI_stream_receiver_dout_data_11_TDATA
        integer fp;
        reg [128 - 1:0] data;
        reg [8 * 5:1] str;
        
        transaction_save_dout_data_11_TDATA = 0;
        fifo_dout_data_11_TDATA.clear();
        wait (reset === 1);
        forever begin
            @ (negedge clk);
            if (done_1 == 1) begin
                fp = $fopen(`TV_OUT_dout_data_11_TDATA, "a");
                if (fp == 0) begin // Failed to open file
                    $display("ERROR: Failed to open file \"%s\"!", `TV_OUT_dout_data_11_TDATA);
                    $finish;
                end
                $fdisplay(fp, "[[transaction]] %d", transaction_save_dout_data_11_TDATA);
                while (~fifo_dout_data_11_TDATA.empty) begin
                    fifo_dout_data_11_TDATA.pop(data);
                    $fdisplay(fp, "0x%x", data);
                end
                $fdisplay(fp, "[[/transaction]]");
                transaction_save_dout_data_11_TDATA = transaction_save_dout_data_11_TDATA + 1;
                fifo_dout_data_11_TDATA.clear();
                $fclose(fp);
            end
        end
    end

endmodule
