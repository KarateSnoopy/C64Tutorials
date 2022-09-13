* = $0801 "Basic Upstart"
BasicUpstart(main)

* = $0810 "Program"
#import "print.asm"

helloMsg: .text "8502 ASM EXAMPLES"; brk
branchTrueMsg: .text "BRANCH TRUE"; .byte PRINT.CHR_Return; brk
branchFalseMsg: .text "BRANCH FALSE"; .byte PRINT.CHR_Return; brk

main:
    print_text(helloMsg)
    print_text(PRINT.print_string_header)

    // uncomment these jsr lines one at a time, and run to see results.  
    // Study code and see videos for details
    
    // Addressing mode examples
    // Watch "Tutorial Five - 6502 Addressing Modes" by OldSkoolCoder
    // https://www.youtube.com/watch?v=kk0aW_p8EeE&list=PLiOlLd4dhIDC6RN6t0cCCQwBlusnHm8nt&index=6
    jsr immediate_indexing_mode_examples 
    // jsr absolute_zero_page_mode_examples
    // jsr zero_page_mode_index_mode_examples
    // jsr absolute_mode_examples
    // jsr absolute_indexed_X_or_Y_mode_examples
    // jsr zero_page_X_indexed_indirect_mode_examples
    // jsr zero_page_indirect_Y_indexed_examples

    // 6502 Instruction Set Part One
    // Watch "Tutorial Six - 6502 Instruction Set Part One" by OldSkoolCoder
    // https://www.youtube.com/watch?v=cLdZvM7q7Jg&list=PLiOlLd4dhIDC6RN6t0cCCQwBlusnHm8nt&index=7
    // jsr lda_examples
    // jsr adc_sbc_clc_sec_examples
    // jsr and_ora_eor_examples
    // jsr asl_lsr_examples
    // jsr bcc_bcs_examples
    // jsr flag_examples
    // jsr bit_examples
    // jsr bne_beq_bpl_bmi_examples
    // jsr bvc_bvs_examples

    // Tutorial Seven - 6502 Instruction Set Part Two
    // Watch "Tutorial Six - 6502 Instruction Set Part Two" by OldSkoolCoder
    // https://www.youtube.com/watch?v=8Tu-z3DDHhw&list=PLiOlLd4dhIDC6RN6t0cCCQwBlusnHm8nt&index=8
    // jsr cmp_cpx_cpy_examples
    // jsr dec_inc_examples
    // jsr dex_inx_examples
    // jsr dey_iny_examples
    // jsr jmp_jsr_nop_examples
    // jsr ldx_ldy_stx_sty_examples
    // jsr tax_txa_tay_tya_examples
    // jsr pha_pla_php_plp_examples
    // jsr rol_ror_examples
    // jsr tsx_txs_examples

    // No example for rti. rti = pull SR, pull PC. call from interupt
    // No example for brk. brk = used for debugging.  sets break & interrupt flags, and stores PC+2/SR on stack and raises interupt
    // In Kick assembler, use .break to stop (or added breakpoint in VS Code to auto-insert)
    rts

lda_examples:
immediate_indexing_mode_examples:
    lda #59 // Z & N flag is cleared
    jsr PRINT.print_accumlator 
    lda #0 // Z flag is set
    jsr PRINT.print_accumlator
    lda #-2 // N flag is set
    jsr PRINT.print_accumlator 
    rts

.label VarX = $36
absolute_zero_page_mode_examples:
    lda #10
    sta VarX  // $36 = #10
    lda #0
    lda $0036 // zero page indexing, saves 1 byte. auto optimzed by kick. fetch value at ($0036)
    jsr PRINT.print_accumlator 
    lda $36 // zero page indexing, saves 1 byte. fetch value at ($0036)
    jsr PRINT.print_accumlator 
    lda $0036 // not zero page, fetch value at ($0036)
    jsr PRINT.print_accumlator 
    rts

.label VarXPlus3 = VarX+3  //  $39
zero_page_mode_index_mode_examples:
    lda #10
    sta VarX  // $36 = 10
    lda #3
    sta VarXPlus3 // $36+3 = 3
    lda $36 // fetch value at ($0036)
    jsr PRINT.print_accumlator    
    ldx #3 
    lda $36,X // fetch value at ($0036+3)
    jsr PRINT.print_accumlator
    rts

.label VarY = $2036
absolute_mode_examples:
    lda #10
    sta VarY
    lda #0
    lda $2036 // fetch value at ($2036)
    jsr PRINT.print_accumlator
    rts

 .label VarYPlus3 = $2039
