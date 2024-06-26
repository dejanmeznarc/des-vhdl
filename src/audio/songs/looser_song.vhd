library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity looser_song is

  port (
    clk  : in  std_logic;
    play : in  std_logic;
    tone : out unsigned(2 downto 0)
  );
end entity;

architecture rtl of looser_song is
  signal counter : unsigned(27 downto 0);

begin

  process (clk)
    --variable curSong : composer_song_t;
  begin

    if (rising_edge(clk)) then

      if (counter < (2 ** 27)) then
        counter <= counter + 1;
      end if;

      if (play = '1') then
        counter <= (others => '0');
      end if;

    end if;
  end process;

  tone <= "100" when (counter < 2 ** 25) else
          "010" when (counter < 2 ** 26) else
          "001" when (counter < 2 ** 27) else
          "000";

end architecture;
