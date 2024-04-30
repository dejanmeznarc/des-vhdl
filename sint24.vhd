library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

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

  signal matrixData : unsigned(7 downto 0);
  signal buttonData : unsigned(3 downto 0);

  signal matrixLine : unsigned(4 downto 0);

  signal counter : unsigned(24 downto 0);
  signal janez   : unsigned(24 downto 0);

  signal screen : screen_t := (
    "11111",
    "00001",
    "00001",
    "10001",
    "00001",
    "00001",
    "11111"
  );
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
      matrix   => matrixData,
      pin_addr => pin_io_addr,
      pin_data => pin_io_data,
      pin_clk  => pin_io_clkout
    );

  matrix_inst: entity work.matrix
    port map (
      clk         => counter(3), -- needs to be at least 4x slower than interface clock
      matrix_data => matrixData,
      screen      => screen
    );

end architecture;
