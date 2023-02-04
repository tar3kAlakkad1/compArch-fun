
; bcd-addition.asm
; CSC 230: Fall 2022
;
; UVic CSC 230: Fall 2022 taught by Dr. Mike Zastre

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Program description: Two packed-BCD numbers are provided in R16
; and R17. The program adds the two numbers together, such
; that the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

.cseg
.org 0

; ========= SOME TEST CASES BELOW ===========
;
; Your code will always be tested with legal BCD
; values in r16 and r17 (i.e. no need for error checking).

; 94 + 9 = 03, carry = 1
;ldi r16, 0x94
;ldi r17, 0x09

; 86 + 79 = 65, carry = 1
;ldi r16, 0x86
;ldi r17, 0x79

; 35 + 49 = 84, carry = 0
;ldi r16, 0x35
;ldi r17, 0x49

; 32 + 41 = 73, carry = 0
;ldi r16, 0x32
;ldi r17, 0x41

;ldi r16, 0x50
;ldi r17, 0x50

ldi r16, 0x0
ldi r17, 0x0

;=============== END OF TEST CASES ================

ldi r31, 0b0 ;will store the original value of r17
.def originalR17 = r31
mov originalR17, r17

ldi r25, 0b0 ; will store the original value of r16
.def originalR16 = r25
mov originalR16, r16

ldi r24, 0b0 ; counter
.def counter = r24

ldi r27, 0b00000000 ; will be used to add one once appropriate. Adding one accounts for the carry that occurs if summation of digits is > 9.
.def addOne = r27

ldi r28, 0b00000110 ; will be used to add six once appropriate. Adding six and subtracting one helps us deal with the carries that occur if summation of digits is > 9.
.def addSix = r28

ldi r29, 0b00001010 ; will be used to check if the summation of the binary numbers in the lower nibble is 10 by using brge. This is to account for when the digit is > 9, thus dealing with a carry
.def brgeComp = r29

ldi r18, 0b00001111 ; will be our mask. If summation of two digits is 0b1010 (0xA), then we will be adding six and subtracting from the resultant. A one will be added as a carry for the upper nibble (or r24 if the summation performed was on the upper nibble). Once that occurs, the fourth bit position will be occupied, thus a mask must be performed in order to maintain the digit.
.def lowerNibbleMask = r18

ldi r19, 0b11110000 ; upper nibble mask
.def upperNibbleMask = r19

.def firstNum_UpperNibble = r16 ;r16 will be used to store the upper nibble of our first number

ldi r21, 0b0 ; stores the lower nibble value of the first number
.def firstNum_LowerNibble = r21

.def secondNum_UpperNibble = r17 ; r17 will be used to store the upper nibble of our second number

ldi r23, 0b0 ; stores the lower nibble value of the second number 
.def secondNum_LowerNibble = r23

mov firstNum_LowerNibble, r16
mov secondNum_LowerNibble, r17

and firstNum_UpperNibble, upperNibbleMask ; getting the "upper" four bits from first num
and firstNum_LowerNibble, lowerNibbleMask ; getting the "lower" four bits from first num

and secondNum_UpperNibble, upperNibbleMask ; getting the "upper" four bits from second num
and secondNum_LowerNibble, lowerNibbleMask ; getting the "lower" four bits from second num


; swapping the high and low nibble. This is performed in order to appropriately
; store the carry in r24 rather than having the carry overflow in once summation is performed
swap firstNum_UpperNibble 

swap secondNum_UpperNibble

add firstNum_LowerNibble, secondNum_LowerNibble ; adding the "lower" four bits from both nums together
cp firstNum_LowerNibble, brgeComp ; comparing to see if the answer of that summation is greater than or equal to 10
brge dealWithCarryLower ; if so, branch to secondLoop in order to deal with the carry/overflow

; =========== ADD UPPER NIBBLE, adds the upper nibble of both numbers =================
addUpperNibble:
    add firstNum_UpperNibble, secondNum_UpperNibble
    add firstNum_UpperNibble, addOne 
    cp firstNum_UpperNibble, brgeComp 
    brge dealWithCarryUpper 
    rjmp noUpperCarry

; DEAL WITH CARRY LOWER - if summation of lower nibbles from the digits is greater
; than 9, we add six to the result and perform a logical and in order to "maintain" the digit
dealWithCarryLower:
    add firstNum_LowerNibble, addSix
    and firstNum_LowerNibble, lowerNibbleMask
    inc addOne
    rjmp addUpperNibble

; DEAL WITH CARYY UPPER - if summation of upper nibbles from the digits is greater than 9,
; we add six to the result and perform a logical and in order to "maintain" the digit 
dealWithCarryUpper:
    add firstNum_UpperNibble, addSix
    and firstNum_UpperNibble, lowerNibbleMask
    inc r24
    swap firstNum_UpperNibble
    or firstNum_UpperNibble, firstNum_LowerNibble
    mov r25, firstNum_UpperNibble
    rjmp bcd_addition_end

; NO UPPER CARRY - directly sotring final result in r25 since no carries
; occured in upper nibble addition
noUpperCarry:
    swap firstNum_UpperNibble
    or firstNum_UpperNibble, firstNum_LowerNibble 
    mov r25, firstNum_UpperNibble 
    rjmp bcd_addition_end
    

bcd_addition_end:
	rjmp bcd_addition_end
