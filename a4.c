/*
 *
 * a4.c
 * UVic CSC 230: Fall 2022 taught by Dr. Mike Zastre
 *
 */

#define __DELAY_BACKWARD_COMPATIBLE__ 1
#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define DELAY1 0.000001
#define DELAY3 0.01

#define PRESCALE_DIV1 8
#define PRESCALE_DIV3 64
#define TOP1 ((int)(0.5 + (F_CPU / PRESCALE_DIV1 * DELAY1)))
#define TOP3 ((int)(0.5 + (F_CPU / PRESCALE_DIV3 * DELAY3)))

#define PWM_PERIOD ((long int)500)

volatile long int count = 0;
volatile long int slow_count = 0;

ISR(TIMER1_COMPA_vect)
{
    count++;
}

ISR(TIMER3_COMPA_vect)
{
    slow_count += 5;
}

void led_state(uint8_t LED, uint8_t state)
{

    /*
     * setting PORTL to out
     */
    DDRL = 0xFF;

    /*
     * multiple if statements to determine which LED to turn on
     */
    if (state == 0)
    {
        if (LED == 0)
        {
            PORTL &= 0b01111111;
        }
        else if (LED == 1)
        {
            PORTL &= 0b11011111;
        }
        else if (LED == 2)
        {
            PORTL &= 0b11110111;
        }
        else if (LED == 3)
        {
            PORTL &= 0b11111101;
        }
    }
    else if (state == 1)
    {
        if (LED == 0)
        {
            PORTL |= 0b10000000;
        }
        else if (LED == 1)
        {
            PORTL |= 0b00100000;
        }
        else if (LED == 2)
        {
            PORTL |= 0b00001000;
        }
        else if (LED == 3)
        {
            PORTL |= 0b00000010;
        }
    }
}

void SOS()
{
    uint8_t light[] = {
        0x1, 0, 0x1, 0, 0x1, 0,
        0xf, 0, 0xf, 0, 0xf, 0,
        0x1, 0, 0x1, 0, 0x1, 0,
        0x0};

    int duration[] = {
        100, 250, 100, 250, 100, 500,
        250, 250, 250, 250, 250, 500,
        100, 250, 100, 250, 100, 250,
        250};

    int length = 19;

    /*
     * array of values that turn on corresponding LEDs.
     * eg: index 0 turns on LED 0, index 1 turns on LED 1, etc.
     */
    uint8_t LEDs[] = {
        0b00000001,
        0b00000010,
        0b00000100,
        0b00001000};

    for (int i = 0; i < length; i++) // loop through duration and light indices
    {
        for (int j = 0; j < 4; j++) // loop through each LED and determine whether or not it should be turned on or off
        {
            int temp = light[i];

            temp &= LEDs[j]; // performing a logical and in order to determine if an LED is to be turned on or off

            if (temp != 0b0) // turning LED on if result of logical and is not 0
            {
                led_state(j, 1);
            }
            else // turning LED off otherwise
            {
                led_state(j, 0);
            }
        }
        _delay_ms(duration[i]); // corresponding delay duration.
    }
}

void glow(uint8_t LED, float brightness)
{

    float threshold = PWM_PERIOD * brightness;

    while (1)
    {
        if (count < threshold && count != 0) // count != 0 (along with count < threshold) means that the LED hasn't been turned on
        {
            led_state(LED, 1);
        }
        else if (count < PWM_PERIOD && count > 1) // count > 1 (along with count < PWM_PERIOD) means that the LED has been turned on
        {
            led_state(LED, 0);
        }
        else if (count > PWM_PERIOD)
        {
            count = 0;
            led_state(LED, 1);
        }
    }
}

void pulse_glow(uint8_t LED)
{

    float threshold;

    while (1)
    {
        threshold = 0;
        count = 0;
        slow_count = 0;

        for (threshold; threshold < PWM_PERIOD; threshold = slow_count * 0.1) // glowing the LED up
        {
            /*
             * same as part C
             */
            if (count < threshold && count != 0)
            {
                led_state(LED, 1);
            }
            else if (count < PWM_PERIOD && count > 1)
            {
                led_state(LED, 0);
            }
            else
            {
                count = 0;
                led_state(LED, 1);
            }
        }
        /*
         * resetting count, slow_count, and threshold
         */

        count = 0;
        slow_count = 0;
        threshold = 0;

        for (threshold; threshold < PWM_PERIOD; threshold = slow_count * 0.1) // dimming the LED down
        {
            /*
             * same as part C with opposite led_state numbers
             */
            if (count < threshold && count != 0)
            {
                led_state(LED, 0);
            }
            else if (count < PWM_PERIOD && count > 1)
            {
                led_state(LED, 1);
            }
            else
            {
                count = 0;
                led_state(LED, 0);
            }
        }
    }
}

