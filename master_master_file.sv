
// PC SECTION
module pc_branch(
  // juntou <<2 e pcbranch
  input  [31:0] SignImm,
  input  [31:0] PCplus4,
  output [31:0] result
);
  
  assign result = PCplus4 + SignImm*4; 
endmodule;

module pc_src_mux(
  input  PCSrc,
  input  [31:0] PCPlus4,
  input  [31:0] PCBranch,
  output [31:0] Result
);

 assign Result = PCSrc ? PCBranch : PCPlus4;
endmodule;

module pc(
  input  [31:0] next_instr, 
  input  clk, 
  output reg [31:0] curr_instr 
);

  initial curr_instr = 0;
  always @(posedge clk) begin
    curr_instr = next_instr;
  end
endmodule

module pc_mux (
  input  [31:0] plus4_instr, 
  input  [31:0] branch, 
  input  PCSrc, 
  output [31:0] next_instr 
);

  assign next_instr = (PCSrc) ? branch : plus4_instr;
endmodule

module pc_plus_4(
  input  [INSTRSIZE:0] last_instr, 
  output [INSTRSIZE:0] next_instr
);

  parameter INSTRSIZE = 31;  

  assign next_instr = last_instr + 4;
endmodule

module pc_jump_mux (
  input [31:0] PCcommaw, 
  input jump, 
  input [25:0] target,  
  output reg [31:0] pc_jump_output
);
  
  reg [31:0] target_times_4;
  
  always @(*) begin
    if (jump) begin
      target_times_4 = target*4;
      pc_jump_output = {PCcommaw[31:28], target_times_4};
      // $display("%b %b", PCcommaw[31:28], target_times_4);
    end else begin
      pc_jump_output = PCcommaw;
    end
  end
endmodule

// INSTRUCTION MEMORY

module instruction_memory(
  input [31:0] A,        
  output reg [31:0] RD       
);
  reg [7:0] memoria [72:0]; 

  initial begin
    // addi $at, $zero, 10 
    memoria[0]  = 8'b001000_00;  
    memoria[1]  = 8'b000_00001;  
    memoria[2]  = 8'b00000000;  
    memoria[3]  = 8'b00001010;  

    // sw $at, 1($zero)
    memoria[4] = 8'b101011_00;  
    memoria[5] = 8'b000_00001;  
    memoria[6] = 8'b00000000;  
    memoria[7] = 8'b00000001;

    // addi $v0, $zero, 20 
    memoria[8]  = 8'b001000_00;  
    memoria[9]  = 8'b000_00010;  
    memoria[10]  = 8'b00000000; 
    memoria[11]  = 8'b00010100; 

    // sw $v0, 2($zero)
    memoria[12] = 8'b101011_00;  
    memoria[13] = 8'b000_00010;  
    memoria[14] = 8'b00000000;  
    memoria[15] = 8'b00000010;  

    // addi $v1, $zero, 50 
    memoria[16]  = 8'b001000_00; 
    memoria[17]  = 8'b000_00011; 
    memoria[18] = 8'b00000000; 
    memoria[19] = 8'b00110010; 

    // sw $v1, 3($zero)
    memoria[20] = 8'b101011_00;  
    memoria[21] = 8'b000_00011;  
    memoria[22] = 8'b00000000;  
    memoria[23] = 8'b00000011;  

    // addi $a0, $zero, 0 
    memoria[24] = 8'b001000_00; 
    memoria[25] = 8'b000_00100; 
    memoria[26] = 8'b00000000;  
    memoria[27] = 8'b0000000;
  
    // sw $a0, 4($zero)
    memoria[28] = 8'b101011_00;  
    memoria[29] = 8'b000_00100;  
    memoria[30] = 8'b00000000;  
    memoria[31] = 8'b00000100; 

    // lw $at,1($zero)
    memoria[32] = 8'b100011_00;  
    memoria[33] = 8'b000_00001;  
    memoria[34] = 8'b00000000;  
    memoria[35] = 8'b00000001;  

    // lw $v0,2($zero)
    memoria[36] = 8'b100011_00;  
    memoria[37] = 8'b000_00010;  
    memoria[38] = 8'b00000000;  
    memoria[39] = 8'b00000010;  

    // lw $v1,3($zero)
    memoria[40] = 8'b100011_00;  
    memoria[41] = 8'b000_00011;  
    memoria[42] = 8'b00000000;  
    memoria[43] = 8'b00000011;  

    // lw $a0,4($zero) 
    memoria[44] = 8'b100011_00;  
    memoria[45] = 8'b000_00100;  
    memoria[46] = 8'b00000000;  
    memoria[47] = 8'b00000100;  

    // add  $at, $v0, $at
    memoria[48] = 8'b000000_00;  
    memoria[49] = 8'b001_00010;  
    memoria[50] = 8'b00001_000;  
    memoria[51] = 8'b00_100000;  

    // addi $a0, $zero, 1
    memoria[52] = 8'b001000_00;  
    memoria[53] = 8'b100_00100;  
    memoria[54] = 8'b00000000;  
    memoria[55] = 8'b00000001; 

    // sw   $at,1($zero)
    memoria[56] = 8'b101011_00;  
    memoria[57] = 8'b000_00001;  
    memoria[58] = 8'b00000000;  
    memoria[59] = 8'b00000001;  

    // sw   $a0,4($zero)
    memoria[60] = 8'b101011_00;  
    memoria[61] = 8'b000_00100;  
    memoria[62] = 8'b00000000;  
    memoria[63] = 8'b00000100;  

    // beq  $at, $v1, 420000
    memoria[64] = 8'b000100_00;  
    memoria[65] = 8'b001_00011;  
    memoria[66] = 8'b00000000;  
    memoria[67] = 8'b11111111;  

    // j 8
    memoria[68] = 8'b000010_00;  
    memoria[69] = 8'b00000000;  
    memoria[70] = 8'b00000000;  
    memoria[71] = 8'b00001000;  
  end

  always @(A) begin
      RD[7:0]   = memoria[A+3];
      RD[15:8]  = memoria[A+2];
      RD[23:16] = memoria[A+1];
      RD[31:24] = memoria[A];
  end
