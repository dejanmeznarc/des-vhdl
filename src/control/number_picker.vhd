
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity number_picker is
  generic (
    LIMIT_TOP   : unsigned := "100";
    LIMIT_BOTOM : unsigned := "000"
  );
  port (
    clk    : in    std_logic;
    up     : in    std_logic;
    down   : in    std_logic;
    number : inout unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of number_picker is

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if (up = '1') then
        if (number >= LIMIT_TOP) then
          number <= LIMIT_TOP;
        else
          number <= number + 1;
        end if;
      end if;

      if (down = '1') then
        if (number <= LIMIT_BOTOM) then
          number <= LIMIT_BOTOM;
        else
          number <= number - 1;
        end if;
      end if;

    end if;
  end process; -- identifier

  number <= number;
end architecture;
