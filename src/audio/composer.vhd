
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity composer is

  port (
    clk          : in  std_logic;
    tone         : out unsigned(2 downto 0);

    playBtnPress : in  std_logic
      --playLooser   : in  std_logic

  );
end entity;

architecture rtl of composer is
  signal counter : unsigned(32 downto 0);

begin

  identifier: process (clk)
  begin
    if (rising_edge(clk)) then
      if (counter < 2 ** 27) then
        counter <= counter + 1;
      end if;

      if (playBtnPress = '1') then
        counter <= (others => '0');
      end if;

    end if;
  end process;

  tone <= "100" when (counter < 2 ** 25) else
          "010" when (counter < 2 ** 26) else
          "001" when (counter < 2 ** 27) else
          "000";

end architecture;
