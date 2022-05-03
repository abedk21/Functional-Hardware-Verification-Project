`include "trans.sv"

covergroup cg1(ref trans tr);
PORT1_CMD1: coverpoint tr.cmd1 {
    bins no_op       = { 4'b0000 };
    bins add         = { 4'b0001 };
    bins subtract    = { 4'b0010 };
    bins shift_left  = { 4'b0101 };
    bins shift_right = { 4'b0110 };
    bins invalid     = default    ;
}
PORT1_CMD2: coverpoint tr.cmd2 {
    bins no_op = { 4'b0000 };
    bins dirty = default    ;
}
PORT1_DATA1: coverpoint tr.data1 {
    bins min   = { 32'h00000000 };
    bins one   = { 32'h00000001 };
    bins max_1 = { 32'hFFFFFFFE };
    bins max   = { 32'hFFFFFFFF };
    bins other = default         ;
}
PORT1_DATA2: coverpoint tr.data2 {
    bins min        = { 32'h00000000 };
    bins one        = { 32'h00000001 };
    bins thirty_one = { 32'h0000001F };
    bins max_1      = { 32'hFFFFFFFE };
    bins max        = { 32'hFFFFFFFF };
    bins other      = default         ;
}
cross_port1: cross PORT1_CMD1, PORT1_CMD2, PORT1_DATA1, PORT1_DATA2;
endgroup

covergroup cg2(ref trans tr);
    PORT2_CMD1: coverpoint tr.cmd1 {
        bins no_op       = { 4'b0000 };
        bins add         = { 4'b0001 };
        bins subtract    = { 4'b0010 };
        bins shift_left  = { 4'b0101 };
        bins shift_right = { 4'b0110 };
        bins invalid     = default    ;
    }
    PORT2_CMD2: coverpoint tr.cmd2 {
        bins no_op = { 4'b0000 };
        bins dirty = default    ;
    }
    PORT2_DATA1: coverpoint tr.data1 {
        bins min   = { 32'h00000000 };
        bins one   = { 32'h00000001 };
        bins max_1 = { 32'hFFFFFFFE };
        bins max   = { 32'hFFFFFFFF };
        bins other = default         ;
    }
    PORT2_DATA2: coverpoint tr.data2 {
        bins min        = { 32'h00000000 };
        bins one        = { 32'h00000001 };
        bins thirty_one = { 32'h0000001F };
        bins max_1      = { 32'hFFFFFFFE };
        bins max        = { 32'hFFFFFFFF };
        bins other      = default         ;
    }
    cross_port2: cross PORT2_CMD1, PORT2_CMD2, PORT2_DATA1, PORT2_DATA2;
endgroup

covergroup cg3(ref trans tr);
    PORT3_CMD1: coverpoint tr.cmd1 {
        bins no_op       = { 4'b0000 };
        bins add         = { 4'b0001 };
        bins subtract    = { 4'b0010 };
        bins shift_left  = { 4'b0101 };
        bins shift_right = { 4'b0110 };
        bins invalid     = default    ;
    }
    PORT3_CMD2: coverpoint tr.cmd2 {
        bins no_op = { 4'b0000 };
        bins dirty = default    ;
    }
    PORT3_DATA1: coverpoint tr.data1 {
        bins min   = { 32'h00000000 };
        bins one   = { 32'h00000001 };
        bins max_1 = { 32'hFFFFFFFE };
        bins max   = { 32'hFFFFFFFF };
        bins other = default         ;
    }
    PORT3_DATA2: coverpoint tr.data2 {
        bins min        = { 32'h00000000 };
        bins one        = { 32'h00000001 };
        bins thirty_one = { 32'h0000001F };
        bins max_1      = { 32'hFFFFFFFE };
        bins max        = { 32'hFFFFFFFF };
        bins other      = default         ;
    }
    cross_port3: cross PORT3_CMD1, PORT3_CMD2, PORT3_DATA1, PORT3_DATA2;
endgroup

covergroup cg4(ref trans tr);
    PORT4_CMD1: coverpoint tr.cmd1 {
        bins no_op       = { 4'b0000 };
        bins add         = { 4'b0001 };
        bins subtract    = { 4'b0010 };
        bins shift_left  = { 4'b0101 };
        bins shift_right = { 4'b0110 };
        bins invalid     = default    ;
    }
    PORT4_CMD2: coverpoint tr.cmd2 {
        bins no_op = { 4'b0000 };
        bins dirty = default    ;
    }
    PORT4_DATA1: coverpoint tr.data1 {
        bins min   = { 32'h00000000 };
        bins one   = { 32'h00000001 };
        bins max_1 = { 32'hFFFFFFFE };
        bins max   = { 32'hFFFFFFFF };
        bins other = default         ;
    }
    PORT4_DATA2: coverpoint tr.data2 {
        bins min        = { 32'h00000000 };
        bins one        = { 32'h00000001 };
        bins thirty_one = { 32'h0000001F };
        bins max_1      = { 32'hFFFFFFFE };
        bins max        = { 32'hFFFFFFFF };
        bins other      = default         ;
    }
    cross_port4: cross PORT4_CMD1, PORT4_CMD2, PORT4_DATA1, PORT4_DATA2;
endgroup