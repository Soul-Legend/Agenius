LIBRARY IEEE;
USE IEEE.std_logic_1164.all; 
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Datapath IS
PORT(
	-- Entradas de dados
	CLOCK: IN std_logic;
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SWITCH: IN std_logic_vector(7 DOWNTO 0);

	-- Entradas de controle
	R1, R2, E1, E2, E3, E4: IN std_logic;
	SEL: IN std_logic;

	-- Saídas de dados
	hex0, hex1, hex2, hex3, hex4, hex5: OUT std_logic_vector(6 DOWNTO 0);
	leds: OUT std_logic_vector(3 DOWNTO 0);
	ledg: out std_logic_vector(3 downto 0);
	
	-- Saídas de status
	end_FPGA, end_User, end_time, win, match: OUT std_logic
);
END ENTITY;

ARCHITECTURE arc OF Datapath IS
---------------------------SIGNALS-----------------------------------------------------------

--ButtonSync-----------------------------------------------------------
	SIGNAL BTN0: std_logic;
	SIGNAL BTN1: std_logic;
	SIGNAL BTN2: std_logic;
	SIGNAL BTN3: std_logic;
	SIGNAL NBTN, NOTKEYS: std_logic_vector(3 DOWNTO 0);

--Operações booleanas--------------------------------------------------
	SIGNAL E_Counter_User: std_logic;
	SIGNAL data_REG_FPGA: std_logic_vector(63 DOWNTO 0);
	SIGNAL data_REG_User: std_logic_vector(63 DOWNTO 0);
	SIGNAL c1aux, c2aux: std_logic;

--REG_Setup-------------------------------------------------------------
	SIGNAL SETUP: std_logic_vector(7 downto 0);

--div_freq--------------------------------------------------------------
	SIGNAL C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: std_logic;
	SIGNAL C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: std_logic;
	SIGNAL C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: std_logic;
	SIGNAL C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: std_logic;

--Counter_Round--------------------------------------------------------
	SIGNAL win_internal: std_logic;
	SIGNAL sig_round: std_logic_vector(3 DOWNTO 0);

--Counter_time---------------------------------------------------------
	SIGNAL TEMPO: std_logic_vector(3 DOWNTO 0);

--Counter_FPGA---------------------------------------------------------
	SIGNAL SEQFPGA: std_logic_vector(3 DOWNTO 0);

--ROM------------------------------------------------------------------
	SIGNAL SEQ_FPGA: std_logic_vector(3 DOWNTO 0);

--Counter_User---------------------------------------------------------
	SIGNAL end_User_internal: std_logic;

--REG_FPGA-------------------------------------------------------------
	SIGNAL OUT_FPGA: std_logic_vector(63 DOWNTO 0);

--REG_User-------------------------------------------------------------
	SIGNAL OUT_User: std_logic_vector(63 DOWNTO 0);	

--COMP-----------------------------------------------------------------
	SIGNAL is_equal: std_logic;

--LOGICA---------------------------------------------------------------
	SIGNAL POINTS: std_logic_vector(7 DOWNTO 0);

--DECODIFICADORES------------------------------------------------------
--Externos-------------------------------------------------------------
	SIGNAL G_dec7segHEX4: std_logic_vector(3 DOWNTO 0);

--DecBCD---------------------------------------------------------------
	SIGNAL POINTS_BCD: std_logic_vector(7 DOWNTO 0);

--dec7segHEX4----------------------------------------------------------
	SIGNAL dec7segHEX4: std_logic_vector(6 DOWNTO 0);

--dec7segHEX2----------------------------------------------------------
	SIGNAL dec7segHEX2: std_logic_vector(6 DOWNTO 0);

--dec7segHEX1----------------------------------------------------------
	SIGNAL dec7segHEX1: std_logic_vector(6 DOWNTO 0);

--dec7segHEX00---------------------------------------------------------
	SIGNAL dec7segHEX00: std_logic_vector(6 DOWNTO 0);

--dec7segHEX01---------------------------------------------------------
	SIGNAL dec7segHEX01: std_logic_vector(6 DOWNTO 0);
	
--MULTIPLEXADORES----------------------------------------------------------------------------

--Mux0HEX5-------------------------------------------------------------
	SIGNAL output_Mux0HEX5: std_logic_vector(6 DOWNTO 0);

--Mux16_1--------------------------------------------------------------
	SIGNAL saida0mux16_1, saida1mux16_1, saida2mux16_1, saida3mux16_1: std_logic;
	
--Mux0HEX2-------------------------------------------------------------
	SIGNAL output_Mux0HEX2: std_logic_vector(6 DOWNTO 0);
	
--Mux0HEX3-------------------------------------------------------------
	SIGNAL output_Mux0HEX3: std_logic_vector(6 DOWNTO 0);

--Mux0HEX4-------------------------------------------------------------
	SIGNAL output_Mux0HEX4: std_logic_vector(6 DOWNTO 0);

