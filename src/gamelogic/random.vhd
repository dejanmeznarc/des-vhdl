--- https://www.engineersgarage.com/feed-back-register-in-vhdl/
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity random is
  port (
    clk    : in  std_logic;
    number : out unsigned(7 downto 0)
  );
end entity;

architecture rtl of random is

  signal curstate  : unsigned(7 downto 0) := (0 => '1', others => '0');
  signal nextstate : unsigned(7 downto 0);
  signal feedback  : std_logic;
begin
  process (clk)
  begin
    if rising_edge(clk) then
      curstate <= nextstate;
    end if;
  end process;

  feedback  <= curstate(4) xor curstate(3) xor curstate(2) xor curstate(0);
  Nextstate <= feedback & curstate(7 downto 1);
  number    <= curstate;

end architecture;
