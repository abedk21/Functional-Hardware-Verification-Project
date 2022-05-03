`default_nettype none
module calc1_tb ();

   reg        c_clk       ;
   reg [ 1:7] reset       ;
   reg [ 0:3] req1_cmd_in ;
   reg [0:31] req1_data_in;
   reg [ 0:3] req2_cmd_in ;
   reg [0:31] req2_data_in;
   reg [ 0:3] req3_cmd_in ;
   reg [0:31] req3_data_in;
   reg [ 0:3] req4_cmd_in ;
   reg [0:31] req4_data_in;

   wire [ 0:1] out_resp1;
   wire [0:31] out_data1;
   wire [ 0:1] out_resp2;
   wire [0:31] out_data2;
   wire [ 0:1] out_resp3;
   wire [0:31] out_data3;
   wire [ 0:1] out_resp4;
   wire [0:31] out_data4;

   reg [0:31] data1, data2, data3, data4;
   reg [ 0:3] cmd1, cmd2, cmd3, cmd4;
   reg [0:31] expected_data1, expected_data2, expected_data3, expected_data4;

   integer error_count = 0;

   integer correct_count = 0;

   localparam
      No_Op = 4'b0000,
      Add = 4'b0001,
      Sub = 4'b0010,
      Shift_Left = 4'b0101,
      Shift_Right = 4'b0110;

   localparam
      No_Response = 2'b00,
      Success = 2'b01,
      Invalid_Command = 2'b10,
      Overflow = 2'b10,
      Underflow = 2'b10,
      Internal_Error = 2'b11;

   localparam
      Max = 32'hFFFFFFFF,
      Min = 32'h00000000;

   reg [0:3] Opcode;

   reg overflow_check1, overflow_check2, overflow_check3, overflow_check4, underflow_check1, underflow_check2, underflow_check3, underflow_check4;

   calc1_top calc1_top (
      .c_clk       (c_clk       ),
      .reset       (reset       ),
      .req1_cmd_in (req1_cmd_in ),
      .req1_data_in(req1_data_in),
      .req2_cmd_in (req2_cmd_in ),
      .req2_data_in(req2_data_in),
      .req3_cmd_in (req3_cmd_in ),
      .req3_data_in(req3_data_in),
      .req4_cmd_in (req4_cmd_in ),
      .req4_data_in(req4_data_in),
      .out_resp1   (out_resp1   ),
      .out_data1   (out_data1   ),
      .out_resp2   (out_resp2   ),
      .out_data2   (out_data2   ),
      .out_resp3   (out_resp3   ),
      .out_data3   (out_data3   ),
      .out_resp4   (out_resp4   ),
      .out_data4   (out_data4   ),
      .scan_out    (            ),
      .a_clk       (            ),
      .b_clk       (            ),
      .error_found (            ),
      .scan_in     (            )
   );

   initial begin
      c_clk = 0;
      forever #50 c_clk = !c_clk;
   end

   initial begin
      reset[1:7]      =       7'b1111111;

      req1_cmd_in    = 4'b0000;
      req2_cmd_in    = 4'b0000;
      req3_cmd_in    =4'b0000;
      req4_cmd_in    = 4'b0000;
      req1_data_in   =       32'h00000000;
      req2_data_in   =       32'h00000000;
      req3_data_in   =       32'h00000000;
      req4_data_in   =       32'h00000000;

      repeat(7)@(posedge c_clk);
      reset[1:7] =    ~reset[1:7];

      repeat(1)@(posedge c_clk);
      //  reset[1:7]  <=      ~reset[1:7];

      Opcode = Add;

      $display("Add (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000001;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Add (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000001;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Add (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000001;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Add (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000001;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = Sub;

      $display("Sub (Port 1)");
      req1_cmd_in             =       Opcode;
      req1_data_in           =       32'h00000002;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Sub (Port 2)");
      req2_cmd_in             =       Opcode;
      req2_data_in           =       32'h00000002;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Sub (Port 3)");
      req3_cmd_in             =       Opcode;
      req3_data_in           =       32'h00000002;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Sub (Port 4)");
      req4_cmd_in             =       Opcode;
      req4_data_in           =       32'h00000002;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      Opcode = Shift_Left;

      $display("Shift Left (Port 1)");
      req1_cmd_in             =       Opcode;
      req1_data_in           =       32'h00000001;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000002;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << req1_data_in[27:31];

      $display("Shift Left (Port 2)");
      req2_cmd_in             =       Opcode;
      req2_data_in           =       32'h00000001;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000002;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 << req2_data_in[27:31];

      $display("Shift Left (Port 3)");
      req3_cmd_in             =       Opcode;
      req3_data_in           =       32'h00000001;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000002;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 << req3_data_in[27:31];

      $display("Shift Left (Port 4)");
      req4_cmd_in             =       Opcode;
      req4_data_in           =       32'h00000001;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000002;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 << req4_data_in[27:31];

      Opcode = Shift_Right;

      $display("Shift Right (Port 1)");
      req1_cmd_in             =       Opcode;
      req1_data_in           =       32'h80000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000002;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 >> req1_data_in[27:31];

      $display("Shift Right (Port 2)");
      req2_cmd_in             =       Opcode;
      req2_data_in           =       32'h80000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000002;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 >> req2_data_in[27:31];

      $display("Shift Right (Port 3)");
      req3_cmd_in             =       Opcode;
      req3_data_in           =       32'h80000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000002;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 >> req3_data_in[27:31];

      $display("Shift Right (Port 4)");
      req4_cmd_in             =       Opcode;
      req4_data_in           =       32'h80000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000002;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 >> req4_data_in[27:31];

      Opcode = Add;

      $display("Overflow (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000000F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Overflow (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000000F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Overflow (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000000F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Overflow (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000000F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = Sub;

      $display("Underflow (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000000F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Underflow (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000000F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Underflow (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000000F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Underflow (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000000F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      Opcode = Add;

      $display("Dirty State: Addition followed by Subtraction (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       Sub;
      req1_data_in           =       32'h000F0F0F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Dirty State: Addition followed by Subtraction (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000FFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       Sub;
      req2_data_in           =       32'h000F0F0F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Dirty State: Addition followed by Subtraction (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000FFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       Sub;
      req3_data_in           =       32'h000F0F0F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Dirty State: Addition followed by Subtraction (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000FFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       Sub;
      req4_data_in           =       32'h000F0F0F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = Shift_Left;

      $display("Dirty State: Shift Left followed by Shift Right (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       Shift_Right;
      req1_data_in           =       32'h0000000F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << req1_data_in[27:31];

      $display("Dirty State: Shift Left followed by Shift Right (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000FFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       Shift_Right;
      req2_data_in           =       32'h0000000F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 << req2_data_in[27:31];

      $display("Dirty State: Shift Left followed by Shift Right (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000FFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       Shift_Right;
      req3_data_in           =       32'h0000000F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 << req3_data_in[27:31];

      $display("Dirty State: Shift Left followed by Shift Right (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000FFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       Shift_Right;
      req4_data_in           =       32'h0000000F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 << req4_data_in[27:31];

      Opcode = Add;

      $display("Dirty State: Across all ports, Addition followed by subtraction");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       Sub;
      req2_cmd_in                     =       Sub;
      req3_cmd_in                     =       Sub;
      req4_cmd_in                     =       Sub;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;
      expected_data2 = data2 + req2_data_in;
      expected_data3 = data3 + req3_data_in;
      expected_data4 = data4 + req4_data_in;

      Opcode = Shift_Left;

      $display("Dirty State: Across all ports, Shift left followed by shift right");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       Shift_Right;
      req2_cmd_in                     =       Shift_Right;
      req3_cmd_in                     =       Shift_Right;
      req4_cmd_in                     =       Shift_Right;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << req1_data_in[27:31];
      expected_data2 = data2 << req2_data_in[27:31];
      expected_data3 = data3 << req3_data_in[27:31];
      expected_data4 = data4 << req4_data_in[27:31];

      Opcode = Add;

      $display("Addition Priority");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       No_Op;
      req2_cmd_in                     =       No_Op;
      req3_cmd_in                     =       No_Op;
      req4_cmd_in                     =       No_Op;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;
      expected_data2 = data2 + req2_data_in;
      expected_data3 = data3 + req3_data_in;
      expected_data4 = data4 + req4_data_in;

      Opcode = Sub;

      $display("Subtraction Priority");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       No_Op;
      req2_cmd_in                     =       No_Op;
      req3_cmd_in                     =       No_Op;
      req4_cmd_in                     =       No_Op;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;
      expected_data2 = data2 - req2_data_in;
      expected_data3 = data3 - req3_data_in;
      expected_data4 = data4 - req4_data_in;

      Opcode = Shift_Left;

      $display("Shift left Priority");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       No_Op;
      req2_cmd_in                     =       No_Op;
      req3_cmd_in                     =       No_Op;
      req4_cmd_in                     =       No_Op;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << req1_data_in[27:31];
      expected_data2 = data2 << req2_data_in[27:31];
      expected_data3 = data3 << req3_data_in[27:31];
      expected_data4 = data4 << req4_data_in[27:31];

      Opcode = Shift_Right;

      $display("Shift right Priority");
      req1_cmd_in                    =       Opcode;
      req2_cmd_in                    =       Opcode;
      req3_cmd_in                    =       Opcode;
      req4_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       No_Op;
      req2_cmd_in                     =       No_Op;
      req3_cmd_in                     =       No_Op;
      req4_cmd_in                     =       No_Op;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t All Ports: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 >> req1_data_in[27:31];
      expected_data2 = data2 >> req2_data_in[27:31];
      expected_data3 = data3 >> req3_data_in[27:31];
      expected_data4 = data4 >> req4_data_in[27:31];

      $display("All operations at the same time");
      req1_cmd_in                    =       Add;
      req2_cmd_in                    =       Sub;
      req3_cmd_in                    =       Shift_Left;
      req4_cmd_in                    =       Shift_Right;
      req1_data_in           =       32'h00000FFF;
      req2_data_in           =       32'h00000FFF;
      req3_data_in           =       32'h00000FFF;
      req4_data_in           =       32'h00000FFF;
      data1                      =       req1_data_in;
      data2                      =       req2_data_in;
      data3                      =       req3_data_in;
      data4                      =       req4_data_in;
      cmd1                       =       req1_cmd_in;
      cmd2                       =       req2_cmd_in;
      cmd3                       =       req3_cmd_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       No_Op;
      req2_cmd_in                     =       No_Op;
      req3_cmd_in                     =       No_Op;
      req4_cmd_in                     =       No_Op;
      req1_data_in           =       32'h0000000F;
      req2_data_in           =       32'h0000000F;
      req3_data_in           =       32'h0000000F;
      req4_data_in           =       32'h0000000F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Add, data1, req1_data_in);
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Sub, data2, req2_data_in);
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Shift_Left, data3, req3_data_in);
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Shift_Right, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;
      expected_data2 = data2 - req2_data_in;
      expected_data3 = data3 << req3_data_in[27:31];
      expected_data4 = data4 >> req4_data_in[27:31];

      Opcode = Shift_Left;

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << req1_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 << req2_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 << req3_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 << req4_data_in[27:31];

      Opcode = Shift_Right;

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 >> req1_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 >> req2_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 >> req3_data_in[27:31];

      $display("Check that the high-order 27 bits are ignored in the second operand of shift left command. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00AB0FFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 >> req4_data_in[27:31];

      Opcode = Add;

      $display("Data dependent corner case: Add two numbers that overflow by 1 (“FFFFFFFF”X + 1). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Data dependent corner case: Add two numbers that overflow by 1 (“FFFFFFFF”X + 1). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Data dependent corner case: Add two numbers that overflow by 1 (“FFFFFFFF”X + 1). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Data dependent corner case: Add two numbers that overflow by 1 (“FFFFFFFF”X + 1). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      $display("Data dependent corner case: Add two numbers whose sum is “FFFFFFFF”X. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hEEEEFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h11110000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Data dependent corner case: Add two numbers whose sum is “FFFFFFFF”X. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hEEEEFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h11110000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Data dependent corner case: Add two numbers whose sum is “FFFFFFFF”X. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hEEEEFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h11110000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Data dependent corner case: Add two numbers whose sum is “FFFFFFFF”X. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hEEEEFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h11110000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = Sub;

      $display("Data dependent corner case: Subtract two equal numbers. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0000FFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000FFFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Data dependent corner case: Subtract two equal numbers. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0000FFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000FFFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Data dependent corner case: Subtract two equal numbers. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0000FFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000FFFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Data dependent corner case: Subtract two equal numbers. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0000FFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000FFFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      $display("Data dependent corner case: Subtract a number that underflows by 1 (Operand2 is one greater than Operand1). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Data dependent corner case: Subtract a number that underflows by 1 (Operand2 is one greater than Operand1). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Data dependent corner case: Subtract a number that underflows by 1 (Operand2 is one greater than Operand1). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Data dependent corner case: Subtract a number that underflows by 1 (Operand2 is one greater than Operand1). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      Opcode = Shift_Left;

      $display("Data dependent corner case: Shift Left 0 places (should return Operand1 unchanged). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1;

      $display("Data dependent corner case: Shift Left 0 places (should return Operand1 unchanged). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2;

      $display("Data dependent corner case: Shift Left 0 places (should return Operand1 unchanged). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3;

      $display("Data dependent corner case: Shift Left 0 places (should return Operand1 unchanged). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4;

      Opcode = Shift_Right;

      $display("Data dependent corner case: Shift Right 0 places (should return Operand1 unchanged). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1;

      $display("Data dependent corner case: Shift Right 0 places (should return Operand1 unchanged). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00000000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2;

      $display("Data dependent corner case: Shift Right 0 places (should return Operand1 unchanged). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3;

      $display("Data dependent corner case: Shift Right 0 places (should return Operand1 unchanged). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4;

      Opcode = Shift_Left;

      $display("Data dependent corner case: Shift Left 31 places (the max allowable shift places). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000001F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 << 31;

      $display("Data dependent corner case: Shift Left 31 places (the max allowable shift places). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000001F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 << 31;

      $display("Data dependent corner case: Shift Left 31 places (the max allowable shift places). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000001F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 << 31;

      $display("Data dependent corner case: Shift Left 31 places (the max allowable shift places). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000001F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 << 31;

      Opcode = Shift_Right;

      $display("Data dependent corner case: Shift Right 31 places (the max allowable shift places). (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000001F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 >> 31;

      $display("Data dependent corner case: Shift Right 31 places (the max allowable shift places). (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000001F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 >> 31;

      $display("Data dependent corner case: Shift Right 31 places (the max allowable shift places). (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000001F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 >> 31;

      $display("Data dependent corner case: Shift Right 31 places (the max allowable shift places). (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000001F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 >> 31;

      Opcode = Add;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X with min number. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X with min number. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X with min number. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Data dependent corner case: Add max number “FFFFFFFF”X with min number. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      $display("Data dependent corner case: Add min number. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Data dependent corner case: Add min number. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Data dependent corner case: Add min number. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Data dependent corner case: Add min number. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = Sub;

      $display("Data dependent corner case: Subtract min number. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Data dependent corner case: Subtract min number. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Data dependent corner case: Subtract min number. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00000000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Data dependent corner case: Subtract min number. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00000000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      $display("Data dependent corner case: Subtract max number. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'hFFFFFFFF;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Data dependent corner case: Subtract max number. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'hFFFFFFFF;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Data dependent corner case: Subtract max number. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'hFFFFFFFF;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Data dependent corner case: Subtract max number. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'hFFFFFFFF;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      $display("Data dependent corner case: Subtract max and min numbers. (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000000;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 - req1_data_in;

      $display("Data dependent corner case: Subtract max and min numbers. (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h00000000;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 - req2_data_in;

      $display("Data dependent corner case: Subtract max and min numbers. (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h00000000;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 - req3_data_in;

      $display("Data dependent corner case: Subtract max and min numbers. (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h00000000;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'hFFFFFFFF;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 - req4_data_in;

      Opcode = Add;

      $display("Invalid Input Data (Port 1)");
      req1_cmd_in                    =       Opcode;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h0000000F;
      data1                      =       req1_data_in;
      repeat(1)@(posedge c_clk);
      req1_data_in           =       32'h0000000F;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Invalid Input Data (Port 2)");
      req2_cmd_in                    =       Opcode;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h0000000F;
      data2                      =       req2_data_in;
      repeat(1)@(posedge c_clk);
      req2_data_in           =       32'h0000000F;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Invalid Input Data (Port 3)");
      req3_cmd_in                    =       Opcode;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h0000000F;
      data3                      =       req3_data_in;
      repeat(1)@(posedge c_clk);
      req3_data_in           =       32'h0000000F;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Invalid Input Data (Port 4)");
      req4_cmd_in                    =       Opcode;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h0000000F;
      data4                      =       req4_data_in;
      repeat(1)@(posedge c_clk);
      req4_data_in           =       32'h0000000F;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      $display("Invalid Input Data 2 (Port 1)");
      req1_data_in = 32'h0000000F;
      data1                      =       req1_data_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                    =       Opcode;
      cmd1                       =       req1_cmd_in;
      req1_data_in           =       32'h0000000F;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;

      $display("Invalid Input Data 2 (Port 2)");
      req2_data_in = 32'h0000000F;
      data2                      =       req2_data_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                    =       Opcode;
      cmd2                       =       req2_cmd_in;
      req2_data_in           =       32'h0000000F;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);
      expected_data2 = data2 + req2_data_in;

      $display("Invalid Input Data 2 (Port 3)");
      req3_data_in = 32'h0000000F;
      data3                      =       req3_data_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                    =       Opcode;
      cmd3                       =       req3_cmd_in;
      req3_data_in           =       32'h0000000F;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);
      expected_data3 = data3 + req3_data_in;

      $display("Invalid Input Data 2 (Port 4)");
      req4_data_in = 32'h0000000F;
      data4                      =       req4_data_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                    =       Opcode;
      cmd4                       =       req4_cmd_in;
      req4_data_in           =       32'h0000000F;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);
      expected_data4 = data4 + req4_data_in;

      Opcode = 4'b0011;

      $display("Illegal Input Command: 0011 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0011 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0011 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0011 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b0100;

      $display("Illegal Input Command: 0100 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b0100;

      $display("Illegal Input Command: 0100 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0100 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b0111;

      $display("Illegal Input Command: 0111 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0111 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0111 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 0111 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1000;

      $display("Illegal Input Command: 1000 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1000 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1000 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1000 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1001;

      $display("Illegal Input Command: 1001 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1001 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1001 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1001 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1010;

      $display("Illegal Input Command: 1010 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1010 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1010 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1010 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1011;

      $display("Illegal Input Command: 1011 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1011 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1011 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1011 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1100;

      $display("Illegal Input Command: 1100 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1100 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1100 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1100 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1101;

      $display("Illegal Input Command: 1101 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1101 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1101 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1101 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1110;

      $display("Illegal Input Command: 1110 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1110 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1110 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1110 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      Opcode = 4'b1111;

      $display("Illegal Input Command: 1111 (Port 1)");
      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h0010F011;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00A0C001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1111 (Port 2)");
      req2_cmd_in                    =       Opcode;
      req2_data_in           =       32'h0010F011;
      data2                      =       req2_data_in;
      cmd2                       =       req2_cmd_in;
      repeat(1)@(posedge c_clk);
      req2_cmd_in                     =       4'b0000;
      req2_data_in           =       32'h00A0C001;
      $display("time = %t Port 2: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data2, req2_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1111 (Port 3)");
      req3_cmd_in                    =       Opcode;
      req3_data_in           =       32'h0010F011;
      data3                      =       req3_data_in;
      cmd3                       =       req3_cmd_in;
      repeat(1)@(posedge c_clk);
      req3_cmd_in                     =       4'b0000;
      req3_data_in           =       32'h00A0C001;
      $display("time = %t Port 3: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data3, req3_data_in);
      repeat(1)@(posedge c_clk);

      $display("Illegal Input Command: 1111 (Port 4)");
      req4_cmd_in                    =       Opcode;
      req4_data_in           =       32'h0010F011;
      data4                      =       req4_data_in;
      cmd4                       =       req4_cmd_in;
      repeat(1)@(posedge c_clk);
      req4_cmd_in                     =       4'b0000;
      req4_data_in           =       32'h00A0C001;
      $display("time = %t Port 4: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data4, req4_data_in);
      repeat(1)@(posedge c_clk);

      $display("Reset Check");
      repeat(1)@(posedge c_clk);
      reset[1:7]      =       7'b1111111;

      req1_cmd_in    = 4'b0000;
      req2_cmd_in    = 4'b0000;
      req3_cmd_in    =4'b0000;
      req4_cmd_in    = 4'b0000;
      req1_data_in   =       32'h00000000;
      req2_data_in   =       32'h00000000;
      req3_data_in   =       32'h00000000;
      req4_data_in   =       32'h00000000;

      repeat(7)@(posedge c_clk);
      reset[1:7] =    ~reset[1:7];

      repeat(1)@(posedge c_clk);

      Opcode = Add;

      req1_cmd_in                    =       Opcode;
      req1_data_in           =       32'h00000001;
      data1                      =       req1_data_in;
      cmd1                       =       req1_cmd_in;
      repeat(1)@(posedge c_clk);
      req1_cmd_in                     =       4'b0000;
      req1_data_in           =       32'h00000001;
      $display("time = %t Port 1: Input Command = %b, Operand 1 =  %h, Operand 2 =  %h", $time, Opcode, data1, req1_data_in);
      repeat(1)@(posedge c_clk);
      expected_data1 = data1 + req1_data_in;


      $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
      $finish;

   end

   always @(out_resp1, out_resp2, out_resp3, out_resp4) begin
      if((cmd1 == Add) && (req1_data_in > (Max - data1))) begin
         overflow_check1 = 1;
      end
      else begin
         overflow_check1 = 0;
      end
      if((cmd2 == Add) && (req2_data_in > (Max - data2))) begin
         overflow_check2 = 1;
      end
      else begin
         overflow_check2 = 0;
      end
      if((cmd3 == Add) && (req3_data_in > (Max - data3))) begin
         overflow_check3 = 1;
      end
      else begin
         overflow_check3 = 0;
      end
      if((cmd4 == Add) && (req4_data_in > (Max - data4))) begin
         overflow_check4 = 1;
      end
      else begin
         overflow_check4 = 0;
      end
      if((cmd1 == Sub) && (req1_data_in > data1)) begin
         underflow_check1 = 1;
      end
      else begin
         underflow_check1 = 0;
      end
      if((cmd2 == Sub) && (req2_data_in > data2)) begin
         underflow_check2 = 1;
      end
      else begin
         underflow_check2 = 0;
      end
      if((cmd3 == Sub) && (req3_data_in > data3)) begin
         underflow_check3 = 1;
      end
      else begin
         underflow_check3 = 0;
      end
      if((cmd4 == Sub) && (req4_data_in > data4)) begin
         underflow_check4 = 1;
      end
      else begin
         underflow_check4 = 0;
      end

      if (out_resp1 == Success) begin
         if (cmd1 == No_Op) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 1: out_resp1 should be No Response ('00'b)", $time);
         end
         else if (cmd1 == Add || cmd1 == Sub || cmd1 == Shift_Left || cmd1 == Shift_Right) begin
            if (overflow_check1 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 1: Overflow but the response is Success ('01'b)", $time, cmd1);
            end
            else if (underflow_check1 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 1: Underflow but the response is Success ('01'b)", $time, cmd1);
            end
            else if (out_data1 == expected_data1) begin
               correct_count = correct_count + 1;
               $display("time = %t Input Command = %b: Correct: Output (%h) is equal to Expected Result (%h)", $time, cmd1, out_data1, expected_data1);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 1: Output (%h) is not equal to Expected Result (%h)", $time, cmd1, out_data1, expected_data1);
            end
         end
         else begin
            error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 1: Illegal command but the response is Success ('01'b)", $time, cmd1);
         end
      end
      else if (out_resp1 == 2'b10) begin
         if (out_data1 != Min) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 1: Output data is not zero", $time, cmd1);
         end
         if (cmd1 == Add) begin
            if (overflow_check1 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Overflow at Port 1", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 1: No overflow but the response is '10'b", $time, cmd1);
            end
         end
         else if (cmd1 == Sub) begin
            if (underflow_check1 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Underflow at Port 1", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 1: No underflow but the response is '10'b", $time, cmd1);
            end
         end
         else if (cmd1 == Shift_Left || cmd1 == Shift_Right) begin
            error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 1: Shift command but the response is '10'b", $time, cmd1);
         end
         else if (cmd1 != No_Op && cmd1 != Add && cmd1 != Sub && cmd1 != Shift_Left && cmd1 != Shift_Right) begin
            correct_count = correct_count + 1;
            $display("time = %t Input Command = %b: Illegal input command at Port 1", $time, cmd1);
         end
      end

      if (out_resp2 == Success) begin
         if (cmd2 == No_Op) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 2: out_resp2 should be No Response ('00'b)", $time);
         end
         else if (cmd2 == Add || cmd2 == Sub || cmd2 == Shift_Left || cmd2 == Shift_Right) begin
            if (overflow_check2 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 2: Overflow but the response is Success ('01'b)", $time, cmd2);
            end
            else if (underflow_check2 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 2: Underflow but the response is Success ('01'b)", $time, cmd2);
            end
            else if (out_data2 == expected_data2) begin
               correct_count = correct_count + 1;
               $display("time = %t Input Command = %b: Correct: Output (%h) is equal to Expected Result (%h)", $time, cmd2, out_data2, expected_data2);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 2: Output (%h) is not equal to Expected Result (%h)", $time, cmd2, out_data2, expected_data2);
            end
         end
         else begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 2: Illegal command but the response is Success ('01'b)", $time);
         end
      end
      else if (out_resp2 == 2'b10) begin
         if (out_data2 != Min) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 2: Output data is not zero", $time, cmd2);
         end
         if (cmd2 == Add) begin
            if (overflow_check2 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Overflow at Port 2", $time);
            end
            else
               error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 2: No overflow but the response is '10'b", $time, cmd2);
         end
         else if (cmd2 == Sub) begin
            if (underflow_check2 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Underflow at Port 2", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 2: No underflow but the response is '10'b", $time, cmd2);
            end
         end
         else if (cmd2 == Shift_Left || cmd2 == Shift_Right) begin
            error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 2: Shift command but the response is '10'b", $time, cmd2);
         end
         else if (cmd2 != No_Op && cmd2 != Add && cmd2 != Sub && cmd2 != Shift_Left && cmd2 != Shift_Right) begin
            correct_count = correct_count + 1;
            $display("time = %t Input Command = %b: Illegal input command at Port 2", $time, cmd2);
         end
      end

      if (out_resp3 == Success) begin
         if (cmd3 == No_Op) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 3: out_resp3 should be No Response ('00'b)", $time);
         end
         else if (cmd3 == Add || cmd3 == Sub || cmd3 == Shift_Left || cmd3 == Shift_Right) begin
            if (overflow_check3 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 3: Overflow but the response is Success ('01'b)", $time, cmd3);
            end
            else if (underflow_check3 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 3: Underflow but the response is Success ('01'b)", $time, cmd3);
            end
            else if (out_data3 == expected_data3) begin
               correct_count = correct_count + 1;
               $display("time = %t Input Command = %b: Correct: Output (%h) is equal to Expected Result (%h)", $time, cmd3, out_data3, expected_data3);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 3: Output (%h) is not equal to Expected Result (%h)", $time, cmd3, out_data3, expected_data3);
            end
         end
         else begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 3: Illegal command but the response is Success ('01'b)", $time);
         end
      end
      else if (out_resp3 == 2'b10) begin
         if (out_data3 != Min) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 3: Output data is not zero", $time, cmd3);
         end
         if (cmd3 == Add) begin
            if (overflow_check3 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Overflow at Port 3", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 3: No overflow but the response is '10'b", $time, cmd3);
            end
         end
         else if (cmd3 == Sub) begin
            if (underflow_check3 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Underflow at Port 3", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 3: No underflow but the response is '10'b", $time, cmd3);
            end
         end
         else if (cmd3 == Shift_Left || cmd3 == Shift_Right) begin
            error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 3: Shift command but the response is '10'b", $time, cmd3);
         end
         else if (cmd3 != No_Op && cmd3 != Add && cmd3 != Sub && cmd3 != Shift_Left && cmd3 != Shift_Right) begin
            correct_count = correct_count + 1;
            $display("time = %t Input Command = %b: Illegal input command at Port 3", $time, cmd3);
         end
      end

      if (out_resp4 == Success) begin
         if (cmd4 == No_Op) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 4: out_resp4 should be No Response ('00'b)", $time);
         end
         else if (cmd4 == Add || cmd4 == Sub || cmd4 == Shift_Left || cmd4 == Shift_Right) begin
            if (overflow_check4 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 4: Overflow but the response is Success ('01'b)", $time, cmd4);
            end
            else if (underflow_check4 == 1) begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 4: Underflow but the response is Success ('01'b)", $time, cmd4);
            end
            else if (out_data4 == expected_data4) begin
               correct_count = correct_count + 1;
               $display("time = %t Input Command = %b: Correct: Output (%h) is equal to Expected Result (%h)", $time, cmd4, out_data4, expected_data4);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 4: Output (%h) is not equal to Expected Result (%h)", $time, cmd4, out_data4, expected_data4);
            end
         end
         else begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 4: Illegal command but the response is Success ('01'b)", $time);
         end
      end
      else if (out_resp4 == 2'b10) begin
         if (out_data4 != Min) begin
            error_count = error_count + 1;
            $display("time = %t Error at Port 4: Output data is not zero", $time, cmd4);
         end
         if (cmd4 == Add) begin
            if (overflow_check4 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Overflow at Port 4", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 4: No overflow but the response is '10'b", $time, cmd4);
            end
         end
         else if (cmd4 == Sub) begin
            if (underflow_check4 == 1) begin
               correct_count = correct_count + 1;
               $display("time = %t Underflow at Port 4", $time);
            end
            else begin
               error_count = error_count + 1;
               $display("time = %t Input Command = %b: Error at Port 4: No underflow but the response is '10'b", $time, cmd4);
            end
         end
         else if (cmd4 == Shift_Left || cmd4 == Shift_Right) begin
            error_count = error_count + 1;
            $display("time = %t Input Command = %b: Error at Port 4: Shift command but the response is '10'b", $time, cmd4);
         end
         else if (cmd4 != No_Op && cmd4 != Add && cmd4 != Sub && cmd4 != Shift_Left && cmd4 != Shift_Right) begin
            correct_count = correct_count + 1;
            $display("time = %t Input Command = %b: Illegal input command at Port 4", $time, cmd4);
         end
      end
   end
endmodule