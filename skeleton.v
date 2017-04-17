module skeleton( 
	ps2_clock, ps2_data, 										// ps2 related I/O
	leds, 
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements															//	VGA Blue[9:0]
	CLOCK_50, resetn, sw0, sw1);  								// 50 MHz clock
		
	input CLOCK_50;
	input sw0, sw1;
	
	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	
	
	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	
	
	assign clock = CLOCK_50;

	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	
	//Register clock generation
	wire release_pulse;
	PS2_pulse_output ps2p(clock, ps2_out, release_pulse);
	
	//Message Buffer
	wire[127:0] m_sr_out;
	ShiftRegister sr_m(release_pulse, (sel==2'b01), ps2_out, m_sr_out);
	wire[7:0] mo0, mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11, mo12, mo13, mo14, mo15;
	splitter s_m(m_sr_out, mo0, mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11, mo12, mo13, mo14, mo15);
	
	//Enc Key Buffer
	wire[127:0] k_sr_out;
	ShiftRegister sr_k(release_pulse, (sel==2'b00), ps2_out, k_sr_out);
	wire[7:0] ko0, ko1, ko2, ko3, ko4, ko5, ko6, ko7, ko8, ko9, ko10, ko11, ko12, ko13, ko14, ko15;
	splitter s_k(k_sr_out, ko0, ko1, ko2, ko3, ko4, ko5, ko6, ko7, ko8, ko9, ko10, ko11, ko12, ko13, ko14, ko15);
	
	// lcd controller
	assign lcd_on = 1'b1;
	assign lcd_blon = 1'b1;
	wire lcd_reset;
	Reset_Delay r0(.iCLK(clock),.oRESET(lcd_reset), .iRESET(release_pulse));
	
	wire [1:0] sel;
	assign sel = {sw1, sw0};
	
	wire[7:0] o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15;
	assign o0 = (sel==2'b01)?mo0:((sel==2'b00)?ko0:((sel==2'b10)?co0:rmo0));
	assign o1 = (sel==2'b01)?mo1:((sel==2'b00)?ko1:((sel==2'b10)?co1:rmo1));
	assign o2 = (sel==2'b01)?mo2:((sel==2'b00)?ko2:((sel==2'b10)?co2:rmo2));
	assign o3 = (sel==2'b01)?mo3:((sel==2'b00)?ko3:((sel==2'b10)?co3:rmo3));
	assign o4 = (sel==2'b01)?mo4:((sel==2'b00)?ko4:((sel==2'b10)?co4:rmo4));
	assign o5 = (sel==2'b01)?mo5:((sel==2'b00)?ko5:((sel==2'b10)?co5:rmo5));
	assign o6 = (sel==2'b01)?mo6:((sel==2'b00)?ko6:((sel==2'b10)?co6:rmo6));
	assign o7 = (sel==2'b01)?mo7:((sel==2'b00)?ko7:((sel==2'b10)?co7:rmo7));
	assign o8 = (sel==2'b01)?mo8:((sel==2'b00)?ko8:((sel==2'b10)?co8:rmo8));
	assign o9 = (sel==2'b01)?mo9:((sel==2'b00)?ko9:((sel==2'b10)?co9:rmo9));
	assign o10 = (sel==2'b01)?mo10:((sel==2'b00)?ko10:((sel==2'b10)?co10:rmo10));
	assign o11 = (sel==2'b01)?mo11:((sel==2'b00)?ko11:((sel==2'b10)?co11:rmo11));
	assign o12 = (sel==2'b01)?mo12:((sel==2'b00)?ko12:((sel==2'b10)?co12:rmo12));
	assign o13 = (sel==2'b01)?mo13:((sel==2'b00)?ko13:((sel==2'b10)?co13:rmo13));
	assign o14 = (sel==2'b01)?mo14:((sel==2'b00)?ko14:((sel==2'b10)?co14:rmo14));
	assign o15 = (sel==2'b01)?mo15:((sel==2'b00)?ko15:((sel==2'b10)?co15:rmo15));
	
	wire[7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
	scancode_to_ascii s0(o0, a0);
	scancode_to_ascii s1(o1, a1);
	scancode_to_ascii s2(o2, a2);
	scancode_to_ascii s3(o3, a3);
	scancode_to_ascii s4(o4, a4);
	scancode_to_ascii s5(o5, a5);
	scancode_to_ascii s6(o6, a6);
	scancode_to_ascii s7(o7, a7);
	scancode_to_ascii s8(o8, a8);
	scancode_to_ascii s9(o9, a9);
	scancode_to_ascii s10(o10, a10);
	scancode_to_ascii s11(o11, a11);
	scancode_to_ascii s12(o12, a12);
	scancode_to_ascii s13(o13, a13);
	scancode_to_ascii s14(o14, a14);
	scancode_to_ascii s15(o15, a15);
	
	
	LCD_mod my_lcd(clock, lcd_reset, lcd_data, lcd_rw, lcd_en, lcd_rs,
	a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15);
	
	//AES
	wire [1407:0] xpanded_keys;
	wire [127:0] cyph_txt, r_message;
	wire[7:0] co0, co1, co2, co3, co4, co5, co6, co7, co8, co9, co10, co11, co12, co13, co14, co15;
	wire[7:0] rmo0, rmo1, rmo2, rmo3, rmo4, rmo5, rmo6, rmo7, rmo8, rmo9, rmo10, rmo11, rmo12, rmo13, rmo14, rmo15;
	key_expansion kx(.w(xpanded_keys), .key_in(k_sr_out), .enable(1'b1));
	cipher cyph(.in(m_sr_out), .out(cyph_txt), .w(xpanded_keys), .enable(1'b1));
	invcipher icyph(.in(cyph_txt), .out(r_message), .w(xpanded_keys), .enable(1'b1));
	splitter s_c(cyph_text, co0, co1, co2, co3, co4, co5, co6, co7, co8, co9, co10, co11, co12, co13, co14, co15);
	splitter s_rm(m_sr_out, rmo0, rmo1, rmo2, rmo3, rmo4, rmo5, rmo6, rmo7, rmo8, rmo9, rmo10, rmo11, rmo12, rmo13, rmo14, rmo15);
	
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(o0[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(o0[7:4], seg2);
	
	
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex3(o1[3:0], seg3);
	Hexadecimal_To_Seven_Segment hex4(o1[7:4], seg4);
	Hexadecimal_To_Seven_Segment hex5(o2[3:0], seg5);
	Hexadecimal_To_Seven_Segment hex6(o2[7:4], seg6);
	Hexadecimal_To_Seven_Segment hex7(o3[3:0], seg7);
	Hexadecimal_To_Seven_Segment hex8(o3[7:4], seg8);
	
	// some LEDs that you could use for debugging if you wanted
	assign leds = {6'b000000, sel};

endmodule 