endmodule


// REGISTER FILE
module register_file(
  input [4:0] a1, 
  input [4:0] a2, 
  input [4:0] a3, 
  input signed [31:0] WD3, 
  input WE3, 
  input clk, 
  output signed [31:0] RD1, 
  output signed [31:0] RD2 
);

  reg signed [31:0] registers [0:31]; 

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) 
      registers[i] = 32'd0;
  end

  assign RD1 = (a1 == 0) ? 32'd0 : registers[a1];
  assign RD2 = (a2 == 0) ? 32'd0 : registers[a2];

  always @(posedge clk) begin
    if (WE3 && (a3 != 0)) begin
      registers[a3] <= WD3;
    end
  end
endmodule

module reg_dst_mux(
  input  RegDst,
  input  [4:0] inst_20_16,
  input  [4:0] inst_15_11,
  output [4:0] WriteReg
);

 assign WriteReg = RegDst ? inst_15_11 : inst_20_16;
endmodule;


// SIGN EXTEND
module sign_extend(
  input  signed [15:0] instr,
  output signed [31:0] SignImm
);
  
  assign SignImm = (instr[15]) ? {16'b1111111111111111, instr} : {16'b0, instr};
endmodule


// ALU
module ALU(
  input  [2:0] aluControl, 
  input  signed [31:0] srcA, 
  input  signed [31:0] srcB, 
  output zero, 
  output signed [31:0] aluResult 
);

  parameter ADD  = 3'b010; 
  parameter SUBT = 3'b110; 
  parameter AND  = 3'b000; 
  parameter OR   = 3'b001; 
  parameter SETLESSTHAN = 3'b111;
  
  assign aluResult = (aluControl == ADD) ? (srcA + srcB): 
                     (aluControl == SUBT) ? (srcA - srcB): 
                     (aluControl == AND) ? (srcA && srcB): 
                     (aluControl == OR) ? (srcA || srcB): 
                     (aluControl == SETLESSTHAN) ? (srcA < srcB): 
                     32'd0;
  
  assign zero = (aluResult == 0) ? 1 : 0;
