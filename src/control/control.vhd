library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity control is
  port (
    clk       : in  std_logic;
    --  pin_led  : out   unsigned(7 downto 0);
    buttons   : in  unsigned(3 downto 0);
    locLimitR : in  unsigned(2 downto 0) := "000";
    locLimitL : in  unsigned(2 downto 0) := "100";
    location  : out unsigned(2 downto 0)
  );
end entity;

architecture rtl of control is

  type clicks_t is array (3 downto 0) of std_logic;
  signal clicks : clicks_t;

begin
  clickDetector: for i in 0 to 3 generate
    u4: entity work.btn_click_detector
      port map (
        clk    => clk,
        button => buttons(i),
        click  => clicks(i)
      );
  end generate;

  horizontalLocationController: entity work.number_picker
    port map (
      clk       => clk,
      up        => clicks(0),
      down      => clicks(1),
      number    => location,
      limitDown => locLimitR,
      limitUp   => locLimitL
    );

  -- pin_led(2 downto 0) <= location;
end architecture;
