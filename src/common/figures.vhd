library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;

package figures is

  constant figuresRom : figures_t := (
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
      "000",
      "000",
      "010"
    ),
    (
      "110",
      "010",
      "010"
    )
  );

end package;
