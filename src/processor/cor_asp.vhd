library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

use work.address_constants;

-- library work;
-- use work.TdmaMinTypes.all;

entity cor_asp is
    port (
        clock         : in  std_logic;
        global_reset  : in  std_logic;
        global_enable : in  std_logic;

        -- recv_data     : in  tdma_min_data;
        -- recv_addr     : in  tdma_min_addr;
        -- send_data     : out tdma_min_data;
        -- send_addr     : out tdma_min_addr

        recv_data     : in  std_logic_vector(31 downto 0);
        recv_addr     : in  std_logic_vector(7 downto 0);
        send_data     : out std_logic_vector(31 downto 0);
        send_addr     : out std_logic_vector(7 downto 0)
    );
end cor_asp;

architecture arch of cor_asp is

    signal config_register_write_enable         : std_logic;
    signal config_reset                         : std_logic;

    -- NOC -> COR CONFIG REGS
    signal config_enable                        : std_logic_vector(0 downto 0);
    signal config_address                       : std_logic_vector(3 downto 0);
    signal config_bit_mode                      : std_logic_vector(1 downto 0);
    signal config_correlation_window            : std_logic_vector(4 downto 0);
    signal config_adc_wait                      : std_logic_vector(3 downto 0);

    -- COR CONFIG REGS -> COR
    signal registered_config_enable             : std_logic_vector(0 downto 0);
    signal registered_config_address            : std_logic_vector(3 downto 0);
    signal registered_config_bit_mode           : std_logic_vector(1 downto 0);
    signal registered_config_correlation_window : std_logic_vector(4 downto 0);
    signal registered_config_adc_wait           : std_logic_vector(3 downto 0);

    signal num_unaddressed                      : integer := 0;
    signal index_right                          : integer := 0;
    signal index_left                           : integer := 0;

    signal correlation_test                     : std_logic_vector(31 downto 0);

begin

    -- COR CONFIG REGS
    address_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => config_reset,
            write_enable => config_register_write_enable,
            data_in      => config_address,
            data_out     => registered_config_address
        );

    bit_mode_register : entity work.register_buffer
        generic map(
            width => 2
        )
        port map(
            clock        => clock,
            reset        => config_reset,
            write_enable => config_register_write_enable,
            data_in      => config_bit_mode,
            data_out     => registered_config_bit_mode
        );

    correlation_window_register : entity work.register_buffer
        generic map(
            width => 5
        )
        port map(
            clock        => clock,
            reset        => config_reset,
            write_enable => config_register_write_enable,
            data_in      => config_correlation_window,
            data_out     => registered_config_correlation_window
        );

    enable_register : entity work.register_buffer
        generic map(
            width => 1
        )
        port map(
            clock        => clock,
            reset        => config_reset,
            write_enable => config_register_write_enable,
            data_in      => config_enable,
            data_out     => registered_config_enable
        );

    adc_wait_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => config_reset,
            write_enable => config_register_write_enable,
            data_in      => config_adc_wait,
            data_out     => registered_config_adc_wait
        );

    -- [31  ..  28] [27 .. 24] [23 .. 20] [19  ..  18] [ 17 ] [  16  ] [15  ..  12] [11    ..    7]
    -- [ msg type ] [  addr  ] [  dest  ] [ bit mode ] [ en ] [ rset ] [ adc wait ] [ corr window ]

    -- Wire config packets
    config_address               <= recv_data(27 downto 24);
    config_bit_mode              <= recv_data(19 downto 18);
    config_enable(0)             <= recv_data(17);
    config_reset                 <= recv_data(16);
    config_adc_wait              <= recv_data(15 downto 12);
    config_correlation_window    <= recv_data(11 downto 7);

    config_register_write_enable <= '1' when recv_data(31 downto 28) = address_constants.message_type_config else
                                    '0';

    process (clock)
        variable correlation : signed(31 downto 0) := (others => '0');

        type array_type is
        array(0 to 31) of signed(15 downto 0);

        variable signal_array : array_type := (others => (others => '0'));
    begin
        if rising_edge(clock) then
            send_data <= (others => '0');
            send_addr <= (others => '0');
            if (recv_data(31 downto 28) = address_constants.message_type_config) then
                index_right <= (to_integer(unsigned(recv_data(11 downto 7))) + 1) / 2;
                index_left  <= ((to_integer(unsigned(recv_data(11 downto 7))) + 1) / 2) - 1;
                correlation := (others => '0');
                if config_reset = '1' then
                    signal_array := (others => (others => '0'));
                    num_unaddressed <= 0;
                end if;
            elsif registered_config_enable(0) = '1' then
                -- INCOMING DATA
                if recv_data(31 downto 28) = address_constants.message_type_average then
                    shift : for i in 31 downto 1 loop
                        signal_array(i) := signal_array(i - 1);
                    end loop shift;
                    signal_array(0) := signed(recv_data(15 downto 0));
                    num_unaddressed <= num_unaddressed + 1;
                else
                    if num_unaddressed > to_integer(unsigned(registered_config_adc_wait)) then
                        if index_right < registered_config_correlation_window then
                            correlation := correlation + signal_array(index_right) * signal_array(index_left);
                            index_right <= index_right + 1;
                            index_left  <= index_left - 1;
                        else
                            send_data       <= address_constants.message_type_correlate & "00000000" & std_logic_vector(resize(correlation, 20));
                            send_addr       <= "0000" & registered_config_address;
                            index_right     <= (to_integer(unsigned(registered_config_correlation_window)) + 1) / 2;
                            index_left      <= ((to_integer(unsigned(registered_config_correlation_window)) + 1) / 2) - 1;
                            num_unaddressed <= 0;
                            correlation := (others => '0');
                        end if;
                    else
                    end if;
                end if;
            else
            end if;
        end if;

        correlation_test <= correlation;

    end process;

end architecture; -- arch