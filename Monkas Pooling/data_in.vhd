LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY data_in IS
	GENERIC(DATA_WIDTH: INTEGER;
		ROW_SIZE: INTEGER;
		COL_SIZE: INTEGER);
	PORT(	Clk: IN STD_LOGIC;
		We_in: IN STD_LOGIC;
		Re_in: IN STD_LOGIC;
		Addr: IN INTEGER RANGE 0 TO COL_SIZE * ROW_SIZE - 1;
		Data_in: IN INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
		Data_out: OUT INTEGER RANGE 0 TO 2**DATA_WIDTH - 1);
END data_in;

ARCHITECTURE data_in_arch OF data_in IS
	TYPE DATA_ARRAY IS ARRAY(0 TO COL_SIZE * ROW_SIZE - 1) OF INTEGER;
	SIGNAL Matrix_in : DATA_ARRAY := (1, 2, 3, 4,
					5, 6, 7, 8,
					9, 10, 11, 12,
					13, 14, 15, 16);
	BEGIN
		PROCESS(Clk)
		BEGIN
			IF (Clk'Event AND Clk = '1') THEN
				IF (We_in = '1') THEN Matrix_in(Addr) <= Data_in;
				ELSE 
					IF (Re_in = '1') THEN Data_out <= Matrix_in(Addr);
					END IF;
				END IF;
			END IF;
		END PROCESS;
END data_in_arch;
