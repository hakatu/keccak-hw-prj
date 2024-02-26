////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : alsyncram112x.v
// Description  : .
//
// Author       : nlgiang@HW-NLGIANG
// Created On   : Wed Apr 14 10:41:19 2004
// History (Date, Changed By)
//  Mon Jul 27 14:41:51 2009, ndtu@HW-NDTU
//      add parameter MAXDEPTH for better resource usage
//
////////////////////////////////////////////////////////////////////////////////

module alsyncram112x (
    data,
    wren,
    wraddress,
    rdaddress,
    wrclock,
    rdclock,
    q);


parameter ADDRBIT = 6;
parameter DEPTH = 64;
parameter WIDTH = 8;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;
parameter           NUMCLK= 1;// 1 is one clock domain, 2 is two clock domain

input [WIDTH-1:0] data;
input       wren;
input [ADDRBIT-1:0] wraddress;
input [ADDRBIT-1:0] rdaddress;
input       wrclock;
input       rdclock;
output [WIDTH-1:0] q;

`ifdef XILINX
localparam RAMSIZE = WIDTH*DEPTH;

/*
`define ramtypecnv(a,b) {(a == "MLAB") ? "distributed" : (b <= 512) ? "distributed" : "block"}
localparam RAMTYPE = `ramtypecnv(TYPE,RAMSIZE);
(* ram_style = RAMTYPE *) reg [WIDTH-1:0] ram [DEPTH-1:0];
*/

wire [WIDTH-1:0]   q;
reg [WIDTH-1:0]    do;
reg [WIDTH-1:0]    q_reg;

generate 
    if ((TYPE == "MLAB")||(RAMSIZE<=`XRAMDISTMAXSIZE)||(DEPTH<=`XRAMDISTMAXDEPTH))
        begin
        (* ram_style = "distributed" *)  reg [WIDTH-1:0] ram [DEPTH-1:0]/* synthesis syn_ramstyle=no_rw_check*/;
        
        always @ (posedge wrclock)
            begin
            if (wren)
                begin
                ram[wraddress] <= data;
                end        
            end

always @ (posedge rdclock)
    begin
    do  <= ram[rdaddress];
    end
end

    else //Auto
        begin 
        reg [WIDTH-1:0] ram [DEPTH-1:0]/* synthesis syn_ramstyle=no_rw_check*/;
        
        always @ (posedge wrclock)
            begin
            if (wren)
                begin
                ram[wraddress] <= data;
                end        
            end

always @ (posedge rdclock)
    begin
    do  <= ram[rdaddress];
    end
end

endgenerate

//integer  i;
//initial  for  (i=0;  i<DEPTH;  i=i+1)  ram[i]  =  0;


always @ (posedge rdclock)
    begin
    q_reg  <= do;
    end

assign q = q_reg;

`else //Altera

wire [WIDTH-1:0]     sub_wire0;
wire [WIDTH-1:0]     q = sub_wire0[WIDTH-1:0];

    altsyncram  altsyncram_component (
                .wren_a (wren),
                .clock0 (wrclock),
                .clock1 (rdclock),
                .address_a (wraddress),
                .address_b (rdaddress),
                .data_a (data),
                .q_b (sub_wire0));
    defparam
        altsyncram_component.operation_mode = "DUAL_PORT",
        altsyncram_component.width_a = WIDTH, //8,
        altsyncram_component.widthad_a = ADDRBIT, //5,
        altsyncram_component.numwords_a = DEPTH, //32,
        altsyncram_component.width_b = WIDTH, //8,
        altsyncram_component.widthad_b = ADDRBIT, //5,
        altsyncram_component.numwords_b = DEPTH, //32,
        altsyncram_component.lpm_type = "altsyncram",
        altsyncram_component.maximum_depth = MAXDEPTH,
        altsyncram_component.width_byteena_a = 1,
        altsyncram_component.outdata_reg_b = "CLOCK1",
        altsyncram_component.indata_aclr_a = "NONE",
        altsyncram_component.wrcontrol_aclr_a = "NONE",
        altsyncram_component.address_aclr_a = "NONE",
        altsyncram_component.address_reg_b = "CLOCK1",
        altsyncram_component.address_aclr_b = "NONE",
        altsyncram_component.outdata_aclr_b = "NONE",
        altsyncram_component.ram_block_type = TYPE,
        altsyncram_component.intended_device_family = "Stratix";

`endif

endmodule
