module register_file(
  input [4:0] a1,        // endereço da leitura 1
  input [4:0] a2,        // endereço da leitura 2
  input [4:0] a3,        // endereço da escrita
  input signed [31:0] WD3,      // dados para escrita
  input WE3,             // habilitação para escrita
  input clk,             // sinal de clock
  output signed [31:0] RD1,    // dados lidos 1
  output signed [31:0] RD2     // dados lidos 2
);

  reg signed [31:0] registers [0:31];  // array de registradores de 32 bits

  // Leitura dos registradores
  assign RD1 = (a1 == 0) ? 32'd0 : registers[a1];
  assign RD2 = (a2 == 0) ? 32'd0 : registers[a2];

  // Inicialização dos registradores (para simulação)
  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) 
      registers[i] = 32'd0;
  end

  // Escrita nos registradores
  always @(posedge clk) begin
    if (WE3 && (a3 != 0)) begin
      registers[a3] <= WD3;
    end
  end

endmodule
