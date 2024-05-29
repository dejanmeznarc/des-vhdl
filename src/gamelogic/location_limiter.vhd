library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.screen_pkg.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
--deprecated
entity location_limiter is
  port (
    locLimitR      : out unsigned(2 downto 0) := "010";
    locLimitL      : out unsigned(2 downto 0) := "100";
    location       : in  unsigned(2 downto 0) := "100";
    screen_barrier : in  screen_t;
    screen_fig     : in  screen_t
  );
end entity;

architecture rtl of location_limiter is

  signal limitAbsR : unsigned(2 downto 0) := "000";
  signal limitAbsL : unsigned(2 downto 0) := "100";

  type limits_t is array (0 to 6) of unsigned(2 downto 0);

  signal leftLimits : limits_t;

begin

  -- location limiter
  locLimiter: for i in 0 to 6 generate
    -- limit_left_location <= (screen_barrier(0) and (screen_fig(0) sll 1)) > 0;
    -- limit_left_location <= (screen_barrier(0) and (screen_fig(0) srl)) > 0;
    leftLimits(i) <= (location + 1) when (('0' & screen_barrier(i)) and (screen_fig(i) sll 1)) > 0 else
                    limitAbsL;

  end generate;

  --TODO: location thingie
  -- location should be in process when clk gets high (as well as down movement)
  -- checks if there is collision, if it is, move location back; else proceeed
  -- that is fundemental design flaw. this will only be worse, when we try to implement rotation.
  -- we need to redo whole game logic system.
  --more at the gamelogic
  locLimitR <= limitAbsR;
end architecture;











