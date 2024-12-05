module control_unit(
    input [5:0] op,
    input [5:0] funct,
    output reg mentoreg,       // Saída: controle para armazenamento na ALU
    output reg menwrite,       // Saída: controle para escrita no registrador
    output reg branch,         // Saída: controle para desvio condicional
    output reg alusrc,         // Saída: controle para fonte do operando da ALU
    output reg regdst,         // Saída: controle para registrador de destino
    output reg regwrite,       // Saída: controle para escrever no registrador
    output [2:0] aluControl
);
    reg [1:0] aluop;           // Controle para a ALU

    // Inicializações padrão
    initial begin
        mentoreg = 0;
        menwrite = 0;
        branch = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        aluop = 2'b00;
    end

    // Decodificação do código de operação
    always @ (op) begin
        case (op)
            // SW (Store Word)
            6'b101011: begin
                mentoreg = 0;
                menwrite = 1;
                branch = 0;
                alusrc = 1;
                aluop = 2'b00;
                regdst = 0;
                regwrite = 0;
            end
            
            // LW (Load Word)
            6'b100011: begin
                mentoreg = 1;
                menwrite = 0;
                branch = 0;
                alusrc = 1;
                aluop = 2'b00;
                regdst = 0;
                regwrite = 1;
            end
            
            // R-type
            6'b000000: begin
                mentoreg = 0;
                menwrite = 0;
                branch = 0;
                aluop = 2'b10;        // Definir operação da ALU para R-type
                alusrc = 0;
                regdst = 1;      
                regwrite = 1;
            end

            // ADDI
            6'b001000: begin
                mentoreg = 0;
                menwrite = 0;
                branch = 0;
                aluop = 2'b00; 
                alusrc = 1;
                regdst = 0;      
                regwrite = 1;
            end

            // BEQ
            6'b000100: begin
                mentoreg = 0;
                menwrite = 0;
                branch = 1;
                aluop = 2'b01; 
                alusrc = 0;
                regdst = 0;      
                regwrite = 0;
            end
        endcase
    end

    // Definição dos parâmetros para controle da ALU
    parameter ADD = 3'b010;
    parameter SUBT = 3'b110;
    parameter AND = 3'b000;
    parameter OR = 3'b001;
    parameter SETLESSTHAN = 3'b111;
    parameter FADD = 6'b100000;
    parameter FSUBT = 6'b100010;
    parameter FAND = 6'b100100;
    parameter FOR = 6'b100101;
    parameter FSLT = 6'b101010;

    // Atribuição do controle da ALU baseado em aluop e funct
    assign aluControl = (aluop == 2'b00) ? ADD : 
                        (aluop == 2'b01) ? SUBT :   
                        (aluop == 2'b10) ? (
                            (funct == FADD) ? ADD :
                            (funct == FSUBT) ? SUBT :
                            (funct == FOR) ? OR :
                            (funct == FAND) ? AND : 
                            (funct == FSLT) ? SETLESSTHAN :
                            3'b000
                        ) : 3'b000;
endmodule
