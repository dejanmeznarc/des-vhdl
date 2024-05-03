
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity btn_click_detector is
  port (
    clk    : in  std_logic;
    button : in  std_logic;
    click  : out std_logic
  );
end entity;

architecture rtl of btn_click_detector is
  signal prevState : std_logic;
begin

  process (clk)
  begin
    if rising_edge(clk) then
      prevState <= button;
      click <= (not prevState) and button;
    end if;
  end process;

end architecture;

