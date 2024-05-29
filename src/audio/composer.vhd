library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.song_pkg.all;

entity composer is

  port (
    clk  : in  std_logic;
    tone : out unsigned(2 downto 0);

    song :     composer_song_t := s_quiet;
    play : in  std_logic

  );
end entity;

architecture rtl of composer is
  signal toneLooser : unsigned(2 downto 0);
  signal toneMover  : unsigned(2 downto 0);

begin

  -- one melody
  looser_song_inst: entity work.looser_song
    port map (
      clk  => clk,
      play => play,
      tone => toneLooser
    );

  -- second melody
  move_song_inst: entity work.move_song
    port map (
      clk  => clk,
      play => play,
      tone => toneMover
    );


  -- control which melody to play
  tone <= toneLooser when (song = s_looser) else
          toneMover  when (song = s_move) else
          "000"; -- 000 -> be quiet
end architecture;
