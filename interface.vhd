library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity interface is
  port (
    clk      : in    std_logic;
    addr_pin : out   std_logic_vector(1 downto 0);
    data_pin : inout std_logic_vector(7 downto 0);
    btns: out unsigned(3 downto 0)
  );

end entity;

architecture rTL of interface is
  signal selectedAddr : unsigned(1 downto 0);
  signal buttons      : unsigned(3 downto 0);
  signal matix        : unsigned(7 downto 0);
begin

  --- Syncronizes extension board with io panel
  syncBoard: process (clk)
  begin
    if rising_edge(clk) then
      selectedAddr <= selectedAddr + 1;
    end if;

    if (selectedAddr = 1) then
      data_pin <= (others => 'Z');
      buttons <= unsigned(data_pin(3 downto 0));

    elsif (selectedAddr = 2) then
      data_pin <= std_logic_vector(matix);
    end if;

  end process; -- syncBoard 

  addr_pin <= std_logic_vector(selectedAddr);
  btns <= buttons;

end architecture;
