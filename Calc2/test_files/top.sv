`include "test.sv"

module tb ;
bit    clk;

always #50 clk = !clk;

calc2_intf intf (clk);

calc2_top dut (
	.c_clk       (intf.clk         ),
	.b_clk       (                 ),
	.a_clk       (                 ),
	.scan_in     (                 ),
	.reset       (intf.reset       ),
	.req1_cmd_in (intf.req1_cmd_in ),
	.req1_data_in(intf.req1_data_in),
	.req1_tag_in (intf.req1_tag_in ),
	.out_resp1   (intf.out_resp1   ),
	.out_data1   (intf.out_data1   ),
	.out_tag1    (intf.out_tag1    ),
	.req2_cmd_in (intf.req2_cmd_in ),
	.req2_data_in(intf.req2_data_in),
	.req2_tag_in (intf.req2_tag_in ),
	.out_resp2   (intf.out_resp2   ),
	.out_data2   (intf.out_data2   ),
	.out_tag2    (intf.out_tag2    ),
	.req3_cmd_in (intf.req3_cmd_in ),
	.req3_data_in(intf.req3_data_in),
	.req3_tag_in (intf.req3_tag_in ),
	.out_resp3   (intf.out_resp3   ),
	.out_data3   (intf.out_data3   ),
	.out_tag3    (intf.out_tag3    ),
	.req4_cmd_in (intf.req4_cmd_in ),
	.req4_data_in(intf.req4_data_in),
	.req4_tag_in (intf.req4_tag_in ),
	.out_resp4   (intf.out_resp4   ),
	.out_data4   (intf.out_data4   ),
	.out_tag4    (intf.out_tag4    ),
	.scan_out    (                 )
);

test t0 (intf);
endmodule