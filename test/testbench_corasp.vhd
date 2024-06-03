library ieee;
use ieee.std_logic_1164.all;

use work.address_constants;

entity testbench_corasp is
end testbench_corasp;

architecture arch of testbench_corasp is

    signal t_clock         : std_logic                     := '0';
    signal t_global_reset  : std_logic                     := '0';
    signal t_global_enable : std_logic                     := '1';
    signal t_recv_data     : std_logic_vector(31 downto 0) := (others => '0');
    signal t_recv_addr     : std_logic_vector(7 downto 0)  := (others => '0');
    signal t_send_data     : std_logic_vector(31 downto 0) := (others => '0');
    signal t_send_addr     : std_logic_vector(7 downto 0)  := (others => '0');

begin

    dut : entity work.cor_asp
        port map(
            clock         => t_clock,
            global_reset  => t_global_reset,
            global_enable => t_global_enable,
            recv_data     => t_recv_data,
            recv_addr     => t_recv_addr,
            send_data     => t_send_data,
            send_addr     => t_send_addr
        );

    -- [31  ..  28] [27 .. 24] [23 .. 20] [19  ..  18] [ 17 ] [  16  ] [15  ..  12] [11    ..    7]
    -- [ msg type ] [  addr  ] [  dest  ] [ bit mode ] [ en ] [ rset ] [ adc wait ] [ corr window ]

    process
        variable const_test_val : std_logic_vector(15 downto 0) := x"0002";

    begin
        t_recv_data <= address_constants.message_type_config & "0000" & "0000" & "00" & '1' & '0' & "0101" & "11111" & "0000000";

        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BEEF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"F00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"CAFE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BA5E";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"D00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"DEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"EEEE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FFFF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"AAAA";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BEEF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"F00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"CAFE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BA5E";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"D00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"DEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"EEEE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FFFF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"AAAA";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BEEF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"F00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"CAFE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"BA5E";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"D00D";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"DEED";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"EEEE";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FFFF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"AAAA";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"FFFF";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & x"AAAA";
        wait for 40 ns;
        t_recv_data <= "0000" & "000000000000" & x"0000";
        wait for 40 ns;
        t_recv_data <= "0000" & "000000000000" & x"0000";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_config & "0000" & "0000" & "00" & '1' & '0' & "0101" & "00110" & "0000000";
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= address_constants.message_type_signal & "000000000000" & const_test_val;
        wait for 40 ns;
        t_recv_data <= "0000" & "000000000000" & x"0000";
        wait for 40 ns;
        wait;
    end process;

    process
    begin
        t_clock <= '1';
        wait for 20 ns;
        t_clock <= '0';
        wait for 20 ns;
    end process;

end architecture; -- arch