--Mux4:1_4bits---------------------------------------------------------
	SIGNAL MUX4X1_4bits00: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits01: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits10: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits11: std_logic_vector(3 DOWNTO 0);

--MUXdiv_freq_de2-------------------------------------------------------
	SIGNAL CLKHZ: std_logic;	
	
---------------------------COMPONENTS-----------------------------------------------------------

--------------------------Multiplexadores----------------------------------
component Mux2_1 is
port (
    A, B: in std_logic_vector(6 downto 0);
    sel: in std_logic;
    output: out std_logic_vector(6 downto 0)
);
end component;

component Mux4_1 is
port (
    W, X, Y, Z: in std_logic;
    sel: in std_logic_vector(1 downto 0);
    output: out std_logic
);
end component;

component Mux4_1_4 is
port (
    W, X, Y, Z: in std_logic_vector(3 downto 0);
    sel: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end component;

component Mux16_1 is
port (
    E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15: std_logic;
    sel: in std_logic_vector(3 downto 0);
    output: out std_logic
);
end component;


---------------------------dec7seg----------------------------------------
COMPONENT dec7seg IS
PORT(G: IN std_logic_vector(3 DOWNTO 0);
	O: OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;


---------------------------Registradores gerais---------------------------
component Register8 is port (
    clock, reset, enable: in std_logic;
    D: in std_logic_vector(7 downto 0);
    Q: out std_logic_vector(7 downto 0)
);
end component;

component Register64 is port (
    clock, reset, enable: in std_logic;
    D: in std_logic_vector(63 downto 0);
    Q: out std_logic_vector(63 downto 0)
);
end component;


--------------------------------Sequências--------------------------------
component Seq00 is
port (
    address: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end component;

component Seq01 is
port (
    address: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end component;

component Seq02 is
port (
    address: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end component;

component Seq03 is
port (
    address: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(3 downto 0)
);
end component;

-------CONTADOR GERAL-----
component Counter is
port (
    data: in std_logic_vector(3 downto 0);
    clock, reset, enable: in std_logic;
    tc: out std_logic;
    contagem: out std_logic_vector(3 downto 0)
);
end component;


----------------------div_freq_de2----------------------------------------
COMPONENT div_freq_de2 IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
----------------------div_freq_emu----------------------------------------
COMPONENT div_freq_emu IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
---------------------------LOGICA-----------------------------------------
component Logic is
port (
    setup_level, setup_seq: in std_logic_vector(1 downto 0);
    rodada: in std_logic_vector(3 downto 0);
    points: out std_logic_vector(7 downto 0)
);
end component;
----------------------------COMP------------------------------------------
component Comp is
port (
    out_fpga, out_user: in std_logic_vector(63 downto 0);
    eq: out std_logic
);
end component;
----------------------------buttonSync------------------------------------
component ButtonSync is
port (
	KEY0, KEY1, KEY2, KEY3, CLK: in std_logic;
	BTN0, BTN1, BTN2, BTN3: out std_logic
);
end component;

BEGIN	

-------------------------FREQUÊNCIAS--------------------------------------

	--freq_de2: div_freq_de2 PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);

	freq_emu: div_freq_emu PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);

------------------------------------------------------------------------------------------------------


    c1aux <= E2 and C1Hz;
    c2aux <= E3 and CLKHz;

    end_user <= end_user_internal;
    win <= win_internal;

	logica: Logic PORT MAP (
	    setup_level => Setup(7 downto 6),
		setup_seq => Setup(5 downto 4),
		rodada => sig_round,
		points => POINTS
	);

    cmp: Comp PORT MAP (
        out_FPGA,
        out_User,
        eq => is_equal
    );

    match <= end_user_internal and is_equal;


--------- Botão -------
    btn_sync: buttonSync PORT MAP (
        key(0), 
        key(1), 
        key(2), 
        key(3),
        clock,
        BTN0, BTN1, BTN2, BTN3
    );
    
    NBTN <= NOT (BTN3 & BTN2 & BTN1 & BTN0);
    E_Counter_User <= (NBTN(3) or NBTN(2) or NBTN(1) or NBTN(0)) and E2;


---------  Contadores ----------
    Counter_time: Counter port map (
        data => "1010",
        clock => clock,
        reset => R2,
        enable => c1aux,
        tc => end_time,
        contagem => TEMPO
    );

    Counter_round: Counter port map (
        data => setup(3 downto 0),
        clock => clock,
        reset => R1,
        enable => E4,
        tc => win_internal,
        contagem => sig_round
    );

    Counter_fpga: Counter port map (
        data => sig_round,
        clock => clock,
        reset => R2,
        enable => c2aux,
        tc => end_fpga,
        contagem => SEQFPGA
    );

    Counter_user: Counter port map (
        data => sig_round,
        clock => clock,
        reset => R2,
        enable => E_Counter_User,
        tc => end_user_internal
        --contagem => SEQUSER
    );


--------------Sequenciador----------------
    sequencia0: Seq00 port map (
        address => SEQFPGA,
        output => MUX4X1_4bits00
    );

    sequencia1: Seq01 port map (
        address => SEQFPGA,
        output => MUX4X1_4bits01
    );

    sequencia2: Seq02 port map (
        address => SEQFPGA,
        output => MUX4X1_4bits10
    );
    sequencia3: Seq03 port map (
        address => SEQFPGA,
        output => MUX4X1_4bits11
    );
    
    muxseq: Mux4_1_4 port map (
        MUX4X1_4bits00, MUX4X1_4bits01, MUX4X1_4bits10, MUX4X1_4bits11,
        Setup(5 downto 4),
        SEQ_FPGA
    );


----------- Registradores ---------------
    Reg_setup: Register8 port map (
        clock,
        reset => R1,
        enable => E1,
        D => SWITCH,
        Q => Setup
    );

    data_REG_FPGA <= seq_fpga & out_fpga(63 downto 4);
    Reg_fpga: Register64 port map (
        clock,
        reset => R2,
        enable => c2aux,
        D => data_REG_FPGA,
        Q => out_fpga
    );

    data_REG_User <= NBTN & out_user(63 downto 4);
    Reg_user: Register64 port map (
        clock,
        reset => R2,
        enable => E_Counter_User,
        D => data_REG_User,
        Q => out_user
    );

------------Multiplexadores ClkHz-----------
    clkmux0: Mux16_1 port map (
        C05Hz, C07Hz, C09Hz, C11Hz, C13Hz, C15Hz, C17Hz, C19Hz,
        C21Hz, C23Hz, C25Hz, C27Hz, C29Hz, C31Hz, C33Hz, C35Hz,
        sig_round,
        saida0mux16_1
    );

    clkmux1: Mux16_1 port map (
        C1Hz, C12Hz, C14Hz, C16Hz, C18Hz, C2Hz, C22Hz, C24Hz,
        C26Hz, C28Hz, C3Hz, C32Hz, C34Hz, C36Hz, C38Hz, C4Hz,
        sig_round,
        saida1mux16_1
    );

    clkmux2: Mux16_1 port map (
        C2Hz, C22Hz, C24Hz, C26Hz, C28Hz, C3Hz, C32Hz, C34Hz,
        C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz,
        sig_round,
        saida2mux16_1
    );

    clkmux3: Mux16_1 port map (
        C3Hz, C32Hz, C34Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz,
        C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz,
        sig_round,
        saida3mux16_1
    );
    
    clkmux: Mux4_1 port map (
        saida0mux16_1, saida1mux16_1, saida2mux16_1, saida3mux16_1,
        Setup(7 downto 6),
        ClkHz
    );


---------HEX--------
    muxhex51: Mux2_1 port map (
        -- F
        "0001110",
        -- U
        "1000001",
        win_internal,
        output_Mux0HEX5
    );
    muxhex5: Mux2_1 port map (
        -- L
        "1000111",
        output_Mux0HEX5,
        Sel,
        hex5
    );

    G_dec7segHEX4 <= "00" & Setup(7 downto 6);
    dechex4: dec7seg port map (
        G_dec7segHEX4,
        dec7segHEX4
    );
    muxhex41: Mux2_1 port map (
        -- P
        "0001100",
        -- S
        "0010010",
        win_internal,
        output_Mux0HEX4
    );
    muxhex4: Mux2_1 port map (
        dec7segHEX4,
        output_Mux0HEX4,
        Sel,
        hex4
    );

    muxhex31: Mux2_1 port map (
        -- g
        "0010000",
        -- E
        "0000110",
        win_internal,
        output_Mux0HEX3
    );
    muxhex3: Mux2_1 port map (
        -- t
        "0000111",
        output_Mux0HEX3,
        Sel,
        hex3
    );

    dechex2: dec7seg port map (
        TEMPO,
        dec7segHEX2
    );
    muxhex21: Mux2_1 port map (
        -- A
        "0001000",
        -- r
        "0101111",
        win_internal,
        output_Mux0HEX2
    );
    muxhex2: Mux2_1 port map (
        dec7segHEX2,
        output_Mux0HEX2,
        Sel,
        hex2
    );

    dechex1: dec7seg port map (
        Points(7 downto 4),
        dec7segHEX1
    );
    muxhex1: Mux2_1 port map (
        -- r
        "0101111",
        dec7segHEX1,
        Sel,
        hex1
    );

    dechex00: dec7seg port map (
        sig_round,
        dec7segHEX00
    );
    dechex01: dec7seg port map (
        Points(3 downto 0),
        dec7segHEX01
    );
    muxhex0: Mux2_1 port map (
        dec7segHEX00,
        dec7segHEX01,
        Sel,
        hex0
    );

    leds(3 downto 0) <= OUT_FPGA(63 downto 60);
    ledg(3 downto 0) <= NOT KEY(3 downto 0);


end arc;