`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2019, Nigel Topham, All rights reserved.
//
// This is an unpublished, proprietary work of Nigel Topham and is fully
// protected under copyright law. You may not disclose or distribute this file
// or any information contained herein except persuant to a valid written
// license from Nigel Topham.
//
// The entire notice above must be reproduced on all authorized copies.
//
////////////////////////////////////////////////////////////////////////////////
//
// Description:    Result bypass and stall logic for RISC-V core
// 
////////////////////////////////////////////////////////////////////////////////

module bypass_or_stall(

  //==== DEC-stage source operands  ============================================
  //
  input      [4:0]  dec_rs1,        // first source operand register address
  input             dec_rs1_renb,   // 1 => rs1 is used, 0 => rs1 is unused
  input      [31:0] dec_rdata1,     // R[rs1] from register file
  //
  input      [4:0]  dec_rs2,        // second source operand register address
  input             dec_rs2_renb,   // 1 => rs2 is used, 0 => rs2 is unused
  input      [31:0] dec_rdata2,     // R[rs2] from register file

  //==== EXE-stage instruction information  ====================================
  //
  input      [4:0]  exe_rd,         // EXE destination operand register address
  input             exe_rd_wenb,    // 1 => rd is written, 0 => rd not written
  input      [31:0] exe_result,     // result at EXE stage, destined for R[rd]
  input             exe_load,       // EXE instruction is a Load operation
  input             exe_csr,        // EXE instruction is a CSRRx operation

  //==== MEM-stage instruction information  ====================================
  //
  input      [4:0]  mem_rd,         // MEM destination operand register address
  input             mem_rd_wenb,    // 1 => rd is written, 0 => rd not written
  input      [31:0] mem_result,     // result at MEM stage, destined for R[rd]

  //==== WRB-stage instruction information  ====================================
  //
  input      [4:0]  wrb_rd,         // WRB destination operand register address
  input             wrb_rd_wenb,    // 1 => rd is written, 0 => rd not written
  input      [31:0] wrb_result,     // result at WRB stage, destined for R[rd]

  //==== Outputs to stall DEC stage and provide forwarded results ==============
  //
  output reg        dec_stall,      // 1 => stall DEC, 0 => no stall at DEC
  output reg        dec_load_use,   // DEC stall is due to Load use with MEM
  output reg        dec_csr_use,    // DEC stall is due to CSR use with MEM
  output reg [31:0] dec_rs1_data,   // R[rs1] value to pass on to EXE stage
  output reg [31:0] dec_rs2_data    // R[rs2] value to pass on to EXE stage
);

always @*
  begin : bypass_stall_PROC

  //===========================================================================
  // Your Parts (a) and (b) will totally replace the next three lines of code
  //
  //dec_stall       = 1'b0 & wrb_rd_wenb; // this is just to assign a value
  //dec_load_use    = 1'b0 & wrb_rd_wenb; // this is just to assign a value
  //dec_csr_use     = 1'b0 & wrb_rd_wenb; // this is just to assign a value

  begin
  
  // Set the stall registers to 0
    dec_stall = 1'b0;
    dec_load_use = 1'b0;
    dec_csr_use = 1'b0;
  
  // If the first DEC operand has the same address as EXE operand then stall
  if(dec_rs1 == exe_rd && dec_rs1_renb == 1'b1 && exe_rd_wenb == 1'b1)
    dec_stall = 1'b1;
    dec_load_use = exe_load;
    dec_csr_use = exe_csr;
    
  // If the second DEC operand has the same address as EXE operand then stall
  if(dec_rs2 == exe_rd && dec_rs2_renb == 1'b1 && exe_rd_wenb == 1'b1)
    dec_stall = 1'b1;
    dec_load_use = exe_load;
    dec_csr_use = exe_csr;
    
  // If the first DEC operand has the same address as MEM operand then stall
  if(dec_rs1 == mem_rd && dec_rs1_renb == 1'b1 && mem_rd_wenb == 1'b1)
    dec_stall = 1'b1;
    
  // If the second DEC operand has the same address as MEM operand then stall
  if(dec_rs2 == mem_rd && dec_rs2_renb == 1'b1 && mem_rd_wenb == 1'b1)
    dec_stall = 1'b1;
    
  // If the first DEC operand has the same address as WRB operand then stall
  if(dec_rs1 == wrb_rd && dec_rs1_renb == 1'b1 && wrb_rd_wenb == 1'b1)
    dec_stall = 1'b1;
   
  // If the second DEC operand has the same address as WRB operand then stall
  if(dec_rs2 == wrb_rd && dec_rs2_renb == 1'b1 && wrb_rd_wenb == 1'b1)
    dec_stall = 1'b1;
    
  end


  //===========================================================================
  // Leave these next two lines intact for Part (a), but for Part (b)
  // the logic for dec_rs1_data and dec_rs2_data will need to be modified.
  //
  dec_rs1_data    = dec_rdata1;
  dec_rs2_data    = dec_rdata2;
 
  end // bypass_stall_PROC

endmodule
