
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
  signal counter     : unsigned(25 downto 0);
  signal miliseconds : unsigned(10 downto 0);

  signal btnPressPlaying : std_logic;
begin

  identifier: process (clk)
  begin --TODO composer installment
    if rising_edge(clk) then
      if (counter > 2 ** 20) then
        miliseconds <= miliseconds + 1;
      else
        counter <= counter + 1;
      end if;

      if (playBtnPress = '1') then
        btnPressPlaying <= '1';
        miliseconds <= (others => '0');
      end if;

      if (miliseconds > 250) then
        btnPressPlaying <= '0';
      end if;

    end if;

  end process; -- identifier

  tone <= "010" when btnPressPlaying='1' else "000";

end architecture;
