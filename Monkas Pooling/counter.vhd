LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
	GENERIC(stop_value: INTEGER);
	PORT(	Clk, Inc, Clr: IN STD_LOGIC;
		Z: OUT STD_LOGIC;
		Count: OUT INTEGER RANGE 0 TO stop_value);
END counter;

ARCHITECTURE counter_arch OF counter IS
	SIGNAL Count_temp: INTEGER RANGE 0 TO stop_value;
	BEGIN 
		PROCESS	
		BEGIN 
			WAIT UNTIL (Clk'Event AND Clk = '1');
			IF Clr = '1' THEN
				Count_temp <= 0;
				Z <= '0';
			ELSE 
				IF Inc = '1' THEN
					IF Count_temp = Stop_value - 1 THEN
						Z <= '1';
					ELSE 
						Count_temp <= Count_temp + 1;
						Z <= '0';
					END IF;
				END IF;
			END IF;
		END PROCESS;
	Count <= Count_temp;
END counter_arch;
