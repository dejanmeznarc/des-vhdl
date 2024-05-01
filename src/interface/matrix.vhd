library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.screen_pkg.all;

entity matrix is
  port (
    clk         : in  std_logic;
    matrix_data : out unsigned(7 downto 0);

    screen      : in  screen_t

  );

end entity;

architecture rtl of matrix is
  signal curLine      : unsigned(2 downto 0);
  signal reverseCol   : unsigned(4 downto 0);
  signal pwmCounter   : unsigned(2 downto 0);
  signal pwmDutyCycle : unsigned(2 downto 0) := "010";
begin

  -- sweep between line numbers for matrix display
  lineSweeper: process (pwmCounter)
  begin
    if (rising_edge(pwmCounter(2))) then -- go to next line only when pwm duty cycle finishe
      if (curLine > 7) then
        curLine <= "000";
      else
        curLine <= curLine + 1;
      end if;
    end if;
  end process; -- lineSweeper

  -- reverse bit order TODO: find better way
  reverseCol <= screen(to_integer(curLine))(0) --
    & screen(to_integer(curLine))(1) --
    & screen(to_integer(curLine))(2) --
    & screen(to_integer(curLine))(3) --
    & screen(to_integer(curLine))(4);

  pwmCounterProcess: process (clk)
  begin
    if rising_edge(clk) then
      pwmCounter <= pwmCounter + 1;
    end if;
  end process; -- pwmCounterProcess

  -- count nubmer of bits
  ones_counter_inst: entity work.ones_counter
    port map (
      A    => reverseCol,
      ones => pwmDutyCycle
    );

  -- (curLine + 1) -> line numbers are offset by one
  -- turn off leds and wait for certian time
  matrix_data <= (curLine + 1) & reverseCol when pwmCounter > not(pwmDutyCycle) else (others => '0');
end architecture;



