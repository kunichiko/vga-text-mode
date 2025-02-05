module console # (
    parameter BIT_WIDTH = 12,
    parameter BIT_HEIGHT = 11,
    parameter FONT_WIDTH = 8,
    parameter FONT_HEIGHT = 16
) (
    input wire clk_pixel,
    input wire [7:0] codepoint,
    input wire [7:0] charattr,
    input wire [BIT_WIDTH-1:0] cx,
    input wire [BIT_HEIGHT-1:0] cy,
    output reg [23:0] rgb = 24'd0
);

wire [127:0] glyph;
glyphmap glyphmap(.codepoint(codepoint), .glyph(glyph));

wire [23:0] fgrgb, bgrgb;
wire blink;
wire glyph_bit;
reg glyph_bit_d = 0;
attributemap attributemap(.charattr(charattr), .fgrgb(fgrgb), .bgrgb(bgrgb), .blink(blink));

reg [BIT_HEIGHT-1:0] prevcy = 0;
reg [$clog2(FONT_HEIGHT)-1:0] vindex = 0;
reg [$clog2(FONT_WIDTH)-1:0] hindex = 0;
reg [5:0] blink_timer = 0;

assign glyph_bit = glyph[{~vindex, ~hindex}];

always @(posedge clk_pixel)
begin
    if (cx == 0 && cy == 0)
    begin
        prevcy <= 0;
        vindex <= 0;
        hindex <= 0;
        blink_timer <= blink_timer + 1'b1;
    end
    else if (prevcy != cy)
    begin
        prevcy <= cy;
        vindex <= vindex == FONT_HEIGHT - 1 ? 1'b0 : vindex + 1'b1;
        hindex <= 0;
    end
    else
    begin
        hindex <= hindex == FONT_WIDTH - 1 ? 1'b0 : hindex + 1'b1;
    end

    if (blink && blink_timer[5])
        rgb <= bgrgb;
    else begin
        glyph_bit_d <= glyph_bit;
        //if ((hindex > 0) && (hindex < 7)) 
        if (hindex > 0)
            rgb <= (glyph_bit || glyph_bit_d) ? fgrgb : bgrgb;
        else
            rgb <= glyph_bit ? fgrgb : bgrgb;
    end
end
endmodule
