`include "trans.sv"

class driver;

trans tr1 [];
trans tr2 [];
trans tr3 [];
trans tr4 [];

mailbox gen2drv1;
mailbox gen2drv2;
mailbox gen2drv3;
mailbox gen2drv4;

mailbox drv2sb1;
mailbox drv2sb2;
mailbox drv2sb3;
mailbox drv2sb4;

trans t1,t2,t3,t4;

virtual calc2_intf.DRIVER intf;

function new(mailbox gen2drv1,mailbox gen2drv2,mailbox gen2drv3,mailbox gen2drv4, mailbox drv2sb1, mailbox drv2sb2, mailbox drv2sb3, mailbox drv2sb4, virtual calc2_intf intf);
    this.gen2drv1 = gen2drv1;
    this.gen2drv2 = gen2drv2;
    this.gen2drv3 = gen2drv3;
    this.gen2drv4 = gen2drv4;
    this.drv2sb1 = drv2sb1;
    this.drv2sb2 = drv2sb2;
    this.drv2sb3 = drv2sb3;
    this.drv2sb4 = drv2sb4;
    this.intf=intf;
endfunction

task run();
    fork
        drive1(); //drive port 1
        drive2(); //drive port 2
        drive3(); //drive port 3
        drive4(); //drive port 4
    join
endtask

task drive1();
    forever
        begin
            gen2drv1.get(tr1); //the driver will receive the transaction array from the generator
            for(int i=0;i<tr1.size();i++) begin
                @(posedge intf.clk);
                t1 = tr1[i];
                intf.req1_cmd_in = t1.cmd1;
                intf.req1_tag_in = t1.tag;
                intf.req1_data_in = t1.data1;

                repeat (1) @(posedge intf.clk);
                intf.req1_cmd_in = t1.cmd2;
                intf.req1_tag_in = 2'b00;
                intf.req1_data_in = t1.data2;
            end
            drv2sb1.put(tr1); //it will send it to the scoreboard
        end
endtask

task drive2();
    forever
        begin
            gen2drv2.get(tr2);
            for(int i=0;i<tr2.size();i++) begin
                @(posedge intf.clk);
                t2 = tr2[i];
                intf.req2_cmd_in = t2.cmd1;
                intf.req2_tag_in = t2.tag;
                intf.req2_data_in = t2.data1;

                repeat (1) @(posedge intf.clk);
                intf.req2_cmd_in = t2.cmd2;
                intf.req2_tag_in = 2'b00;
                intf.req2_data_in = t2.data2;
            end
            drv2sb2.put(tr2);
        end
endtask

task drive3();
    forever
        begin
            gen2drv3.get(tr3);
            for(int i=0;i<tr3.size();i++) begin
                @(posedge intf.clk);
                t3 = tr3[i];
                intf.req3_cmd_in = t3.cmd1;
                intf.req3_tag_in = t3.tag;
                intf.req3_data_in = t3.data1;

                repeat (1) @(posedge intf.clk);
                intf.req3_cmd_in = t3.cmd2;
                intf.req3_tag_in = 2'b00;
                intf.req3_data_in = t3.data2;
            end
            drv2sb3.put(tr3);
        end
endtask

task drive4();
    forever
        begin
            gen2drv4.get(tr4);
            for(int i=0;i<tr4.size();i++) begin
                @(posedge intf.clk);
                t4 = tr4[i];
                intf.req4_cmd_in = t4.cmd1;
                intf.req4_tag_in = t4.tag;
                intf.req4_data_in = t4.data1;

                repeat (1) @(posedge intf.clk);
                intf.req4_cmd_in = t4.cmd2;
                intf.req4_tag_in = 2'b00;
                intf.req4_data_in = t4.data2;
            end
            drv2sb4.put(tr4);
        end
endtask

endclass