absolute_indexed_X_or_Y_mode_examples:
    lda #10
    sta VarY
    lda #7
    sta VarYPlus3 // $2036+3 = 7
    lda #9
    sta VarYPlus3+1 // $2036+4 = 9
    lda #0
    ldx #3
    lda $2036,X // fetch value at ($2036+3)
    jsr PRINT.print_accumlator
    lda #0
    ldy #4
    lda $2036,Y // fetch value at ($2036+4)
    jsr PRINT.print_accumlator
    rts

zero_page_X_indexed_indirect_mode_examples:
    lda #10
    sta VarX  // $36 = 10
    lda #$40
    sta VarX+2 // $38 = $40 // full address is $0040
    lda #$0
    sta VarX+3 // $39 = 0
    lda #7
    sta $40 // $40 = 7
    lda $36
    jsr PRINT.print_accumlator
    ldx #2
    lda $36,X
    jsr PRINT.print_accumlator
    lda $40 
    jsr PRINT.print_accumlator
    lda #0
    lda ($36,X) //  x=2, value at $38/$39 is $0040, so value at $0040 == #7
    jsr PRINT.print_accumlator

zero_page_indirect_Y_indexed_examples:
    lda #$70
    sta $38
    lda #$20
    sta $39 // stored address at $38/$39 = 2070

    lda #7
    sta $2070 // $2020 = 7
    lda #3
    sta $2071 // $2021 = 3

    lda $38
    jsr PRINT.print_accumlator
    lda $39
    jsr PRINT.print_accumlator
    lda $2070 
    jsr PRINT.print_accumlator
    lda $2071 
    jsr PRINT.print_accumlator

    ldy #$0
    lda ($38),Y // address is $2020, and its value is #7
    jsr PRINT.print_accumlator
    ldy #$1
    lda ($38),Y // y=1, address is $2020+1, and its value is #3
    jsr PRINT.print_accumlator
    rts

adc_sbc_clc_sec_examples:
    clc     // clear carry
    lda #$3
    adc #$4  // 3+4
    jsr PRINT.print_accumlator

    sec     // set carry
    lda #$3
    adc #$4  // 3+4+1
    jsr PRINT.print_accumlator

    clc     // clear carry
    lda #$4
    adc #-$5  // 4-5 == -1 or $FF, N set
    jsr PRINT.print_accumlator

    clc     // clear carry
    lda #$03
    adc #$FF  // 0x03+0xFF == 0x02 with carry set
    jsr PRINT.print_accumlator

    // In twos complement, $80 through $FF represent -128 through -1
    // $00 through $7F represents 0 through +127.
    // Thus, after:
    clc
    lda #$7F // 127
    adc #$01 // +1
    // The overflow flag is set, because in signed arithmetic (127 + 1 = -128). And after:
    jsr PRINT.print_accumlator

    sec
    lda #$80 // -128
    sbc #$01 // A = A-M-C, so if C is set it'll do another -1
    // The overflow flag is set, because in signed arthmetic (-128 -1 = 127).
    jsr PRINT.print_accumlator
    rts

and_ora_eor_examples:
    lda #$0F     
    and #$F4    // 0x0F & 0xF4 == 0x04
    jsr PRINT.print_accumlator

    lda #$0F     
    ora #$40    // 0x0F | 0x40 == 0x4F
    jsr PRINT.print_accumlator

    lda #$0F     
    ora #$44    // 0x0F ^ 0x44 == 0x47
    jsr PRINT.print_accumlator   
    rts

flag_examples:
    lda #$0
    sec // set carry
    jsr PRINT.print_accumlator

    lda #$0
    clc // clear carry
    jsr PRINT.print_accumlator

    lda #$0
    sed // set decimal mode
    jsr PRINT.print_accumlator

    lda #$0
    cld // clear decimal mode
    jsr PRINT.print_accumlator

    lda #$0
    sei // set interupt flag
    jsr PRINT.print_accumlator

    lda #$0
    cli // clear interupt flag
    jsr PRINT.print_accumlator

    clc
    lda #$7F // 127
    adc #$01 // +1
    // The overflow flag is set, because in signed arithmetic (127 + 1 = -128). And after:
    jsr PRINT.print_accumlator

    lda #$0
    clv // clear overflow flag
    jsr PRINT.print_accumlator
    rts

asl_lsr_examples:
    lda #$03
    jsr PRINT.print_accumlator
    asl // 0x03 << 1 == 0x6  
    jsr PRINT.print_accumlator
    asl // 0x06 << 1 == 12
    jsr PRINT.print_accumlator

    lsr // 12 >> 1 == 6
    jsr PRINT.print_accumlator
    lsr // 6 >> 1 == 3
    jsr PRINT.print_accumlator
    lsr // 3 >> 1 == 1, carry set
    jsr PRINT.print_accumlator

    rts

