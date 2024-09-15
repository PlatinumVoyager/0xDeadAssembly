global _start

section .data
    data: db "000000000000000", 0, 10
    data_len:       ; dynamic length, 1 label
    
; GPR's (General Purpose Registers) available are 16
; they are 64-bits wide and support operations on byte, word, doubleword, and
; quadword integers

; The stack pointer size is 64-bits, stack size can't be controlled by a bit
; in the SS descriptor as it is on non-64-bit modes, nor can it be overriden
; by an instruction prefix

; Control and Debug registers are expanded to 64-bits

; The memory that the processor addresses on its bus is called "Physical Memory"

section .text
_start:
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, data               ; const char *str
    mov rdx, data_len - data    ; ssize_t sz
    syscall

; exit
    mov rax, 60
    xor rdi, rdi
    syscall
    
; Any OS designed to work with IA-32 or Intel 64 processor will use the processors
; memory management facilities to access memory

; When employing the processors memory management facilities, programs do not
; directly address physical memory. Instead they access memory using one of three
; memory models: flat, segmented, or real address mode

; Flat memory model - Memory appears to the program as a single, continuous
; address space. This is known as "linear address space"

; Code, data, and stacks are all contained in this address space.
; This type of memory is "byte addressable" with addresses running contiguously
; from 0 to 2^32 - 1. Any address for any byte in linear address space is called
; a "linear address"

; Segmented memory model - Memory appears to the program as a group of independent
; address spaces called segments.

; Code, data and stacks are typically contained in separate segments
; To address a byte in a segment, a program issues a "logical address", 
; this consists of a "segment selector" and an offset (logical addresses are
; often referred to as 'far pointers')
; Segment selector - identifies the segment to be accessed 
; offset - identifies a byte in the address space of the segment
; Internally all of the segments that are defined for a system are mapped into a
; processors linear address space.

; To access a memory location the processor translates each logical address into
; a linear address. Such a translation is transparent to the application program

; Real-address mode memory model - Read "3.3.1 IA-32 Memory Models PG#69" from 
; "Intel 64 and IA-32 Architectures Software Developer's Manual"

; With the flat and segmented memory models, linear address space is mapped
; into the processors physical address space either directly or indirectly
; through paging.

; When using direct-mapping (non paging) each linear address space has a 1-to-1
; correspondence with a physical address. Linear addresses are sent out on the
; processors address lines without translation

; When using the IA-32 paging mechanism (paging enabled) linear address space is 
; divided into pages which are mapped to virtual memory. These pages are then
; mapped as needed into physical memory. When using paging the paging mechansim
; is transparent to the application program. All the application sees is a linear
; address space

; Typical paging mechansim extensions:

; Physical Address Extensions (PAE) - to address physical address space greater
; than 4 GBytes

; Page Size Extensions (PSE) - to map a linear address to a physical address
; in 4-MBytes pages
