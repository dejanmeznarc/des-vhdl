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
  signal counter     : unsigned(27 downto 0);
  signal currentLine : unsigned(2 downto 0) := "011";

  signal screenBarrier : screen_t := (others => (others => '0'));
  signal screenFig     : screen_t := (others => (others => '0'));

  signal location : unsigned(2 downto 0);

  signal figureId : unsigned(2 downto 0) := "010";

begin

  screenBarrier <= (
    -- "10001",
    -- "10001",
    -- "10001",
    -- "10001",
    -- "10001",
    -- "10001",
    -- "10001"

    "00001",
    "00001",
    "00001",
    "00001",
    "00001",
    "00001",
    "00001"

    -- "00000",
    -- "00000",
    -- "00000",
    -- "00000",
    -- "00000",
    -- "00000",
    -- "00000"
  );

  -- line_counter_inst: entity work.line_counter
  --   port map (
  --     clk  => clk,
  --     line => currentLine
  --   );

  movement_control: process (clk)
    variable limitRight      : unsigned(2 downto 0);
    variable limitLeft       : unsigned(2 downto 0);
    variable virtualLocation : unsigned(2 downto 0);

  begin
    if rising_edge(clk) then

      -- calculate left/right limits
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

      -- Types of limits:
      ---  a) figure/edge limit (figures bigger than 1x1, so they dont go over screen edge) 
      ---  b) collision limit (figures cant collide into exsisting barrier)
      --- 01*00 -- lock_left=true, lock_right_false
      --- 01000
      --- 01000
      --- 01**0 -- locl left=1
      --- 010*0 -- lock left=0
      --- 01000
      --- 01000
      -- process user left/right interaction and constrain it.
      if (clicks(0) = '1') then
        constrain_loc_left: if (virtualLocation < limitLeft) then
          virtualLocation := virtualLocation + 1;
        end if;
      elsif (clicks(1) = '1') then
        constrain_loc_right: if (virtualLocation > limitRight) then
          virtualLocation := virtualLocation - 1;
        end if;
      end if;

      if (clicks(3) = '1') then
        figureId <= figureId + 1;
      end if;

    end if;
    pin_leds(2 downto 0) <= limitLeft;
    location <= virtualLocation;
  end process;

  -- collsion_check: process (currentLine, location)
  -- begin
  --   screenFig <= (others => (others => '0'));
  --   screenFig(to_integer(currentLine)) <= "00000" & '1' sll to_integer(location);
  --   -- screen(3) <= "00000" & '1' sll to_integer(location);
  -- end process;
  gpu_firuge_drawer_inst: entity work.gpu_firuge_drawer
    port map (
      figureID => figureId,
      cord_x   => location,
      cord_y   => 3,
      screen   => screenFig
    );

  jj: for i in 0 to 6 generate
    screen(i) <= screenFig(i) or screenBarrier(i);
  end generate;
end architecture;
