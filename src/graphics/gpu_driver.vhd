library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_driver is
  port (
    clk      : in     std_logic;
    screen   : buffer screen_t;
    offset_x : in     unsigned(2 downto 0) := (others => '0');
    offset_y : in     unsigned(2 downto 0) := (others => '0');
    figure   : in     unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of gpu_driver is

  signal counter : unsigned(5 downto 0);

  --signal figure : unsigned(2 downto 0) := (others => '0');

begin

  identifier: process (clk)
  begin
    if rising_edge(clk) then
      if (counter > 7) then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process; -- identifier

  gpu_firuge_drawer_inst: entity work.gpu_firuge_drawer
    port map (
      figureID => figure,
      cord_x   => offset_x,
      cord_y   => offset_y,
      screen   => screen
    );

end architecture;
