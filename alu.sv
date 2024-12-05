module ALU(
  input [2:0] aluControl, 
  input signed [31:0] srcA, 
  input signed [31:0] srcB, 
  output zero, 
  output signed [31:0] aluResult 
);

  parameter ADD = 3'b010; 
  parameter SUBT = 3'b110; 
  parameter AND = 3'b000; 
  parameter OR = 3'b001; 
  parameter SETLESSTHAN = 3'b111;
  
  assign aluResult = (aluControl == ADD) ? (srcA + srcB): 
                     (aluControl == SUBT) ? (srcA - srcB): 
                     (aluControl == AND) ? (srcA && srcB): 
                     (aluControl == OR) ? (srcA || srcB): 
                     (aluControl == SETLESSTHAN) ? (srcA < srcB): 32'd0;
  
  assign zero = (aluResult == 0) ? 1 : 0;
  
endmodule
