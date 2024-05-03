
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity number_picker is
  port (
    clk       : in  std_logic;
    up        : in  std_logic;
    down      : in  std_logic;
    number    : out unsigned(2 downto 0) := (others => '0');
    limitUp   : in  unsigned(2 downto 0) := (others => '0');
    limitDown : in  unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of number_picker is
  signal num : unsigned(2 downto 0) := (others => '0');
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if (up = '1') then
        if (num >= limitUp) then
          num <= limitUp;
        else
          num <= num + 1;
        end if;
      end if;

      if (down = '1') then
        if (num <= limitDown) then
          num <= limitDown;
        else
          num <= num - 1;
        end if;
      end if;

    end if;
  end process; -- identifier

  number <= num;
end architecture;
