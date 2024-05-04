library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

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


  signal playBtnPress : std_logic;


begin
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

  control_inst: entity work.control
    port map (
      clk     => clk,
      buttons => buttonData,
      clicks  => clicks
    );

  gamelogic_inst: entity work.gamelogic
    port map (
      clk      => clk,
      btns     => buttonData,
      pin_leds => pin_led,
      clicks   => clicks,
      screen   => screen,
      playBtnPress => playBtnPress
    );


    audio_composer: entity work.composer
    port map (
      clk  => clk,
      tone => tone,
      playBtnPress => clicks(2)
    );

end architecture;
