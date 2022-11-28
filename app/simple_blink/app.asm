.nolist
.include "m328Pdef.inc"
.list


.def TMPREG = r16
.def LEDREG = r17



.CSEG
.org $0000
    rjmp Main

Main:
    ; Init MSP
    ldi TMPREG, HIGH(RAMEND)
    out SPH, TMPREG
    ldi TMPREG, LOW(RAMEND)
    out SPL, TMPREG

    ; Init PORTC:0
    ldi LEDREG, 0b00000001
    sbi DDRC, 0
    sbi PORTC, 0
    
Start:
    rcall Delay
    rcall TogglePin
    rjmp Start
    
Endloop:
    nop
    rjmp Endloop

TogglePin:
    ldi TMPREG, 0x01
    eor LEDREG, TMPREG
    out PORTC, LEDREG
    ret

Delay:
.def CNT0REG = r20
.def CNT1REG = r21
.def CNT2REG = r22
    push CNT0REG
    push CNT1REG
    push CNT2REG
    ; fill 24bit counter registers
    ldi TMPREG, 0x00
    mov CNT0REG, TMPREG
    mov CNT1REG, TMPREG
    mov CNT2REG, TMPREG
InnerLoop:
    inc CNT0REG
    brne InnerLoop
    inc CNT1REG
    brne InnerLoop
    inc CNT2REG
    ldi TMPREG, 0x4C
    cp CNT2REG, TMPREG
    brne InnerLoop

    pop CNT2REG
    pop CNT1REG
    pop CNT0REG
    ret