


library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity io_interface is
  port (
    clk      : in    std_logic; -- WARN: needs 4 cycles to sync all data
    buttons  : out   unsigned(3 downto 0);
    matrixData   : in    unsigned(7 downto 0);

    pin_addr : out   std_logic_vector(1 downto 0);
    pin_data : inout std_logic_vector(7 downto 0);
    pin_clk  : out   std_logic
  );

end entity;

architecture rtl of io_interface is
  signal address     : unsigned(1 downto 0) := "00";
  signal buttonsData : unsigned(3 downto 0);
begin

  addressChooser: process (clk)
  begin
    if rising_edge(clk) then
      address <= address + 1;

      -- dont waste clock cycles for unimplemented stuff
      if (address = "11") then
        address <= "01";
      end if;

    end if;
    end process; -- addressChooser

  pin_clk  <= clk;
  pin_addr <= std_logic_vector(address);
  pin_data <= (others => 'Z')             when address = "01" else -- read mode
               (std_logic_vector(matrixData)) when address = "10" else -- write matrix
               (others => 'Z'); -- others (not yet defined)

  -- TODO: find better way of storing button state. (without creating another signal)
  buttonsData <= unsigned(pin_data(3 downto 0)) when address = "01" else buttonsData;
  buttons     <= buttonsData;

end architecture;




