LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY datapath IS 
	GENERIC(DATA_WIDTH: INTEGER;
		ROW_SIZE_IN: INTEGER;
		COL_SIZE_IN: INTEGER;
		ROW_SIZE_OUT: INTEGER;
		COL_SIZE_OUT: INTEGER;
		ROW_STEP: INTEGER;
		COL_STEP: INTEGER);
	PORT(	Clk: IN STD_LOGIC;
		--Row, Row_Step, Column, Column_Step
		R_clr, Rs_clr, C_clr, Cs_clr: IN STD_LOGIC;
		R_inc, Rs_inc, C_inc, Cs_inc: IN STD_LOGIC;
		Data_in: IN INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
		Data_out: IN INTEGER RANGE 0 TO 4*(2**DATA_WIDTH - 1);
		R_z, Rs_z, C_z, Cs_z: OUT STD_LOGIC;
		--Adress
		Data_in_addr: OUT INTEGER RANGE 0 TO ROW_SIZE_IN * COL_SIZE_IN - 1;
		Data_out_addr: OUT INTEGER RANGE 0 TO ROW_SIZE_OUT * COL_SIZE_OUT - 1;
		New_data_out: OUT INTEGER RANGE 0 TO 4*(2**DATA_WIDTH - 1)
	);
END datapath;

ARCHITECTURE datapath_arch OF datapath IS
	
	SIGNAL Count_r:	INTEGER RANGE 0 TO ROW_SIZE_OUT;
	SIGNAL Count_rs: INTEGER RANGE 0 TO ROW_STEP;
	SIGNAL Count_c:	INTEGER RANGE 0 TO COL_SIZE_OUT;
	SIGNAL Count_cs: INTEGER RANGE 0 TO COL_STEP;
	
	BEGIN
	Counter_r: counter 
		GENERIC MAP(stop_value => ROW_SIZE_OUT)
		PORT MAP(Clk => Clk,
			Inc => R_inc,
			Clr => R_clr,
			Z => R_z,
			Count => Count_r);
	Counter_rs: counter
		GENERIC MAP(stop_value => ROW_STEP)
		PORT MAP(Clk => Clk,
			Inc => Rs_inc,
			Clr => Rs_clr,
			Z => Rs_z,
			Count => Count_rs);
	Counter_c: counter
		GENERIC MAP(stop_value => COL_SIZE_OUT)
		PORT MAP(Clk => Clk,
			Inc => C_inc,
			Clr => C_clr,
			Z => C_z,
			Count => Count_c);
	Counter_cs:	counter
		GENERIC MAP(stop_value => COL_STEP)
		PORT MAP(Clk => Clk,
			Inc => Cs_inc,
			Clr => Cs_clr,
			Z => Cs_z,
			Count => Count_cs);
	
	Data_in_addr <= (Count_r * ROW_STEP + Count_rs) * ROW_SIZE_IN + Count_c * COL_STEP + Count_cs;
	Data_out_addr <= Count_r * ROW_SIZE_OUT + Count_c;
	New_data_out <= Data_out + Data_in;
	
END datapath_arch;
