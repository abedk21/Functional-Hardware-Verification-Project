`include "environment.sv"

program automatic test(calc2_intf intf);

env e0;

initial begin
	e0 = new(intf);
	e0.g0.max_trans_cnt = 1000;
	e0.reset();
	e0.run();
	repeat (10) @(posedge intf.clk);
	$display("Correct Count: %d, Error Count: %d", e0.s0.correct_cnt, e0.s0.error_cnt);
	$finish;
end
endprogram
