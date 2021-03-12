-- entidad top-level
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_controller is
    Port (
				CLK :   in  STD_LOGIC;
				RST : in  STD_LOGIC;

				TX	  :  OUT	STD_LOGIC;
				RX	  :  IN	STD_LOGIC
				--SW
				--SWITCHES   : in std_logic_vector(7 downto 0)
				);
end uart_controller;

architecture behavioral of uart_controller is

component uart IS
	GENERIC(
		clk_freq		:	INTEGER		:= 50_000_000;	--frequency of system clock in Hertz
		baud_rate	:	INTEGER		:= 19_200;		--data link baud rate in bits/second
		os_rate		:	INTEGER		:= 16;			--oversampling rate to find center of receive bits (in samples per baud period)
		d_width		:	INTEGER		:= 8; 			--data bus width
		parity		:	INTEGER		:= 1;				--0 for no parity, 1 for parity
		parity_eo	:	STD_LOGIC	:= '0');			--'0' for even, '1' for odd parity
	PORT(
		clk		:	IN		STD_LOGIC;										--system clock
		reset_n	:	IN		STD_LOGIC;										--ascynchronous reset
		tx_ena	:	IN		STD_LOGIC;										--initiate transmission
		tx_data	:	IN		STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
		rx			:	IN		STD_LOGIC;										--receive pin
		rx_busy	:	OUT	STD_LOGIC;										--data reception in progress
		rx_error	:	OUT	STD_LOGIC;										--start, parity, or stop bit error detected
		rx_data	:	OUT	STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);	--data received
		tx_busy	:	OUT	STD_LOGIC;  									--transmission in progress
		tx			:	OUT	STD_LOGIC;
-- I/O port bus
    PORT_CYC_I : in 	std_logic;
    PORT_STB_I : in 	std_logic;
    PORT_WE_I  : in 	std_logic;
    PORT_ACK_O : out 	std_logic;
    PORT_ADR_I : in		std_logic_vector(7 downto 0);
    PORT_DAT_I : in 	std_logic_vector(7 downto 0);
    PORT_DAT_O : out 	std_logic_vector(7 downto 0);
    -- Interrupts
    INT_REQ : out std_logic;
    INT_ACK : in std_logic
		);										--transmit pin
END component uart;


-- Input Peripheral
component Inp_Peripheral is port(
CLK : in  std_logic;
RST : in  std_logic;

-- GUMNUT PORTS
-- I/O port bus
PORT_CYC_I  :  in 	std_logic;
PORT_STB_I  :  in 	std_logic;
PORT_WE_I   :  in 	std_logic;
PORT_ACK_O  :  out 	std_logic;
PORT_ADR_I  :  in	  std_logic_vector(7 downto 0);
PORT_DAT_I  :  in 	std_logic_vector(7 downto 0);
PORT_DAT_O  :  out 	std_logic_vector(7 downto 0);

-- Interrupts
INT_REQ_O   : out std_logic;
INT_ACK_I   : in  std_logic;

-- SPI PORTS
miso    : IN     std_logic;                             --master in, slave out
sclk    : BUFFER std_logic;                             --spi clock
ss_n    : BUFFER std_logic_vector(0 DOWNTO 0);          --slave select
mosi    : OUT    std_logic                              --master out, slave in

);
end component Inp_Peripheral;

component gumnut_with_mem is
  generic ( IMem_file_name : string := "gasm_text.dat";
            DMem_file_name : string := "gasm_data.dat";
            debug : boolean := false );
  port ( clk_i : in std_logic;
         rst_i : in std_logic;
         -- I/O port bus
         port_cyc_o : out std_logic;
         port_stb_o : out std_logic;
         port_we_o : out std_logic;
         port_ack_i : in std_logic;
         port_adr_o : out std_logic_vector(7 downto 0);
         port_dat_o : out std_logic_vector(7 downto 0);
         port_dat_i : in std_logic_vector(7 downto 0);
         -- Interrupts
         int_req : in std_logic;
         int_ack : out std_logic );
end component gumnut_with_mem;

component uart_periferico_out is
    Port (
				CLK :   in  STD_LOGIC;
				RST_n : in  STD_LOGIC;

				-- I/O port bus
				PORT_CYC_I : in 	std_logic;
				PORT_STB_I : in 	std_logic;
				PORT_WE_I  : in 	std_logic;
				PORT_ACK_O : out 	std_logic;
				PORT_ADR_I : in		std_logic_vector(7 downto 0);
				PORT_DAT_I : in 	std_logic_vector(7 downto 0);
				PORT_DAT_O : out 	std_logic_vector(7 downto 0);
				-- Interrupts
				INT_REQ : out std_logic;
				INT_ACK : in std_logic;

				-- tx interface
				TX_ENABLE   : out std_logic;
				TX_BUSY     : in 	std_logic;
				TX_DATA     : out std_logic_vector(7 downto 0);

				-- rx interface
				RX_BUSY    : in 	std_logic;
				RX_ERROR   : in 	std_logic;
				RX_DATA    : in 	std_logic_vector(7 downto 0)

				);
