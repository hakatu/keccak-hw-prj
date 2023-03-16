library verilog;
use verilog.vl_types.all;
entity padder is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \in\            : in     vl_logic_vector(63 downto 0);
        in_ready        : in     vl_logic;
        is_last         : in     vl_logic;
        byte_num        : in     vl_logic_vector(2 downto 0);
        buffer_full     : out    vl_logic;
        \out\           : out    vl_logic_vector(575 downto 0);
        out_ready       : out    vl_logic;
        f_ack           : in     vl_logic
    );
end padder;
