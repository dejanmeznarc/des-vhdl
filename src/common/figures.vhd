library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;

package figures is

  constant figuresRom : figures_t := (
    ( -- 0
      "101", 
      "010",
      "101"
    ),
    ( -- 1
      "110",
      "010",
      "000"
    ),
    ( --- 2
      "000",
      "010",
      "000"
    ),
    ( --- 3
      "110",
      "010",
      "010"
    )
  );

end package;
