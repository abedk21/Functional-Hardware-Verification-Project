`include "trans.sv"

class scoreboard;

trans trd1 [];
trans trd2 [];
trans trd3 [];
trans trd4 [];

trans trm1 [];
trans trm2 [];
trans trm3 [];
trans trm4 [];

mailbox mntr2sb1;
mailbox mntr2sb2;
mailbox mntr2sb3;
mailbox mntr2sb4;

mailbox drv2sb1;
mailbox drv2sb2;
mailbox drv2sb3;
mailbox drv2sb4;

int correct_cnt = 0;
int error_cnt   = 0;

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
    Max_1 = 32'hFFFFFFFE,
    Thirty_one = 32'hF0000001F,
    One = 32'h00000001,
    Min = 32'h00000000;


function new(mailbox drv2sb1, mailbox drv2sb2, mailbox drv2sb3, mailbox drv2sb4, mailbox mntr2sb1, mailbox mntr2sb2, mailbox mntr2sb3, mailbox mntr2sb4);
    this.drv2sb1 = drv2sb1;
    this.drv2sb2 = drv2sb2;
    this.drv2sb3 = drv2sb3;
    this.drv2sb4 = drv2sb4;
    this.mntr2sb1 = mntr2sb1;
    this.mntr2sb2 = mntr2sb2;
    this.mntr2sb3 = mntr2sb3;
    this.mntr2sb4 = mntr2sb4;
endfunction

task run();
    fork
        check1(); //check for port 1
        check2(); //check for port 2
        check3(); //check for port 3
        check4(); //check for port 4
    join
endtask

task check1();
    forever begin
        drv2sb1.get(trd1); //receive transaction array from driver
        mntr2sb1.get(trm1); //receive transaction array from monitor
        print(1, trd1, trm1);
        check_size(trd1, trm1);
        check_order(trd1, trm1); //the order of the transactions will be checked first (order of the add\sub transactions and the order of the shift transactions)
        for(int i=0;i<trd1.size();i++) begin
            for(int j=0;j<trm1.size();j++) begin
                if(trd1[i].tag == trm1[j].out_tag)
                    compare(trd1[i],trm1[j]); //the transactions with the same tag will be compared with each other
            end
        end
    end
endtask

task check2();
    forever begin
        drv2sb2.get(trd2);
        mntr2sb2.get(trm2);
        print(2, trd2, trm2);
        check_size(trd2, trm2);
        check_order(trd2, trm2);
        for(int i=0;i<trd2.size();i++) begin
            for(int j=0;j<trm2.size();j++) begin
                if(trd2[i].tag == trm2[j].out_tag)
                    compare(trd2[i],trm2[j]);
            end
        end
    end
endtask

task check3();
    forever begin
        drv2sb3.get(trd3);
        mntr2sb3.get(trm3);
        print(3, trd3, trm3);
        check_size(trd3, trm3);
        check_order(trd3, trm3);
        for(int i=0;i<trd3.size();i++) begin
            for(int j=0;j<trm3.size();j++) begin
                if(trd3[i].tag == trm3[j].out_tag)
                    compare(trd3[i],trm3[j]);
            end
        end
    end
endtask

task check4();
    forever begin
        drv2sb4.get(trd4);
        mntr2sb4.get(trm4);
        print(4, trd4, trm4);
        check_size(trd4, trm4);
        check_order(trd4, trm4);
        for(int i=0;i<trd4.size();i++) begin
            for(int j=0;j<trm4.size();j++) begin
                if(trd4[i].tag == trm4[j].out_tag)
                    compare(trd4[i],trm4[j]);
            end
        end
    end
endtask

task automatic print(int port_num, trans trd [], trans trm []);
    $display ("Time: %t ",$time, "Port %d: \n", port_num);
    $display ("**Driver to Scoreboard**: ");
    foreach(trd[index]) begin
        if(trd[index].cmd1 == Add && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Min)
            $display("Test Case 1: Adding min with min \n");
        else if(trd[index].cmd1 == Add && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Max)
            $display("Test Case 2: Adding min with max \n");
        else if(trd[index].cmd1 == Add && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == One)
            $display("Test Case 3: Adding max with one (Overflow) \n");
        else if(trd[index].cmd1 == Add && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Max)
            $display("Test Case 4: Adding max with max (Overflow) \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Min)
            $display("Test Case 5: Subtracting min with min \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Min)
            $display("Test Case 6: Subtracting max with min \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Max)
            $display("Test Case 7: Subtracting max with max \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == One)
            $display("Test Case 8: Subtracting max with one \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == One)
            $display("Test Case 9: Subtracting min with one (Underflow) \n");
        else if(trd[index].cmd1 == Sub && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Max)
            $display("Test Case 10: Subtracting min with max (Underflow) \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Max)
            $display("Test Case 11: Shifting Left min by max \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Min)
            $display("Test Case 12: Shifting Left min by min \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Min)
            $display("Test Case 13: Shifting Left max by min \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == One)
            $display("Test Case 14: Shifting Left max by one \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == One)
            $display("Test Case 15: Shifting Left min by one \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Min)
            $display("Test Case 16: Shifting Left one by min \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Max)
            $display("Test Case 17: Shifting Left one by max \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == One)
            $display("Test Case 18: Shifting Left one by one \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Thirty_one)
            $display("Test Case 19: Shifting Left one by 31 \n");
        else if(trd[index].cmd1 == Shift_Left && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Thirty_one)
            $display("Test Case 20: Shifting Left max by 31 \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Max)
            $display("Test Case 21: Shifting Right min by max \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == Min)
            $display("Test Case 22: Shifting Right min by min \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Min)
            $display("Test Case 23: Shifting Right max by min \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == One)
            $display("Test Case 24: Shifting Right max by one \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Min && trd[index].data2 == One)
            $display("Test Case 25: Shifting Right min by one \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Min)
            $display("Test Case 26: Shifting Right one by min \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Max)
            $display("Test Case 27: Shifting Right one by max \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == One)
            $display("Test Case 28: Shifting Right one by one \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == One && trd[index].data2 == Thirty_one)
            $display("Test Case 29: Shifting Right one by 31 \n");
        else if(trd[index].cmd1 == Shift_Right && trd[index].cmd2 == No_Op && trd[index].data1 == Max && trd[index].data2 == Thirty_one)
            $display("Test Case 30: Shifting Right max by 31 \n");
        else
            $display("Test Case 31: Other \n");
        if(trd[index].cmd1 != Add && trd[index].cmd1 != Sub && trd[index].cmd1 != Shift_Left && trd[index].cmd1 != Shift_Right && trd[index].cmd1 != No_Op)
            $display("Invalid Command 1 \n");
        if(trd[index].cmd2 != No_Op)
            $display("Dirty State (Command 2 isn't no_op) \n");
        if(trd[index].cmd1 == No_Op)
            $display("No Operation \n");
        trd[index].display("driver");
    end
    $display ("**Monitor to Scoreboard**: ");
    foreach(trm[index]) begin
        trm[index].display("monitor");
    end
endtask

task automatic compare(trans trd, trans trm);
    $display("Checking transaction with tag: %b \n",trd.tag);
    assert((trm.out_resp!==1'bx)&&(trm.out_data!==32'bx)&&(trm.out_tag!==32'bx)) else $error ("Assertion Error! Undefined Output Detected. \n");
    case(trd.cmd1)
        No_Op : begin
            trd.out_data = 32'h00000000;
            trd.out_resp = 2'b00;
        end
        Add : begin
            if ((32'hFFFFFFFF - trd.data1) < trd.data2) begin
                trd.out_data = 32'h00000000;
                trd.out_resp = 2'b10;
            end else begin
                trd.out_data = trd.data1 + trd.data2;
                trd.out_resp = 2'b01;
            end
        end

        Sub : begin
            if (trd.data1 < trd.data2) begin
                trd.out_data = 32'h00000000;
                trd.out_resp = 2'b10;
            end else begin
                trd.out_data = trd.data1 - trd.data2;
                trd.out_resp = 2'b01;
            end
        end

        Shift_Left : begin
            trd.out_data = trd.data1 << trd.data2[27:31];
            trd.out_resp = 2'b01;
        end

        Shift_Right : begin
            trd.out_data = trd.data1 >> trd.data2[27:31];
            trd.out_resp = 2'b01;
        end

        default : begin
            trd.out_data = 32'h00000000;
            trd.out_resp = 2'b10;
        end
    endcase
    if (trd.out_data == trm.out_data) begin
        $display ("Correct Output Data: Actual: %h, Expected: %h \n", trm.out_data, trd.out_data);
        correct_cnt++;
    end else begin
        $display ("Error: Incorrect Output Data: Actual: %h, Expected: %h \n", trm.out_data, trd.out_data);
        error_cnt++;
    end
    if (trd.out_resp == trm.out_resp) begin
        $display ("Correct Output Response: Actual: %b, Expected: %b \n", trm.out_resp, trd.out_resp);
        correct_cnt++;
    end else begin
        $display ("Error: Incorrect Output Response: Actual: %b, Expected: %b \n", trm.out_resp, trd.out_resp);
        error_cnt++;
    end
endtask

task automatic check_order(trans trd [], trans trm []);
    trans addsub1 [];
    trans addsub2 [];
    trans shift1 [];
    trans shift2 [];
    for(int i=0;i<trd.size();i++) begin
        if(trd[i].cmd1 == Add || trd[i].cmd1 == Sub)
            addsub1[i] = trd[i];
        else if(trd[i].cmd1 == Shift_Left || trd[i].cmd1 == Shift_Right)
            shift1[i] = trd[i];
          end
          for(int i=0;i<trm.size();i++) begin
        if(trm[i].cmd1 == Add || trm[i].cmd1 == Sub)
            addsub2[i] = trm[i];
        else if(trm[i].cmd1 == Shift_Left || trm[i].cmd1 == Shift_Right)
            shift2[i] = trm[i];
    end
    for(int i=0;i<addsub1.size();i++) begin
        if(addsub1[i] != addsub2[i]) begin
            $display("Error: Order of the Add and Sub transactions is wrong \n");
            error_cnt++;
            break;
        end
    end
    for(int i=0;i<shift1.size();i++) begin
        if(shift1[i] != shift2[i]) begin
            $display("Error: Order of the Shift transactions is wrong \n");
            error_cnt++;
            break;
        end
    end
endtask

task automatic check_size(trans trd [], trans trm []);
    if(trd.size() != trm.size()) begin
        $display("Error: Missing transactions from output \n");
        error_cnt++;
    end
endtask

endclass
