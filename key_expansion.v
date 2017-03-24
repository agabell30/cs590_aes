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
reg [7:0] rcon_result;
reg [31:0] subword_result;
reg [31:0] rotword_result;
reg [15:0] i; //counter variable (has to count up to 44 (needs 6 bits)
reg [15:0] j;
always @ (enable, key_in)
begin
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
  
  while(i<44)
  begin
	temp = w[(i-1)*32+31 -: 32];
	if(i % 4 == 0)
	begin
		//temp = subword(rotword(temp)) ^ Rcon(i/4);
		temp = subword(rotword(temp)) ^ Rcon(i/4);
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

function [31:0] subword;
	input [31:0] in_word;
	reg [31:0] result;
	begin
	result[7:0] = subbyte(in_word[7:0]);
	result[15:8] = subbyte(in_word[15:8]);
	result[23:16] = subbyte(in_word[23:16]);
	result[31:24] = subbyte(in_word[31:24]);
	subword = result;
	end
endfunction

function [7:0] subbyte;
	input [7:0] in_byte;
	
	reg [7:0]s;
	reg [7:0]result;
	reg [2:0]i;
	reg [7:0] out_byte;
	begin
		s = in_byte;
		result[7:0] = 8'h00;
		for(i = 0; i < 5; i = i + 3'b001)
		begin
			result = result ^ s;
			s = {s[6:0],s[7]};
		end
		out_byte = result ^ 8'h63;
		subbyte = out_byte;
	end
endfunction

function [31:0] rotword;
	input [31:0]in_word;
	reg [31:0] out_word;
	begin
	out_word[7:0] = in_word[15:8];
	out_word[15:8] = in_word[23:16];
	out_word[23:16] = in_word[31:24];
	out_word[31:24] = in_word[7:0];
	rotword = out_word;
	end
endfunction

function [7:0] Rcon;
	input [7:0]in_byte;
	reg[7:0] out_byte;
	begin
		case(in_byte)
			0: out_byte = 8'h8d;
			1: out_byte = 8'h01;
			2: out_byte = 8'h02;
			3: out_byte = 8'h04;
			4: out_byte = 8'h08;
			5: out_byte = 8'h10;
			6: out_byte = 8'h20;
			7: out_byte = 8'h40;
			8: out_byte = 8'h80;
			9: out_byte = 8'h1b;
			10: out_byte = 8'h36;
			default: out_byte = 8'h00;
		endcase
		Rcon = out_byte;
	end
endfunction

endmodule
