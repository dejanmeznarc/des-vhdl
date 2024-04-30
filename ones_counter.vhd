library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.all;

entity ones_counter is
  port (A    : in  unsigned(4 downto 0);
        ones : out unsigned(2 downto 0));
end entity;

architecture Behavioral of ones_counter is

begin

  process (A)
    variable count : unsigned(2 downto 0) := "000";
  begin
    count := "000"; --initialize count variable.
    for i in 0 to 4 loop --check for all the bits.
      if (A(i) = '1') then --check if the bit is '1'
        count := count + 1; --if its one, increment the count.
      end if;
    end loop;
    ones <= count; --assign the count to output.
  end process;

end architecture;
--src: https://vhdlguru.blogspot.com/2017/10/count-number-of-1s-in-binary-number.html
