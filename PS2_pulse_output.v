module PS2_pulse_output(clock, in, pulse); //Pulse is high to read char after key is released
	input clock;
	input [7:0] in;
	output pulse;

	reg[7:0] prev_in;

	always @(posedge clock) begin
		if(prev_in == 8'hF0 && in !=8'hF0) begin
			pulse = 1'b1;
		end else begin
			pulse = 1'b0;
		end
		prev_in = in;
	end


endmodule 