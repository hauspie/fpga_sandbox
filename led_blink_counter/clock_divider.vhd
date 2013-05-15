library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity clock_divider is
    Port ( CK_IN : in  STD_LOGIC;
           LED   : out STD_LOGIC_VECTOR(7 downto 0));
end clock_divider;

architecture Behavioral of clock_divider is
begin
    process (CK_IN)
        -- This signal stores the state of LEDs
        variable count : unsigned(7 downto 0) := X"00";
        -- This counter create a delay between each incrementation of the LEDs counter
        variable global_count : integer := 0;
    begin
        if (CK_IN'event and CK_IN = '1') then
            if (global_count = 50000000) then
                global_count := 0;
                count := count + 1;
            else
                global_count := global_count + 1;
            end if;
        end if;
        -- Convert an integer to a bit field
        LED <= std_logic_vector(count);
    end process;
end Behavioral;

