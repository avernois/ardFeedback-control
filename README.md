ArdFeedback-Control
======

Goal
----
[ArdFeedback](https://github.com/avernois/ardFeedback) and ArdFeedback-Control are the two parts of an Extrem Device Feedback.

ArdFeedback-Control is use to send command to an Arduino depending on status of build statuses of a Jenkins server.
The Arduino should be connected to the computer where ArdFeedback-Control is running through serial.

Usage
-----

	ruby lib/ard_feedback.rb

Currently, jenkins location and serial port where the arduino is connected are hardcoded.

* jenkins : http://localhost:8080/api/xml
* serial : /dev/ttyACM0

It should not be to difficult to change it to match your need.


TODO
====
* currently, jenkins location and serial device are hardcoded. That's not very nice...
* improve xml parsing (it may be parse up to 3 times, I could probably find better solution :)