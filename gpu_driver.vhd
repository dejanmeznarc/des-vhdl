library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_driver is
  port (
    clk    : in     std_logic;
    screen : buffer screen_t;
    offset : in     unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of gpu_driver is

  signal counter : unsigned(5 downto 0);

  type figure_t is array (0 to 2) of unsigned(0 to 2);
  type figures_t is array (0 to 2) of figure_t;
  constant figs : figures_t := (
    (
      "010",
      "010",
      "010"
    ),
    (
      "110",
      "010",
      "000"
    ),
    (
      "110",
      "110",
      "000"
    )
  );

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

  jani: process (counter)
  begin
    screen <= (others => (others => '0')); -- clear screen
    screen(to_integer(counter + 1))(to_integer(offset + 2) downto to_integer(offset + 0)) <= figs(1)(0);
    screen(to_integer(counter + 2))(to_integer(offset + 2) downto to_integer(offset + 0)) <= figs(1)(1);
    -- screen(to_integer(counter + 3))(2 downto 0) <= figs(1)(2);

  end process; -- jani

end architecture;
