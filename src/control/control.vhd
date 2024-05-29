library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity control is
  port (
    clk     : in  std_logic;
    --  pin_led  : out   unsigned(7 downto 0);
    buttons : in  unsigned(3 downto 0);
    clicks  : out unsigned(3 downto 0)
  );
end entity;

architecture rtl of control is
  signal clicks_tmp : std_logic_vector(3 downto 0);

begin
  -- detect click on all buttons
  clickDetector: for i in 0 to 3 generate
    u4: entity work.btn_click_detector
      port map (
        clk    => clk,
        button => buttons(i),
        click  => clicks_tmp(i)
      );
  end generate;

  clicks <= unsigned(clicks_tmp);

  -- pin_led(2 downto 0) <= location;
end architecture;
