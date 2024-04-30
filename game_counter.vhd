
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity game_counter is
  port (
    clk   : in    std_logic;
    reset : in    std_logic;
    cnt   : inout unsigned(2 downto 0)
  );
end entity;

architecture rtl of game_counter is

begin

  counter: process (clk, reset)
  begin
    if rising_edge(clk) then
      if cnt > 7 then
        cnt <= (others => '0');
      else
        cnt <= cnt + 1;
      end if;
    end if;

    -- check reset
    if (reset = '1') then
      cnt <= (others => '0');
    end if;
  end process; -- counter

end architecture;
