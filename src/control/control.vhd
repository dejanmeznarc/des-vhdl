library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity control is
  port (
    clk     : in  std_logic;
    pin_led : out unsigned(7 downto 0);
    buttons : in  unsigned(3 downto 0)
  );
end entity;

architecture rtl of control is
  signal loc_x : unsigned(2 downto 0) := (others => '0');

  signal btn0 : unsigned(1 downto 0);
  signal btn1 : unsigned(1 downto 0);

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

  identifier: process (clk)
  begin
    if rising_edge(clk) then
      if (clicks(0) = '1') then
        if (loc_x >= 4) then
          loc_x <= "100";
        else
          loc_x <= loc_x + 1;
        end if;
      end if;

      if (clicks(1) = '1') then
        if (loc_x <= 0) then
          loc_x <= "000";
        else
          loc_x <= loc_x - 1;
        end if;
      end if;

    end if;
  end process; -- identifier

  pin_led(2 downto 0) <= loc_x;

end architecture;
