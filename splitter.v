module splitter(in, o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15);
input wire[127:0] in;
output [7:0] o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15;

o0=in[7:0];
o1=in[15:8];
o2=in[23:16];
o3=in[31:24];
o4=in[39:32];
o5=in[47:40];
o6=in[55:48];
o7=in[63:56];
o8=in[71:64];
o9=in[79:72];
o10=in[87:80];
o11=in[95:88];
o12=in[103:96];
o13=in[111:104];
o14=in[119:112];
o15=in[127:120];


endmodule 