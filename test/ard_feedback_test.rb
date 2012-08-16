require "test/unit"

require_relative "../lib/ard_feedback.rb"

class ArdFeedbackTest < Test::Unit::TestCase

    def setup 
        @serial = SerialMock.new
        @ardFeedback = ArdFeedback.new @serial
    end

    def test_success_should_blink_led
        @ardFeedback.light_led :building
        assert_equal("B", @serial.last_written)
    end

    def test_build_with_at_least_one_red_and_no_anime_should_light_red
        @ardFeedback.light_led :failed
        assert_equal("R", @serial.last_written)
    end

    def test_build_with_only_blue_and_no_anime_should_light_green
        @ardFeedback.light_led :success
        assert_equal("G", @serial.last_written)
    end

    def test_unstable_should_light_yellow
        @ardFeedback.light_led :unstable
        assert_equal("Y", @serial.last_written)
    end

end

class SerialMock 
    def initialize
        @written = ""
    end
    def write(char)
        @written = char
    end

    def last_written
        @written
    end
end