library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity d_latch is
  
  port (
    d   : in  std_logic;
    q   : out std_logic := '1';
    clk : in  std_logic;
    s   : in  std_logic);
end entity d_latch;


architecture behavior of d_latch is
begin  -- architecture behavior

  process (clk, s) is
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      if s = '1' then
        q <= d;
      end if;
    end if;
  end process;

end architecture behavior;
