library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package figure_type is

  subtype fig_line_t is unsigned(0 to 2);

  type bigfig_t is array (natural range <>) of fig_line_t;

  subtype figure_t is bigfig_t(0 to 2);

  type figures_t is array (0 to 7) of figure_t;

end package;
