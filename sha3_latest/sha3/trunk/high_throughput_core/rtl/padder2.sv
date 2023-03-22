module padder2(in, byte_num, out);//padder cho SHA3-256

    input      [63:0] in;
    input      [3:0]  byte_num;
    output reg [63:0] out;
    
    always @ (*)
      case (byte_num)
        0: out = 64'h8600000000000000;
        1: out = {in[63:56], 56'h86000000000000};
        2: out = {in[63:48], 48'h860000000000};
        3: out = {in[63:40], 40'h8600000000};
        4: out = {in[63:32], 32'h86000000};
        5: out = {in[63:24], 24'h860000};
        6: out = {in[63:16], 16'h8600};
        7: out = {in[63:8],   8'h86};
        8: out = {in[63:0],   8'h00}; // Extra case for SHA3-256
      endcase
endmodule
