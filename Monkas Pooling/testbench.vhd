LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE arch OF testbench IS

	CONSTANT CLK_TIME: TIME := 20 ns;
	CONSTANT DATA_WIDTH: INTEGER := 8;
	CONSTANT ROW_SIZE_IN: INTEGER := 4;
	CONSTANT COL_SIZE_IN: INTEGER := 4;
	CONSTANT ROW_SIZE_OUT: INTEGER := 2;
	CONSTANT COL_SIZE_OUT: INTEGER := 2;
	CONSTANT ROW_STEP: INTEGER := 2;
	CONSTANT COL_STEP: INTEGER := 2;

	SIGNAL Data_in_addr: INTEGER RANGE 0 TO ROW_SIZE_IN * COL_SIZE_IN - 1;
	SIGNAL Data_out_addr: INTEGER RANGE 0 TO ROW_SIZE_OUT * COL_SIZE_OUT - 1;
	SIGNAL Data_read_in, Data_read_out, Data_write_in, Data_write_out: INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
	SIGNAL Clk: STD_LOGIC := '0';
	SIGNAL Start, Reset, Done: STD_LOGIC;

	BEGIN 
		Clk <= NOT Clk AFTER CLK_TIME;
		U_Average_pooling : pooling
			GENERIC MAP(DATA_WIDTH => DATA_WIDTH,
				ROW_SIZE_IN => ROW_SIZE_IN,
				COL_SIZE_IN => COL_SIZE_IN,
				ROW_SIZE_OUT => ROW_SIZE_OUT,
				COL_SIZE_OUT => COL_SIZE_OUT,
				ROW_STEP => ROW_STEP,
				COL_STEP => COL_STEP)
			PORT MAP(Clk => Clk,
				Start => Start,
				Reset => Reset,
				Done => Done);
	TESTING:PROCESS
		BEGIN
			Reset <= '1';
			WAIT FOR 100 ns;
			Reset <= '0';
			Start <= '1';
			WAIT;
		END PROCESS;

END arch;

