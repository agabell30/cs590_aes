module    LCD_mod (
// Host Side
  input iCLK,iRST_N,
// LCD Side
  output [7:0]     LCD_DATA,
  output LCD_RW,LCD_EN,LCD_RS,  
//Message to display
  input [7:0] i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15  
);
//    Internal Wires/Registers
reg    [5:0]    LUT_INDEX;
reg    [8:0]    LUT_DATA;
reg    [5:0]    mLCD_ST;
reg    [17:0]    mDLY;
reg        mLCD_Start;
reg    [7:0]    mLCD_DATA;
reg        mLCD_RS;
wire        mLCD_Done;

parameter    LCD_INTIAL    =    0;
parameter    LCD_LINE1    =    5;
parameter    LCD_CH_LINE    =    LCD_LINE1+16;
parameter    LCD_LINE2    =    LCD_LINE1+16+1;
parameter    LUT_SIZE    =    LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        LUT_INDEX    <=    0;
        mLCD_ST        <=    0;
        mDLY        <=    0;
        mLCD_Start    <=    0;
        mLCD_DATA    <=    0;
        mLCD_RS        <=    0;
    end
    else
    begin
        if(LUT_INDEX<LUT_SIZE)
        begin
            case(mLCD_ST)
            0:    begin
                    mLCD_DATA    <=    LUT_DATA[7:0];
                    mLCD_RS        <=    LUT_DATA[8];
                    mLCD_Start    <=    1;
                    mLCD_ST        <=    1;
                end
            1:    begin
                    if(mLCD_Done)
                    begin
                        mLCD_Start    <=    0;
                        mLCD_ST        <=    2;                    
                    end
                end
            2:    begin
                    if(mDLY<18'h3FFFE)
                    mDLY    <=    mDLY + 1'b1;
                    else
                    begin
                        mDLY    <=    0;
                        mLCD_ST    <=    3;
                    end
                end
            3:    begin
                    LUT_INDEX    <=    LUT_INDEX + 1'b1;
                    mLCD_ST    <=    0;
                end
            endcase
        end
    end
end

wire[7:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;
assign d0 = (i0==8'b0)?8'd63:i0;
assign d1 = (i1==8'b0)?8'd63:i1;
assign d2 = (i2==8'b0)?8'd63:i2;
assign d3 = (i3==8'b0)?8'd63:i3;
assign d4 = (i4==8'b0)?8'd63:i4;
assign d5 = (i5==8'b0)?8'd63:i5;
assign d6 = (i6==8'b0)?8'd63:i6;
assign d7 = (i7==8'b0)?8'd63:i7;
assign d8 = (i8==8'b0)?8'd63:i8;
assign d9 = (i9==8'b0)?8'd63:i9;
assign d10 = (i10==8'b0)?8'd63:i10;
assign d11 = (i11==8'b0)?8'd63:i11;
assign d12 = (i12==8'b0)?8'd63:i12;
assign d13 = (i13==8'b0)?8'd63:i13;
assign d14 = (i14==8'b0)?8'd63:i14;
assign d15 = (i15==8'b0)?8'd63:i15;


always
begin
    case(LUT_INDEX)
    //    Initial
    LCD_INTIAL+0:    LUT_DATA    <=    9'h038;
    LCD_INTIAL+1:    LUT_DATA    <=    9'h00C;
    LCD_INTIAL+2:    LUT_DATA    <=    9'h001;
    LCD_INTIAL+3:    LUT_DATA    <=    9'h006;
    LCD_INTIAL+4:    LUT_DATA    <=    9'h080;
    //    Line 1
    LCD_LINE1+0:    LUT_DATA    <=    {1'b1, d15};   
    LCD_LINE1+1:    LUT_DATA    <=    {1'b1, d14};
    LCD_LINE1+2:    LUT_DATA    <=    {1'b1, d13};
    LCD_LINE1+3:    LUT_DATA    <=    {1'b1, d12};
    LCD_LINE1+4:    LUT_DATA    <=    {1'b1, d11};
    LCD_LINE1+5:    LUT_DATA    <=    {1'b1, d10};
    LCD_LINE1+6:    LUT_DATA    <=    {1'b1, d9};
    LCD_LINE1+7:    LUT_DATA    <=    {1'b1, d8};
    LCD_LINE1+8:    LUT_DATA    <=    {1'b1, d7};
    LCD_LINE1+9:    LUT_DATA    <=    {1'b1, d6};
    LCD_LINE1+10:    LUT_DATA    <=    {1'b1, d5};
    LCD_LINE1+11:    LUT_DATA    <=    {1'b1, d4};
    LCD_LINE1+12:    LUT_DATA    <=    {1'b1, d3};
    LCD_LINE1+13:    LUT_DATA    <=    {1'b1, d2};
    LCD_LINE1+14:    LUT_DATA    <=    {1'b1, d1};
    LCD_LINE1+15:    LUT_DATA    <=    {1'b1, d0};
    //    Change Line
    LCD_CH_LINE:    LUT_DATA    <=    9'h0C0;
    //    Line 2
    LCD_LINE2+0:    LUT_DATA    <=    {1'b1, 8'd32};    
    LCD_LINE2+1:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+2:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+3:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+4:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+5:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+6:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+7:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+8:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+9:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+10:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+11:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+12:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+13:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+14:    LUT_DATA    <=    {1'b1, 8'd32};
    LCD_LINE2+15:    LUT_DATA    <=    {1'b1, 8'd32};
    default:        LUT_DATA    <=    9'dx ;
    endcase
end

LCD_Controller u0(
//    Host Side
.iDATA(mLCD_DATA),
.iRS(mLCD_RS),
.iStart(mLCD_Start),
.oDone(mLCD_Done),
.iCLK(iCLK),
.iRST_N(iRST_N),
//    LCD Interface
.LCD_DATA(LCD_DATA),
.LCD_RW(LCD_RW),
.LCD_EN(LCD_EN),
.LCD_RS(LCD_RS)    );

endmodule