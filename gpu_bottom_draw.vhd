
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_bottom_draw is
  port (
    clk    : in  std_logic;
    screen : out screen_t
  );
end entity;

architecture rtl of gpu_bottom_draw is

begin

  bla: process (clk)
  begin
    screen <= (others => (others => '0'));
    screen(6) <= "11011";
  end process; -- 

end architecture;
