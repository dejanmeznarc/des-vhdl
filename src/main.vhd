library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.song_pkg.all;

entity main is
  port (
    clk           : in    std_logic;                              -- sistemska ura	
    pin_io_data   : inout std_logic_vector(7 downto 0);           -- IO modul
    pin_io_addr   : out   std_logic_vector(1 downto 0);
    pin_io_clkout : out   std_logic;
    pin_led       : out   unsigned(7 downto 0) := (others => '0') -- LED
  );
end entity;

architecture RTL of main is
  signal buttonData : unsigned(3 downto 0);

  signal screen : screen_t := (
    "11111",
    "00001",
    "00001",
    "10001",
    "00001",
    "00001",
    "11111"
  );

  signal clicks : unsigned(3 downto 0);

  signal tone : unsigned(2 downto 0);

  signal song     : composer_song_t;
  signal songPlay : std_logic;

begin

  -- Interface handles communication to external board 
  interface_inst: entity work.interface
    port map (
      clk      => clk,
      buttons  => buttonData,
      screen   => screen,
      pin_addr => pin_io_addr,
      pin_data => pin_io_data,
      pin_clk  => pin_io_clkout,
      tone     => tone
    );

  -- Control detects button click, hold and push
  control_inst: entity work.control
    port map (
      clk     => clk,
      buttons => buttonData,
      clicks  => clicks
    );


  -- Main game engine
  gamelogic_inst: entity work.gamelogic
    port map (
      clk      => clk,
      btns     => buttonData,
      pin_leds => pin_led,
      clicks   => clicks,
      screen   => screen,
      song     => song,
      songPlay     => songPlay
    );


  -- Plays melodies and controls sound effects
  audio_composer: entity work.composer
    port map (
      clk  => clk,
      tone => tone,
      song => song,
      play => songPlay
    );


  -- identifier: process (clk)
  -- begin
  --   if (rising_edge(clk)) then
  --     if (clicks(2) = '1') then
  --       song <= looser;
  --     end if;
  --     if (clicks(3) = '1') then
  --       song <= move;
  --     end if;
  --     if (clicks(0) = '1') then
  --       song <= quiet;
  --     end if;
  --   end if;
  -- end process; -- identifier
end architecture;
