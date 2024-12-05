module ttB;
    //joins all the components of the computer
    parameter INSTRSIZE = 31;
    reg clk = 0;
  

    //CU wires
    wire PCSrcw;

    // instruction are dealt withj here
    wire [INSTRSIZE:0] PCcommaw; wire [INSTRSIZE:0] PCBranchw; wire [INSTRSIZE:0] PCplus4w; wire [INSTRSIZE:0] PCw;
    reg [INSTRSIZE:0] SignImmw = 0;
    pc_mux pc_multiplexertb(PCplus4w, PCBranchw, PCSrcw, PCcommaw);
    pc pctb (PCcommaw, clk, PCw );
    pcplus4 pcplus4tb (PCw, PCplus4w);
    pc_branch pc_brancht (SignImmw, PCplus4w, PCBranchw);



    reg [31:0] Instrw;
    instruction_memory instruction_memorytb(PCw, Instrw);


    //instruction wires
    wire [5:0] instr_31_26; wire [4:0] instr_25_21; wire [4:0] instr_20_16; 
  wire [4:0] instr_15_11; wire [15:0] instr_15_0; wire [5:0] instr_5_0;

    assign instr_31_26 = Instrw[31:26];
    assign instr_25_21 = Instrw[25:21];
    assign instr_20_16 = Instrw[20:16];
    assign instr_15_11 = Instrw[15:11];
    assign instr_15_0  = Instrw[15:0];
    assign instr_5_0   = Instrw[5:0];

    wire [4:0] writeregw; wire regdstw;
    reg_dst_mux reg_dst_muxt(regdstw, instr_20_16, instr_15_11, writeregw);

    wire [31:0] resultw; //wire that comes from the ALU or the data memory //////////////ASSIGN ME PLS
    wire RegWriteCUw;
    wire [31:0] RD1w; wire [31:0] RD2w;
    register_file register_filet(.a1(instr_25_21),.a2(instr_20_16),.a3(writeregw),.WD3(resultw),.WE3(RegWriteCUw),.RD1(RD1w),.RD2(RD2w),.clk(clk));
   
  
  wire memwritewCU;wire memtoregCUw;wire branchCUw; wire alusrcCUw; wire [2:0] alucontrolCUw;
  
  control_unit control_unitt(instr_31_26, instr_5_0,memtoregCUw,memwritewCU,branchCUw,alusrcCUw,regdstw,RegWriteCUw,alucontrolCUw);

  wire [31:0] SrcBw;

  alu_scr_mux alu_scr_muxt (.ALUSrc(alusrcCUw), .RD2(RD2w), .SignImm(SignImmw), .SrcB(SrcBw));

  wire zerow;
  wire [31:0] aluResultw;
  ALU ALUt (.aluControl(alucontrolCUw), .srcA(RD1w), .srcB(SrcBw), .zero(zerow), .aluResult(aluResultw));


  assign PCSrcw = branchCUw && zerow;

  wire [31:0] ReadDataw;
  mem_to_reg_mux mem_to_regt (.MemtoReg(memtoregCUw), .ALUResult(aluResultw), .ReadData(ReadDataw), .Result(resultw)); //Atenção ao nome ReadDataw

 
    initial forever #5 clk = ~clk;

    initial forever begin
      #5 $display("PCw (curr): %d, plus4w %d, PCBranchw %d PCSrcw %d", PCw, PCplus4w, PCBranchw, PCSrcw);
      $display("%b", Instrw);
      
      //control unit tests
      $display("memtoreg %d  memwrite %d branch %d alusrc %d regdst %d regwrite %d alucontrol %b", memtoregCUw, memwritewCU,branchCUw,alusrcCUw,regdstw,RegWriteCUw,alucontrolCUw);
      end


    initial begin
      #70 $finish;
    end

    endmodule
