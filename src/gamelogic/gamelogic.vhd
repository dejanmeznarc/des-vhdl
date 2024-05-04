library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

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
  signal currentLine : unsigned(2 downto 0);

  signal screenBarrier : screen_t := (others => (others => '0'));
  signal screenFig     : screen_t := (others => (others => '0'));

  signal location : unsigned(2 downto 0);
begin

  line_counter_inst: entity work.line_counter
    port map (
      clk  => clk,
      line => currentLine
    );

  movement_control: process (clk)
    variable limitRight      : unsigned(2 downto 0);
    variable limitLeft       : unsigned(2 downto 0);
    variable virtualLocation : unsigned(2 downto 0);
  begin
    if rising_edge(clk) then
      limitRight := "000";
      limitLeft := "100";

      -- calculate left/right limits
      -- process user left/right interaction
      if (clicks(0) = '1') then
        constrain_loc_left: if (virtualLocation < limitLeft) then
          virtualLocation := virtualLocation + 1;
        end if;
      elsif (clicks(1) = '1') then
        constrain_loc_right: if (virtualLocation > limitRight) then
          virtualLocation := virtualLocation - 1;
        end if;
      end if;

    end if;

    location <= virtualLocation;
  end process;

  collsion_check: process (currentLine)
  begin

    screen <= (others => (others => '0'));
    screen(to_integer(currentLine)) <= "00000" & '1' sll to_integer(location);

  end process;

end architecture;
