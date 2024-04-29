library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity matixDriver is
  port (
    clk    : in  std_logic;
    matrix : out unsigned(7 downto 0)
  );
end entity;

architecture rtl of matixDriver is
  signal counter : unsigned(4 downto 0);

  signal lineBCD : unsigned(2 downto 0);
  signal col     : unsigned(4 downto 0);

begin

  cntr: process (clk)
  begin
    if rising_edge(clk) then
        lineBCD <= lineBCD + 1;
    end if;

  end process;

  col <= "10001";

  matrix <= lineBCD & col;

end architecture;
