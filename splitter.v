module splitter(in, o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15);
input wire[127:0] in;
output [7:0] o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15;

assign o0=in[7:0];
assign o1=in[15:8];
assign o2=in[23:16];
assign o3=in[31:24];
assign o4=in[39:32];
assign o5=in[47:40];
assign o6=in[55:48];
assign o7=in[63:56];
assign o8=in[71:64];
assign o9=in[79:72];
assign o10=in[87:80];
assign o11=in[95:88];
assign o12=in[103:96];
assign o13=in[111:104];
assign o14=in[119:112];
assign o15=in[127:120];


endmodule 