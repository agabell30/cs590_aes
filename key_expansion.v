//-----------------------------------------------------
// Design Name : key_expansion
// File Name   : key_expansion.v
// Function    : Expands 128-bit key for AES
// Coder       : Alex Abell
//-----------------------------------------------------
module key_expansion(
w, //  44 words of output round keys
key_in , //  16 bytes of keys for input
enable    //  1 to trigger key expansion
);

output [1407:0] w; // 44 words of output (44*32 = 1408)
input  enable ; 
input [127:0]key_in ; // 16 bytes of keys (16*8 = 128)

reg [31:0] temp; //temporary word-sized variable
reg [31:0] subword_result;
reg [31:0] rotword_result;
reg [0:2047]sbox;
reg [15:0] i; //counter variable (has to count up to 44 (needs 6 bits)


always @ (enable, key_in)
begin

	sbox = {
8'h63,8'h7c,8'h77,8'h7b,8'hf2,8'h6b,8'h6f,8'hc5,8'h30,8'h01,8'h67,8'h2b,8'hfe,8'hd7,8'hab,8'h76,
8'hca,8'h82,8'hc9,8'h7d,8'hfa,8'h59,8'h47,8'hf0,8'had,8'hd4,8'ha2,8'haf,8'h9c,8'ha4,8'h72,8'hc0,
8'hb7,8'hfd,8'h93,8'h26,8'h36,8'h3f,8'hf7,8'hcc,8'h34,8'ha5,8'he5,8'hf1,8'h71,8'hd8,8'h31,8'h15, 
8'h04,8'hc7,8'h23,8'hc3,8'h18,8'h96,8'h05,8'h9a,8'h07,8'h12,8'h80,8'he2,8'heb,8'h27,8'hb2,8'h75, 
8'h09,8'h83,8'h2c,8'h1a,8'h1b,8'h6e,8'h5a,8'ha0,8'h52,8'h3b,8'hd6,8'hb3,8'h29,8'he3,8'h2f,8'h84, 
8'h53,8'hd1,8'h00,8'hed,8'h20,8'hfc,8'hb1,8'h5b,8'h6a,8'hcb,8'hbe,8'h39,8'h4a,8'h4c,8'h58,8'hcf, 
8'hd0,8'hef,8'haa,8'hfb,8'h43,8'h4d,8'h33,8'h85,8'h45,8'hf9,8'h02,8'h7f,8'h50,8'h3c,8'h9f,8'ha8, 
8'h51,8'ha3,8'h40,8'h8f,8'h92,8'h9d,8'h38,8'hf5,8'hbc,8'hb6,8'hda,8'h21,8'h10,8'hff,8'hf3,8'hd2, 
8'hcd,8'h0c,8'h13,8'hec,8'h5f,8'h97,8'h44,8'h17,8'hc4,8'ha7,8'h7e,8'h3d,8'h64,8'h5d,8'h19,8'h73, 
8'h60,8'h81,8'h4f,8'hdc,8'h22,8'h2a,8'h90,8'h88,8'h46,8'hee,8'hb8,8'h14,8'hde,8'h5e,8'h0b,8'hdb, 
8'he0,8'h32,8'h3a,8'h0a,8'h49,8'h06,8'h24,8'h5c,8'hc2,8'hd3,8'hac,8'h62,8'h91,8'h95,8'he4,8'h79, 
8'he7,8'hc8,8'h37,8'h6d,8'h8d,8'hd5,8'h4e,8'ha9,8'h6c,8'h56,8'hf4,8'hea,8'h65,8'h7a,8'hae,8'h08, 
8'hba,8'h78,8'h25,8'h2e,8'h1c,8'ha6,8'hb4,8'hc6,8'he8,8'hdd,8'h74,8'h1f,8'h4b,8'hbd,8'h8b,8'h8a, 
8'h70,8'h3e,8'hb5,8'h66,8'h48,8'h03,8'hf6,8'h0e,8'h61,8'h35,8'h57,8'hb9,8'h86,8'hc1,8'h1d,8'h9e, 
8'he1,8'hf8,8'h98,8'h11,8'h69,8'hd9,8'h8e,8'h94,8'h9b,8'h1e,8'h87,8'he9,8'hce,8'h55,8'h28,8'hdf, 
8'h8c,8'ha1,8'h89,8'h0d,8'hbf,8'he6,8'h42,8'h68,8'h41,8'h99,8'h2d,8'h0f,8'hb0,8'h54,8'hbb,8'h16};


  i = 0;
  for(int i=0;i<4;i++)
  begin  //w[i] = word(key[4*i], key[4*i+1], key[4*i+2], key[4*i+3])
		w[i*32+31 -: 8] = key_in[(4*i+0)*8+7 -: 8];
		w[i*32+23 -: 8] = key_in[(4*i+1)*8+7 -: 8];
		w[i*32+15 -: 8] = key_in[(4*i+2)*8+7 -: 8];
		w[i*32+7 -: 8] = key_in[(4*i+3)*8+7 -: 8];	
  end
  
  /*while (i < 4)
  begin
   j = 4*i+3;
   w[i][7:0] = key_in[j[15:0]];
	w[i][15:8] = key_in[4*i+2];
	w[i][23:16] = key_in[4*i+1];
	w[i][31:24] = key_in[4*i+0];
	i = i + 32'h00000001;
  end*/
  
  i = 4;
  
  while(i<44) //i < 44
  begin
	temp = w[(i-1)*32+31 -: 32];
	if(i % 4 == 0)
	begin
		rotword_result = rotword(temp);
		//subword_result = subword(rotword_result);
		for(int j=0;j<4;j=j+1)
		begin
			subword_result[8*j+7 -: 8] = sbox[(rotword_result[8*j+7 -: 8])*8+7 -: 8];
		end
		temp = subword_result ^ Rcon(i/4);
		//temp = subword(rotword(temp)) ^ Rcon(i/4);
	end
	w[i*32+31 -: 32] = w[(i-4)*32+31 -: 32] ^ temp;
	i = i + 16'h0001;
  end
  
  /*
  while(i < 44)
  begin
   temp = w[i-1][31:0];
	if(i % 4 == 0)
	begin
		//temp = subword(rotword(temp)) ^ Rcon(i/4);
		temp = subword(rotword(temp)) ^ Rcon(i/4);
	end
	
	w[i][31:0] <= w[i-4][31:0] ^ temp;
  
	i = i + 1;
  end  
  */
end

function [31:0] rotword;
	input [31:0]in_word;
	reg [31:0] out_word;
	begin
	out_word[7:0] = in_word[31:24];
	out_word[15:8] = in_word[7:0];
	out_word[23:16] = in_word[15:8];
	out_word[31:24] = in_word[23:16];
	rotword = out_word;
	end
endfunction

function [31:0] Rcon;
	input [7:0]in_byte;
	reg[31:0] out_byte;
	begin
		case(in_byte)
			0: out_byte = 32'h8d000000;
			1: out_byte = 32'h01000000;
			2: out_byte = 32'h02000000;
			3: out_byte = 32'h04000000;
			4: out_byte = 32'h08000000;
			5: out_byte = 32'h10000000;
			6: out_byte = 32'h20000000;
			7: out_byte = 32'h40000000;
			8: out_byte = 32'h80000000;
			9: out_byte = 32'h1b000000;
			10: out_byte = 32'h36000000;
			default: out_byte = 32'h00000000;
		endcase
		Rcon = out_byte;
	end
endfunction

endmodule
