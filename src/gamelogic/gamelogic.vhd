library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity gamelogic is

  port (
    clk       : in  std_logic;
    location  : in  unsigned(2 downto 0);
    locLimitR : out unsigned(2 downto 0) := "010";
    locLimitL : out unsigned(2 downto 0) := "100";
    screen    : out screen_t;
    pin_leds  : out unsigned(7 downto 0);
    btns      : in  unsigned(3 downto 0)

  );
end entity;

architecture rtl of gamelogic is
  signal count : unsigned(27 downto 0);

  signal line      : unsigned(2 downto 0) := "000";
  signal curFigure : unsigned(2 downto 0) := "010";

  signal limitAbsRight : unsigned(2 downto 0);
  signal limitAbsLeft  : unsigned(2 downto 0);

  signal screen_fig     : screen_t := (others => (others => '0'));
  signal screen_barrier : screen_t := (others => (others => '0'));

  signal screen_combined : screen_t := (others => (others => '0'));

  signal screen_game_over : screen_t := (
    "00000",
    "01000",
    "01000",
    "01000",
    "01000",
    "01110",
    "00000"
  );

  signal reset     : std_logic := '0';
  signal looseFlag : std_logic := '0';
begin

  line <= line when looseFlag = '1' else count(27 downto 25);

  figLimitFinder_inst: entity work.figLimitFinder
    port map (
      figureID   => curFigure,
      limitLeft  => limitAbsLeft,
      limitRight => limitAbsRight
    );

  identifier: process (clk)
  begin
    if rising_edge(clk) then

      count <= count + 1;

      -- detect bottom of screen
      if (screen_fig(6) > 0) then
        count <= (others => '0');

        saveFigureToBarrier: for i in 0 to 6 loop
          screen_barrier(i) <= screen_barrier(i) or screen_fig(i);
        end loop;
      end if;

      --detect collisions
      detectCollsion: for i in 0 to 6 loop
        if (screen_fig(i) and screen_barrier(i)) > 0 then
          count <= (others => '0');

          saveFigToBarrier2: for i in 1 to 6 loop
            screen_barrier(i - 1) <= screen_barrier(i - 1) or screen_fig(i);
          end loop;

        end if;
      end loop;

      --- looser detection
      if (((screen_barrier(0)) > 0)) then
        looseFlag <= '1';
      end if;

      if (reset = '1') then -- reset
        count <= (others => '0');
        --location <= (others => '0');
        looseFlag <= '0';

        clearall: for i in 0 to 6 loop
          screen_barrier(i) <= (others => '0');
        end loop;
      end if;

    end if;
  end process; -- identifier

  gpu_firuge_drawer_inst: entity work.gpu_firuge_drawer
    port map (
      figureID => curFigure,
      cord_x   => location,
      cord_y   => line - 1,
      screen   => screen_fig
    );

  combineScreens: for i in 0 to 6 generate
    screen_combined(i) <= screen_barrier(i) or screen_fig(i);
  end generate;

  screen <= screen_barrier   when btns(2) = '1' else
            screen_fig       when btns(3) = '1' else
            screen_game_over when looseFlag = '1' else
            screen_combined;

  reset     <= btns(2) and btns(3);


  locLimitL <= limitAbsLeft;
  locLimitR <= limitAbsRight;
  pin_leds(7 downto 5) <= limitAbsLeft;
  pin_leds(2 downto 0) <= limitAbsRight;
end architecture;
