`include "trans.sv"
`include "coverage.sv"

class generator;

trans tr1 [];
trans tr2 [];
trans tr3 [];
trans tr4 [];

trans trg1,trg2,trg3,trg4;

mailbox gen2drv1;
mailbox gen2drv2;
mailbox gen2drv3;
mailbox gen2drv4;

mailbox tr1_size;
mailbox tr2_size;
mailbox tr3_size;
mailbox tr4_size;

int trans_cnt1 = 0;
int trans_cnt2 = 0;
int trans_cnt3 = 0;
int trans_cnt4 = 0;

int s1,s2,s3,s4;

int r1,r2,r3,r4;

int max_trans_cnt;

virtual calc2_intf intf;

event mntr_done1;
event mntr_done2;
event mntr_done3;
event mntr_done4;

//coverage is done here
cg1 c1 = new(trg1);
cg2 c2 = new(trg2);
cg3 c3 = new(trg3);
cg4 c4 = new(trg4);

function new(mailbox gen2drv1,mailbox gen2drv2,mailbox gen2drv3,mailbox gen2drv4,virtual calc2_intf intf);
	this.gen2drv1 = gen2drv1;
	this.gen2drv2 = gen2drv2;
	this.gen2drv3 = gen2drv3;
	this.gen2drv4 = gen2drv4;
	this.intf=intf;
endfunction

task run();
	fork
		generate1(); //generate transaction arrays for port 1
		generate2(); //generate transaction arrays for port 2
		generate3(); //generate transaction arrays for port 3
		generate4(); //generate transaction arrays for port 4
	join
endtask

task generate1();
	while(trans_cnt1 < max_trans_cnt)
		begin
                	//a random number between 0 and 4 is generated for the number of transactions sent in one iteration
                	//we consider 0 as one transaction with an input command of No_Op
			r1 = $urandom_range(0, 4); 
			if(r1 == 0)
				s1 = 1;
			else
				s1 = r1;
			tr1 = new[s1];
			for(int i=0;i<s1;i++) begin
				trg1  = new();
				assert(trg1.randomize()) else $error("randomization failed");
				if(r1 == 0) begin
					trg1.cmd1 = 2'b00;
					trg1.cmd2 = 2'b00;
					trg1.tag = 2'b01; //if the the transaction is No_Op, we gave it a tag of "01" for simplicity
				end
				else
					trg1.tag = i; //the tags are given in order for the generated transactions same as the index
				c1.sample();
				tr1[i] = trg1;
			end
			tr1_size.put(r1); //the random number is used by the monitor in order to know the number of transactions to expect and if there's a No_Op transaction
			gen2drv1.put(tr1); //the array of generated transaction is placed in the mailbox that is used by the driver
			trans_cnt1++;
			@(mntr_done1); //the generator will actually wait for the monitor to be done in order to proceed to the next iteration
		end
endtask

task generate2();
	while(trans_cnt2 < max_trans_cnt)
		begin
			r2 = $urandom_range(0, 4);
			if(r2 == 0)
				s2 = 1;
			else
				s2 = r2;
			tr2 = new[s2];
			for(int i=0;i<s2;i++) begin
				trg2  = new();
				assert(trg2.randomize()) else $error("randomization failed");
				if(r2 == 0) begin
					trg2.cmd1 = 2'b00;
					trg2.cmd2 = 2'b00;
					trg2.tag = 2'b01;
				end
				else
					trg2.tag = i;
				c2.sample();
				tr2[i] = trg2;
			end
			if(r2 == 0) begin
				trg2.cmd1 = 2'b00;
				trg2.tag = 2'b01;
			end
			tr2_size.put(r2);
			gen2drv2.put(tr2);
			trans_cnt2++;
			@(mntr_done2);
		end
endtask

task generate3();
	while(trans_cnt3 < max_trans_cnt)
		begin
			r3 = $urandom_range(0, 4);
			if(r3 == 0)
				s3 = 1;
			else
				s3 = r3;
			tr3 = new[s3];
			for(int i=0;i<s3;i++) begin
				trg3  = new();
				assert(trg3.randomize()) else $error("randomization failed");
				if(r3 == 0) begin
					trg3.cmd1 = 2'b00;
					trg3.cmd2 = 2'b00;
					trg3.tag = 2'b01;
				end
				else
					trg3.tag = i;
				c3.sample();
				tr3[i] = trg3;
			end
			tr3_size.put(r3);
			gen2drv3.put(tr3);
			trans_cnt3++;
			@(mntr_done3);
		end
endtask

task generate4();
	while(trans_cnt4 < max_trans_cnt)
		begin
			r4 = $urandom_range(0, 4);
			if(r4 == 0)
				s4 = 1;
			else
				s4 = r4;
			tr4 = new[s4];
			for(int i=0;i<s4;i++) begin
				trg4  = new();
				assert(trg4.randomize()) else $error("randomization failed");
				if(r4 == 0) begin
					trg4.cmd1 = 2'b00;
					trg4.cmd2 = 2'b00;
					trg4.tag = 2'b01;
				end
				else
					trg4.tag = i;
				c4.sample();
				tr4[i] = trg4;
			end
			tr4_size.put(r4);
			gen2drv4.put(tr4);
			trans_cnt4++;
			@(mntr_done4);
		end
endtask

endclass