module pc_src_mux (
  input PCSrc,
  input [31:0] PCPlus4,
  input [31:0] PCBranch,
  output [31:0] Result
);

 assign Result = PCSrc ? PCBranch : PCPlus4;
  
endmodule;
