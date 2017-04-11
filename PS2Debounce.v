module PS2Debounce(clock, ps2_in, out);

input wire clock;
input wire [7:0] ps2_in;
output reg [7:0] out = 8'b0;

reg[7:0] prev_in = 8'b0;
reg[18:0] counter = 19'b0;

always @(posedge clock) begin
	if(ps2_in == prev_in) begin
		counter = counter + 19'd1;
	end else begin
		counter = 19'b0;
	end
	if(counter == 19'd524288) begin
		out = ps2_in;
		counter = 19'b0;
	end
	prev_in = ps2_in;
end
	
endmodule 