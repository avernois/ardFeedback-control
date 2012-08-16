#!/usr/bin/env ruby
require "serialport"
require 'net/http'
require 'uri'

require_relative "ard_feedback_args.rb"
require_relative "jenkins_status_parser.rb"
require_relative "travis_status_parser.rb"
class ArdFeedback

    def initialize (serial)
        @serial = serial
    end

    def light_led (status)
        case status
        when :unstable
            @serial.write("U")
        when :building
            @serial.write("B")
        when :failed
            @serial.write("F")
        when :success
            @serial.write("S")
        end
    end

end

if $0 == __FILE__
    args = ArdFeedbackArgs.parse_args
    serial = SerialPort.new(args[:serial], 9600)
    feedback = ArdFeedback.new serial
   
    if (args[:travis])
        status_parser = TravisStatusParser.new
    else
        status_parser = JenkinsStatusParser.new
    end
    
    while(true)
        xml_content = Net::HTTP::get(URI::parse(args[:url]))
        status = status_parser.get_status(xml_content)
        feedback.light_led(status)

        sleep(args[:refresh])
    end
end



