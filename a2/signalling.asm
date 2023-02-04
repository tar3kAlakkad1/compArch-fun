; a2-signalling.asm
; UVic CSC 230: Fall 2022 taught by Dr. Mike Zastre
;

.include "m2560def.inc"
.cseg
.org 0

	; initializion code will need to appear in this
    ; section
	ldi r20, 0xff
	sts DDRL, r20
	out DDRB, r20

	clr r20

	ldi r20, low(RAMEND)
	ldi r21, high(RAMEND)
	out SPL, r20
	out SPH, r21

; ---------------------------------------------------
; --------- TESTING SECTIONS OF THE CODE ------------
; ----- TO BE USED AS FUNCTIONS ARE COMPLETED. ------
; ---------------------------------------------------
; ------ YOU CAN SELECT WHICH TEST IS INVOKED -------
; ---- BY MODIFYING THE rjmp INSTRUCTION BELOW. -----
; ----------------------------------------------------

	rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16

	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000
test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:
	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end

;============== PART A ==============
set_leds:
	push r16
	push r18
	push r19
	push r22
	push r23
	push r24
	push r25

	;loading masks that will turn on LEDs via setting the appropriate bits of ports L and B
	ldi r18, 0b10000000
	ldi r19, 0b00100000
	ldi r22, 0b00001000
	ldi r23, 0b00000010

	clr r24
	clr r25

	sbrc r16, 0 ; skips next instruction if bit 0 in r16 is cleared.
                ; The next instruction turns on LED #6 (corresponding to bit 7 of port L)
                ; if the bit is set
	add r25, r18

	sbrc r16, 1  
	add r25, r19

	sbrc r16, 2
	add r25, r22

	sbrc r16, 3
	add r25, r23

	sbrc r16, 4
	add r24, r22

	sbrc r16, 5
	add r24, r23

	sts PORTL, r25
	out PORTB, r24

	pop r25
	pop r24
	pop r23
	pop r22
	pop r19
	pop r18
	pop r16

	ret

;============== PART B ==============
slow_leds:
	push r16
	push r17

	mov r16, r17            ; copy r17 into r16 in order to call set_leds
	rcall set_leds 

	rcall delay_long
	 
	ldi r16, 0b0            ; loading r16 with 0 in order to turn off LEDs at the end of the function call
	rcall set_leds

	pop r17
	pop r16
	ret

;============== PART B ==============
fast_leds:
	push r16 
	push r17

	mov r16,r17             ; copy r17 into r16 in order to call set_leds
	rcall set_leds 

	rcall delay_short

	ldi r16,0b0             ; loading r16 wih 0 in order to turn off LEDs at the end of the function call
	rcall set_leds
	
	pop r17
	pop r16
	ret

; ============== PART C ==============
leds_with_speed:
	; protecting the Z register since it will be used in the subroutine
	push ZL
	push ZH

	; protecting r18 and r19 since they will be used in the subroutine
	push r19
	push r18

	; loading the value in stack pointer into the Z register
	in ZH, SPH
	in ZL, SPL

	; getting the parameter pushed on the stack into temp
	ldd r19, Z+8

	; copying the value of temp into r17 in anticipation to calling fast_leds and slow_leds
	mov r17, r19

	ldi r18, 0b11000000 ; was mask, 0b11000000
	and r18, r19
	brne long
	rcall fast_leds

	done:
		pop r18
		pop r19
		pop ZH
		pop ZL
		ret

	long:
		rcall slow_leds
		rjmp done


; Note -- this function should only ever be used
; for capital letters.


;============== PART D ==============
encode_letter:
	; protecting the registers to be used in the subroutine
 	push YH
	push YL

	push ZH
	push ZL

	push r18
	push r22
	push r26
	push r24
	push r23
	push r19

	; setting the Y register as the stack pointer
	in YH, SPH
	in YL, SPL

	; loading the address of PATTERNS
	ldi ZH, high(PATTERNS << 1)
	ldi ZL, low(PATTERNS << 1)
	clr r25
	
	; defining registers to be used
	.def inputLetter=r18
	.def temp=r22
	.def offLED=r23
	.def onLED=r24
	.def mask=r19
	
	; loading defined registers
	ldd inputLetter,Y+14    ; accessing input letter from the stack.
	lpm temp, Z             ; accessing the first letter to compare from PATTERNS.
	ldi offLED, 0x2e        ; loading the hex value of ".", which means that the LED is off.
	ldi onLED, 0x6f         ; loading the hex value of "o", which means that the LED is on.
	ldi mask, 0b00100000    ; mask for setting r25 if LED is on or off. the mask will be logically-shifted-right every
                            ; time in order to appropriately set the value of r25.

	; checkIfLettersMatch will loop through PATTERNS and compare whether or not the input letter matches the letter in PATTERNS
	checkIfLettersMatch:
		cp inputLetter, temp
		breq detectPattern
		adiw Z, 8           ; accessing the next letter in PATTERNS
		lpm temp, Z         ; loading temp with the next letter in PATTERNS
		rjmp checkIfLettersMatch 

	detectPattern:
		cpi mask, 0x0       ; checking if the mask is 0 after logically-shifting-right occurs
		breq checkNum       ; if the mask is, then we have successfully looped through the possible states of LEDs 1-6. The first two numbers are left to check the duration of letter (0.25s or 1s)
		adiw Z, 1           ; accesing LED pattern/value (on or off)
		lpm temp, Z         ; loading temp with the LED pattern/value (on or off)
		cp temp, onLED
		breq setBit         ; branching to set the appropriate bit if the LED is to be turned on
		lsr mask
		rjmp detectPattern

	; setBit is used to turn on the appropriate LED if the pattern says so
	setBit:
		add r25, mask
		lsr mask
		rjmp detectPattern

	; checks the number correlated to each letter that denotes the appropriate duration.
	checkNum:
		adiw Z, 1           ; accesing the number
		lpm temp, Z         ; loading temp with the number
		cpi temp, 0x1       ; comparing if the value of num is 1
		breq duration       ; branching to duration. we only need to check if the number is one
                            ; in order to change r25 from 0b00xxxxxx to 0b11xxxxxx. If num is not one, no need to branch into set duration.
		rjmp wrapup

	; changing the value of r25 if duration is set to 1
	duration:
		ldi mask, 0b11000000
		add r25, mask

	wrapup:
		pop r19
		pop r23
		pop r24
		pop r26
		pop r22
		pop r18

		pop ZL
		pop ZH

		pop YL
		pop YH

		ret 

;============== PART E ==============
display_message:
	; protecting value of registers that will be used
	push r25
	push r24
	push r23
	push ZH
	push ZL

	; moving the addresses into the Z register
	mov ZH, r25
	mov ZL, r24
	
	; looping through the letters in the word
	loop:
		lpm r23, Z+             ; loading the value of the first letter in the word
		tst r23                 ; checking if the value of r23 is 0. Since the string is a c-style string,
                                ; that means that the end of the word is marked by a 0.
		breq finale
		push r23                
		rcall encode_letter
		pop r23
		push r25                ; pushing the value of r25 that was modified from calling encode_letter
		rcall leds_with_speed   ; calling leds_with_speed in order to display the the letter called
		pop r25                 ; popping r25
		rcall delay_short       ; calling delay_short between each letter
		rcall delay_short
		rjmp loop 

	finale:
		pop ZL
		pop ZH
		pop r23
		pop r24
		pop r25
		ret

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables
.cseg
.org 0x600

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "W", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0