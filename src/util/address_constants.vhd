library ieee;
use ieee.std_logic_1164.all;

package address_constants is

    constant message_type_config      : std_logic_vector := "1000";
    constant message_type_average     : std_logic_vector := "1001";
    constant message_type_correlate   : std_logic_vector := "1010";
    constant message_type_peak_detect : std_logic_vector := "1111";

end package; -- common_network_addresses