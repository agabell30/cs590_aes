module scancode_to_ascii(in, out);
	input wire [7:0] in;
	output wire [7:0] out;
	
	always case (in)
		8'h1c:out=8'd65;
		8'h32:out=8'd66;
		8'h21:out=8'd67;
		8'h23:out=8'd68;
		8'h24:out=8'd69;
		8'h2B:out=8'd70;
		8'h34:out=8'd71;
		8'h33:out=8'd72;
		8'h43:out=8'd73;
		8'h3B:out=8'd74;
		8'h42:out=8'd75;
		8'h4B:out=8'd76;
		8'h3A:out=8'd77;
		8'h31:out=8'd78;
		8'h44:out=8'd79;
		8'h4D:out=8'd80;
		8'h15:out=8'd81;
		8'h2D:out=8'd82;
		8'h1B:out=8'd83;
		8'h2C:out=8'd84;
		8'h3C:out=8'd85;
		8'h2A:out=8'd86;
		8'h1D:out=8'd87;
		8'h22:out=8'd88;
		8'h35:out=8'd89;
		8'h1A:out=8'd90;
		8'h45:out=8'd48;
		8'h16:out=8'd49;
		8'h1E:out=8'd50;
		8'h26:out=8'd51;
		8'h25:out=8'd52;
		8'h2E:out=8'd53;
		8'h36:out=8'd54;
		8'h3D:out=8'd55;
		8'h3E:out=8'd56;
		8'h46:out=8'd57;
		default: out=out;
	endcase 
	
endmodule 