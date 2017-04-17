module parser(clock, in, out);
input wire[127:0] in;
input clock;
output [7:0] out;

reg [3:0] count = 4'b0;
reg [7:0] o;

always @(posedge clock) begin
	case(count)
	4'd0:o=in[7:0];
	4'd1:o=in[15:8];
	4'd2:o=in[23:16];
	4'd3:o=in[31:24];
	4'd4:o=in[39:32];
	4'd5:o=in[47:40];
	4'd6:o=in[55:48];
	4'd7:o=in[63:56];
	4'd8:o=in[71:64];
	4'd9:o=in[79:72];
	4'd10:o=in[87:80];
	4'd11:o=in[95:88];
	4'd12:o=in[103:96];
	4'd13:o=in[111:104];
	4'd14:o=in[119:112];
	4'd15:o=in[127:120];
	endcase
	count = count+1;
end

scancode_to_ascii sca(o, out);

endmodule 