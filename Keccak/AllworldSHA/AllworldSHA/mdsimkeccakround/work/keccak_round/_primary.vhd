library verilog;
use verilog.vl_types.all;
entity keccak_round is
    generic(
        WIDTH           : integer := 1600
    );
    port(
        \in\            : in     vl_logic_vector;
        round_constant_signal: in     vl_logic_vector(63 downto 0);
        \out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end keccak_round;
