library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity gpu_driver is
  port (
    clk    : in     std_logic;
    screen : buffer screen_t;
    offset : in     unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture rtl of gpu_driver is

  signal counter : unsigned(5 downto 0);

  signal cord_line : unsigned(5 downto 0) := (others => '0');
  signal cord_col  : unsigned(2 downto 0) := (others => '0');
  signal figure    : unsigned(2 downto 0) := (others => '0');

  signal line1 : unsigned(11 downto 0);
  signal line2 : unsigned(11 downto 0);
  signal line0 : unsigned(11 downto 0);

  signal dummy0 : unsigned(11 downto 0);
  signal dummy1 : unsigned(11 downto 0);
  signal dummy2 : unsigned(11 downto 0);

  type figure_t is array (0 to 2) of unsigned(0 to 2);
  type figures_t is array (0 to 2) of figure_t;
  constant figs : figures_t := (
    (
      "101",
      "010",
      "101"
    ),
    (
      "110",
      "010",
      "000"
    ),
    (
      "110",
      "110",
      "000"
    )
  );

begin

  identifier: process (clk)
  begin
    if rising_edge(clk) then
      if (counter > 7) then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process; -- identifier

  cord_col  <= offset;
  cord_line <= counter;

  draw: process (figure, cord_col, cord_line)
  begin
    screen <= (others => (others => '0')); -- clear screen

    --- ###############################
    --- LEFT/RIGHT and down tile
    --- #############################
    -- save figure to lines, use dummy var because others doesn't work with memory
    dummy0 <= "000000000" & unsigned(figs(to_integer(figure))(0));
    dummy1 <= "000000000" & unsigned(figs(to_integer(figure))(1));
    dummy2 <= "000000000" & unsigned(figs(to_integer(figure))(2));

    -- slide object left to the desired cords
    line0 <= dummy0 sll to_integer(cord_col);
    line1 <= dummy1 sll to_integer(cord_col);
    line2 <= dummy2 sll to_integer(cord_col);

    -- write to screen, but dont erase empty spaces
    screen(to_integer(cord_line + 0)) <= line0(7 downto 3); -- line is bigger, so we can slide object freely
    screen(to_integer(cord_line + 1)) <= line1(7 downto 3);
    screen(to_integer(cord_line + 2)) <= line2(7 downto 3);

    --- ###############################
    --- BOTTOM TILES
    --- #############################
    screen(6)(1) <= '1'; -- write dot in middle, so we can test
    screen(6)(2) <= '1'; -- write dot in middle, so we can test
    screen(5)(3) <= '1'; -- write dot in middle, so we can test
    screen(6)(4) <= '1'; -- write dot in middle, so we can test

-- TODO: save bottom tiles
-- TODO: do game logic (limit use of left/right shift), detect loosing
  end process; -- identifier

end architecture;
