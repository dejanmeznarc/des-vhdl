library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.screen_pkg.all;

entity matrix is
  port (
    clk         : in  std_logic;
    matrix_data : out unsigned(7 downto 0);

    screen      : in  screen_t

  );

end entity;

architecture rtl of matrix is
  signal curLine : unsigned(2 downto 0);

  signal reverseCol : unsigned(4 downto 0);
begin

  identifier: process (clk)
  begin
    if (rising_edge(clk)) then
      if (curLine > 7) then
        curLine <= "000";
      else
        curLine <= curLine + 1;
      end if;
    end if;
  end process; -- identifier


  -- reverse bit order TODO: find better way
  reverseCol <= screen(to_integer(curLine))(0) --
    & screen(to_integer(curLine))(1) --
    & screen(to_integer(curLine))(2) --
    & screen(to_integer(curLine))(3) --
    & screen(to_integer(curLine))(4);


  matrix_data <= (curLine+1) & reverseCol;
end architecture;



