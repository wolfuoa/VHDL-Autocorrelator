library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all
use ieee.std_logic_1164.all;

use work.address_constants;

library work;
use work.TdmaMinTypes.all;

entity COR_ASP is
    port (
        clock         : in  std_logic;
        global_reset  : in  std_logic;
        global_enable : in  std_logic;

        recv_data     : in  tdma_min_data;
        recv_addr     : in  tdma_min_addr;
        send_data     : out tdma_min_data;
        send_addr     : out tdma_min_addr
    );
end COR_ASP;

architecture arch of COR_ASP is

    signal config_register_write_enable         : std_logic;
    signal config_reset                         : std_logic;

    -- NOC -> COR CONFIG REGS
    signal config_enable                        : std_logic;
    signal config_address                       : std_logic;
    signal config_bit_mode                      : std_logic_vector(1 downto 0);
    signal config_correlation_window            : std_logic_vector(4 downto 0);
    signal config_adc_wait                      : std_logic_vector(3 downto 0);

    -- COR CONFIG REGS -> COR
    signal registered_config_enable             : std_logic;
    signal registered_config_address            : std_logic;
    signal registered_config_bit_mode           : std_logic_vector(1 downto 0);
    signal registered_config_correlation_window : std_logic_vector(4 downto 0);
    signal registered_config_adc_wait           : std_logic_vector(3 downto 0);

    signal count                                : integer := 0;

begin

    -- COR CONFIG REGS
    address_register : entity work.register port map (
        clock        => clock,
        reset        => config_reset,
        write_enable => config_register_write_enable,
        data_in      => config_address,
        data_out     => registered_config_address
        );

    bit_mode_register : entity work.register port map (
        clock        => clock,
        reset        => config_reset,
        write_enable => config_register_write_enable,
        data_in      => config_bit_mode,
        data_out     => registered_config_bit_mode
        );

    correlation_window_register : entity work.register port map (
        clock        => clock,
        reset        => config_reset,
        write_enable => config_register_write_enable,
        data_in      => config_correlation_window,
        data_out     => registered_config_correlation_window
        );

    enable_register : entity work.register port map (
        clock        => clock,
        reset        => config_reset,
        write_enable => config_register_write_enable,
        data_in      => config_enable,
        data_out     => registered_config_enable
        );

    enable_register : entity work.register port map (
        clock        => clock,
        reset        => config_reset,
        write_enable => config_register_write_enable,
        data_in      => config_adc_wait,
        data_out     => registered_config_adc_wait
        );

    -- [31  ..  28] [27 .. 24] [23 .. 20] [19  ..  18] [ 17 ] [  16  ] [15  ..  12] [11    ..    7]
    -- [ msg type ] [  addr  ] [  dest  ] [ bit mode ] [ en ] [ rset ] [ adc wait ] [ corr window ]

    -- Wire config packets
    config_address            <= recv_data(27 downto 24);
    config_bit_mode           <= recv_data(19 downto 18);
    config_enable             <= recv_data(17);
    config_reset              <= recv_data(16);
    config_adc_wait           <= recv_data(15 downto 12);
    config_correlation_window <= recv_data(11 downto 7);

    -- Propagate data to registers if a new config message was received
    process (recv_data)
    begin
        if (recv_data(31 downto 0) = message_type_config) then
            config_register_write_enable <= '1';
        else
            config_register_write_enable <= '0';
        end if;
    end process;

    process (clock)
        variable data        : signed(15 downto 0) := (others => '0');
        variable data_result : signed(15 downto 0) := (others => '0');
        variable correlation : signed(31 downto 0) := (others => '0');
        variable index       : integer             := 0;

        type array_type is
        array(0 to 31) of signed(15 downto 0);

        variable signal_array : array_type;
        variable shift_array  : array_type;
    begin

        send_data <= (others => '0');
        send_addr <= (others => '0');

        if registered_config_reset = '1' then
            signal_array <= (others => (others => '0'));
            shift_array  <= (others => (others => '0'));
            count        <= 0;
        elsif rising_edge(clock) then
            if registered_config_enable = '1' then
                -- INCOMING DATA
                if recv_data(31 downto 28) = message_type_average then
                    data_array(count + 9) := recv_data(15 downto 0);
                    shift_array(count)    := recv_data(15 downto 0);
                else
                    if count > 10 then
                        if index < 31 then
                            correlation := correlation + data_array(index) * shift_array(index);
                            index       := index + 1;
                        else
                            -- Fruit Loops
                            shit : for i in 31 downto 1 loop
                                shift_array(i) := shift_array(i - 1);
                            end loop shit;
                            shift_array(0) := (others => '0');

                            send_data <= message_type_correlate & "000000000000" & resize(correlation, 16);
                            send_addr <= registered_config_address;

                            index       := 1;
                            correlation := (others => '0');
                        end if;
                    else
                    end if;
                end if;
            else
            end if;
        end if;

    end process;

end architecture; -- arch