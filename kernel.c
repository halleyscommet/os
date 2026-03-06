#include "vga.h"

void kmain() {
    uint8_t color = vga_make_color(VGA_WHITE, VGA_BLACK);
    vga_clear(color);
    while (1);
}