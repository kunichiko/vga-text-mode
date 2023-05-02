module attributemap (
           input wire [7:0] charattr,
           output wire [23:0] fgrgb,
           output wire [23:0] bgrgb,
           output wire blink
);
// See https://en.wikipedia.org/wiki/Video_Graphics_Array#Color_palette
assign blink = charattr[7];
assign bgrgb = charattr[6:4] == 3'b000 ? 24'h000000
    : charattr[6:4] == 3'b001 ? 24'h0000AA
    : charattr[6:4] == 3'b010 ? 24'h00AA00
    : charattr[6:4] == 3'b011 ? 24'h00AAAA
    : charattr[6:4] == 3'b100 ? 24'hAA0000
    : charattr[6:4] == 3'b101 ? 24'hAA00AA
    : charattr[6:4] == 3'b110 ? 24'hAA5500
    : charattr[6:4] == 3'b111 ? 24'hAAAAAA
    : 24'h000000;

assign fgrgb = charattr[3:0] == 4'h0 ? 24'h000000
    : charattr[3:0] == 4'h1 ? 24'h0000AA
    : charattr[3:0] == 4'h2 ? 24'h00AA00
    : charattr[3:0] == 4'h3 ? 24'h00AAAA
    : charattr[3:0] == 4'h4 ? 24'hAA0000
    : charattr[3:0] == 4'h5 ? 24'hAA00AA
    : charattr[3:0] == 4'h6 ? 24'hAA5500
    : charattr[3:0] == 4'h7 ? 24'hAAAAAA
    : charattr[3:0] == 4'h8 ? 24'h555555
    : charattr[3:0] == 4'h9 ? 24'h5555FF
    : charattr[3:0] == 4'hA ? 24'h55FF55
    : charattr[3:0] == 4'hB ? 24'h55FFFF
    : charattr[3:0] == 4'hC ? 24'hFF5555
    : charattr[3:0] == 4'hD ? 24'hFF55FF
    : charattr[3:0] == 4'hE ? 24'hFFFF55
    : charattr[3:0] == 4'hF ? 24'hFFFFFF
    : 24'h000000;

endmodule
