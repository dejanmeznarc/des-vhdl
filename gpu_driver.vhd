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

  jani: process (counter)

  begin
    -- screen <= (others => (others => '0')); -- clear screen
    -- screen(to_integer(counter + 1))(to_integer(offset + 2) downto to_integer(offset + 0)) <= figs(1)(0);
    -- screen(to_integer(counter + 2))(to_integer(offset + 2) downto to_integer(offset + 0)) <= figs(1)(1);
    -- screen(to_integer(counter + 3))(2 downto 0) <= figs(1)(2);
  end process; -- jani

  cord_col <= offset;

  micika: process (figure, cord_col, cord_line)
  begin
    screen <= (others => (others => '0')); -- clear screen

    -- others for some reason doesnt work
    dummy0 <= "000000000" & unsigned(figs(to_integer(figure))(0));
    dummy1 <= "000000000" & unsigned(figs(to_integer(figure))(1));
    dummy2 <= "000000000" & unsigned(figs(to_integer(figure))(2));

    -- dummy1 <= unsigned(figs(to_integer(figure))(1));
    -- dummy2 <= unsigned(figs(to_integer(figure))(2));
    line0 <= dummy0 sll to_integer(cord_col);
    line1 <= dummy1 sll to_integer(cord_col);
    line2 <= dummy2 sll to_integer(cord_col);

    -- line1 <= dummy1(2 downto 0) & (others => '0');
    -- line2 <= dummy2(2 downto 0) & (others => '0');
    screen(to_integer(cord_line + 0)) <= line0(7 downto 3);
    screen(to_integer(cord_line + 1)) <= line1(7 downto 3);
    screen(to_integer(cord_line + 2)) <= line2(7 downto 3);
    -- screen(to_integer(cord_line + 1)) <= line1(8 downto 3);
    -- screen(to_integer(cord_line + 2)) <= line2(8 downto 3);
  end process; -- identifier

end architecture;
