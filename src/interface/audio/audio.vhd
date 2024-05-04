
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity audio is

  port (
    clk    : in  std_logic;
    pwmClk : in  std_logic;
    tone   : in  unsigned(2 downto 0);

    output : out std_logic
  );
end entity;

architecture rtl of audio is

  signal audioAnalog : unsigned(7 downto 0);
begin

  --- audio
  sin_gen_inst: entity work.sin_gen
    port map (
      clk          => clk,
      en           => pwmClk,
      analogOutput => audioAnalog
    );

  pwm_inst: entity work.pwm
    port map (
      clk    => clk,
      duty   => audioAnalog,
      output => output
    );

end architecture;
