library verilog;
use verilog.vl_types.all;
entity f_permutation is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \in\            : in     vl_logic_vector(575 downto 0);
        in_ready        : in     vl_logic;
        ack             : out    vl_logic;
        \out\           : out    vl_logic_vector(1599 downto 0);
        out_ready       : out    vl_logic
    );
end f_permutation;
