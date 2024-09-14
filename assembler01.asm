global _start       ; expose to the linker as an entry point
                    ; makes _start accessible from other files

; produce object file and link statically
; nasm -f elf64 test1.asm -o test1.o && ld -m elf_x86_64 test1.o -o test1 ; ./test1

; section .data = used for declaring constants
section .data
    ; msg: as a label marks the beginning of a data block
    ; db = define byte
    ; could be written as `msg db "<string>" <opts>`
    msg: db "Hello, assembly!", 0, 10
    
    ; msg_end:        ; denotes a memory address, used mainly for calculating
                      ; the length up until that point within the currect section
    
    ; `equ $` meaning:
    ;       - equ is used to define constant/symbolic names for values
    ;       - $ represents the current value of the location counter
    ;           - the LC (location counter) keeps track of where in memory the
    ;             assembler is currently placing instructions or data
    ;   TLDR - simply holds the current position of the address in memory
    msg_len: equ $ - msg       
                         
    msg_data: db "Within .data section", 0, 10  ; NUL terminated string + "\n"
    msg_data_len: equ $ - msg_data      ; `equ $` (get current position in memory
                                        ; and subtract from label `msg_data` to 
                                        ; dynamically calculate the correct offset
                                        ; which returns the proper length of the
                                        ; current string `msg_data`
 
    ; msg_end2: ; serves as an offset

;section .rodata
     ; msg = label to refer to collection of bytes
                                    ; db = interpret sequence as bytes
                                    ; "" = sequence of bytes
                                    ; 10 = CR code which is LF (
                                    ; Line Feed, LF moves cursor to next line)
                                
section .text       ; this section is for actual code/machine instructions
                    ; has r+w permissions
                    ; is only loaded into memory once

; A label is an identifier which is followed by a colon
; Lables serve as markers for specific memory addresses
; A mnemonic is a reserved name for a class of instruction opcodes which have
; the same function

; Arguments are put in the registers rdi, rsi, rdx, rcx, r8 and r9, in that order.
_start:
    ; `man 2 write` = 2 ensures the system call man page is shown
    ;  ssize_t write(int fd, const void *buf, size_t count);
    
    ; mov = mnemonic identifier for OPCODE move
    ; 1 = destination operand, rax = source operand
    mov rax, 1              ; write(
    mov rdi, 1              ; STDOUT_FILENO = 1 (stdout),
    mov rsi, msg            ; "Hello, world!\n",
    mov rdx, msg_len        ; sizeof("Hello, world!\n")
    syscall                 ; );
    
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, msg_data       ; string
    mov rdx, msg_data_len   ; string length
    syscall
    
    ; call function - void _exit(int status);
    mov rax, 60     ; exit(
    
    ; zero out register
    xor rdi, rdi    ; EXIT_SUCCESS | xor rdi, rdi (Exit code 0)
    syscall         ; );
    
    ; Base 16 numbers are represented by a string of hexadecimal digits followed
    ; by an 'H': example - 0F82EH = 0x0F82E (base 10 => 63534)
    
    ; Base 2 numbers are represented by a string of 1's and 0's followed by an 
    ; optional 'B': example - 10001B
    
    ; The processor uses byte addressing - this means that memory is organized
    ; and accessed as a sequence of bytes.
    
    ; Address space - the range of memory that can be addressed
    ; The processor also support segmented addressing - this is a form of 
    ; addressing where the program may have many independent address spaces
    ; called segments
    ;   - code addresses always refer to the address space
    ;   - stack addresses always refer to the stack space
    
    ; The following notation is used to specify a byte address within a segment:
    ;   `Segment-register:Byte-address`
    ;       - Example: DS:FF79H
    
    ; Identify an instruction address in a code segment:
    ;   - the CS register points to the code segment, while the EIP register
    ;     contains the address of the instruction
    ;           Example: CS:EIP
    
    ; An "Exception" is an event that typically occurs when an instruction 
    ; causes an error
    
    ; Notation used to show an error code which demonstrates a generic
    ; page-fault exception: #PF(fault code)
