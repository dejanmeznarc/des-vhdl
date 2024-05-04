library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;
  use work.figure_type.all;
  use work.figures.all;

entity figure_drawer is

  generic (
    SIZE : natural := 2 -- (figure size -1) 2x2->1 or 3x3 -> 2
  );

  port (
    figureID : in  unsigned(2 downto 0);                    -- wha fig to display

    cord_x   : in  unsigned(2 downto 0) := (others => '0'); -- col
    cord_y   : in  integer range - 1 to 6;
    rotation : in  unsigned(1 downto 0) := (others => '0');
    screen   : out screen_t
  );
end entity;

architecture rtl of figure_drawer is

  signal figure : figure_t;

begin

  rotate: process (rotation, figureID)

    variable fig        : figure_t;
    variable rotatedFig : figure_t;

    --type fig2_t is array (natural range <>) of unsigned(0 to 2);
    -- alias inverted : bigfig_t(0 to 2) is fig; 

  begin
    fig := figuresRom(to_integer(figureID));

    if (rotation = 0) then
      rotatedFig := fig;

    elsif (rotation = 1) then
      -- zasuk za 90 deg
      for j in 0 to SIZE loop
        for i in 0 to SIZE loop
          rotatedFig(j)(i) := fig(SIZE - i)(j);
        end loop;
      end loop;

    elsif (rotation = 2) then
      -- zasuk 2 (za 180deg)
      for j in 0 to SIZE loop
        for i in 0 to SIZE loop
          rotatedFig(i)(SIZE - j) := fig(SIZE - i)(j);
        end loop;
      end loop;

    elsif (rotation = 3) then
      -- zasuk za 270 deg
      for j in 0 to SIZE loop
        for i in 0 to SIZE loop
          rotatedFig(SIZE - j)(i) := fig(i)(j);
        end loop;
      end loop;
    end if;

    figure <= rotatedFig;

  end process; -- rotate

  draw: process (figure, cord_x, cord_y)
  begin

    screen <= (others => (others => '0'));

    if (cord_y > 0) then -- here to prevent drawing on the other side of screen
      screen((cord_y - 1)) <= ((("00000" & figure(0)) sll to_integer(cord_x)) srl 1);
    end if;

    if (cord_y >= 0) then
      screen((cord_y)) <= (("00000" & figure(1)) sll to_integer(cord_x)) srl 1;
    end if;

    -- draw third line, only if fgure is 3x3
    if (SIZE = 2) then 
      if (cord_y < 6) then -- here to prevent drawing on the other side of screen
        screen((cord_y + 1)) <= ((("00000" & figure(2)) sll to_integer(cord_x)) srl 1);
      end if;
    end if;

  end process; -- identifier

end architecture;
