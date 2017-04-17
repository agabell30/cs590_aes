module Reset_Delay( input iCLK, output reg oRESET, input iRESET);
reg [19:0] Cont;

always@(posedge iCLK or posedge iRESET)
begin
	if(iRESET) begin
		Cont = 20'b0;
	end else begin
		if(Cont!=20'hFFFFF)begin
			Cont <= Cont + 1'b1;
			oRESET <= 1'b0;
		end else begin
			oRESET <= 1'b1;
		end
	end
end


endmodule 