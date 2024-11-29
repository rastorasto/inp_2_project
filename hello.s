; Autor reseni: Rastislav Uhliar xuhliar00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "rastislavuhliar" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
  
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice

key:            .asciiz "uhl" ; klic

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                daddi  r1, r0, msg    ; load address of msg into r1
                daddi  r2, r0, cipher ; load address of cipher into r2
                daddi  r3, r0, key    ; load address of key into r3
                daddi  r5, r0, 0      ; key index counter

loop:           lb      r4, 0(r1)      ; load byte from msg
                beq     r4, r0, end    ; if null terminator, end loop

                lb      r6, 0(r3)      ; load byte from key
                beq     r6, r0, key_start ; if null terminator go to first byte

loop_cont:
                andi    r7, r5, 1      ; check if r5 is odd or even
                beq     r7, r0, key_add ; if even, jump to key_add
                j       key_subtract  ; if odd, jump to key_subtract

loop_continue:
                sb      r4, 0(r2)          ; store byte into cipher
                daddi   r5, r5, 1      ; increment key index counter
                daddi   r1, r1, 1      ; increment msg address
                daddi   r2, r2, 1      ; increment cipher address
                daddi   r3, r3, 1      ; increment key address
                j       loop           ; repeat loop
                
key_start:
                daddi  r3, r0, key    ; reset key address to start
                lb      r6, 0(r3)
               ; daddi  r5, r0, 0      ; reset key index counter to 0
                ;j       loop_continue  ; continue loop
                j		loop_cont	; continue loop

key_add:
                daddi  r8, r0, 96     ; load ASCII value of a into r8
                subu    r6, r6, r8     ; subtract a from key byte
                addu    r4, r4, r6     ; add key byte to msg byte
                daddi  r9, r0, 122     ; load ASCII value of z into r9
                slt     r8, r9, r4     ; check if msg byte is greater than z
                beq     r8, r0, loop_continue ; if not, continue loop
                daddi  r4, r4, -26    ; if greater, subtract 26 from msg byte
                j       loop_continue  ; continue loop

key_subtract:
                daddi  r8, r0, 96     ; load ASCII value of a into r8
                subu    r6, r6, r8     ; subtract a from key byte
                subu    r4, r4, r6     ; subtract key byte from msg byte
                daddi  r9, r0, 97      ; load ASCII value of a into r8
                slt     r8, r4, r9      ; check if msg byte is less than a
                beq     r8, r0, loop_continue ; if not, continue loop
                daddi  r4, r4, 26     ; if less, add 26 to msg byte
                j       loop_continue  ; continue loop

end:            
                sb      r0, 0(r2)      ; add null terminator to the cipher
                daddi   r4, r0, cipher ; load address of cipher into print register
                jal     print_string ; print the cipher


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
