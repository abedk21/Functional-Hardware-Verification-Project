`include "trans.sv"

class monitor;

mailbox mntr2sb1;
mailbox mntr2sb2;
mailbox mntr2sb3;
mailbox mntr2sb4;


mailbox tr1_size;
mailbox tr2_size;
mailbox tr3_size;
mailbox tr4_size;

event mntr_done1;
event mntr_done2;
event mntr_done3;
event mntr_done4;

trans trm1 [];
trans trm2 [];
trans trm3 [];
trans trm4 [];

trans tr1,tr2,tr3,tr4;

int s1,s2,s3,s4;

int r1,r2,r3,r4;

int tags1 [],tags2 [],tags3 [],tags4 [];

virtual calc2_intf.MONITOR intf;

function new(mailbox mntr2sb1, mailbox mntr2sb2, mailbox mntr2sb3, mailbox mntr2sb4, virtual calc2_intf intf);
  this.mntr2sb1 = mntr2sb1;
  this.mntr2sb2 = mntr2sb2;
  this.mntr2sb3 = mntr2sb3;
  this.mntr2sb4 = mntr2sb4;
  this.intf=intf;
endfunction

task run();
  fork
    monitor1(); //monitor port 1
    monitor2(); //monitor port 2
    monitor3(); //monitor port 3
    monitor4(); //monitor port 4
  join
endtask

task monitor1();
  forever begin
    tr1_size.get(r1); //the random number from the generator is used by the monitor in order to know the number of transactions to expect and if there's a No_Op transaction
    if(r1 == 0)
      s1 = 1;
    else
      s1 = r1;
    trm1 = new[1];
    tags1 = new[1];
    if(r1 == 0) begin
      //if the input transaction is No_Op, the monitor will wait for the output with tag "01" to appear
      while (intf.out_tag1 != 1) begin
        @(posedge intf.clk);
      end
      tr1 = new();
      tr1.out_resp = intf.out_resp1;
      tr1.out_data = intf.out_data1;
      tr1.out_tag = intf.out_tag1;
      trm1[0] = tr1;
    end else begin
      int j = 0;
      //the monitor will wait for the first output to show up and will sample the same number of transactions that were used to drive the dut
      //it will wait maximum 10 clock cycles
      while ((intf.out_tag1 == 0 && intf.out_resp1 == 0 && intf.out_data1 == 0) && j < 10) begin
        @(posedge intf.clk);
        j++;
      end
      tr1 = new();
      tr1.out_resp = intf.out_resp1;
      tr1.out_data = intf.out_data1;
      tr1.out_tag = intf.out_tag1;
      trm1[0] = tr1;
      tags1[0] = intf.out_tag1;
      //if the first output showed up before 10 clock cycles, then we'll check for the consecutive outputs
      for(int i=1;i<s1;i++) begin
        int c = 0;
        int j = 0;
        //we'll check each output tag. If it's not sampled before, it will be appended to the array sent to the scoreboard
        //we'll wait maximum 5 clock cycles for the consecutive outputs
        while (c == 0 && j < 5) begin
          if(contain(intf.out_tag1, tags1) == 1)
            @(posedge intf.clk);
          else
            if (!(intf.out_tag1 == 0 && intf.out_resp1 == 0 && intf.out_data1 == 0))
              c = 1;
          else
            @(posedge intf.clk);
          j++;
        end
        if(contain(intf.out_tag1, tags1) == 0) begin
          tr1 = new();
          tr1.out_resp = intf.out_resp1;
          tr1.out_data = intf.out_data1;
          tr1.out_tag = intf.out_tag1;
          trm1 = new [trm1.size()+1] (trm1);
          trm1[i] = tr1;
          tags1 = new [tags1.size()+1] (tags1);
          tags1[i] = intf.out_tag1;
        end
        //repeat (1) @(posedge intf.clk);
        if (j >= 5)
          break;
      end
    end
    mntr2sb1.put(trm1); //the monitor will then send the transaction array to the scoreboard
    ->mntr_done1; //after that, the monitor is done and this will allow the generator to proceed with the next iteration
  end
endtask

task monitor2();
  forever begin
    tr2_size.get(r2);
    if(r2 == 0)
      s2 = 1;
    else
      s2 = r2;
    trm2 = new[1];
    tags2 = new[1];
    if(r2 == 0) begin
      while (intf.out_tag2 != 1) begin
        @(posedge intf.clk);
      end
      tr2 = new();
      tr2.out_resp = intf.out_resp2;
      tr2.out_data = intf.out_data2;
      tr2.out_tag = intf.out_tag2;
      trm2[0] = tr2;
    end else begin
      int j = 0;
      while (intf.out_tag2 == 0 && intf.out_resp2 == 0 && intf.out_data2 == 0 && j < 10) begin
        @(posedge intf.clk);
        j++;
      end
      tr2 = new();
      tr2.out_resp = intf.out_resp2;
      tr2.out_data = intf.out_data2;
      tr2.out_tag = intf.out_tag2;
      trm2[0] = tr2;
      tags2[0] = intf.out_tag2;
      for(int i=1;i<s2;i++) begin
        int c = 0;
        int j = 0;
        while (c == 0 && j < 5) begin
          if(contain(intf.out_tag2, tags2) == 1)
            @(posedge intf.clk);
          else
            if(!(intf.out_tag2 == 0 && intf.out_resp2 == 0 && intf.out_data2 == 0))
              c = 1;
          else
            @(posedge intf.clk);
          j++;
        end
        if(contain(intf.out_tag2, tags2) == 0) begin
          tr2 = new();
          tr2.out_resp = intf.out_resp2;
          tr2.out_data = intf.out_data2;
          tr2.out_tag = intf.out_tag2;
          trm2 = new [trm2.size()+1] (trm2);
          trm2[i] = tr2;
          tags2 = new [tags2.size()+1] (tags2);
          tags2[i] = intf.out_tag2;
        end
        //repeat (1) @(posedge intf.clk);
        if (j >= 5)
          break;
      end
    end
    mntr2sb2.put(trm2);
    ->mntr_done2;
  end
endtask

task monitor3();
  forever begin
    tr3_size.get(r3);
    if(r3 == 0)
      s3 = 1;
    else
      s3 = r3;
    trm3 = new[1];
    tags3 = new[1];
    if(r3 == 0) begin
      while (intf.out_tag3 != 1) begin
        @(posedge intf.clk);
      end
      tr3 = new();
      tr3.out_resp = intf.out_resp3;
      tr3.out_data = intf.out_data3;
      tr3.out_tag = intf.out_tag3;
      trm3[0] = tr3;
    end else begin
      int j = 0;
      while (intf.out_tag3 == 0 && intf.out_resp3 == 0 && intf.out_data3 == 0 && j < 10) begin
        @(posedge intf.clk);
        j++;
      end
      tr3 = new();
      tr3.out_resp = intf.out_resp3;
      tr3.out_data = intf.out_data3;
      tr3.out_tag = intf.out_tag3;
      trm3[0] = tr3;
      tags3[0] = intf.out_tag3;
      for(int i=1;i<s3;i++) begin
        int c = 0;
        int j = 0;
        while (c == 0 && j < 5) begin
          if(contain(intf.out_tag3, tags3) == 1)
            @(posedge intf.clk);
          else
            if(!(intf.out_tag3 == 0 && intf.out_resp3 == 0 && intf.out_data3 == 0))
              c = 1;
          else
            @(posedge intf.clk);
          j++;
        end
        if(contain(intf.out_tag3, tags3) == 0) begin
          tr3 = new();
          tr3.out_resp = intf.out_resp3;
          tr3.out_data = intf.out_data3;
          tr3.out_tag = intf.out_tag3;
          trm3 = new [trm3.size()+1] (trm3);
          trm3[i] = tr3;
          tags3 = new [tags3.size()+1] (tags3);
          tags3[i] = intf.out_tag3;
        end
        if (j >= 5)
          break;
        //repeat (1) @(posedge intf.clk);
      end
    end
    mntr2sb3.put(trm3);
    ->mntr_done3;
  end
endtask

task monitor4();
  forever begin
    tr4_size.get(r4);
    if(r4 == 0)
      s4 = 1;
    else
      s4 = r4;
    trm4 = new[1];
    tags4 = new[1];
    if(r4 == 0) begin
      while (intf.out_tag4 != 1) begin
        @(posedge intf.clk);
      end
      tr4 = new();
      tr4.out_resp = intf.out_resp4;
      tr4.out_data = intf.out_data4;
      tr4.out_tag = intf.out_tag4;
      trm4[0] = tr4;
    end else begin
      int j = 0;
      while (intf.out_tag4 == 0 && intf.out_resp4 == 0 && intf.out_data4 == 0 && j < 10) begin
        @(posedge intf.clk);
        j++;
      end
      tr4 = new();
      tr4.out_resp = intf.out_resp4;
      tr4.out_data = intf.out_data4;
      tr4.out_tag = intf.out_tag4;
      trm4[0] = tr4;
      tags4[0] = intf.out_tag4;
      for(int i=1;i<s4;i++) begin
        int c = 0;
        int j = 0;
        while (c == 0 && j < 5) begin
          if(contain(intf.out_tag4, tags4) == 1)
            @(posedge intf.clk);
          else
            if(!(intf.out_tag4 == 0 && intf.out_resp4 == 0 && intf.out_data4 == 0))
              c = 1;
          else
            @(posedge intf.clk);
          j++;
        end
        if(contain(intf.out_tag4, tags4) == 0) begin
          tr4 = new();
          tr4.out_resp = intf.out_resp4;
          tr4.out_data = intf.out_data4;
          tr4.out_tag = intf.out_tag4;
          trm4 = new [trm4.size()+1] (trm4);
          trm4[i] = tr4;
          tags4 = new [tags4.size()+1] (tags4);
          tags4[i] = intf.out_tag4;
        end
        //repeat (1) @(posedge intf.clk);
        if (j >= 5)
          break;
      end
    end
    mntr2sb4.put(trm4);
    ->mntr_done4;
  end
endtask

function automatic int contain(int tag, int tags []);
  int b = 0;
  foreach(tags[index]) begin
    if(tags[index] == tag)
      b = 1;
  end
  return b;
endfunction

endclass