endmodule

module alu_scr_mux(
  input  ALUSrc,
  input  [31:0] RD2,
  input  [31:0] SignImm,
  output [31:0] SrcB
);

  assign SrcB = (ALUSrc) ? SignImm : RD2;
endmodule;


//  DATA MEMORY
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

module mem_to_reg_mux(
  input MemtoReg,
  input [31:0] ALUResult,
  input [31:0] ReadData,
  output [31:0] Result
);

 assign Result = MemtoReg ? ReadData : ALUResult;
endmodule;


// CONTROL UNIT
module control_unit(
  input [5:0] op,
  input [5:0] funct,
  output reg mentoreg, 
  output reg menwrite, 
  output reg branch, 
  output reg alusrc, 
  output reg regdst, 
  output reg regwrite, 
  output reg jump,
  output [2:0] aluControl
);

  reg [1:0] aluop; 

  initial begin
      mentoreg = 0;
      menwrite = 0;
      branch = 0;
      alusrc = 0;
      regdst = 0;
      regwrite = 0;
      aluop = 2'b00;
      jump = 0;
  end

  always @ (op) begin
    case (op)
      // R-type
      6'b000000: begin
          mentoreg = 0;
          menwrite = 0;
          branch = 0;
          aluop = 2'b10; 
          alusrc = 0;
          regdst = 1;      
          regwrite = 1;
          jump = 0;
      end

      // SW (Store Word)
      6'b101011: begin
          mentoreg = 0;
          menwrite = 1;
          branch = 0;
          alusrc = 1;
          aluop = 2'b00;
          regdst = 0;
          regwrite = 0;
          jump = 0;
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
          jump = 0;
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
        jump = 0;
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
          jump = 0;
      end

      // J 
      6'b000010: begin
            mentoreg = 0;
            menwrite = 0;
            branch = 1;
            aluop = 2'b01; 
            alusrc = 0;
            regwrite = 0;
          jump = 1;
        end
    endcase
  end

  // parâmetros para controle da ALU
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

  // controle da ALU
  assign aluControl = (aluop == 2'b00) ? ADD : 
                      (aluop == 2'b01) ? SUBT :   
                      (aluop == 2'b10) ? (
                          (funct == FADD) ? ADD :
                          (funct == FSUBT) ? SUBT :
                          (funct == FOR) ? OR :
                          (funct == FAND) ? AND : 
                          (funct == FSLT) ? SETLESSTHAN :
                          3'b000
                      ) : 
                      3'b000;
endmodule


// CONEXÃO
module ttB;
    parameter INSTRSIZE = 31;
    reg clk = 0;
 
    wire pc_src_w;
    wire [INSTRSIZE:0] pc_src_mux_output; 
    wire [INSTRSIZE:0] pc_branch_w; 
  	wire [INSTRSIZE:0] pc_plus_4_w; 
  	wire [INSTRSIZE:0] pc_jump_output;
  	wire [INSTRSIZE:0] pc_w;
  	wire [INSTRSIZE:0] sign_imm_w;
    

    // PC MUX
  	pc_mux   pc_mux_t(
      pc_plus_4_w, 
      pc_branch_w, 
      pc_src_w, 
      pc_src_mux_output
    );
    
    // PC
  	pc   pc_t (
      pc_jump_output, 
      clk, 
      pc_w 
    );
    
    // PC PLUS 4
  	pc_plus_4   pc_plus_4_t (
      pc_w, 
      pc_plus_4_w
    );
    
    // PC BRANCH
  	pc_branch   pc_branch_t (
      sign_imm_w, 
      pc_plus_4_w, 
      pc_branch_w
    );

    // INSTRUCTION MEMORY
    reg [31:0] instr_w;
    instruction_memory   instruction_memory_t(
      pc_w, 
      instr_w
    );

    wire  [5:0]  instr_31_26; 
  	wire  [4:0]  instr_25_21; 
    wire [25:0]  instr_25_0; 
  	wire  [4:0]  instr_20_16; 
  	wire  [4:0]  instr_15_11; 
  	wire signed  [15:0] instr_15_0; 
  	wire  [5:0]  instr_5_0;

    assign instr_31_26 = instr_w[31:26];
    assign instr_25_21 = instr_w[25:21];
    assign instr_25_0  = instr_w[25:0];
    assign instr_20_16 = instr_w[20:16];
    assign instr_15_11 = instr_w[15:11];
    assign instr_15_0  = instr_w[15:0];
    assign instr_5_0   = instr_w[5:0];


    // REG DST MUX
  	wire [4:0] write_reg_w; 
  	wire reg_dst_w;
  	reg_dst_mux   reg_dst_mux_t(
      reg_dst_w, 
      instr_20_16, 
      instr_15_11, 
      write_reg_w
    );

    // SIGN EXTEND
    sign_extend   sign_extend_t (
      instr_15_0,
      sign_imm_w
    );

    // CONTROL UNIT
    wire reg_write_w;
 	wire mem_write_w;
  	wire mem_to_reg_w;
  	wire branch_w; 
  	wire alu_src_w; 
  	wire jump_w;
  	wire [2:0] alu_control_w;
  
  	control_unit control_unit_t(
      instr_31_26,
      instr_5_0,
      mem_to_reg_w, 
      mem_write_w, 
      branch_w,
      alu_src_w, 
      reg_dst_w, 
      reg_write_w, 
      jump_w,
      alu_control_w
    );

    // PC JUMP MUX
    pc_jump_mux pc_jump_mux_t(
      pc_src_mux_output,
      jump_w,
      instr_25_0,
      pc_jump_output
    );

    // REGISTER FILE
    wire signed [31:0] mem_to_reg_mux_output; 
    wire [31:0] rd1_w; 
    wire [31:0] rd2_w;
    
    register_file   register_file_t(
      instr_25_21, 
      instr_20_16, 
      write_reg_w, 
      mem_to_reg_mux_output,
      reg_write_w,
      clk,
      rd1_w,
      rd2_w
    );

    // ALU SRC MUX
 	wire [31:0] src_b_w;
  	alu_scr_mux   alu_scr_mux_t (
      alu_src_w, 
      rd2_w, 
      sign_imm_w, 
      src_b_w
    );

    // ALU 
 	wire zero_w;
  	wire signed [31:0] alu_result_w;
  	ALU   alu_t (
      alu_control_w, 
      rd1_w, 
      src_b_w, 
      zero_w, 
      alu_result_w
    );

    // PC SRC
	assign pc_src_w = branch_w && zero_w;

    // MEM TO REG MUX
  	wire [31:0] read_data_w;
  	mem_to_reg_mux   mem_to_reg_mux_t (
      mem_to_reg_w, 
      alu_result_w, 
      read_data_w, 
      mem_to_reg_mux_output
    );
	
    // DATA MEMORY
  	data_memory   data_memory_t (
      clk,
      alu_result_w,
      rd2_w,
      mem_write_w,
      read_data_w
    );
  

 	// clock
    initial forever #5 clk = ~clk;

    // SAÍDA DETALHADA
    // integer i;
    // always @(posedge clk) begin
    //   if (pc_w>32'd68) begin
    //     $display("Fim. ");
    //     $finish;  
    //   end 
    //   $display("PC: %0d", pc_w);
    //   $display("Memória: ");
    //   for (i = 0; i < 31; i = i + 1) begin
    //     $write("%0d ", data_memory_t.Mem[i]); 
    //   end
    //   $display("");
    //   $display("REG[1] = %0d ; REG[3] %0d ?", register_file_t.registers[1], register_file_t.registers[3]);
    //   $display("");
    // end


    // SAÍDA SIMPLES
    // always @(data_memory_t.Mem[4]) begin
    // $display("%0d %0d %0d", data_memory_t.Mem[4], data_memory_t.Mem[1], data_memory_t.Mem[3]);
    // end
  
    initial begin
      #300 $finish;
    end

    endmodule
