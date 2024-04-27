-- Projekt: DES, sintetizator zvoka 2024

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity sint24 is
  port (
    clk    : in    std_logic;            -- sistemska ura	
    clk1   : out   std_logic;            -- serijska tipkovnica	
    sdata  : in    std_logic;
    shld   : out   std_logic;
    pwm1   : out   std_logic;            -- PWM

    data   : inout unsigned(7 downto 0); -- IO modul
    addr   : out   unsigned(1 downto 0);
    clkout : out   std_logic;

    led    : out   unsigned(7 downto 0); -- LED

    sw     : in    unsigned(3 downto 0); -- butns
    key    : in    unsigned(1 downto 0)  -- butns
  );
end entity;

architecture RTL of sint24 is

  signal clk1hz  : std_logic;
  signal clk10hz : std_logic;

begin
  led(0) <= key(0);

  u1: entity work.clocks
    port map (
      clkin   => clk,
      clk1hz  => clk1hz,
      clk10hz => clk10hz
    );

  led(1) <= clk1hz;
  led(2) <= clk10hz;

end architecture;
