library verilog;
use verilog.vl_types.all;
entity rconst2in1 is
    port(
        i               : in     vl_logic_vector(11 downto 0);
        rc1             : out    vl_logic_vector(63 downto 0);
        rc2             : out    vl_logic_vector(63 downto 0)
    );
end rconst2in1;
