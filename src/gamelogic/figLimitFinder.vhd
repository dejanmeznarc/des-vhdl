
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;
  use work.figures.all;

entity figLimitFinder is
  generic (
    LEFT_COL_INDEX  : natural := 2;
    RIGHT_COL_INDEX : natural := 0
  );
  port (
    figureID   : in  unsigned(2 downto 0);
    limitLeft  : out unsigned(2 downto 0);
    limitRight : out unsigned(2 downto 0)
  );
end entity;

architecture rtl of figLimitFinder is
  signal figure : figure_t;

  type max_t is array (0 to 2) of unsigned(0 to 2);

  signal isRightLimit : std_logic;
  signal isLeftLimit  : std_logic;

begin
  figure <= figuresRom(to_integer(figureID));

  --   "000",
  --   "000",
  --   "000",
  isRightLimit <= figure(0)(RIGHT_COL_INDEX) or figure(1)(RIGHT_COL_INDEX) or figure(2)(RIGHT_COL_INDEX);
  isLeftLimit  <= figure(0)(LEFT_COL_INDEX) or figure(1)(LEFT_COL_INDEX) or figure(2)(LEFT_COL_INDEX);

  limitRight <= "001" when isRightLimit='1' else "000";
  limitLeft  <= "011" when isLeftLimit='1' else "100";

end architecture;
