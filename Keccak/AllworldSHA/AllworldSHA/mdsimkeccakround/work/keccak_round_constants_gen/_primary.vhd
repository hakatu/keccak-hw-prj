library verilog;
use verilog.vl_types.all;
entity keccak_round_constants_gen is
    port(
        round_number    : in     vl_logic_vector(4 downto 0);
        round_constant_signal_out: out    vl_logic_vector(63 downto 0)
    );
end keccak_round_constants_gen;
