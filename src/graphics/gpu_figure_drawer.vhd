library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;
  use work.figures.all;

entity gpu_firuge_drawer is
  port (
    figureID : in  unsigned(2 downto 0);                    -- wha fig to display

    cord_x   : in  unsigned(2 downto 0) := (others => '0'); -- col
    cord_y   : in  integer range - 1 to 6;
    screen   : out screen_t
  );
end entity;

architecture rtl of gpu_firuge_drawer is
  signal figure : figure_t;

  signal janez : unsigned(4 downto 0);
begin

  figure <= figuresRom(to_integer(figureID));

  draw: process (figure, cord_x, cord_y)
  begin

    screen <= (others => (others => '0'));

    if (cord_y > 0) then -- here to prevent drawing on the other side of screen
      screen((cord_y - 1)) <= ((("00000" & figure(0)) sll to_integer(cord_x)) srl 1);
    end if;

    if (cord_y > 0) then
      screen((cord_y)) <= (("00000" & figure(1)) sll to_integer(cord_x)) srl 1;
    end if;

    if (cord_y < 6) then -- here to prevent drawing on the other side of screen
      screen((cord_y + 1)) <= ((("00000" & figure(2)) sll to_integer(cord_x)) srl 1);
    end if;

  end process; -- identifier

end architecture;