bcc_bcs_examples:
    sec // set carry
    bcs !+ // jump 1! markers forward if clear is set
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:

    clc // clear carry
    bcc !++ // jump 1! markers forward if clear is not set
    jmp !+  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:
    rts

bit_examples:
    lda #$F0
    sta $38

    clc
    lda #$0F
    jsr PRINT.print_accumlator

     // BIT = fetch value at M AND it with ACC, then AND 2 values set Z. also look at M and set N flag (M7 of M), V flag (M6 of M)
    bit $38 // 0xF0 AND 0x0F = if 0 then Z=set. N(M7)=set, V(M6)=set
    jsr PRINT.print_accumlator

    lda #$80
    sta $38
    lda #$FF
    bit $38 // 0x80 AND 0xFF = 0x80, so then Z=clear. N(M7 of $38)=set, V(M6 of $38)=clear
    jsr PRINT.print_accumlator

    lda #$40
    sta $38
    lda #$0F
    bit $38 // 0x40 AND 0x0F = 0 so Z=set. N(M7 of $38)=clear, V(M6 of $38)=set
    jsr PRINT.print_accumlator

    lda #$30
    sta $38
    lda #$0F
    bit $38 // 0x30 AND 0x0F = 0 so Z=set. N(M7 of $38)=clear, V(M6 of $38)=clear
    jsr PRINT.print_accumlator

    rts

bne_beq_bpl_bmi_examples:
    lda #$0    
    jsr PRINT.print_accumlator
    bne !+ // jump 1! markers forward if Z is clear
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:

    lda #$0    
    jsr PRINT.print_accumlator
    beq !+ // jump 1! markers forward if Z is set
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:

    lda #$FF
    jsr PRINT.print_accumlator
    bpl !+ // jump 1! markers forward if N is clear
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:

    lda #$FF
    jsr PRINT.print_accumlator
    bmi !+ // jump 1! markers forward if N is set
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!: 
    print_text(branchFalseMsg)
!:
    rts    

bvc_bvs_examples:
    lda #$0
    jsr PRINT.print_accumlator
    bvc !+ // jump 1! markers forward if V is clear
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:

    clc
    lda #$7F // 127
    adc #$01 // +1
    // The overflow flag is set, because in signed arithmetic (127 + 1 = -128)
    jsr PRINT.print_accumlator
    bvs !+ // jump 1! markers forward if V is set
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchTrueMsg)
    jmp !++  // jump 2! markers forward (see 3.4. Multi Labels in Kick Asm manual for details)
!:
    print_text(branchFalseMsg)
!:
    rts

cmp_cpx_cpy_examples:

    // Z = 0, A<>NUM so use BNE
    // Z = 1, A==NUM so use BEQ
    // C = 0, A<NUM so use BCC
    // C = 1, A>=NUM so use BCS

    clv
    clc
    lda #$20
    cmp #$20 // Z will be set cause 0x20 == 0x20, and C set
    jsr PRINT.print_accumlator

    clv
    clc
    lda #$20
    cmp #$30 // 0x20-0x30 is negative, so N will be set, C clear
    jsr PRINT.print_accumlator

    clv
    clc
    lda #$20
    cmp #$10 // 0x20-0x10, so N will be clear, C set since its less
    jsr PRINT.print_accumlator

    // CPX
    clv
    clc
    ldx #$20
    cpx #$20 // Z will be set cause 0x20 == 0x20, and C set
    jsr PRINT.print_accumlator

    clv
    clc
    ldx #$20
    cpx #$30 // 0x20-0x30 is negative, so N will be set, C clear
    jsr PRINT.print_accumlator

    clv
    clc
    ldx #$20
    cpx #$10 // 0x20-0x10, so N will be clear, C set since its less
    jsr PRINT.print_accumlator

    // CPY
    clv
    clc
    ldy #$20
    cpy #$20 // Z will be set cause 0x20 == 0x20, and C set
    jsr PRINT.print_accumlator

    clv
    clc
    ldy #$20
    cpy #$30 // 0x20-0x30 is negative, so N will be set, C clear
    jsr PRINT.print_accumlator

    clv
    clc
    ldy #$20
    cpy #$10 // 0x20-0x10, so N will be clear, C set since its less
    jsr PRINT.print_accumlator

    rts

dec_inc_examples:
    lda #$02
    jsr PRINT.print_accumlator
    sta $38
    dec $38
    lda $38
    jsr PRINT.print_accumlator
    dec $38 // hit 0 so Z is set, N is clear
    lda $38
    jsr PRINT.print_accumlator
    dec $38 // hit 0xFF so Z is clear, N is set
    lda $38
    jsr PRINT.print_accumlator

    inc $38
    lda $38 // hit 0 so Z is set, N is clear
    jsr PRINT.print_accumlator
    inc $38  
    lda $38
    jsr PRINT.print_accumlator
    inc $38 
    lda $38
    jsr PRINT.print_accumlator

    rts    

