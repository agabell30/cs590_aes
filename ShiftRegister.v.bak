module ShiftRegister(clock, in, out);
	input clock;
	input wire[7:0] in;
	output reg[127:0] out;
	
	

	always @(posedge clock) begin
		out = out << 8;
		out[7:0] = in;
	end


endmodule 