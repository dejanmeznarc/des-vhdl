library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity sin_gen is
  port (
    clk          : in  std_logic;
    en           : in  std_logic;

    step         : in  unsigned(7 downto 0);

    analogOutput : out unsigned(7 downto 0)
  );

end entity;

architecture rtl of sin_gen is

  type waveform_t is array (0 to 7) of SIGNED(7 downto 0);
  signal waveform : waveform_t := (
    X"0C", X"25", X"3C", X"51",
    X"62", X"70", X"7A", X"7E"
  );

  signal counter : unsigned(15 downto 0);

  signal analog : signed(7 downto 0);

  signal adr : unsigned(2 downto 0);

begin

  process (en)
  begin
    if rising_edge(en) then
      counter <= counter + step;

      if (counter(14) = '1') then
        adr <= counter(13 downto 11);
      else
        adr <= not(counter(13 downto 11));
      end if;

    end if;
  end process;

  analog <= waveform(to_integer(adr)) when counter(15) = '1' else
            - waveform(to_integer(adr));

  analogOutput <= unsigned(analog xor "10000000");

end architecture;
