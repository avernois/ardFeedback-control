#!/usr/bin/env ruby
require "serialport"
require 'net/http'
require 'uri'

require_relative "ard_feedback_args.rb"
require_relative "jenkins_status_parser.rb"
class ArdFeedback

    def initialize (serial)
        @serial = serial
    end

    def light_led (status)
        case status
        when :unstable
            @serial.write("Y")
        when :building
            @serial.write("B")
        when :failed
            @serial.write("R")
        when :success
            @serial.write("G")
        end
    end

end

if $0 == __FILE__
    args = ArdFeedbackArgs.parse_args
    serial = SerialPort.new(args[:serial], 9600)
    feedback = ArdFeedback.new serial
    status_parser = JenkinsStatusParser.new
    while(true)
        xml_content = Net::HTTP::get(URI::parse(args[:jenkins]))
        status = status_parser.get_status(xml_content)
        feedback.light_led(status)

        sleep(args[:refresh])
    end
end



