// Converted https://github.com/OldSkoolCoder/Tutorials/blob/master/03%20-%20Tutorial%20Three.asm by OldSkoolCoder to Kick Asm

* = * "Print"

.macro print_text(param1) {
    ldy #>param1             // Load Hi Byte to Y
    lda #<param1             // Load Lo Byte to Acc.
    jsr PRINT.print_string              // Print The .text until hit Zero
}

PRINT: 
{

.label CHR_White                   = 5
.label CHR_DisableCommodoreKey     = 8
.label CHR_EnableCommodoreKey      = 9
.label CHR_Return                  = 13
.label CHR_SwitchToLowerCase       = 14
.label CHR_CursorUp                = 17
.label CHR_ReverseOn               = 18
.label CHR_Home                    = 19
.label CHR_Overwrite               = 20
.label CHR_Red                     = 28
.label CHR_CursorRight             = 29
.label CHR_Green                   = 30
.label CHR_Blue                    = 31
.label CHR_Space                   = 32
.label CHR_ShiftReturn             = 141
.label CHR_SwitchToUpperCase       = 142
.label CHR_Black                   = 144
.label CHR_CursorDown              = 145
.label CHR_ReverseOff              = 146
.label CHR_ClearScreen             = 147
.label CHR_Insert                  = 148
.label CHR_Purple                  = 156
.label CHR_CursorLeft              = 157
.label CHR_Yellow                  = 158
.label CHR_Cyan                    = 159
.label CHR_ShiftSpace              = 160

.label PrintCode=$ffd2

//*******************************************************************************
// print_accumlator
// This prints the number from the Accumulator to binary / Hex / Decimal       
// Input: Acc
//*******************************************************************************
StatusState:
    brk
NumberToPrint:
    brk
NumberToWork:
    brk
print_accumlator:
    sta NumberToPrint       // Store away the Accumulator
    php
    pla
    sta StatusState

    lda NumberToPrint
    pha                     // Save: Push Acc (a) to Stack
    txa
    pha                     // Save: Push Acc (X) to Stack
    tya 
    pha                     // Save: Push Acc (Y) to Stack
    php                     // Save: Push Processor Status (SR) to Stack

    lda StatusState
    pha
    lda NumberToPrint
    plp

    php                     // Push Processor Status (SR) to Stack
    pha                     // Push the Acc (a) to Stack
    txa                     // Move X to Acc.
    pha                     // Push Acc (x) to Stack
    tya                     // Move Y to Acc.
    pha                     // Push Acc (y) to Stack

    cld                     // clear decimal mode

    jsr BinPrint            // Print Binary Array for NumberToPrint
    jsr print_space         // Add a space
    jsr hexadecimal_print   // Print Hexadecimal for NumberToPrint
    jsr print_space         // Add a space
    jsr decimal_print       // Print Decimal for NumberToPrint
    
    jsr print_space         // Add a space
    jsr print_space         // Add a space

    // pad 0 to 2 extra spaces spending on how big the number is
    lda NumberToPrint       // ACC = number to print
    cmp #10                 // ACC>=10 ?
    bcs space99             // carry set, so ACC >= 10
space9:
    jsr print_space         // number is 1 digits, so add 2 spaces
    jsr print_space               
    jmp spaceDone
space99:
    cmp #100                // ACC>=100 ?
    bcs spaceDone           // carry set, so ACC >= 100  
    jsr print_space         // number is 2 digits, so add 1 space
spaceDone:

    pla                     // Pull Acc (y) off Stack
    tay                     // Transfer Acc to Y	
    pla                     // Pull Acc (x) off Stack
    tax                     // Transfer Acc to X
    pla                     // Pull Acc (a) off Stack
    pla                     // Pull Acc (sr) off Stack
    jsr status_register

    print_text(newline)

    plp                     // Restore: Pull Acc (sr) off Stack
    pla                     // Restore: Pull Acc (y) off Stack
    tay      
    pla                     // Restore: Pull Acc (x) off Stack
    tax
    pla                     // Restore: Pull Acc (a) off Stack
    rts                     // Return Back

//*******************************************************************************
// print_space                                                                 
// This rotuines prints a space on the screen                                  
//*******************************************************************************
print_space:
    lda #CHR_Space          // Load Space Character 
    jmp PrintCode               // Print This Character
//*******************************************************************************

//*******************************************************************************
// print_string
// This routine prints a string of characters terminating in a zero .byte      
// Inputs : Accumulator : Lo Byte Address of String                           
//         : Y Register  : Hi Byte Address of String                           
//*******************************************************************************
.label htlo=$14
.label hthi=$15
print_string:
    sta htlo       // Store Lo Byte Address of String
    sty hthi       // Store Hi Byte Address of String
nxtchr:
    ldy #0         // Initialise Index Y
    lda (htlo),y   // Load Character at address + Y
    cmp #0         // Is it Zero?
    beq string_rts // If Zero, goto end of routine
    jsr PrintCode  // Print this character
    clc            // Clear The Carry
    inc htlo       // Increase Lo Byte
    bne nxtchr     // Branch away if Page Not Crossed
    inc hthi       // Increase Hi .byte
    jmp nxtchr     // Jump back to get Next Character
string_rts:
    rts                         // Return Back

print_string_header:
    .byte CHR_Return
    .text "BINARY    HEX   DEC.  NV-BDIZC"
    .byte CHR_Return
    brk 

newline:
    .byte CHR_Return
    brk 

//*******************************************************************************
// status_register
// This routine prints the contents of the status register                    
//  Inputs : Accumulator : Status Register                                    
//*******************************************************************************
streg:
    brk
status_register:
    ldy #0                  // Initialise Y Register
streg1:
    sta streg               // Store Acc. into Status Register Variable
streg3: 
    asl streg               // logically shift the acc left, and carry set or not
    lda #0                  // Load Zero into Accu.
    adc #$30	            // Add "0" to Acc. with  carry
    cpy #2                  // is y = 2
    bne streg2              // if yes, branch past the "-" symbol
    lda #$2d                // Load Acc with "-"
streg2:
    jsr PrintCode           // Print The contents of the Acc
    iny                     // increase the index Y
    cpy#8                   // test for 8 (8th bit of the number)
    bne streg3              // Branch if not equal back to next bit
    rts                     // Return Back

//*******************************************************************************
// This routine prints the contents NumberToPrint as a binary number           
//*******************************************************************************
BinPrint:
    jsr prPercent           // Print "%"
    ldy #0                  // Initialise Y Index Register with zero
    lda NumberToPrint       // Load Acc with number to print
    sta NumberToWork        // Store Acc to Number To Work
binpr4:
    asl NumberToWork        // Logically shift left Number to Work into Carry
    lda #0                  // Load Acc with Zero
    adc #'0'                  // Add Acc with 
    jsr PrintCode               // Print this character either "0" ot "1"
    iny                     // increase Y index
    cpy #8                  // have we hit bit 8?
    bne binpr4              // No, get next Bit
    rts                     // Return Back 

//*******************************************************************************
// decimal_print
// This routine prints the contents NumberToPrint as a decimal number          
//*******************************************************************************
decimal_print:
    jsr prHash              // Print "#"
    lda #$00                // Initialise Acc with zero
    ldx NumberToPrint       // Load X Register with NumberToPrint
    stx NumberToWork        // Store X Register to NumberToWork
    jmp $bdcd               // Jump To Basic Decimal Number Print Routine

prDollar:
    lda #$24 // "$"
    .byte 44
prBracketOpen:
    lda #$28 // "("
    .byte 44
prBracketClosed:
    lda #$29 // ")"
    .byte 44
prComma:
    lda #','
    .byte 44
prx:
    lda #'x'
    .byte 44
pry:
    lda #'y'
    .byte 44
prPercent: 
    lda #'%'
    .byte 44
prHash:
    lda #'#'
    jmp PrintCode

//*******************************************************************************
// hexadecimal_print
// This routine prints the contents NumberToPrint as a hexadecimal number      
//*******************************************************************************
hexadecimal_print:
    jsr prDollar            // Print a "$"
    ldx #$00                // Initialise X Register with Zero
    lda NumberToPrint       // Load Acc with NumberToPrint
    sta NumberToWork        // Store Acc to NumberToPrint
    jmp pbyte2 // Jump to Hexadecimal routine


//*******************************************************************************
// pbyte2
// This routine evaluates and prints a four character hexadecimal number       
//  Inputs : Accumulator : Lo Byte of the number to be converted               
//           X Register  : Hi Byte of the number to be converted               
//*******************************************************************************
pbyte2:
    pha                     // Push Acc to the Stack 
    txa                     // Tansfer X register To Acc
    jsr pbyte1              // Execute 2 digit Hexadecimal convertor
    pla                     // Pull Acc from Stack
pbyte1:
    pha                     // Push Acc to the Stack 
                            // Convert Acc into a nibble Top "4 bits"
    lsr                     // Logically shift Right Acc
    lsr                     // Logically shift Right Acc
    lsr                     // Logically shift Right Acc
    lsr                     // Logically shift Right Acc
    jsr pbyte               // Execute 1 digit Hexadecimal number
    tax                     // Transfer Acc back into X Register 
    pla                     // Pull Acc from the Stack
    and #15                 // AND with %00001111 to filter out lower nibble
pbyte:
    clc                     // Clear the Carry
                            // Perform Test weather number is greater than 10
    adc #$f6                // Add #$F6 to Acc with carry
    bcc pbyte_skip          // Branch is carry  is still clear
    adc #6                  // Add #$06 to Acc to align PETSCII Character "A"
pbyte_skip:
    adc #$3a                // Add #$3A to align for PETSCII Character "0"
    jmp PrintCode               // Jump to the Print Routine for that character

}