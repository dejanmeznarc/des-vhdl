library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity interface_clock_divider is
  port (
    clk   : in  std_logic;
    clk2  : out std_logic; -- clock with interface delay in mind
    pwmEN : out std_logic  -- clock fow pwm
    --counter : out unsigned(31 downto 0) := (others => '0')
  );
end entity;

architecture rtl of interface_clock_divider is
  signal count : unsigned(5 downto 0) := (others => '0');

  signal pwmcounter : unsigned(8 downto 0) := (others => '0');

begin

  interface_clock_divider: process (clk)
  begin
    if rising_edge(clk) then
      count <= count + 1;
      clk2 <= count(5);

      -- 50mhz to 100khz
      if (pwmcounter > 499) then 
        pwmEN <= '1';
        pwmcounter <= (others => '0');
      else
        pwmcounter <= pwmcounter + 1;
        pwmEN <= '0';
      end if;

    end if;
  end process; -- interface_clock_divider

  --counter <= count;
end architecture;
