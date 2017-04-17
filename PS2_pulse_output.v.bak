module PS2_pulse_output(clock, in, pulse); //Pulse is high to read char after key is released
	input clock;
	input [7:0] in;
	output pulse;

	reg prev_in;

	always(@ posedge) begin
		if(prev_in == 8'hF0) begin
			pulse = 1'b1;
		end else begin
			pulse = 1'b0;
		end
	end

endmodule 