----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:02:55 05/13/2013 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
    Port ( CK_IN : in  STD_LOGIC;
           CK_OUT : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
constant TIMECONST : integer := 10000000;
signal count : integer range 0 to 100000000;
signal D : std_logic := '0';
begin
process (CK_IN, D)
begin
	if (CK_IN'event and CK_IN = '1') then
		count <= count + 1;
		if count = TIMECONST then
			count <= 0;
			D <= not D;
		end if;
	end if;
	CK_OUT <= D;
end process;

end Behavioral;

