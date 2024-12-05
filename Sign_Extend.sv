module Sign_Extend(
  input signed [15:0] instr,
  output signed [31:0] SignImm
);
  
  assign SignImm = instr[15] ? {16'b1111111111111111, instr} : {16'b0, instr};
  
endmodule
