//-----------------------------------------------------
// Design Name : key_expansion
// File Name   : key_expansion.v
// Function    : Expands 128-bit key for AES
// Coder       : Alex Abell
//-----------------------------------------------------
module key_expansion(
keys_out , //  4 bit binary Output
key_in , //  16-bit Input
enable,     //  1 to trigger key expansion
finished,	// 1 when finished

);
output [31:0] w [43:0]  ; // 44 words of output
input  enable ; 
input [7:0] key_in [15:0] ; // 16 bytes of keys 

reg [3:0] rounds = 4'hA; //AES-128 key expansion uses 10 rounds (a in hex)
reg [31:0] temp; //temporary word-sized variable
reg [5:0] i; //counter variable (has to count up to 44 (needs 6 bits)

always @ (enable)
begin
  i <= 0;
  while (i < 4)
  begin
   w[7:0][i] <= key_in[7:0][4*i+3];
	w[15:8][i] <= key_in[7:0][4*i+2];
	w[23:16][i] <= key_in[7:0][4*i+1];
	w[31:24][i] <= key_in[7:0][4*i];
	i <= i + 1;
  end
  
  i <= 4;
  
  while(i < 44)
  begin
   temp <= w[31:0][i-1];
	if(i % 4 == 0)
	begin
		//temp = subword(rotword(temp)) xor Rcon[i/4]; 
	end
	
	w[31:0][i] = w[31:0][i-4] xor temp;
  
	i <= i + 1;
  end  
end

endmodule
