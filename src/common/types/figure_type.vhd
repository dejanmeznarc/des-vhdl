library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package figure_type is
  type figure_t is array (0 to 2) of unsigned(0 to 2);

  type figures_t is array (0 to 7) of figure_t;


end package;
