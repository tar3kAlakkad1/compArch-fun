 /*
 
 Name: Tarek Alakkad
 
 reset-rightmost.asm

 UVic CSC 230: Fall 2022 taught by Dr. Mike Zastre

 Program description: take the bit sequence stored in R16,
 and reset the rightmost contiguous sequence of set
 by storing this new value in R25. For example, given
 the bit sequence 0b01011100, resetting the right-most
 contigous sequence of set bits will produce 0b01000000.
 As another example, given the bit sequence 0b10110110,
 the result will be 0b10110000.

 */

.cseg
.org 0


/* TESTING WITH DIFFERENT VALUES */

; ldi R16, 0b11000000
; ldi R16, 0b10110110
; ldi r16, 0b00000000
ldi r16, 0b00000001


ldi r19, 0x0 ;counter
ldi r17, 0b00000001 ;mask
ldi r25, 0b0 ;result
ldi r20, 0b0 ;temp storage
mov r18, r16 ;store r16 into r18
mov r25, r16 ;store r16 into r25

loop:
	cpi r19, 0x08 ;check if we have gone through every bit in the byte
	breq reset_rightmost_stop ;if count is 7, stop (starts at 0, ends at 7, netting 8 comparisons)
	mov r16, r18 ;copies r18 (which has the original value of r16) into r16
	and r16, r17 ;checking to catch first bit in r16 that is equal to 1
	brne secondLoop ;branches to secondLoop if so
	inc r19 ;increment counter
	lsl r17 ;shift mask left
	rjmp loop

secondLoop:
	mov r16, r18 ;copies r18 (which has the original value of r16) into r16
	cpi r19, 0x08 ;check if we have gone through every bit in the byte
	breq reset_rightmost_stop ;if count is 7, stop (starts at 0, ends at 7, netting 8 comparisons)
	eor r16, r17 ;sets the bit we found to 0
	mov r20, r16 ;copies r16 to r20
	and r25, r20
	lsl r17 ;shift mask
	inc r19 ;increment count
	and r16, r17 ;check if next bit is 1
	breq reset_rightmost_stop ;if not, end program
	rjmp secondLoop

reset_rightmost_stop:
    rjmp reset_rightmost_stop