//-----------------------------------------------------
// Design Name : invcipher
// File Name   : invcipher.v
// Function    : Invert AES-128
//-----------------------------------------------------
module invcipher(
in, //16 bytes of encrypted input
out, //16 bytes of plaintext output
w, //44 words of expanded key (done in key_expansion.v)
enable
);

input  enable ; 
input [1407:0]w ; //44 words (44 * 32 = 1408)
input [127:0]in; //16 bytes of input (16 * 8 = 128)
output [127:0]out; //16 bytes of output

reg [127:0]state;
reg [0:2047]invsbox;
reg [31:0]i;
reg [31:0]j;
always @ (enable, in, w)
begin

	invsbox = {8'h52,8'h09,8'h6a,8'hd5,8'h30,8'h36,8'ha5,8'h38,8'hbf,8'h40,8'ha3,8'h9e,8'h81,8'hf3,8'hd7,8'hfb,
8'h7c,8'he3,8'h39,8'h82,8'h9b,8'h2f,8'hff,8'h87,8'h34,8'h8e,8'h43,8'h44,8'hc4,8'hde,8'he9,8'hcb, 
8'h54,8'h7b,8'h94,8'h32,8'ha6,8'hc2,8'h23,8'h3d,8'hee,8'h4c,8'h95,8'h0b,8'h42,8'hfa,8'hc3,8'h4e, 
8'h08,8'h2e,8'ha1,8'h66,8'h28,8'hd9,8'h24,8'hb2,8'h76,8'h5b,8'ha2,8'h49,8'h6d,8'h8b,8'hd1,8'h25, 
8'h72,8'hf8,8'hf6,8'h64,8'h86,8'h68,8'h98,8'h16,8'hd4,8'ha4,8'h5c,8'hcc,8'h5d,8'h65,8'hb6,8'h92, 
8'h6c,8'h70,8'h48,8'h50,8'hfd,8'hed,8'hb9,8'hda,8'h5e,8'h15,8'h46,8'h57,8'ha7,8'h8d,8'h9d,8'h84, 
8'h90,8'hd8,8'hab,8'h00,8'h8c,8'hbc,8'hd3,8'h0a,8'hf7,8'he4,8'h58,8'h05,8'hb8,8'hb3,8'h45,8'h06, 
8'hd0,8'h2c,8'h1e,8'h8f,8'hca,8'h3f,8'h0f,8'h02,8'hc1,8'haf,8'hbd,8'h03,8'h01,8'h13,8'h8a,8'h6b, 
8'h3a,8'h91,8'h11,8'h41,8'h4f,8'h67,8'hdc,8'hea,8'h97,8'hf2,8'hcf,8'hce,8'hf0,8'hb4,8'he6,8'h73, 
8'h96,8'hac,8'h74,8'h22,8'he7,8'had,8'h35,8'h85,8'he2,8'hf9,8'h37,8'he8,8'h1c,8'h75,8'hdf,8'h6e, 
8'h47,8'hf1,8'h1a,8'h71,8'h1d,8'h29,8'hc5,8'h89,8'h6f,8'hb7,8'h62,8'h0e,8'haa,8'h18,8'hbe,8'h1b, 
8'hfc,8'h56,8'h3e,8'h4b,8'hc6,8'hd2,8'h79,8'h20,8'h9a,8'hdb,8'hc0,8'hfe,8'h78,8'hcd,8'h5a,8'hf4, 
8'h1f,8'hdd,8'ha8,8'h33,8'h88,8'h07,8'hc7,8'h31,8'hb1,8'h12,8'h10,8'h59,8'h27,8'h80,8'hec,8'h5f, 
8'h60,8'h51,8'h7f,8'ha9,8'h19,8'hb5,8'h4a,8'h0d,8'h2d,8'he5,8'h7a,8'h9f,8'h93,8'hc9,8'h9c,8'hef, 
8'ha0,8'he0,8'h3b,8'h4d,8'hae,8'h2a,8'hf5,8'hb0,8'hc8,8'heb,8'hbb,8'h3c,8'h83,8'h53,8'h99,8'h61, 
8'h17,8'h2b,8'h04,8'h7e,8'hba,8'h77,8'hd6,8'h26,8'he1,8'h69,8'h14,8'h63,8'h55,8'h21,8'h0c,8'h7d};
//state = in
state = in;
//AddRoundKey(state, w[40,43])
state = AddRoundKey(state, w[1407 -: 128]);
//for round = 9 step -1 downto 1
for(i=9;i>=1;i=i-1)
begin	
//		InvShiftRows(state)
	state = InvShiftRows(state);
