# Programming Environment
The code found in this directory has been tested and correctly executed using Microchip Studio 7. The hardware used was Arduino mega2560.

# a4.c

## lcd_state()

The function accepts two parameters: 

  1. The number of an LCD; and
  2. A number indicating the state to which that LCD must be put (with zero value meaning "off", and all other values meaning "on")

The function is therefore an LED <b>on</b> or <b>off</b> and immediately return.

LED's 2-6 will be the only LED's used by this code. LED #0 corresponds to port L, bit 7;
                                                    LED #1 corresponds to port L, bit 5;
                                                    LED #2 corresponds to port L, bit 3;
                                                    LED #3 corresponds to port L, bit 1;
                                                    
## SOS()
We	can	implement	dots	and	dashes	by	calls	to	led_state() and	_delay_ms()

The message SOS will then be displayed through flashing LEDs, effectively 'spelling' SOS in Morse code. 

In the function, there are three variables:

  1. uint8_t light[]:	an	array	of	8-bit	values	indicate	the	LED	pattern.	An	array	
     value indicates	LEDs	on	or	off	by	bits	set	or	cleared,	with	bit	0	the	state	for	
     LED #0,	bit	1	the	state	for	LED	#1,	etc.
  2. int duration[]:	an	array	of	ints (i.e.,	16-bit	values)	representating the	
     duration	in	milliseconds	for	an	LED	pattern.
  3. int length:	the	number	of	elements	in	light[] and	the	number	of	
     elements	in duration[].
     
For example,	at	index	6	the	bit	pattern	indicates	LED	#0	is	turned	on	for	100	
milliseconds).	


## glow() 
This function uses the program-scope variable named *count* that is incremented by the timer 1 interrupt
handler. *glow()* must be ran seperately from *pulse_glow()* and not in the same 'run'.

The function takes in two parameters:

  1. The number of an LCD; and
  2. The duty cycle for that LCD expressed as a floating-point value between 0.0 and 1.0

We control	LED	brightness	by	adjusting	current	
through	the	LED,	but	we	cannot	adjust	the	current	on	our	boards. 
There	is,	however,	another way	to	get	something	like	a	brightness	control	that	
exploits	something	called	pulse-width modulation.	In	essence	it	means	turning	an	
LED	on	and	off,	doing	so	very	rapidly,	and	in	a	way	that	gives	the	appearance	of	
brightness	or	dimness.

Every	500	microseconds,	the	LED	is	turned	on	for	75	microseconds	
and	then	turned	off	for	425	microseconds.	This	cycle	of	500	microseconds	goes	on	
for	as	long	as	dimmer	LED	intensity	is	needed.

And	suppose	we	want	a	brighter	LED,	but	not	as	bright	as	the	fully-on	LED.
Now	for	500	microseconds,	the	LED	is	turned	on	for	250	microseconds	and	then	
turned	off	for	250	microseconds.
So	when	the	LED	is	on,	we	say	the	signal	is	high,	and	the	time	for	which	is	the	signal	
is	high	is	called	the	on	time.	Given	than	our	period	here	is	500	microseconds,	our	
first	diagram	shows an	on	time of	75	microseconds,	and	the	percentage	of	on	time to	
the	overall	period	is	called	the	duty	cycle (i.e., 75/500	=	0.15	=	15% duty	cycle).	For	
our	second	diagram,	the	duty	cycle	is	50%	(i.e.,	250/500	=	0.5	=	50% duty	cycle).	
Going	further,	a	duty	cycle	of	0%	would	be	an	LED	that	is	completely	off,	while	a	
duty	cycle	of	100%	would	be	an	LED	that	is	completely	on.

This function was implemented by using an infinite loop, and therefore we will only be able to 
ever set the glow for a single LED. The infinite	loop	will	take	
advantage	of	the	fact	that	the	global	variable count is	incremented	once	a	
microsecond
Warning:	Even	though	we	might	expect	the	LEDs	to	respond	in	a	visually	linear	
fashion	as	we change	the	duty	cycle,	unfortunately	our	own	visual	systems	do	not
respond	in	a	similar	way.	That	is,	the	differences	in	brightness	that	we	see	as
increase	the	duty	cycle	from	10%	to	20%	to	30%	to	40%	etc.	will	not	“appear”	as
evenly-spaced	changes to	our	eyes	and	brains.	Don’t	worry	about	this	(or	if	you	
insist	on	worrying	about	this,	please	spend	some	time	at	https://bit.ly/2pGn61A)

## pulse_glow() 
This function uses the program-scope variables named *count* and *slow_count* that are incremented 
by the timer 1 and timer 3 interrupt handlers respectively.

To increase and	decrease the	brightness	over	time,	we	need	to	increase and	decrease the	
duty	cycle	over	time.	As	our	proxy	for	duty	time	in	*glow()*	was	the	value	assigned	to	
the variable	threshold,	this	means	changing	the	value	of	threshold over	time.

The	infinite	loop	will	take	
advantage	of	the	fact	that	the	global	variables count and	slow_count are	
incremented	once	a	microsecond and	once	ever	10	milliseconds	respectively.	Your	
loop	will	need	to	modify	threshold by	increasing	it	to	PWM_PERIOD or	decreasing	it	
to	0 in	some	way	related	to	changes	in	slow_count


## light_show()
Create your own light show!




NOTE: This file uses description from Dr. Mike Zastre's teaching material in CSC 230.
