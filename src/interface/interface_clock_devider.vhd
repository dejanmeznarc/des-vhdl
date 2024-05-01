library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity interface_clock_divider is
  port (
    clk     : in  std_logic;
    counter : out unsigned(31 downto 0) := (others => '0')
  );
end entity;

architecture rtl of interface_clock_divider is
  signal count : unsigned(31 downto 0) := (others => '0');
begin

  interface_clock_divider: process (clk)
  begin
    if rising_edge(clk) then
      count <= count + 1;
    end if;
  end process; -- interface_clock_divider

  counter <= count;

end architecture;
