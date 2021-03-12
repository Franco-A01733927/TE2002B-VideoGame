library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Input Peripheral
entity Inp_Peripheral is port(
CLK : in  std_logic;
RST : in  std_logic;

-- GUMNUT PORTS
-- I/O port bus
PORT_CYC_I  :  in 	std_logic;
PORT_STB_I  :  in 	std_logic;
PORT_WE_I   :  in 	std_logic;
PORT_ACK_O  :  out 	std_logic;
PORT_ADR_I  :  in	  unsigned(7 downto 0);
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
end Inp_Peripheral;

architecture behavioral of Inp_Peripheral is

-- Interface
  component accelerometer_interface is
      Port (

      CLK : in  STD_LOGIC;
      RST : in  STD_LOGIC;

      -- I/O port bus
      PORT_CYC_I : in 	std_logic;
      PORT_STB_I : in 	std_logic;
      PORT_WE_I  : in 	std_logic;
      PORT_ACK_O : out 	std_logic;
      PORT_ADR_I : in	  unsigned(7 downto 0);
      PORT_DAT_I : in 	std_logic_vector(7 downto 0);
      PORT_DAT_O : out 	std_logic_vector(7 downto 0);

      -- Interrupts
      INT_REQ : out std_logic;
      INT_ACK : in  std_logic;

      --SENSOR
      acceleration_x : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis acceleration data
      acceleration_y : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis acceleration data
      acceleration_z : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);  --z-axis acceleration data
      flag           : IN   STD_LOGIC

			);
      end component accelerometer_interface;

-- Accelerometer
      component pmod_accelerometer_adxl345 IS

        GENERIC(
          clk_freq   : INTEGER := 50;              --system clock frequency in MHz
          data_rate  : STD_LOGIC_VECTOR := "0100"; --data rate code to configure the accelerometer
          data_range : STD_LOGIC_VECTOR := "00");  --data range code to configure the accelerometer

        PORT(

          clk            : IN      STD_LOGIC;                      --system clock
          reset_n        : IN      STD_LOGIC;                      --active low asynchronous reset

          miso           : IN      STD_LOGIC;                      --SPI bus: master in, slave out
          sclk           : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
          ss_n           : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);   --SPI bus: slave select
          mosi           : OUT     STD_LOGIC;                      --SPI bus: master out, slave in

          acceleration_x : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis acceleration data
          acceleration_y : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis acceleration data
          acceleration_z : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --z-axis acceleration data
      	  flag           : OUT     STD_LOGIC

      	);

      END component pmod_accelerometer_adxl345;

--  ADXL345 signals
signal acceleration_x1_s, acceleration_x2_s, acceleration_y1_s, acceleration_y2_s, acceleration_z1_s, acceleration_z2_s : std_logic_vector(15 downto 0);
signal flag1_s, flag2_s : std_logic;

begin

interface : accelerometer_interface port map(CLK,RST,PORT_CYC_I,PORT_STB_I,PORT_WE_I,PORT_ACK_O,PORT_ADR_I,PORT_DAT_I,PORT_DAT_O,INT_REQ_O,INT_ACK_I,acceleration_x1_s,acceleration_y1_s,acceleration_z1_s,flag1_s);

sensor : pmod_accelerometer_adxl345 generic map(50, "0100", "00")
                                    port map(CLK, RST, miso, sclk, ss_n, mosi, acceleration_x2_s, acceleration_y2_s, acceleration_z2_s, flag2_s);

end behavioral;
