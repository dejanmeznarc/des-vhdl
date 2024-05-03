library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package screen_pkg is
  type screen_t is array (0 to 6) of unsigned(4 downto 0);
end package;
