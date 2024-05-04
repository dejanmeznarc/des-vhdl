
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity pwm is
  port (
    clk    : in  std_logic;
    duty   : in  unsigned(7 downto 0);
    output : out std_logic
  );
end entity;

architecture rtl of pwm is
  signal counter : unsigned(7 downto 0) := (others => '0');
  signal curDuty : unsigned(7 downto 0) := (others => '0');

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if (counter > 254) then
        counter <= (others => '0');
        curDuty <= duty; --load duty cycle here to avoid interterupting pwm gen
      else
        counter <= counter + 1;
      end if;
    end if;
  end process; -- pwmgen

  output <= '0' when curDuty > counter else '1';

end architecture;
