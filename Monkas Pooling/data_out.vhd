LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY data_out IS 
	GENERIC(DATA_WIDTH: INTEGER;
		ROW_SIZE: INTEGER;
		COL_SIZE: INTEGER);
	PORT(	Clk: IN STD_LOGIC;
		We_out:	IN STD_LOGIC;
		Re_out:	IN STD_LOGIC;
		Clean: IN STD_LOGIC;
		Addr: IN INTEGER RANGE 0 TO COL_SIZE * ROW_SIZE - 1;
		Data_in: IN INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
		Data_out: OUT INTEGER RANGE 0 TO 2**DATA_WIDTH - 1;
		Done: BUFFER STD_LOGIC);
END data_out;

ARCHITECTURE data_out_arch OF data_out IS
	TYPE DATA_ARRAY IS ARRAY(0 TO COL_SIZE * ROW_SIZE - 1) OF INTEGER;
	SIGNAL Matrix_out : DATA_ARRAY := (OTHERS => 0);
	SIGNAL Temp: INTEGER RANGE 0 TO 4*(2**DATA_WIDTH - 1); 
	BEGIN
		PROCESS(Clk)
		BEGIN
			IF (Clk'Event AND Clk = '1') THEN
				IF (We_out = '1') THEN Matrix_out(Addr) <= Data_in;
				ELSE 
					IF (Re_out = '1') THEN Data_out <= Matrix_out(Addr);
					END IF;
				END IF;
			END IF;

			IF (Clean = '1' AND Done = '0') THEN
				CLEANUP: FOR i IN 0 TO COL_SIZE * ROW_SIZE - 1 LOOP
						Matrix_out(i) <= Matrix_out(i)/(ROW_SIZE * COL_SIZE);
					 END LOOP;
				Done <= '1';
			ELSE Done <= '0';
			END IF;
		END PROCESS;
END data_out_arch;
