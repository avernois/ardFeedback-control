#!/usr/bin/env ruby
require 'xmlsimple'
require "serialport"
require 'net/http'
require 'uri'
require "trollop"

require_relative "ard_feedback_args.rb"

class ArdFeedback

    def initialize (serial)
        @serial = serial
    end

    def get_status (xml_content)
        parse(xml_content)
        return :building if is_a_job_building
        return :failed if is_a_job 'red'
        return :success if is_a_job 'blue'
    end

    def light_led (status)
        case status
        when :building
            @serial.write("B")
        when :failed
            @serial.write("R")
        when :success
            @serial.write("G")
        end
    end

    private

    def parse(xmlContent)
        xmlContent = xmlContent
        @builds_result = XmlSimple.xml_in(xmlContent, 'ForceArray' => ["job"]) 
    end

    def is_a_job_building
        building= false

        @builds_result['job'].each { |job|
            building ||=  (job['color'].include? "_anime")
        }
        building
    end

    def is_a_job (color)
        result = false

        @builds_result['job'].each { |job|
            result ||=  (job['color'].eql? color)
        }
    
        result
    end

end

if $0 == __FILE__
    args = ArdFeedbackArgs.parse_args
    serial = SerialPort.new(args[:serial], 9600)
    feedback = ArdFeedback.new serial

    while(true)
        xml_content = Net::HTTP::get(URI::parse(args[:jenkins]))
        status = feedback.get_status(xml_content)
        feedback.light_led(status)

        sleep(args[:refresh])
    end
end



