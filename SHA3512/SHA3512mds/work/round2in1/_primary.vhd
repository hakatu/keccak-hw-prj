library verilog;
use verilog.vl_types.all;
entity round2in1 is
    port(
        \in\            : in     vl_logic_vector(1599 downto 0);
        round_const_1   : in     vl_logic_vector(63 downto 0);
        round_const_2   : in     vl_logic_vector(63 downto 0);
        \out\           : out    vl_logic_vector(1599 downto 0)
    );
end round2in1;
