library verilog;
use verilog.vl_types.all;
entity iota is
    port(
        state_in        : in     vl_logic_vector(1599 downto 0);
        round           : in     vl_logic_vector(4 downto 0);
        state_out       : out    vl_logic_vector(1599 downto 0)
    );
end iota;
