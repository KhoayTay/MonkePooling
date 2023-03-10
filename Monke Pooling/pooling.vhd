LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY pooling IS
	GENERIC(DATA_WIDTH: INTEGER;
		ROW_SIZE_IN: INTEGER;
		COL_SIZE_IN: INTEGER;
		ROW_SIZE_OUT: INTEGER;
		COL_SIZE_OUT: INTEGER;
		ROW_STEP: INTEGER;
		COL_STEP: INTEGER);
	
	PORT(	Start, Clk, Reset: IN STD_LOGIC;
		Done: OUT STD_LOGIC);
END pooling;
ARCHITECTURE pooling_arch OF pooling IS

	SIGNAL Cleaned:	STD_LOGIC;
	SIGNAL Clean: STD_LOGIC;
	--Row, Row_Step, Column, Column_Step
	SIGNAL R_clr, Rs_clr, C_clr, Cs_clr: STD_LOGIC;
	SIGNAL R_inc, Rs_inc, C_inc, Cs_inc: STD_LOGIC;
	SIGNAL R_z, Rs_z, C_z, Cs_z, Gt: STD_LOGIC;
	SIGNAL Re_in, Re_out, We_in, We_out: STD_LOGIC;
	SIGNAL Data_in_addr: INTEGER RANGE 0 TO ROW_SIZE_IN * COL_SIZE_IN - 1;
	SIGNAL Data_out_addr: INTEGER RANGE 0 TO ROW_SIZE_OUT * COL_SIZE_OUT - 1;
	SIGNAL Data_write_in: INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
	SIGNAL Data_write_out: INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
	SIGNAL Data_read_in: INTEGER RANGE 0 TO 4*(2**DATA_WIDTH - 1);
	SIGNAL Data_read_out: INTEGER RANGE 0 TO 4*(2**DATA_WIDTH - 1);

	BEGIN
	U_Data_in : data_in
		GENERIC MAP(
			DATA_WIDTH => DATA_WIDTH,
			ROW_SIZE => ROW_SIZE_IN,
			COL_SIZE => COL_SIZE_IN)
		PORT MAP(
			Clk => Clk,
			We_in => We_in,
			Re_in => Re_in,
			Addr => Data_in_addr,
			Data_in => Data_write_in,
			Data_out => Data_read_in);
		
	U_Data_out : data_out
		GENERIC MAP(
			DATA_WIDTH => DATA_WIDTH,
			ROW_SIZE => ROW_SIZE_OUT,
			COL_SIZE => COL_SIZE_OUT)
		PORT MAP(
			Clk => Clk,
			We_out => We_out,
			Re_out => Re_out,
			Addr => Data_out_addr,
			Data_in => Data_write_out,
			Data_out => Data_read_out,
			Clean => Clean,
			Done => Cleaned);

	U_Datapath : datapath
		GENERIC MAP(
			DATA_WIDTH => DATA_WIDTH,
			ROW_SIZE_IN => ROW_SIZE_IN,
			COL_SIZE_IN => COL_SIZE_IN,
			ROW_SIZE_OUT => ROW_SIZE_OUT,
			COL_SIZE_OUT => COL_SIZE_OUT,
			ROW_STEP => ROW_STEP,
			COL_STEP => COL_STEP)
		PORT MAP(
			Clk => Clk,
			R_clr => R_clr,
			Rs_clr => Rs_clr,
			C_clr => C_clr,
			Cs_clr => Cs_clr,
			R_inc => R_inc,
			Rs_inc => Rs_inc,
			C_inc => C_inc,
			Cs_inc => Cs_inc,
			Data_in => Data_read_in,
			Data_out => Data_read_out,
			R_z => R_z,
			Rs_z => Rs_z,
			C_z => C_z,
			Cs_z => Cs_z,
			Data_in_addr => Data_in_addr,
			Data_out_addr => Data_out_addr,
			New_data_out => Data_write_out);

	U_Controller : controller
		GENERIC MAP(DATA_WIDTH => DATA_WIDTH)
		PORT MAP(
			Clk => Clk,
			Start => Start,
			Reset => Reset,
			R_clr => R_clr,
			Rs_clr => Rs_clr,
			C_clr => C_clr,
			Cs_clr => Cs_clr,
			R_inc => R_inc,
			Rs_inc => Rs_inc,
			C_inc => C_inc,
			Cs_inc => Cs_inc,
			R_z => R_z,
			Rs_z => Rs_z,
			C_z => C_z,
			Cs_z => Cs_z,
			Re_in => Re_in,
			Re_out => Re_out,
			We_in => We_in,
			We_out => We_out,
			Done_clean => Cleaned,			
			Clean => Clean,
			Done => Done);
END pooling_arch;