dex_inx_examples:
    ldx #$02
    txa 
    jsr PRINT.print_accumlator

    dex
    txa 
    jsr PRINT.print_accumlator
    dex // hit 0 so Z is set, N is clear
    txa 
    jsr PRINT.print_accumlator
    dex  // hit 0xFF so Z is clear, N is set
    txa 
    jsr PRINT.print_accumlator

    inx
    txa
    jsr PRINT.print_accumlator
    inx
    txa
    jsr PRINT.print_accumlator
    inx
    txa
    jsr PRINT.print_accumlator
    rts

dey_iny_examples:
    ldy #$02
    tya 
    jsr PRINT.print_accumlator

    dey
    tya 
    jsr PRINT.print_accumlator
    dey // hit 0 so Z is set, N is clear
    tya 
    jsr PRINT.print_accumlator
    dey  // hit 0xFF so Z is clear, N is set
    tya 
    jsr PRINT.print_accumlator

    iny
    tya
    jsr PRINT.print_accumlator
    iny
    tya
    jsr PRINT.print_accumlator
    iny
    tya
    jsr PRINT.print_accumlator
    rts

jmp_jsr_nop_examples:
    jmp !+ // jump forward one !
!:  nop // no operation
!:  jmp !++ // jump forward 2 !
!:  nop  // no operation, but skipped by jump
!:  jmp !++ // jump forward 2 !
!:  jmp !- // jump back 1 ! 
!:  nop // no operation

    jsr jmp_jsr_examples_sub // saves the PC on stack
    rts

jmp_jsr_examples_sub:
    lda #$0
    jsr PRINT.print_accumlator
    rts // restores the PC from stack

ldx_ldy_stx_sty_examples:
    ldx #$33 // x = #$44
    stx $38 // store x at $38
    txa 
    jsr PRINT.print_accumlator

    ldy #$44 // y = #$44
    sty $38 // store y at $38
    tya 
    jsr PRINT.print_accumlator
    rts
    
tax_txa_tay_tya_examples:
    ldx #$33
    txa // A=X
    jsr PRINT.print_accumlator

    lda #$0
    ldx #$0
    lda #$44
    tax // X=A
    lda #$0 // set A=0 to prove txa works
    txa // A=X
    jsr PRINT.print_accumlator

    lda #$0
    ldx #$0
    ldy #$0

    ldy #$33
    tya // A=Y
    jsr PRINT.print_accumlator

    lda #$0
    ldy #$0
    lda #$44
    tay // Y=A
    lda #$0 // set A=0 to prove tya works
    tya // A=Y
    jsr PRINT.print_accumlator

    rts

pha_pla_php_plp_examples:
    lda #$22
    pha
    lda #$0
    pla
    jsr PRINT.print_accumlator

    lda #$0 // z is set
    php // push the SR on stack
    lda #$33 // z is clear
    plp // pull SR off stack, so Z is still set while A == 0x33
    jsr PRINT.print_accumlator

    rts    

rol_ror_examples:
    clc
    lda #$0C

    jsr PRINT.print_accumlator
    ror // 0x0C >> 1 == 0x06
    jsr PRINT.print_accumlator
    ror // 0x06 >> 1 == 0x03
    jsr PRINT.print_accumlator
    ror // 0x03 >> 1 == 0x01+C
    jsr PRINT.print_accumlator
    ror // 0x01+C >> 1 == 0x80+C
    jsr PRINT.print_accumlator
    ror // 0x80+C >> 1 == 0xC0
    jsr PRINT.print_accumlator
    ror // 0xC0 >> 1 == 0x60
    jsr PRINT.print_accumlator

    rol // 0x60 << 1 == 0xC0
    jsr PRINT.print_accumlator
    rol // 0xC0 << 1 == 0x80+C
    jsr PRINT.print_accumlator
    rol // 0x80+C << 1 == 0x01+C
    jsr PRINT.print_accumlator
    rol // 0x01+C << 1 == 0x03
    jsr PRINT.print_accumlator
    rol // 0x03 << 1 == 0x06
    jsr PRINT.print_accumlator
    rol // 0x06 << 1 == 0x0C
    jsr PRINT.print_accumlator
    rts

tsx_txs_examples:
    tsx // X = stack pointer
    txa // A = X
    jsr PRINT.print_accumlator
    txs // stack pointer = X

    rts
