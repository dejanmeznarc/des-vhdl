library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity interface is
  port (
    clk      : in    std_logic;
    buttons  : out   unsigned(3 downto 0);
    screen   : in    screen_t;

    pin_addr : out   std_logic_vector(1 downto 0);
    pin_data : inout std_logic_vector(7 downto 0);
    pin_clk  : out   std_logic;
    pin_led  : out   unsigned(7 downto 0)
  );

end entity;

architecture rtl of interface is
  signal matrixData  : unsigned(7 downto 0);
  signal buttonData  : unsigned(3 downto 0);
  signal clk_counter : unsigned(31 downto 0);

  signal slowClk : std_logic := '0';

begin

  interface_clock_divider_inst: entity work.interface_clock_divider
    port map (
      clk     => clk,
      clk2    => slowClk,
      counter => clk_counter
    );

  -- IO interface manages mux at the daughterboard
  io_interface_inst: entity work.io_interface
    port map (
      clk        => clk,
      buttons    => buttonData,
      matrixData => matrixData,
      pin_addr   => pin_addr,
      pin_data   => pin_data,
      pin_clk    => pin_clk
    );

  matrix_inst: entity work.matrix
    port map (
      clk         => slowClk, -- use slower clock, so itnerface can update all values
      matrix_data => matrixData,
      screen      => screen
    );

  buttons_inst: entity work.buttons
    port map (
      clk     => slowClk,
      btn_in  => buttonData,
      buttons => buttons
    );

end architecture;