//		InvSubBytes(state)
	for(j=0;j<16;j=j+1)
	begin
		state[8*j+7 -: 8] = invsbox[(state[8*j+7 -: 8])*8+7 -: 8];
	end
//		AddRoundKey(state, w[round*4, ((round+1)*4)-1])
	//state = AddRoundKey(state, w[i*4,((i+1)*4)-1])
	state = AddRoundKey(state, w[128*i+127 -: 128]);
//		InvMixColumns(state)
	state = InvMixColumns(state);
//end for
end
//SubBytes(state)
for(j=0;j<16;j=j+1)
begin
		state[8*j+7 -: 8] = invsbox[(state[8*j+7 -: 8])*8+7 -: 8];
end
//InvShiftRows(state)
state = InvShiftRows(state);
//AddRoundKey(state, w[0,3])
state = AddRoundKey(state,w[127 -: 128]);
//out = state
out = state;
end

function [127:0] AddRoundKey;
	input [127:0] state;
	input [127:0] w;
	reg [127:0] out;
	reg [31:0] i;
	begin
	for(i=0;i<4;i=i+1)
	begin
		out[7+i*32 -: 8] = state[7+i*32 -: 8] ^ w[31+i*32 -: 8];
		out[15+i*32 -: 8] = state[15+i*32 -: 8] ^ w[23+i*32 -: 8];
		out[23+i*32 -: 8] = state[23+i*32 -: 8] ^ w[15+i*32 -: 8];
		out[31+i*32 -: 8] = state[31+i*32 -: 8] ^ w[7+i*32 -: 8];
	end
	AddRoundKey = out;
	end
endfunction

function [127:0] InvShiftRows;
	input [127:0] state;
	reg[127:0] out;
	begin
	//row 1 does nothing
	out[7:0] = state[7:0];
	out[39:32] = state[39:32];
	out[71:64] = state[71:64];
	out[103:96] = state[103:96];
	//row 2
	out[47:40] = state[15:8];
	out[79:72] = state[47:40];
	out[111:104] = state[79:72];
	out[15:8] = state[111:104];
	//row 3
	out[23:16] = state[87:80];
	out[55:48] = state[119:112];
	out[87:80] = state[23:16];
	out[119:112] = state[55:48];
	//row 4
	out[127:120] = state[31:24];
	out[31:24] = state[63:56];
	out[63:56] = state[95:88];
	out[95:88] = state[127:120];
	InvShiftRows = out;
	end
endfunction

function [127:0] InvMixColumns;
	input [127:0] state;
	reg[127:0] out;
	reg[31:0]i;
	begin
	for(i=0;i<4;i=i+1)
	begin
	out[7+i*32 -: 8] = weirdMult(8'h0e,state[7+i*32 -: 8]) ^ weirdMult(8'h0b,state[15+i*32 -: 8]) ^ weirdMult(8'h0d,state[23+i*32 -: 8]) ^ weirdMult(8'h09,state[31+i*32 -: 8]);
	out[15+i*32 -: 8] = weirdMult(8'h09,state[7+i*32 -: 8]) ^ weirdMult(8'h0e,state[15+i*32 -: 8]) ^ weirdMult(8'h0b,state[23+i*32 -: 8]) ^ weirdMult(8'h0d,state[31+i*32 -: 8]);
	out[23+i*32 -: 8] = weirdMult(8'h0d,state[7+i*32 -: 8]) ^ weirdMult(8'h09,state[15+i*32 -: 8]) ^ weirdMult(8'h0e,state[23+i*32 -: 8]) ^ weirdMult(8'h0b,state[31+i*32 -: 8]);
	out[31+i*32 -: 8] = weirdMult(8'h0b,state[7+i*32 -: 8]) ^ weirdMult(8'h0d,state[15+i*32 -: 8]) ^ weirdMult(8'h09,state[23+i*32 -: 8]) ^ weirdMult(8'h0e,state[31+i*32 -: 8]);
	end
	InvMixColumns = out;
	end
endfunction

function [7:0] weirdMult; //adapted from https://en.wikipedia.org/wiki/Finite_field_arithmetic#Rijndael.27s_finite_field
	input [7:0] a;
	input [7:0] b;
	reg[15:0] p;
	reg[31:0] i;
	reg carry;
	begin
	p = 16'b0000;
	for(i=0;i<8;i=i+1)
	begin
	  if(b[0])
	  begin
		p = p ^ a;
	  end
	  b = b >> 1;
	  carry = a[7];
	  a = a << 1;
	  if(carry)
	  begin
		a = a ^ 8'h1b;
	  end
	end
	weirdMult = p[7:0];
	end
endfunction

endmodule