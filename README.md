# LED-Rings-2

This repo has two sets of code. One for the Arduino (gyro_LED_Wifi) to control light colours and brightness. The other (ring_interface_4) to run on a laptop. The two communicate over wifi.
The laptop sends an xml file with color data and the ring updates its color settings to match the code. The laptop program can instruct the Arduino to transition to a new color over a given amount of time or to allow the gyroscope to control the color settings.