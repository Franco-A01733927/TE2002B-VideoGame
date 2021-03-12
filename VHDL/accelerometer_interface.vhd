library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity accelerometer_interface is Port (

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
end accelerometer_interface;

architecture behavioral of accelerometer_interface is

-- Se declara las direccione de memoria que se mandaran a GUMNUT
constant  ID_data_x1			: unsigned(7 downto 0) := X"00";
constant  ID_data_x2			: unsigned(7 downto 0) := X"01";

constant  ID_data_y1			: unsigned(7 downto 0) := X"02";
constant  ID_data_y2			: unsigned(7 downto 0) := X"03";

constant  ID_data_z1			: unsigned(7 downto 0) := X"04";
constant  ID_data_z2			: unsigned(7 downto 0) := X"05";

constant  ID_leer_bandera	: unsigned(7 downto 0) := X"12";

-- Se declaran señales para splitear los 16 bits de los datos de cada eje en 8 bits
signal acc_x1, acc_x2, acc_y1, acc_y2, acc_z1, acc_z2 : std_logic_vector(7 downto 0);

-- FFD para guardar la "pos del personaje"
signal accel_x_next, accel_x_pres : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal accel_y_next, accel_y_pres : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal accel_z_next, accel_z_pres : STD_LOGIC_VECTOR(15 DOWNTO 0);

-- FFD para guardar el estado de la bandera
signal ffd_flag_next, ffd_flag_pres : std_logic;

-- Variable temporal
signal temporal : std_logic_vector(7 downto 0);

begin

		-- Si hay interrupción
		INT_REQ <= ffd_flag_pres;
		ffd_flag_next <= '1' when (flag = '1')    else -- aquí se genera la interrupción
		                 '0' when (INT_ACK = '1') else
						          ffd_flag_pres;

		-- Si no hay interrupción, gumnut debe leer la bandera en un ciclo-wait
		-- se guarda bandera en temporal
		temporal <= "0000000" & flag;

    -- Se crean registos para las aceleraciones en cada uno de los ejes
		accel_x_next <= acceleration_x when (flag = '1') else accel_x_pres;
		accel_y_next <= acceleration_x when (flag = '1') else accel_y_pres;
		accel_z_next <= acceleration_x when (flag = '1') else accel_z_pres;

    --Se generan las 2 particiones de los datos de cada eje  para que se pueda trabajar con GUMNUT
    -- Eje X
    acc_x1 <= acceleration_x(15 downto 8);
    acc_x2 <= acceleration_x(7 downto 0);

    -- Eje Y
    acc_y1 <= acceleration_y(15 downto 8);
    acc_y2 <= acceleration_y(7 downto 0);

    --Eje Z
    acc_z1 <= acceleration_z(15 downto 8);
    acc_z2 <= acceleration_z(7 downto 0);

    --Se envian los datos a GUMNUT
		PORT_DAT_O <= 	acc_x1 when (PORT_ADR_I = ID_data_x1 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else
								    acc_x2 when (PORT_ADR_I = ID_data_x2 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else

								    acc_y1 when (PORT_ADR_I = ID_data_x2 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else
								    acc_y2 when (PORT_ADR_I = ID_data_x2 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else

									 acc_z1 when (PORT_ADR_I = ID_data_z1 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else
								    acc_z2 when (PORT_ADR_I = ID_data_z2 and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else

								    temporal 	when (PORT_ADR_I = ID_leer_bandera and PORT_CYC_I = '1' and PORT_STB_I = '1' and PORT_WE_I = '0') else
				                (others => '0');


		PORT_ACK_O <= PORT_CYC_I and PORT_STB_I;


		sequential : process(CLK, RST)
		  begin

			  if(RST = '1') then

          accel_x_pres <= (others => '0');
          ffd_flag_pres <= '0';

				elsif(CLK'event and CLK = '1') then

          accel_x_pres <= accel_x_next;
          ffd_flag_pres <= ffd_flag_next;

				end if;

			end process sequential;

end behavioral;
