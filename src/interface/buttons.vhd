library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

entity buttons is
  port (
    clk     : in  std_logic;
    btn_in  : in  unsigned(3 downto 0) := (others => '0');
    buttons : out unsigned(3 downto 0) := (others => '0');
    pin_led : out unsigned(7 downto 0)
  );
end entity;

architecture rtl of buttons is

  type btn_history_t is array (0 to 3) of unsigned(7 downto 0);

  signal history : btn_history_t;


  signal buttonsSig : unsigned(3 downto 0) := (others => '0');

begin

  btn_shift_reg: process (clk)
  begin
    if rising_edge(clk) then


      -- history(0) <= history(0)(6 downto 0) & btn_in(0);


      allbtns: for i in 0 to 3 loop
        history(i) <= history(i)(6 downto 0) & btn_in(i);
      end loop; -- allbtns
    end if;
  end process; -- btn_shift_reg


  lbl: for i in 0 to 3 generate
  buttonsSig(i) <= '1' when history(i) = "1111111" else '0';
  end generate;

  pin_led(5 downto 0) <= history(0)(5 downto 0);
  pin_led(7) <= buttonsSig(0);

  buttons <= buttonsSig;

end architecture; -- arch
