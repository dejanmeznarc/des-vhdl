library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_driver is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    screen   : out screen_t;
    offset_x : in  unsigned(2 downto 0) := (others => '0');
    --offset_y : in  unsigned(2 downto 0) := (others => '0');
    figure   : in  unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of gpu_driver is
  signal screen_moving_fig : screen_t;
  signal screen_old_figs   : screen_t;

  signal cnt : unsigned(2 downto 0);

  signal newFigure : std_logic := '0';
begin

  gpu_firuge_drawer_inst: entity work.gpu_firuge_drawer
    port map (
      figureID => figure,
      cord_x   => offset_x,
      cord_y   => cnt,
      screen   => screen_moving_fig
    );

  --   gpu_bottom_draw_inst: entity work.gpu_bottom_draw
  --     port map (
  --       clk    => clk,
  --       screen => screen_bottom
  --     );
  -- combine screens from multipele draw engines
  combine_screens: for i in 0 to 6 generate
    screen(i) <= screen_moving_fig(i) or screen_old_figs(i);
  end generate;

  ------------------------
  -- GAME LOGIC
  ----------------
  game_counter_inst: entity work.game_counter
    port map (
      clk   => clk,
      reset => (reset or newFigure),
      cnt   => cnt
    );







  bottomDetector: process (clk, screen_moving_fig, screen_old_figs, reset)
  begin
    screen_old_figs <= screen_old_figs;

    --TODO: try outsourcing collision detector
    -- TODO: better reset somehow?

    colisionDetector: for i in 1 to 6 loop
      if (screen_old_figs(i) and screen_moving_fig(i)) > 0 then

        saveFigureToOldOnes: for i in 1 to 6 loop --save state before moving
          screen_old_figs(i - 1) <= screen_old_figs(i - 1) or screen_moving_fig(i);
        end loop;

        
      end if;
    end loop; -- colisionDetector

    if (cnt = 6) then
      saveFigureToOldOnes2: for i in 0 to 6 loop --save current sata
        screen_old_figs(i) <= screen_old_figs(i) or screen_moving_fig(i);
      end loop;
    end if;

    if (reset = '1') then -- this bs is causeing problems with movement somehow???
      screen_old_figs <= (others => (others => '0'));
    end if;

  end process; -- bottomDetector

  resetter: process (reset)
  begin

    -- check reset
  end process; -- resetter

end architecture;
