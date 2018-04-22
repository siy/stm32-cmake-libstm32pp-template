//
// Created by siy on 4/19/18.
//

#include "clock.hpp"

#include "interrupt.hpp"

#include "peripheral/gpio.hpp"

using LED = PC13;
using LED_ALERT = PE9;

#include "peripheral/tim.hpp"

using CLOCK_TIMER = TIM2;

///* Seems needed if using HSE clock */
//void clk::hseFailureHandler()
//{
////    LED_ALERT::enableClock();
////#ifdef STM32F1XX
////    LED_ALERT::setMode(gpio::cr::GP_PUSH_PULL_50MHZ);
////#else
////    LED_ALERT::setMode(gpio::moder::OUTPUT);
////#endif
////    LED_ALERT::setHigh();
////
////  Do something if high speed clock fails
//}


void initializeGpio() {
    LED::enableClock();

#ifdef STM32F1XX
    LED::setMode(gpio::cr::GP_PUSH_PULL_50MHZ);
#else
    LED::setMode(gpio::moder::OUTPUT);
#endif
    //LED::setHigh();
    LED::setLow();
}

void initializeTimer() {
    CLOCK_TIMER::enableClock();
    CLOCK_TIMER::configurePeriodicInterrupt<4>(); /* 4 Hz */
}

void initializePeripherals() {
    initializeGpio();
//    initializeTimer();
//
//    CLOCK_TIMER::startCounter();
}

volatile int tmp = 0;

void loop() {
    bool cnt = 0;

    while (true) {
        cnt = !cnt;

        (cnt) ? LED::setHigh() : LED::setLow();

        tmp = 10000;

        while(tmp > 0) {
            tmp--;
        }
    }
}

int main() {
    clk::initialize();

    initializePeripherals();

    loop();
}

void interrupt::TIM2()
{
    static u8 counter = 0;

    CLOCK_TIMER::clearUpdateFlag();

    if (counter++ % 2)
        LED::setHigh();
    else
        LED::setLow();
}
