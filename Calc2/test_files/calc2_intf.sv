interface calc2_intf (input bit clk); 

	logic reset;

//port 1 inputs
	logic [ 0:3] req1_cmd_in ;
	logic [0:31] req1_data_in;
	logic [ 0:1] req1_tag_in ;

//port 2 inputs
	logic [ 0:3] req2_cmd_in ;
	logic [0:31] req2_data_in;
	logic [ 0:1] req2_tag_in ;

//port 3 inputs
	logic [ 0:3] req3_cmd_in ;
	logic [0:31] req3_data_in;
	logic [ 0:1] req3_tag_in ;

//port 4 inputs
	logic [ 0:3] req4_cmd_in ;
	logic [0:31] req4_data_in;
	logic [ 0:1] req4_tag_in ;

//port 1 outputs
	logic [ 0:1] out_resp1;
	logic [0:31] out_data1;
	logic [ 0:1] out_tag1 ;

//port 2 outputs
	logic [ 0:1] out_resp2;
	logic [0:31] out_data2;
	logic [ 0:1] out_tag2 ;

//port 3 outputs
	logic [ 0:1] out_resp3;
	logic [0:31] out_data3;
	logic [ 0:1] out_tag3 ;

//port 4 outputs
	logic [ 0:1] out_resp4;
	logic [0:31] out_data4;
	logic [ 0:1] out_tag4 ;


	modport DRIVER (
		input clk, output req1_cmd_in, output req1_data_in, output req1_tag_in,
		output req2_cmd_in, output req2_data_in, output req2_tag_in,
		output req3_cmd_in, output req3_data_in, output req3_tag_in,
		output req4_cmd_in, output req4_data_in, output req4_tag_in
	);

	modport MONITOR (
		input clk, input out_resp1, input out_data1, input out_tag1,
		input out_resp2, input out_data2, input out_tag2,
		input out_resp3, input out_data3, input out_tag3,
		input out_resp4, input out_data4, input out_tag4
	);

endinterface
