library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity clocks is
  port (
    clkin : in std_logic;
    clk10hz: out std_logic;
    clk1hz: out std_logic

  );

end entity;

architecture RTL of clocks is

  signal counter : unsigned(26 downto 0);

begin

  clock_devider: process (clkin)
  begin

    if rising_edge(clkin) then
      counter <= counter + 1;
    end if;

  end process; -- clock_devider


  clk10hz <= counter(22);
  clk1hz <= counter(25);

end architecture;





