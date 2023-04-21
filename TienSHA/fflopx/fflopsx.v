//////////////////////////////////////////////////////////////////////////////////
//
//  Arrive Technologies
//
// Filename        : fflopsx.v
// Description     : variable size flip flop
//
// Author          : ducdd@atvn.com.vn
// Created On      : Tue Jul 29 18:00:29 2003
// History (Date, Changed By)
// Thu Jun 26 15:53:35 2015, tund@HW-NDTU, modify to FF SYNC
//////////////////////////////////////////////////////////////////////////////////
(* keep_hierarchy = "yes" *) module fflopsx
    (
     clk,
     rst,
     idat,
     odat
     );

parameter WIDTH = 8;
parameter RESET_VALUE = {WIDTH{1'b0}};

input   clk, rst;

input  [WIDTH-1:0] idat;

output [WIDTH-1:0] odat;
reg    [WIDTH-1:0] odat = RESET_VALUE;

//always @ (posedge clk or negedge rst_)
always @ (posedge clk)
    begin
    if(rst) odat <= RESET_VALUE;
    else odat <= idat;
    end

endmodule
