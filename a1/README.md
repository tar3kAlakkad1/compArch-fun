# Programming Environment

The code found in this directory has been tested and correctly executed using Microchip Studio 7. 
The hardware used was Arduino mega2560.

# edit-distance.asm

One specialization in computer science and mathematics is information theory,
invented in the 1940s when the possibilities for the digital representation of data
and signals were first deeply investigated. An example of a concept in information
theory is edit distance, which describes how much one data string differs from
another data string. If we examine binary numbers instead of data strings, we can
see an edit distance more clearly. For example, consider the 8-bit binary equivalents
of 198 and 81:
  
      11000110
      01010001
      
The numbers are clearly different, and one measure of this is found by determining
the number of bit positions in which the two binary numbers differ. Shown below are
these two numbers again but with the different bits noted in bold:

      _1__10__0__0__11__0
      __0__10__1__0__00__1
      
That is, if we denote bit 7 as the left-most bit of each number, then bits 7, 4, 2, 1 and
0 (i.e. five bits) are different between each number. The edit distance of these two
binary numbers is therefore five (5).

The code in edit-distance.asm completes the above.

The two bytes will be stored in registers r16 and r17
The computed edit distance is stored in r25

Some test cases are provided in the assembly file.

# reset-rightmost.asm

Another common task when working with bit sequences is to identify and work
with contiguous set bits. For example, consider the bit sequence shown below, with
several of the set bits shown in a bold font:

      010__111__00
      
We say that the bolded set bits constitute the right-most contiguous set bits. That is,
bits 4, 3, and 2 are set. If we reset the right-most contiguous set bits of the example
just given, the result is:

      010__000__00

reset-rightmost.asm completes the task demonstrated above. 

The bit sequence for for which the right-most contiguous set bits must be reset
is in r16.
The result is stored in r25

Some test cases are provided in the assembly file.

# bcd-addition.asm 

Addition of two packed BCDs numbers. 

A number such as 72~10~ may be represented as a eightbit
two’s complement number: 0b01001000. Another form for representing decimal
numbers that was once popular is called __binary-coded decimal (BCD)__. For a given
number, each decimal digit (from 0 to 9) was encoded in a four-bit field. The BCD
representation of 72~10~ is 0b01110010, i.e., where the left nibble (0111) represents 7
and the right nibble (0010) represents 2. A larger decimal number would therefore
require more groups of four bits, that is, four bits per decimal digit.

Put differently, one result of BCD is that the hexadecimal version of the number
appears identical to the decimal, even though they are in different bases. That is,
0x72 in a BCD encoding has the same meaning as 72~10~.

Performing arithmetic with BCD numbers is, however, definitely not the same as
with the ordinary two’s-complement encoding we have examined in class! For
example, adding together 0x35 (53~10~) and 0x49 (73~10~) as two’s complement
numbers results in 0x6E (126~10~). However, as BCD, the addition 0x35 and 0x49 is
0x84. This also suggest that the largest number which can be represented in a byte
using BCD is 0x99. 

The program is not designed to handle negative numbers as input.

bcd-addition.asm completes the task of adding two packed BCD numbers.

The BCD operands for addition are in r16 and r16.
The right-most two BCD digits of addition result is stored in r25.
The carry (either 0 or 1) resulting from the addition is stored in r24.
   


NOTE: all rights reserved to Dr. Mike Zastre
