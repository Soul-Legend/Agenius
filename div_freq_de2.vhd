-- Transforma o clock de 50MHz (CLOCK_50) vindo da placa em sinais de 0.5Hz - 6.0Hz.

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY div_freq_de2 IS
PORT(reset: in std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END div_freq_de2;

ARCHITECTURE arc OF div_freq_de2 IS
	SIGNAL c05, c07 , c09, c1, c11, c12, c13, c14, c15, c16, c17, c18, c19, c2, c21, c22, c23, c24, c25, c26, c27, c28, c29, c3, c31, c32, c33, c34, c35, c36, c38, c4, c42, c44, c46, c48, c5, c52, c54, c56, c58, c6: std_logic_vector(27 DOWNTO 0); -- precisamos de 28 bits para representar ateh o valor 100.000.000
BEGIN
	PROCESS(reset,CLOCK, c05, c07 , c09, c1, c11, c12, c13, c14, c15, c16, c17, c18, c19, c2, c21, c22, c23, c24, c25, c26, c27, c28, c29, c3, c31, c32, c33, c34, c35, c36, c38, c4, c42, c44, c46, c48, c5, c52, c54, c56, c58, c6)
	BEGIN
		-- Reset
		IF reset = '1' THEN
			c05 <= x"0000000"; -- notacao para hexadecimal: x"VALOR EM HEXA"
			c07 <= x"0000000";
			c09 <= x"0000000";
			c1 <= x"0000000";
			c11 <= x"0000000";
			c12 <= x"0000000";
			c13 <= x"0000000";
			c14 <= x"0000000";
			c15 <= x"0000000";
			c16 <= x"0000000";
			c17 <= x"0000000";
			c18 <= x"0000000";
			c19 <= x"0000000";
			c2 <= x"0000000";
			c21 <= x"0000000";
			c22 <= x"0000000";
			c23 <= x"0000000";
			c24 <= x"0000000";
			c25 <= x"0000000";
			c26 <= x"0000000";
			c27 <= x"0000000";
			c28 <= x"0000000";
			c29 <= x"0000000";
			c3 <= x"0000000";
			c31 <= x"0000000";
			c32 <= x"0000000";
			c33 <= x"0000000";
			c34 <= x"0000000";
			c35 <= x"0000000";
			c36 <= x"0000000";
			c38 <= x"0000000";
			c4 <= x"0000000";
			c42 <= x"0000000";
			c44 <= x"0000000";
			c46 <= x"0000000";
			c48 <= x"0000000";
			c5 <= x"0000000";
			c52 <= x"0000000";
			c54 <= x"0000000";
			c56 <= x"0000000";
			c58 <= x"0000000";
			c6 <= x"0000000"; 			

		ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
		-- Incrementa todos os contadores
			c05 <= c05 + 1;
			c07 <= c07 + 1;
			c09 <= c09 + 1;
			c1 <= c1 + 1;
			c11 <= c11 + 1;
			c12 <= c12 + 1;
			c13 <= c13 + 1;
			c14 <= c14 + 1;
			c15 <= c15 + 1;
			c16 <= c16 + 1;
			c17 <= c17 + 1;
			c18 <= c18 + 1;
			c19 <= c19 + 1;
			c2 <= c2 + 1;
			c21 <= c21 + 1;
			c22 <= c22 + 1;
			c23 <= c23 + 1;
			c24 <= c24 + 1;
			c25 <= c25 + 1;
			c26 <= c26 + 1;
			c27 <= c27 + 1;
			c28 <= c28 + 1;
			c29 <= c29 + 1;
			c3 <= c3 + 1;
			c31 <= c31 + 1;
			c32 <= c32 + 1;
			c33 <= c33 + 1;
			c34 <= c34 + 1;
			c35 <= c35 + 1;
			c36 <= c36 + 1;
			c38 <= c38 + 1;
			c4 <= c4 + 1;
			c42 <= c42 + 1;
			c44 <= c44 + 1;
			c46 <= c46 + 1;
			c48 <= c48 + 1;
			c5 <= c5 + 1;
			c52 <= c52 + 1;
			c54 <= c54 + 1;
			c56 <= c56 + 1;
			c58 <= c58 + 1;
			c6 <= c6 + 1;
		
		-- Quando o signal do contador de 0.5Hz (c05) chega a 99 999 999 ({[freq do clock]/[freq desejada] - 1}), zera o contador e ativa a saida C05Hz

			IF c05 = x"5F5E0FF" THEN --5F5E0FF eh 99.999.999 em hexadecimal
				C05Hz <= '1'; -- da um pulso para o clock de 0.5Hz (isto ocorrerá a cada 2s)
				c05 <= x"0000000"; -- Ao completar as 99.999.999 voltas, zera o signal do contador
			ELSE 
				c05Hz <= '0'; --	enquanto nao chegar a 99.999.999, mantem C05Hz em 0
			END IF;

		-- 0.7Hz
			IF c07 = x"441E9DA" THEN
				C07Hz <= '1';
				c07 <= x"0000000";
			ELSE 
				c07Hz <= '0';
			END IF;

		-- 0.9Hz
			IF c09 = x"34FB5E3" THEN
				C09Hz <= '1';
				c09 <= x"0000000";
			ELSE 
				c09Hz <= '0';
			END IF;
		
		-- 1Hz
			IF c1 = x"2faf07f" THEN
				C1Hz <= '1';
				c1 <= x"0000000";
			ELSE
				C1Hz <= '0';
			END IF;
		
		-- 1.1Hz
			IF c11 = x"2B594D0" THEN
				C11Hz <= '1';
				c11 <= x"0000000";
			ELSE
				C11Hz <= '0';
			END IF;
		
		-- 1.2Hz
			IF c12 = x"27BC86A" THEN
				C12Hz <= '1';
				c12 <= x"0000000";
			ELSE
				C12Hz <= '0';
			END IF;
		
		-- 1.3Hz
			IF c13 = x"24AE061" THEN
				C13Hz <= '1';
				c13 <= x"0000000";
			ELSE
				C13Hz <= '0';
			END IF;
		
		-- 1.4Hz
			IF c14 = x"220F4ED" THEN
				C14Hz <= '1';
				c14 <= x"0000000";
			ELSE
				C14Hz <= '0';
			END IF;
		
		-- 1.5Hz
			IF c15 = x"1FCA054" THEN
				C15Hz <= '1';
				c15 <= x"0000000";
			ELSE
				C15Hz <= '0';
			END IF;
		
		-- 1.6Hz
			IF c16 = x"1DCD64F" THEN
				C16Hz <= '1';
				c16 <= x"0000000";
			ELSE
				C16Hz <= '0';
			END IF;
		
		-- 1.7Hz
			IF c17 = x"1C0C9B4" THEN
				C17Hz <= '1';
				c17 <= x"0000000";
			ELSE
				C17Hz <= '0';
			END IF;
		
		-- 1.8Hz
			IF c18 = x"1A7DAF1" THEN
				C18Hz <= '1';
				c18 <= x"0000000";
			ELSE
				C18Hz <= '0';
			END IF;
		
		-- 1.9Hz
			IF c19 = x"1918C0C" THEN
				C19Hz <= '1';
				c19 <= x"0000000";
			ELSE
				C19Hz <= '0';
			END IF;
			
		-- 2Hz
		
			IF c2 = x"17d783f" THEN
				C2Hz <= '1';
				c2 <= x"0000000";
			ELSE 
				C2Hz <= '0';
			END IF;
			
		-- 2.1Hz
		
			IF c21 = x"16B4DF3" THEN
				C21Hz <= '1';
				c21 <= x"0000000";
			ELSE 
				C21Hz <= '0';
			END IF;
			
		-- 2.2Hz
		
			IF c22 = x"15ACA68" THEN
				C22Hz <= '1';
				c22 <= x"0000000";
			ELSE 
				C22Hz <= '0';
			END IF;
			
		-- 2.3Hz
		
			IF c23 = x"14BB679" THEN
				C23Hz <= '1';
				c23 <= x"0000000";
			ELSE 
				C23Hz <= '0';
			END IF;
			
		-- 2.4Hz
		
			IF c24 = x"13DE434" THEN
				C24Hz <= '1';
				c24 <= x"0000000";
			ELSE 
				C24Hz <= '0';
			END IF;
			
		-- 2.5Hz
		
			IF c25 = x"1312CFF" THEN
				C25Hz <= '1';
				c25 <= x"0000000";
			ELSE 
				C25Hz <= '0';
			END IF;
			
		-- 2.6Hz
		
			IF c26 = x"1257030" THEN
				C26Hz <= '1';
				c26 <= x"0000000";
			ELSE 
				C26Hz <= '0';
			END IF;
			
		-- 2.7Hz
		
			IF c27 = x"11A91F6" THEN
				C27Hz <= '1';
				c27 <= x"0000000";
			ELSE 
				C27Hz <= '0';
			END IF;
			
		-- 2.8Hz
		
			IF c28 = x"1107A76" THEN
				C28Hz <= '1';
				c28 <= x"0000000";
			ELSE 
				C28Hz <= '0';
			END IF;
			
		-- 2.9Hz
		
			IF c29 = x"1071522" THEN
				C29Hz <= '1';
				c29 <= x"0000000";
			ELSE 
				C29Hz <= '0';
			END IF;

		-- 3Hz
			IF c3 = x"0FE502A" THEN
				C3Hz <= '1';
				c3 <= x"0000000";
			ELSE
				C3Hz <= '0';
			END IF;

		-- 3.1Hz
			IF c31 = x"0F61C07" THEN
				C31Hz <= '1';
				c31 <= x"0000000";
			ELSE
				C31Hz <= '0';
			END IF;

		-- 3.2Hz
			IF c32 = x"0EE6B27" THEN
				C32Hz <= '1';
				c32 <= x"0000000";
			ELSE
				C32Hz <= '0';
			END IF;

		-- 3.3Hz
			IF c33 = x"0E7319A" THEN
				C33Hz <= '1';
				c33 <= x"0000000";
			ELSE
				C33Hz <= '0';
			END IF;

		-- 3.4Hz
			IF c34 = x"0E064D9" THEN
				C34Hz <= '1';
				c34 <= x"0000000";
			ELSE
				C34Hz <= '0';
			END IF;

		-- 3.5Hz
			IF c35 = x"0D9FB91" THEN
				C35Hz <= '1';
				c35 <= x"0000000";
			ELSE
				C35Hz <= '0';
			END IF;

		-- 3.6Hz
			IF c36 = x"0D3ED78" THEN
				C36Hz <= '1';
				c36 <= x"0000000";
			ELSE
				C36Hz <= '0';
			END IF;

		-- 3.8Hz
			IF c38 = x"0C8C606" THEN
				C38Hz <= '1';
				c38 <= x"0000000";
			ELSE
				C38Hz <= '0';
			END IF;

		-- 4.0Hz
			IF c4 = x"0BEBC1F" THEN
				C4Hz <= '1';
				c4 <= x"0000000";
			ELSE
				C4Hz <= '0';
			END IF;

		-- 4.2Hz
			IF c42 = x"0B5A6F9" THEN
				C42Hz <= '1';
				c42 <= x"0000000";
			ELSE
				C42Hz <= '0';
			END IF;

		-- 4.4Hz
			IF c44 = x"0AD6533" THEN
				C44Hz <= '1';
				c44 <= x"0000000";
			ELSE
				C44Hz <= '0';
			END IF;

		-- 4.6Hz
			IF c46 = x"0A5DB3C" THEN
				C46Hz <= '1';
				c46 <= x"0000000";
			ELSE
				C46Hz <= '0';
			END IF;

		-- 4.8Hz
			IF c48 = x"09EF21A" THEN
				C48Hz <= '1';
				c48 <= x"0000000";
			ELSE
				C48Hz <= '0';
			END IF;

		-- 5.0Hz
			IF c5 = x"098967F" THEN
				C5Hz <= '1';
				c5 <= x"0000000";
			ELSE
				C5Hz <= '0';
			END IF;

		-- 5.2Hz
			IF c52 = x"092B818" THEN
				C52Hz <= '1';
				c52 <= x"0000000";
			ELSE
				C52Hz <= '0';
			END IF;

		-- 5.4Hz
			IF c54 = x"08D48FA" THEN
				C54Hz <= '1';
				c54 <= x"0000000";
			ELSE
				C54Hz <= '0';
			END IF;

		-- 5.6Hz
			IF c56 = x"0883D3A" THEN
				C56Hz <= '1';
				c56 <= x"0000000";
			ELSE
				C56Hz <= '0';
			END IF;

		-- 5.8Hz
			IF c58 = x"0838A91" THEN
				C58Hz <= '1';
				c58 <= x"0000000";
			ELSE
				C58Hz <= '0';
			END IF;

		-- 6.0Hz
			IF c6 = x"07F2814" THEN
				C6Hz <= '1';
				c6 <= x"0000000";
			ELSE
				C6Hz <= '0';
			END IF;
			
		END IF;
	END PROCESS;
END arc;