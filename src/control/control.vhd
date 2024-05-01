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

begin

  identifier: process (clk)
  begin
    if rising_edge(clk) then

      btn0 <= btn0(0) & buttons(0);
      pin_led(7 downto 6) <= btn0;

      btn1 <= btn1(0) & buttons(1);

      if (btn0 = "01") then
        if (loc_x >= 4) then
          loc_x <= "100";
        else
          loc_x <= loc_x + 1;
        end if;
      end if;

      if (btn1 = "01") then
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
