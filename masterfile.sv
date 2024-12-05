module ttB;
    //joins all the components of the computer
    parameter INSTRSIZE = 31;
    reg clk = 0;
 
    wire PCSrcw;

    // instruction are dealt withj here
    wire [INSTRSIZE:0] PCcommaw; 
    wire [INSTRSIZE:0] PCBranchw; 
  	wire [INSTRSIZE:0] PCplus4w; 
  	wire [INSTRSIZE:0] PCw;
    
  	wire [INSTRSIZE:0] SignImmw;
    
  	pc_mux pc_multiplexertb(
      PCplus4w, 
      PCBranchw, 
      PCSrcw, 
      PCcommaw
    );
    
  	pc pctb (
      PCcommaw, 
      clk, 
      PCw 
    );
    
  	pcplus4 pcplus4tb (
      PCw, 
      PCplus4w
    );
    
  	pc_branch pc_brancht (
      SignImmw, 
      PCplus4w, 
      PCBranchw
    );

    reg [31:0] Instrw;
    instruction_memory instruction_memorytb(
      PCw, 
      Instrw
    );


    //instruction wires outputs
    wire [5:0] instr_31_26; 
  	wire [4:0] instr_25_21; 
  	wire [4:0] instr_20_16; 
  	wire [4:0] instr_15_11; 
  	wire signed [15:0] instr_15_0; 
  	wire [5:0] instr_5_0;

    assign instr_31_26 = Instrw[31:26];
    assign instr_25_21 = Instrw[25:21];
    assign instr_20_16 = Instrw[20:16];
    assign instr_15_11 = Instrw[15:11];
    assign instr_15_0  = Instrw[15:0];
    assign instr_5_0   = Instrw[5:0];

    
  	wire [4:0] writeregw; 
  	wire regdstw;
    
  	reg_dst_mux reg_dst_muxt(
      regdstw, 
      instr_20_16, 
      instr_15_11, 
      writeregw
    );

    wire signed [31:0] resultw; //wire that comes from the ALU or the data memory //////////////ASSIGN ME PLS
    wire RegWriteCUw;
    wire [31:0] RD1w; 
  	wire [31:0] RD2w;
   
 	wire memwritewCU;
  	wire memtoregCUw;
  	wire branchCUw; 
  	wire alusrcCUw; 
  	wire [2:0] alucontrolCUw;
  
  	control_unit control_unitt(
      instr_31_26,
      instr_5_0,memtoregCUw, 
      memwritewCU, 
      branchCUw,
      alusrcCUw, 
      regdstw, 
      RegWriteCUw, 
      alucontrolCUw
    );

 	wire [31:0] SrcBw;

  	alu_scr_mux alu_scr_muxt (
      .ALUSrc(alusrcCUw), 
      .RD2(RD2w), 
      .SignImm(SignImmw), 
      .SrcB(SrcBw)
    );

 	wire zerow;
  	wire signed [31:0] aluResultw;
  	ALU ALUt (
      .aluControl(alucontrolCUw), 
      .srcA(RD1w), 
      .srcB(SrcBw), 
      .zero(zerow), 
      .aluResult(aluResultw)
    );

	assign PCSrcw = branchCUw && zerow;

  	wire [31:0] ReadDataw;
  	mem_to_reg_mux mem_to_regt (
      .MemtoReg(memtoregCUw), 
      .ALUResult(aluResultw), 
      .ReadData(ReadDataw), 
      .Result(resultw)
    ); //Atenção ao nome ReadDataw
  
  	register_file register_filet(
      .a1(instr_25_21), 
      .a2(instr_20_16), 
      .a3(writeregw), 
      .WD3(resultw),
      .WE3(RegWriteCUw), 
      .RD1(RD1w),
      .RD2(RD2w),
      .clk(clk)
    );
	
  	data_memory data_memoryt (
      .clk(clk),
      .A(aluResultw),
      .WD(RD2w),
      .WE(memwritewCU),
      .RD(ReadDataw)
    );
  
    Sign_Extend Sign_Extendt (
      .instr(instr_15_0),
      .SignImm(SignImmw)
    );

 	// clock
    initial forever #5 clk = ~clk;

//     initial forever begin
//       #5 $display("\nPCw (curr): %d, plus4w %d, PCBranchw %d PCSrcw %d", PCw, PCplus4w, PCBranchw, PCSrcw);
//       //$display("Instrucao: %b", Instrw);
//       //$display("\treg a1:%b %d reg a2:%b %d, a3 %b %d", instr_25_21, register_filet.registers[instr_25_21],instr_20_16, register_filet.registers[1]);
//       //$display("\t\tREG 1:%d |A3 %b| WE %b| WD %d| aluresult %d", register_filet.registers[5'b00001], writeregw,RegWriteCUw, resultw,aluResultw);
//       //control unit tests
//       //$display("memtoreg %d  memwrite %d branch %d alusrc %d regdst %d regwrite %d alucontrol %b", memtoregCUw, memwritewCU,branchCUw,alusrcCUw,regdstw,RegWriteCUw,alucontrolCUw);
//       //alu tests
//       //$display("alucontrol %b| aluA %d, aluB %d, aluResult %d, aluzero %b", ALUt.aluControl,ALUt.srcA,ALUt.srcB,ALUt.aluResult,ALUt.zero);
// $display("\t$a0 %d, $a1 %d, $a2 %d, $a3 %d,\n\t$at %d, $t0 %d, $t1 %d, $t2 %d,\n\t$v0 %d, $v1 %d",
//          register_filet.registers[4],   // $a0
//          register_filet.registers[5],   // $a1
//          register_filet.registers[6],   // $a2
//          register_filet.registers[7],   // $a3
//          register_filet.registers[1],   // $at
//          register_filet.registers[10],  // $t0
//          register_filet.registers[11],  // $t1
//          register_filet.registers[12],  // $t2
//          register_filet.registers[2],   // $v0
//          register_filet.registers[3]);  // $v1
//       end
	
  
  
  
  	// print array
    integer i;
  //   initial forever begin
  //      #5
  //      for (i = 0; i < 31; i = i + 1) begin
  //        $write("%d ", data_memoryt.Mem[i]); 
  //      end
  //      $display("");
  //     for (i = 0; i < 31; i = i + 1) begin
  //       $write("%d ", register_filet.registers[i]); 
  //      end
  //      $display("");
   
	// end

  initial forever begin
    #5;
    for (i = 0; i<16; i = i +1) begin
      if (register_filet.registers[i])
        $write("%d: %d ",i, register_filet.registers[i]);
    end
    $display(" ");
  end

	initial forever begin
       #10
      $display("%0d = %0d ?", register_filet.registers[1], register_filet.registers[3]);
      if (PCw==32'd1060) begin
        $display("Fim. ");
        $finish;  
      end
      $display("PC : %0d", PCw);

	end
  
  	initial forever begin
      #5;
      // print register file;
      // $display("%b %b %b %b %b %b", register_filet.a1, register_filet.a2, register_filet.a3, register_filet.WD3, register_filet.RD1, register_filet.RD2);
      
      // print alu;
      // $display("%d %d %d", ALUt.srcA, ALUt.srcB, ALUt.aluResult);
      
      // print sign extend;
      // $display("%b %b", Sign_Extendt.instr, Sign_Extendt.SignImm);
      
      // print data memory
      // $display("%d %d %d", data_memoryt.A, data_memoryt.WD, data_memoryt.RD);
      
    end

    initial begin
      #300 $finish;
    end

    endmodule
