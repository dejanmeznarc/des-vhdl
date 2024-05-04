library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;
  use work.figures.all;

entity gamelogic is

  port (
    clk      : in  std_logic;
    screen   : out screen_t;
    pin_leds : out unsigned(7 downto 0);
    btns     : in  unsigned(3 downto 0);
    clicks   : in  unsigned(3 downto 0)

  );
end entity;

architecture rtl of gamelogic is
  signal currentLine : unsigned(2 downto 0) := "011";

  signal screenBarrier : screen_t := (others => (others => '0'));
  signal screenFig     : screen_t := (others => (others => '0'));

  signal location : unsigned(2 downto 0);

  signal figureId : unsigned(2 downto 0) := "010";

  signal looser : std_logic := '0';

  signal counter : unsigned(27 downto 0);
  signal random  : unsigned(7 downto 0);
begin

  random_inst: entity work.random
    port map (
      clk    => clk,
      number => random
    );

  movement_control: process (clk)
    variable limitRight      : unsigned(2 downto 0);
    variable limitLeft       : unsigned(2 downto 0);
    variable virtualLocation : unsigned(2 downto 0);

  begin
    if rising_edge(clk) then

      -- clock
      if (counter > 2 ** 26) then
        counter <= (others => '0');
        if (currentLine >= 7) then
          currentLine <= (others => '0');
        else
          currentLine <= currentLine + 1;
        end if;
      else
        counter <= counter + 1;
      end if;

      -- default limits
      limitRight := "000";
      limitLeft := "100";

      calc_limits: for i in 0 to 6 loop
        -- shift figure screen 1 bit to the left and compare it to the barrier. (simulate movement)
        -- also add '1' on side of barrier screen to form screen edge
        if (('1' & screenBarrier(i)) and (('0' & screenFig(i)) sll 1)) > 0 then
          limitLeft := location;
        end if;

        -- do same for the other side
        if ((screenBarrier(i) & '1') and ((screenFig(i) & '0') srl 1)) > 0 then
          limitRight := location;
        end if;
      end loop;

      -- process user left/right interaction and constrain it.
      if (looser = '0') then
        if (clicks(0) = '1') then
          if (virtualLocation < limitLeft) then
            virtualLocation := virtualLocation + 1;
          end if;
        elsif (clicks(1) = '1') then
          if (virtualLocation > limitRight) then
            virtualLocation := virtualLocation - 1;
          end if;
        end if;
      end if;

      -- detect bottom
      bottom_detection: if (screenFig(6) > 0) then
        currentLine <= (others => '0');
        figureId <= random(3 downto 1);

        saveFigToBarrier: for i in 1 to 6 loop
          screenBarrier(i) <= screenBarrier(i) or screenFig(i);
        end loop;
      end if;

      -- detect collision
      collision_detection: for i in 0 to 6 loop
        if (screenFig(i) and screenBarrier(i)) > 0 then
          currentLine <= (others => '0');
          figureId <= random(3 downto 1);

          saveFigToBarrier2: for i in 1 to 6 loop
            screenBarrier(i - 1) <= screenBarrier(i - 1) or screenFig(i);
          end loop;

        end if;
      end loop;

      -- detect loose scenario
      looser_detection: if (screenFig(0) and screenBarrier(0)) > 0 then
        currentLine <= (others => '0');
        pin_leds <= (others => '1');
        looser <= '1';
      end if;

      reset_detection: if (btns(3) and btns(2)) = '1' then
        screenBarrier <= (others => (others => '0'));
        currentLine <= (others => '0');
        figureId <= random(3 downto 1);
        pin_leds <= (others => '0');
        looser <= '0';
      end if;

    end if;
    location <= virtualLocation;
  end process;

  draw_figure_screen: entity work.gpu_firuge_drawer
    port map (
      figureID => figureId,
      cord_x   => location,
      cord_y   => to_integer(currentLine) - 1, -- shift one line up to achive falling effect (so it doesnt just appear on the screen)
      screen   => screenFig
    );

  combine_screens: for i in 0 to 6 generate
    screen(i) <= screenFig(i) or screenBarrier(i);
  end generate;

end architecture;
