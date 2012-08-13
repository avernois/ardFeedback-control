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

    def test_blue_only_builds_is_success_build
        status = @ardFeedback.get_status xml_jenkins ["blue"]

        assert_equal(:success, status)
    end

    def test_yellow_only_builds_is_unstable_build
        status = @ardFeedback.get_status xml_jenkins ["yellow"]

        assert_equal(:unstable, status)
    end

    def test_blue_and_yellow_is_unstable_build
        status = @ardFeedback.get_status xml_jenkins ["blue", "yellow"]

        assert_equal(:unstable, status)
    end

    def test_yellow_and_anime_is_building
        status = @ardFeedback.get_status xml_jenkins ["yellow", "blue_anime"]

        assert_equal(:building, status)
    end

    def test_blue_and_red_builds_is_failed_build
        status = @ardFeedback.get_status xml_jenkins ["blue", "red"]

        assert_equal(:failed, status)
    end

    def test_yellow_and_red_builds_is_failed_build
        status = @ardFeedback.get_status xml_jenkins ["yellow", "red"]

        assert_equal(:failed, status)
    end

    def test_blue_and_anime_builds_is_building
        status = @ardFeedback.get_status xml_jenkins ["blue", "blue_anime"]

        assert_equal(:building, status)
    end

    def test_red_and_anime_builds_is_building
        status = @ardFeedback.get_status xml_jenkins ["red", "blue_anime"]

        assert_equal(:building, status)
    end


    def xml_jenkins(colors)
        xml = "<hudson>"

        colors.each do |color|
            xml += "<job>"
            xml += "<name>thats_my_job</name>"
            xml += "<url>http://localhost:8080/job/thats_my_job/</url>"
            xml += "<color>#{color}</color>"
            xml += "</job>"
        end
        xml += "</hudson>"
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