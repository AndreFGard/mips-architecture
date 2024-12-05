module data_memory (
  input clk,
  input signed [31:0] A,
  input signed [31:0] WD,
  input WE,
  output reg signed [31:0] RD
);
  reg signed[31:0] Mem [31:0];
  
  always @ (clk) begin
    if (WE)
      Mem[A] <= WD; 
    else
      RD <= Mem[A];
  end
endmodule;
