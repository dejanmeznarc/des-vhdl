library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity line_counter is
  generic (
    INTERVAL  : natural := 2 ** 26;
    MAX_LINES : natural := 6
  );
  port (
    clk  : in    std_logic;
    line : inout unsigned(2 downto 0)
  );
end entity;

architecture rtl of line_counter is
  signal count : unsigned(27 downto 0);
begin

  process (clk)
  begin
    if rising_edge(clk) then

      if (count > INTERVAL) then
        count <= (others => '0');

        if (line >= MAX_LINES) then
          line <= (others => '0');
        else
          line <= line + 1;
        end if;

      else
        count <= count + 1;
      end if;

    end if;
  end process;

end architecture;
