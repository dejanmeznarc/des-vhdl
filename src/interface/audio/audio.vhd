
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

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

  type tonemap_t is array (0 to 4) of unsigned(7 downto 0);
  signal tonemap : tonemap_t := (-- TODO: use actual tones
    x"00",
    x"90",
    x"B9",
    x"D3",
    x"F7"
  );

  signal tempOut : std_logic;

begin

  --- audio sinus generator
  sin_gen_inst: entity work.sin_gen
    port map (
      clk          => clk,
      en           => pwmClk,
      step         => tonemap(to_integer(tone)),
      analogOutput => audioAnalog
    );

    -- pwm generator
  pwm_inst: entity work.pwm
    port map (
      clk    => clk,
      duty   => audioAnalog,
      output => tempOut
    );

  output <= tempOut when tone > 0 else '0'; --prevent high pich noise
end architecture;