end component uart_periferico_out;

-- end component output_port_leds;
signal tx_enable_s, tx_busy_s, rx_busy_s, rx_error_s : std_logic;
signal tx_data_s, rx_data_s : std_logic_vector(7 downto 0);
signal port_cyc_o_s, port_stb_o_s, port_we_o_s : std_logic;
signal port_ack_i_s,  port_ack_i_s_1, port_ack_i_s_2, port_ack_i_s_3: std_logic;
signal port_adr_o_s : std_logic_vector(7 downto 0);
signal port_dat_o_s, port_dat_i_s : std_logic_vector(7 downto 0);
signal port_dat_i_s_1, port_dat_i_s_2 , port_dat_i_s_3: std_logic_vector(7 downto 0);
signal int_req_s, int_ack_s : std_logic;
signal int_req_s_1, int_req_s_2, int_req_s_3 : std_logic;
signal miso    :  std_logic;                             --master in, slave out
signal sclk    :  std_logic;                             --spi clock
signal ss_n    :  std_logic_vector(0 DOWNTO 0);          --slave select
signal mosi    :  std_logic;                              --master out, slave in


--directions
constant ID_DATA_TRANSMITED : std_logic_vector(7 downto 0) := X"10";
constant ID_READ_TX_BUSY : std_logic_vector(7 downto 0) := X"11";
constant ID_TX_HABILITATED : std_logic_vector(7 downto 0) := X"12";
--constant ID_SWITCHES : std_logic_vector(7 downto 0) := X"06";

constant  ID_data_x1			: std_logic_vector(7 downto 0) := X"00";
constant  ID_data_x2			: std_logic_vector(7 downto 0) := X"01";

constant  ID_data_y1			: std_logic_vector(7 downto 0) := X"02";
constant  ID_data_y2			: std_logic_vector(7 downto 0) := X"03";

constant  ID_data_z1			: std_logic_vector(7 downto 0) := X"04";
constant  ID_data_z2			: std_logic_vector(7 downto 0) := X"05";


begin

		gumnut_with_mem_0 : gumnut_with_mem 		generic map("gasm_text.dat", "gasm_data.dat", false)
																port map(CLK, RST,
																			port_cyc_o_s, port_stb_o_s, port_we_o_s, port_ack_i_s,
																			port_adr_o_s,
																			port_dat_o_s, port_dat_i_s,
																			int_req_s, int_ack_S
																			);

		sw_input: 	Inp_Peripheral	port map(CLK, RST,port_cyc_o_s, port_stb_o_s,port_we_o_s, port_ack_i_s_1,
											port_adr_o_s,port_dat_o_s, port_dat_i_s_1,int_req_s_1, int_ack_S,miso, sclk, ss_n, mosi);

    uart_0 : uart generic map (10_000_000, 9_600, 16, 8, 1, '0')
						     port map (CLK, RST, tx_enable_s, tx_data_s, RX, rx_busy_s, rx_error_s, rx_data_s, tx_busy_s, TX,port_cyc_o_s, port_stb_o_s,
											port_we_o_s, port_ack_i_s_3, port_adr_o_s,port_dat_o_s, port_dat_i_s_3,int_req_s_3, int_ack_S);

		control : uart_periferico_out port map(CLK, RST, port_cyc_o_s, port_stb_o_s, port_we_o_s, port_ack_i_s_2,port_adr_o_s,port_dat_o_s,
													port_dat_i_s_2,int_req_s_2, int_ack_S,tx_enable_s, tx_busy_s, tx_data_s, rx_busy_s, rx_error_s, rx_data_s);



				--acknowledge para Gumnut
		port_ack_i_s <= port_ack_i_s_1 or port_ack_i_s_2 or int_req_s_3;

		--dato de entrada para Gumnut
		port_dat_i_s <= (port_dat_i_s_1) when (port_adr_o_s = ID_data_x1) else
              (port_dat_i_s_1) when (port_adr_o_s = ID_data_x2) else
              (port_dat_i_s_1) when (port_adr_o_s = ID_data_y1) else
              (port_dat_i_s_1) when (port_adr_o_s = ID_data_y2) else
              (port_dat_i_s_1) when (port_adr_o_s = ID_data_z1) else
              (port_dat_i_s_1) when (port_adr_o_s = ID_data_z2) else
							port_dat_i_s_2 when (port_adr_o_s = ID_DATA_TRANSMITED) else
							port_dat_i_s_3 when (port_adr_o_s = ID_TX_HABILITATED) else
              port_dat_i_s_2 when (port_adr_o_s = ID_READ_TX_BUSY) else
							 (others => '0');

		--request de interrupción para Gumnut
		int_req_s <= int_req_s_1 or int_req_s_2 or int_req_s_3;

end behavioral;
