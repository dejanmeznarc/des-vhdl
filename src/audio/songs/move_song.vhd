library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity move_song is

  port (
    clk  : in  std_logic;
    play : in  std_logic;
    tone : out unsigned(2 downto 0)
  );
end entity;

architecture rtl of move_song is
  signal counter : unsigned(22 downto 0);

begin

  process (clk)
    --variable curSong : composer_song_t;
  begin

    if (rising_edge(clk)) then

      if (counter < (2 ** 22)) then
        counter <= counter + 1;
      end if;

      if (play = '1') then
        counter <= (others => '0');
      end if;

    end if;
  end process;

  tone <= "100" when (counter < 2 ** 22) else
          "000";

end architecture;



