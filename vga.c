#include "vga.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY (uint16_t*)0xB8000

static int cursor_row = 0;
static int cursor_col = 0;

// combine a character and color into one 16 bit val
// low = char, high = attribute / colors (fg / bg)
static inline uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t)c | (uint16_t)color << 8;
}

static inline void outb(uint16_t port, uint8_t value) {
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

static void vga_update_cursor() {
    uint16_t pos = cursor_row * VGA_WIDTH + cursor_col;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t)(pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t)(pos >> 8));
}

void vga_clear(uint8_t color) {
    uint16_t *vga = VGA_MEMORY;

    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga[i] = vga_entry(' ', color);
    }

    cursor_row = 0;
    cursor_col = 0;

    vga_update_cursor();
}

static void vga_scroll() {
    uint16_t *vga = VGA_MEMORY;

    // move every row up by one
    for (int row = 0; row < VGA_HEIGHT - 1; row++) {
        for (int col = 0; col < VGA_WIDTH; col++) {
            vga[row * VGA_WIDTH + col] = vga[(row + 1) * VGA_WIDTH + col];
        }
    }

    // clear the last row
    for (int col = 0; col < VGA_WIDTH; col++) {
        vga[(VGA_HEIGHT - 1) * VGA_WIDTH + col] = vga_entry(' ', 0x07);
    }

    cursor_row = VGA_HEIGHT - 1;
}

void vga_putchar(char c, uint8_t color) {
    uint16_t *vga = VGA_MEMORY;

    if (c == '\n') {
        cursor_col = 0;
        cursor_row++;
    } else if (c == '\r') {
        cursor_col = 0;
    } else {
        vga[cursor_row * VGA_WIDTH + cursor_col] = vga_entry(c, color);
        cursor_col++;
        if (cursor_col >= VGA_WIDTH) {
            cursor_col = 0;
            cursor_row++;
        }
    }

    if (cursor_row >= VGA_HEIGHT) {
        vga_scroll();
    }

    vga_update_cursor();
}

void vga_print(const char *str, uint8_t color) {
    for (int i = 0; str[i] != 0; i++) {
        vga_putchar(str[i], color);
    }
}