void light_show()
{
    /*
     * values in arrays have been set to match (as much as possible) the output in the video.
     */
    uint8_t light[] = {
        0xf, 0x0, 0xf, 0x0, 0xf, 0x0, 0x6, 0x0, 0x9, 0x0,
        0xf, 0x0, 0xf, 0x0, 0xf, 0x0, 0x6, 0x0, 0x9, 0x0,
        0x8, 0xc, 0x6, 0x3,
        0x1, 0x3, 0x6, 0xc,
        0x8, 0xc, 0x6, 0x3,
        0x1, 0x3, 0x6, 0x0,
        0xf, 0x0, 0xf, 0x0, 0x6, 0x0, 0x6, 0x0};

    int duration[] = {
        275, 130, 275, 130, 275, 130, 150, 60, 150, 70,
        275, 130, 275, 130, 275, 130, 150, 60, 150, 70,
        100, 100, 100, 100,
        100, 100, 100, 100,
        100, 100, 100, 100,
        100, 100, 100, 100,
        275, 130, 275, 130, 275, 130, 275, 130};

    int length = 44; // length of the light and duration arrays

    /*
     * array of values that turn on corresponding LEDs.
     * eg: index 0 turns on LED 0, index 1 turns on LED 1, etc.
     */
    uint8_t LEDs[] = {
        0b00000001,
        0b00000010,
        0b00000100,
        0b00001000};

    for (int i = 0; i < length; i++) // loop through duration and light indices
    {
        for (int j = 0; j < 4; j++) // loop through each LED and determine whether or not it should be turned on or off
        {
            int temp = light[i];

            temp &= LEDs[j]; // performing a logical and in order to determine if an LED is to be turned on or off

            if (temp != 0b0) // turning LED on if result of logical and is not 0
            {
                led_state(j, 1);
            }
            else // turning LED off otherwise
            {
                led_state(j, 0);
            }
        }
        _delay_ms(duration[i]); // corresponding delay duration.
    }
}

int main()
{
    /* Turn off global interrupts while setting up timers. */

    cli();

    /* Set up timer 1, i.e., an interrupt every 1 microsecond. */
    OCR1A = TOP1;
    TCCR1A = 0;
    TCCR1B = 0;
    TCCR1B |= (1 << WGM12);
    /* Next two lines provide a prescaler value of 8. */
    TCCR1B |= (1 << CS11);
    TCCR1B |= (1 << CS10);
    TIMSK1 |= (1 << OCIE1A);

    /* Set up timer 3, i.e., an interrupt every 10 milliseconds. */
    OCR3A = TOP3;
    TCCR3A = 0;
    TCCR3B = 0;
    TCCR3B |= (1 << WGM32);
    /* Next line provides a prescaler value of 64. */
    TCCR3B |= (1 << CS31);
    TIMSK3 |= (1 << OCIE3A);

    /* Turn on global interrupts */
    sei();

    /* This code could be used to test part A.
        PORTL = 0b00000000;
        led_state(0, 1);
        _delay_ms(1000);
        led_state(2, 1);
        _delay_ms(1000);
        led_state(1, 1);
        _delay_ms(1000);
        led_state(2, 0);
        _delay_ms(1000);
        led_state(0, 0);
        _delay_ms(1000);
        led_state(1, 0);
        _delay_ms(1000);
    */

    /* This code could be used to test part B.*/

    // SOS();

    /* This code could be used to test part C.*/

    // glow(2, .01);

    // glow(2, 0.1);

    // glow(2, 0.5);

    // glow(2, 1);

    /* This code could be used to test part D.*/

    // pulse_glow(3);

    /* This code could be used to test lightshow. */

    // light_show();

    /* ****************************************************
     * **** END OF SECOND "STUDENT CODE" SECTION **********
     * ****************************************************
     */
}
