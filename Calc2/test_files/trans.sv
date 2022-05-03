`ifndef trans_sv
`define trans_sv

class trans;

rand logic [0:3] cmd1;
rand logic [0:3] cmd2;
rand logic [0:31] data1;
rand logic [0:31] data2;
randc logic [0:1] tag;

logic [ 0:1] out_resp;
logic [0:31] out_data;
logic [ 0:1] out_tag ;

constraint cmd1_c
	{
		cmd1 dist {1:=22,2:=22,5:=22,6:=22,[3:4]:/2,[7:15]:/10};
	}

constraint cmd2_c
	{
		cmd2 dist {0:=90,[1:15]:/10};
	}

constraint data1_c
	{
		data1 dist {32'h00000000:=22,32'h00000001:=22,32'hFFFFFFFF:=22,32'hFFFFFFFE:=22,[32'h00000002:32'hFFFFFFFD]:/12};
	}

constraint data2_c
	{
		data2 dist {32'h00000000:=20,32'h00000001:=20, 32'h0000001F:=10,32'hFFFFFFFF:=20,32'hFFFFFFFE:=20,[32'h00000002:32'hFFFFFFFD]:/10};
	}

function void display(string mode);
	if (mode == "driver")
		$display("Input Command1: %b, Input Command2: %b, Input Tag: %b, Input Data1: %h, Input Data2: %h", cmd1, cmd2, tag, data1, data2);
	else if (mode == "monitor")
		$display("Output Response: %b, Output Tag: %b, Output Data: %h", out_resp, out_tag, out_data);
endfunction
endclass

`endif