-- 4-bit adder
-- Structural description of a 4-bit adder. This device
-- adds two 4-bit numbers together using four 1-bit full adders
-- described above.

-- This is just to make a reference to some common things needed.
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This describes the black-box view of the component we are
-- designing. The inputs and outputs are again described
-- inside port(). It takes two 4-bit values as input (x and y)
-- and produces a 4-bit output (ANS) and a carry out bit (Cout).

entity fourbit_adder is
	port( a, b		: in	STD_LOGIC_VECTOR(3 downto 0);
	      z			: out	STD_LOGIC_VECTOR(3 downto 0);
	      cout		: out	STD_LOGIC		);
end fourbit_adder;

-- Although we have already described the inputs and outputs,
-- we must now describe the functionality of the adder (ie:
-- how we produced the desired outputs from the given inputs).

architecture MY_STRUCTURE of fourbit_adder is

-- We are going to need four 1-bit adders, so include the
-- design that we have already studied in full_adder.vhd.

component FULL_ADDER
	port( x, y, cin	: in  STD_LOGIC;
	      sum, cout	: out STD_LOGIC );
end component;

-- Now create the signals which are going to be necessary
-- to pass the outputs of one adder to the inputs of the next
-- in the sequence.
signal c0, c1, c2, c3 : STD_LOGIC;
begin

c0 <= '0';
b_adder0: FULL_ADDER port map (a(0), b(0), c0, z(0), c1);
b_adder1: FULL_ADDER port map (a(1), b(1), c1, z(1), c2);
b_adder2: FULL_ADDER port map (a(2), b(2), c2, z(2), c3);
b_adder3: FULL_ADDER port map (a(3), b(3), c3, z(3), cout);

END MY_STRUCTURE;
