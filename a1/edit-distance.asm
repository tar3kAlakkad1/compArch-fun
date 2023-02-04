 /*
 Name: Tarek Alakkad
 
 main.asm for edit-distance

 UVic CSC 230: Fall 2022 taught by Dr. Mike Zastre

 Task: To compute the edit distance between two byte values,
 one in R16, the other in R17. If the first byte is:
    0b10101111
 and the second byte is:
    0b10011010
 then the edit distance -- that is, the number of corresponding
 bits whose values are not equal -- would be 4 (i.e., here bits 5, 4,
 2 and 0 are different, where bit 0 is the least-significant bit). 
 
 You are free to change the value in R16 and R17

 In the code, the computed edit distance value is stored in R25.

 */


    .cseg
    .org 0

	ldi r16, 0xa7
	ldi r17, 0x9a

	ldi r25, 0x0
	ldi r19, 0b00000001 ;mask
	.def comp = r19
	.def count = r18
	eor r16, r17
	mov r20, r16
	ldi count, 0

	loop:
		mov r16, r20
		cpi count, 0x08
		breq edit_distance_stop
		and r16, comp
		brne countIt
		inc count
		lsl r19
		rjmp loop

	countIt:
		inc r25
		inc count
		lsl r19
		rjmp loop

edit_distance_stop:
    rjmp edit_distance_stop
