void main() {
    while (1) {
        // Halt the CPU
        asm("hlt");
    }
}

extern void main();

void _start() {
    main();
}