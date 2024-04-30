library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_firuge_drawer is
  port (
    figureID : in  unsigned(2 downto 0); -- wha fig to display

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

  signal figure : figure_t;

  signal janez : unsigned(4 downto 0);
begin

  figure <= figs(to_integer(figureID));

  draw: process (figure, cord_x, cord_y)
  begin

    screen <= (others => (others => '0'));

    -- janez <= (4 downto (to_integer(cord_x) + 1) => '0') & "111" & ((to_integer(cord_x) - 1) downto 0 => '0');

    screen(to_integer(cord_y - 1)) <= (("00000" & figure(0)) sll to_integer(cord_x)) srl 1;
    screen(to_integer(cord_y - 0)) <= (("00000" & figure(1)) sll to_integer(cord_x)) srl 1;
    screen(to_integer(cord_y + 1)) <= (("00000" & figure(2)) sll to_integer(cord_x)) srl 1;


  end process; -- identifier

end architecture;
