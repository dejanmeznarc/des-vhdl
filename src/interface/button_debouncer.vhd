library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity button_debouncer is
  port (
    clk     : in  std_logic;
    btn_in  : in  std_logic;
    button  : out std_logic
  );
end entity;

architecture rtl of button_debouncer is
  signal history : unsigned(7 downto 0) := (others => '0');

  signal dummyButton : std_logic := '0';

begin

  btn_shift_reg: process (clk)
  begin
    if rising_edge(clk) then
      history <= history(6 downto 0) & btn_in; -- create history
    end if;
  end process; -- btn_shift_reg

  dummyButton <= '1' when history(7 downto 0) = "11111111" else '0';
  button      <= dummyButton;
  --pin_led(0)  <= dummyButton;
end architecture;
