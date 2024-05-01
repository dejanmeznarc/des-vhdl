library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity buttons is
  port (
    clk     : in  std_logic;
    btn_in  : in  unsigned(3 downto 0) := (others => '0');
    buttons : out unsigned(3 downto 0) := (others => '0')
  );
end entity;

architecture rtl of buttons is
begin

  allBtns: for i in 0 to 3 generate
    name: entity work.button_debouncer
      port map (
        clk    => clk,
        btn_in => btn_in(i),
        button => buttons(i)
      );
  end generate;
end architecture; -- arch
