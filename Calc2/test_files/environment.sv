`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class      env;
generator  g0 ;
driver     d0 ;
monitor    m0 ;
scoreboard s0 ;

mailbox gen2drv1;
mailbox gen2drv2;
mailbox gen2drv3;
mailbox gen2drv4;

mailbox tr1_size;
mailbox tr2_size;
mailbox tr3_size;
mailbox tr4_size;

mailbox drv2sb1;
mailbox drv2sb2;
mailbox drv2sb3;
mailbox drv2sb4;

mailbox mntr2sb1;
mailbox mntr2sb2;
mailbox mntr2sb3;
mailbox mntr2sb4;

event mntr_done1;
event mntr_done2;
event mntr_done3;
event mntr_done4;

virtual calc2_intf intf;

function new(virtual calc2_intf intf);
    this.intf = intf;
    gen2drv1 = new();
    gen2drv2 = new();
    gen2drv3 = new();
    gen2drv4 = new();
    drv2sb1 = new();
    drv2sb2 = new();
    drv2sb3 = new();
    drv2sb4 = new();
    mntr2sb1 = new();
    mntr2sb2 = new();
    mntr2sb3 = new();
    mntr2sb4 = new();
    tr1_size = new();
    tr2_size = new();
    tr3_size = new();
    tr4_size = new();
    g0 = new(gen2drv1,gen2drv2,gen2drv3,gen2drv4,intf);
    d0 = new(gen2drv1,gen2drv2,gen2drv3,gen2drv4,drv2sb1,drv2sb2,drv2sb3,drv2sb4,intf);
    m0 = new(mntr2sb1,mntr2sb2,mntr2sb3,mntr2sb4,intf);
    s0 = new(drv2sb1,drv2sb2,drv2sb3,drv2sb4,mntr2sb1,mntr2sb2,mntr2sb3,mntr2sb4);
    g0.mntr_done1 = mntr_done1;
    g0.mntr_done2 = mntr_done2;
    g0.mntr_done3 = mntr_done3;
    g0.mntr_done4 = mntr_done4;
    m0.mntr_done1 = mntr_done1;
    m0.mntr_done2 = mntr_done2;
    m0.mntr_done3 = mntr_done3;
    m0.mntr_done4 = mntr_done4;

    g0.tr1_size = tr1_size;
    g0.tr2_size = tr2_size;
    g0.tr3_size = tr3_size;
    g0.tr4_size = tr4_size;
    m0.tr1_size = tr1_size;
    m0.tr2_size = tr2_size;
    m0.tr3_size = tr3_size;
    m0.tr4_size = tr4_size;
endfunction

task run();
    fork
        g0.run();
        d0.run();
        m0.run();
        s0.run();
    join_any
endtask

task reset();

    intf.reset = 1'b1;

    intf.req1_cmd_in = 4'b0;
    intf.req1_data_in = 32'b0;
    intf.req1_tag_in = 2'b0;

    intf.req2_cmd_in = 4'b0;
    intf.req2_data_in = 32'b0;
    intf.req2_tag_in = 2'b0;

    intf.req3_cmd_in = 4'b0;
    intf.req3_data_in = 32'b0;
    intf.req3_tag_in = 2'b0;

    intf.req4_cmd_in = 4'b0;
    intf.req4_data_in = 32'b0;
    intf.req4_tag_in = 2'b0;

    repeat (7) @(posedge intf.clk);
    intf.reset = 1'b0;
endtask
endclass