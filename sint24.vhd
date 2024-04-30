library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity sint24 is
  port (
    clk           : in    std_logic;                              -- sistemska ura	
    pin_io_data   : inout std_logic_vector(7 downto 0);           -- IO modul
    pin_io_addr   : out   std_logic_vector(1 downto 0);
    pin_io_clkout : out   std_logic;
    pin_led       : out   unsigned(7 downto 0) := (others => '0') -- LED
  );
end entity;

architecture RTL of sint24 is

  signal slowclk        : std_logic;
  signal ultraSlowClock : std_logic;
  signal counter        : unsigned(22 downto 0);

  signal address : unsigned(1 downto 0);

  signal matrixData : std_logic_vector(7 downto 0);
  signal matrixLine : unsigned(2 downto 0);
  signal matrixCols : unsigned(4 downto 0);

  signal buttonData : unsigned(3 downto 0);

begin

  clkdownsizer: process (clk)
  begin
    if (rising_edge(clk)) then
      counter <= counter + 1;
    end if;
  end process; -- clkdownsizer
  slowclk        <= counter(10);
  ultraSlowClock <= counter(22);
  pin_led(0)     <= slowclk;
  pin_led(1)     <= ultraSlowClock;

  pin_led(7 downto 4) <= unsigned(buttonData);
  matrixData          <= std_logic_vector(matrixLine & matrixCols);

  interface_inst: entity work.interface
    port map (
      clk      => clk,
      buttons  => buttonData,
      matrix   => unsigned(matrixData),
      pin_addr => pin_io_addr,
      pin_data => pin_io_data,
      pin_clk  => pin_io_clkout
    );

  cddd: process (ultraSlowClock)
  begin
    if rising_edge(ultraSlowClock) then
      matrixLine <= matrixLine + 1;
    end if;
    matrixCols <= "11011";
  end process; -- cddd

end architecture;
