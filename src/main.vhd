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
  signal counter : unsigned(24 downto 0);

  signal location : unsigned(2 downto 0) := (others => '0');

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

  signal locRightLimit : unsigned(2 downto 0);
  signal locLeftLimit  : unsigned(2 downto 0);
begin

  identifier: process (clk)
  begin
    if (rising_edge(clk)) then
      counter <= counter + 1;
    end if;

  end process; -- identifier

  interface_inst: entity work.interface
    port map (
      clk      => clk,
      buttons  => buttonData,

      screen   => screen,
      pin_addr => pin_io_addr,
      pin_data => pin_io_data,
      pin_clk  => pin_io_clkout
    );

  control_inst: entity work.control
    port map (
      clk       => clk,
      buttons   => buttonData,
      location  => location,
      locLimitR => locRightLimit,
      locLimitL => locLeftLimit
    );

  gamelogic_inst: entity work.gamelogic
    port map (
      clk       => clk,
      btns      => buttonData,
      pin_leds  => pin_led,
      locLimitR => locRightLimit,
      locLimitL => locLeftLimit,
      location  => location,
      screen    => screen
    );

  -- gpu_driver_inst: entity work.gpu_driver
  --   port map (
  --     clk      => counter(24),
  --     screen   => screen,
  --     offset_x => offset,
  --     offset_y => offset2
  --   );
  --  mikro: process (buttonData, counter(10))
  -- begin
  --   if (rising_edge(counter(14))) then
  --     if (buttonData(0) = '1' and buttonDataPrev(0) = '0') then
  --       if (offset >= 4) then
  --         offset <= "100";
  --       else
  --         offset <= offset + 1;
  --       end if;
  --     end if;
  --     if (buttonData(1) = '1' and buttonDataPrev(1) = '0') then
  --       if (offset <= 0) then
  --         offset <= "000";
  --       else
  --         offset <= offset - 1;
  --       end if;
  --     end if;
  --     if (buttonData(2) = '1' and buttonDataPrev(2) = '0') then
  --       if (offset2 >= 6) then
  --         offset2 <= "110";
  --       else
  --         offset2 <= offset2 + 1;
  --       end if;
  --     end if;
  --     if (buttonData(3) = '1' and buttonDataPrev(3) = '0') then
  --       if (offset2 <= 0) then
  --         offset2 <= "000";
  --       else
  --         offset2 <= offset2 - 1;
  --       end if;
  --     end if;
  --     if (offset2 > 6) then
  --       offset2 <= (others => '0');
  --     end if;
  --     buttonDataPrev <= buttonData;
  --   end if;
  -- end process; -- mikro
  -- pin_led(2 downto 0) <= offset(2 downto 0);
  -- pin_led(7 downto 5) <= offset2(2 downto 0);
end architecture;
