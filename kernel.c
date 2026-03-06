#include "vga.h"

void kmain() {
    uint8_t color = vga_make_color(VGA_WHITE, VGA_BLACK);
    vga_clear(color);
    vga_print("Hello world!\n", color);
    vga_print("Other color test.\n", vga_make_color(VGA_BLUE, VGA_YELLOW));
    while (1);
}