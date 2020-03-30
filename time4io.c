#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int getsw (void)
{
return ((PORTD >> 8) & 0xF); //den returnerar värdet av the "switches" som är påslagna
} //om den andra switchen på påslagen från höger då returneras värdet 2.

int getbtns(void)
{
  return ((PORTD >> 5) & 0x7); //returnerar värdet från the buttons som blir intryckta
}

int getbtn1 (void)
{
  return ((PORTF >> 1) & 0x1);
}
