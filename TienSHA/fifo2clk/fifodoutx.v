//////////////////////////////////////////////////////////////////////////////////
//
//  Arrive Technologies
//
// Filename        : fifodoutx.v
// Description     : The fifo use registers as a memorie.
//
// Author          : ngocbq@atvn.com.vn
// Created On      : Wed Jul 30 09:49:23 2003
// History (Date, Changed By)
//  Wed Oct 01 13:27:19 2008, ddduc@HW-DDDUC, add fifolen output
//  Wed Oct 01 14:57:30 2008, ddduc@HW-DDDUC, change fifodout without flip flops
//      replace pohfifo into memfifo
//  Thu Aug 20 10:35:06 2015, cuongnv@HW-NVCUONG, change rst_ to rst
//////////////////////////////////////////////////////////////////////////////////
module fifodoutx
    (
     clk,
     rst,
     fiford,        // fifo read signal
     fifowr,        // fifo write signal
     fifodin,       // fifo data in
     fifofull,      // fifo full signal, high when fifo is full
     fifolen,       // fifo len
     notempty,      // fifo not empty signal, high when fifo is not empty
     fifodout       // fifo data out
     );

parameter ADDRBIT = 4;
parameter LENGTH = 16;
parameter WIDTH = 8;

input   clk,
        rst,
        fiford,
        fifowr;

input [WIDTH-1:0] fifodin;

output  fifofull,
        notempty;

output [ADDRBIT:0] fifolen;

output  [WIDTH-1:0] fifodout;


/* synthesis syn_ramstyle="registers" */ reg     [WIDTH-1:0]     memfifo [LENGTH-1:0];
reg     [ADDRBIT:0]     fifo_len = {1'b0,{ADDRBIT{1'b0}}};
reg     [ADDRBIT-1:0]   wrcnt = {ADDRBIT{1'b0}};

wire    fifoempt;
assign  fifoempt    =   (fifo_len=={1'b0,{ADDRBIT{1'b0}}});

wire    fifonemp;
assign  fifonemp    =   !fifoempt;

wire    fifofull;
assign  fifofull    =   (fifo_len[ADDRBIT]);

//assign  fifolen     =   fifo_len;

wire    write;
assign  write       =   (fifowr& !fifofull);

wire    read;
//assign  read        =   (fiford& !fifoempt);

wire    [ADDRBIT-1:0]   rdcnt;
assign  rdcnt       =   wrcnt - fifo_len[ADDRBIT-1:0];

//integer     i;
always @(posedge clk)
    begin
    //if(rst) for(i=0; i<LENGTH; i=i+1) memfifo[i] <= {WIDTH{1'b0}};
    if(write) memfifo[wrcnt] <= fifodin;
    end


always @(posedge clk)
    begin
    if(rst)       wrcnt <= {ADDRBIT{1'b0}};
    else if(write)  wrcnt    <= wrcnt  + 1'b1;
    end

always @(posedge clk)
    begin
    if(rst) fifo_len  <= {1'b0,{ADDRBIT{1'b0}}};
    else
        case({read,write})
        2'b01: fifo_len <= fifo_len + 1'b1;
        2'b10: fifo_len <= fifo_len - 1'b1;
        default: fifo_len <= fifo_len;
        endcase
    end

// Improve timing and prevent registers array to be used as logic
reg         notempty = 1'b0;
always @ (posedge clk)
    begin
    if (rst)    notempty <= 1'b0;
    else        notempty <= fifonemp | (!fiford & notempty);
    end

assign          read = fifonemp & (!notempty | fiford);

reg [WIDTH-1:0] fifodout = {WIDTH{1'b0}};
always @ (posedge clk)
    begin
    if (rst)        fifodout <= {WIDTH{1'b0}};
    else if (read)  fifodout <= memfifo[rdcnt];
    else            fifodout <= fifodout;   
    end

reg     [ADDRBIT:0] fifolen = {1'b0,{ADDRBIT{1'b0}}};
wire                readnew;
assign              readnew = notempty & fiford;

always @(posedge clk)
    begin
    if(rst) fifolen  <= {1'b0,{ADDRBIT{1'b0}}};
    else
        case({readnew,write})
        2'b01: fifolen <= fifolen + 1'b1;
        2'b10: fifolen <= fifolen - 1'b1;
        default: fifolen <= fifolen;
        endcase
    end

//assign fifodout = memfifo[rdcnt];

endmodule // fifodoutx
