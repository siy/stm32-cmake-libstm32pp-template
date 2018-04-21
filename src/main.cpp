//
// Created by siy on 4/19/18.
//

#include "clock.hpp"

#include "interrupt.hpp"

#include "peripheral/gpio.hpp"

typedef PA0 LED;

#include "peripheral/tim.hpp"

/* Seems needed if using HSE clock */
void clk::hseFailureHandler()
{
//  Do something if high speed clock fails
}


void initializeGpio() {
    LED::enableClock();

#ifdef STM32F1XX
    LED::setMode(gpio::cr::GP_PUSH_PULL_50MHZ);
#else
    LED::setMode(gpio::moder::OUTPUT);
#endif
}

void initializeTimer() {
    TIM6::enableClock();
    TIM6::configurePeriodicInterrupt<4>(); /* 4 Hz */
}

void initializePeripherals() {
    initializeGpio();
    initializeTimer();

    TIM6::startCounter();
}

int main() {
    clk::initialize();

    initializePeripherals();

    while (true) {
    }
}

#if defined VALUE_LINE || \
    defined STM32F2XX || \
    defined STM32F4XX
void interrupt::TIM6_DAC()
#else
void interrupt::TIM6()
#endif
{
    static u8 counter = 0;

    TIM6::clearUpdateFlag();

    if (counter++ % 2)
        LED::setHigh();
    else
        LED::setLow();
}
