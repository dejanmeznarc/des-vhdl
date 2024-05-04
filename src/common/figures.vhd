library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;

package figures is

  constant figuresRom : figures_t := (
    (-- 0
      "101",
      "010",
      "101"
    ),
    (-- 1
      "110",
      "010",
      "000"
    ),
    (--- 2 --DOT
      "000",
      "010",
      "000"
    ),
    (--- 3
      "110",
      "010",
      "010"
    ),
    (--- 4
      "100",
      "010",
      "001"
    ),
    (--- 5
      "000",
      "010",
      "010"
    ),
    (--- 6
      "000",
      "011",
      "000"
    ),
    (--- 7
      "101",
      "010",
      "000"
    )
  );

end package;
