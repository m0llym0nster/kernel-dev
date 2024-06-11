[BITS 32]
global start
start:
    mov esp, _sys_stack  ;points to stack in new stack area
    jmp stublet

;must be 4 byte aligned
ALIGN 4
mboot:
    ;multiboot macros
    MULTIBOOT_PAGE_ALIGN equ 1<<0
    MULTIBOOT_MEMORY_INFO equ 1<<1
    MULTIBOOT_HEADER_MAGIC equ 0x1BADB002
    MULTIBOOT_HEADER_FLAGS equ MULTIBOOT_PAGE_ALIGN|MULTIBOOT_MEMORY_INFO 
    MULTIBOOT_CHECKSUM equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

    ; grub multiboot header/boot signature
    dd MULTIBOOT_HEADER_MAGIC
    dd MULTIBOOT_HEADER_FLAGS
    dd MULTIBOOT_CHECKSUM

;endless loop here, later extern_main and call_main exist before the loop jmp$
stublet:
    extern main
    call main
    jmp $

;area for loading the GDT here

;Service routines (ISRs) here

;definition of BSS section, using stack for now (BSS = uninitialized variables)
SECTION .bss
    resb 8192  ;reserves 8KB of memory
_sys_stack:
