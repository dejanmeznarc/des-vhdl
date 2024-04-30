library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_firuge_drawer is
  port (
    figureID : in  unsigned(2 downto 0);                    -- wha fig to display

    cord_x   : in  unsigned(2 downto 0) := (others => '0'); -- col
    cord_y   : in  unsigned(2 downto 0) := (others => '0'); -- line

    screen   : out screen_t
  );
end entity;

architecture rtl of gpu_firuge_drawer is
  type figure_t is array (0 to 2) of unsigned(0 to 2);
  type figures_t is array (0 to 2) of figure_t;
  constant figs : figures_t := (
    (
      "101",
      "010",
      "101"
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

  signal fig : figure_t;

begin

  -- TODO: just write figure in code bellow, no need for sepparate signal
  fig <= figs(to_integer(figureID));

  draw: process (fig, cord_x, cord_y)
  begin

    screen <= (others => (others => '0'));

    -- shift figure bits to the correct position (overflow is ignored)
    screen(to_integer(cord_y - 1)) <= (("00000" & fig(0)) sll to_integer(cord_x)) srl 1;
    screen(to_integer(cord_y - 0)) <= (("00000" & fig(1)) sll to_integer(cord_x)) srl 1;
    screen(to_integer(cord_y + 1)) <= (("00000" & fig(2)) sll to_integer(cord_x)) srl 1;

  end process; -- identifier

end architecture;
