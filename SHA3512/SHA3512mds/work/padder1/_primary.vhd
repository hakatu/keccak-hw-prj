library verilog;
use verilog.vl_types.all;
entity padder1 is
    port(
        \in\            : in     vl_logic_vector(63 downto 0);
        byte_num        : in     vl_logic_vector(2 downto 0);
        \out\           : out    vl_logic_vector(63 downto 0)
    );
end padder1;
