ArdFeedback-Control
======

Goal
----
[ArdFeedback](https://github.com/avernois/ardFeedback) and ArdFeedback-Control are the two parts of an Extrem Device Feedback.

ArdFeedback-Control is use to send command to an Arduino depending on status of build statuses of a Jenkins or Travis.
The Arduino should be connected to the computer where ArdFeedback-Control is running through serial.

Usage
-----

	ruby lib/ard_feedback.rb

Options:

*  --jenkins, -j     :   use with jenkins status (do not use with --travis)
*  --travis, -t     :   use with travis support (do not use with --jenkins)
*  --url, -u         :   url to check. /api/xml for jenkins, /builds.json for travis
*  --serial, -s <s\> :   Serial port use to communicate with arduino (default: /dev/ttyACM0)
*  --refresh, -r <i\>:   Delay between requests to jenkins (in seconds) (default: 30)
*  --help, -h        :   Show this message


TODO
====
* improve xml parsing (it may be parse up to 3 times, I could probably find better solution :)