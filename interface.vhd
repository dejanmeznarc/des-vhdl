library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity interface is
  port (
    clk      : in    std_logic;
    buttons  : out   unsigned(7 downto 0);
    matrix   : in    unsigned(7 downto 0);

    pin_addr : out   std_logic_vector(1 downto 0);
    pin_data : inout std_logic_vector(7 downto 0);

    datain   : in    std_logic_vector(7 downto 0);
    dataout  : out   std_logic_vector(7 downto 0);
    pin_clk  : out   std_logic
  );

end entity;

architecture rTL of interface is
  signal selectedAddr : unsigned(1 downto 0);
  signal btns         : unsigned(7 downto 0) := (others => '0');

begin

  process (clk)
  begin
    if (rising_edge(clk)) then

      selectedAddr <= selectedAddr + 1;

      if (selectedAddr = "01") then
        btns <= unsigned(datain);
      end if;

    end if;
  end process;

  -- btns    <= unsigned(pin_data) when selectedAddr = "01" else btns;
  buttons <= btns;

  pin_addr <= std_logic_vector(selectedAddr);
  dataout  <= std_logic_vector(matrix) when selectedAddr = "10" else "ZZZZZZZZ";
  pin_clk  <= clk;

end architecture;
