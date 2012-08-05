require "test/unit"

require_relative "../lib/ard_feedback.rb"

class ArdFeedbackTest < Test::Unit::TestCase

  def setup

    @blue_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue</color>
    </job>

    </hudson>
EOL


    @blue_and_anime_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue_anime</color>
    </job>
    </hudson>
EOL

    @blue_and_red_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>red</color>
    </job>
    </hudson>
EOL

    @red_and_blue_anime_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>red</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue_anime</color>
    </job>
    </hudson>
EOL

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

def test_blue_only_builds_is_success_build
    status = @ardFeedback.get_status @blue_xml

    assert_equal(:success, status)
end

def test_blue_and_red_builds_is_failed_build
    status = @ardFeedback.get_status @blue_and_red_xml

    assert_equal(:failed, status)
end

def test_blue_and_anime_builds_is_building
    status = @ardFeedback.get_status @blue_and_anime_xml

    assert_equal(:building, status)
end

def test_red_and_anime_builds_is_building
    status = @ardFeedback.get_status @red_and_blue_anime_xml

    assert_equal(:building, status)
end

def test_should_accept_jenkins_arg
    ARGV[0] = "--jenkins"
    ARGV[1] = "http://my-localhost:8080/api/xml"


    args = ArdFeedbackArgs.parse_args
    assert_equal("http://my-localhost:8080/api/xml", args[:jenkins])
end

def test_should_accept_short_jenkins_arg
    ARGV[0] = "-j"
    ARGV[1] = "http://my-localhost:8080/api/xml"


    args = ArdFeedbackArgs.parse_args
    assert_equal("http://my-localhost:8080/api/xml", args[:jenkins])
end


def test_should_have_default_jenkins_arg
    args = ArdFeedbackArgs.parse_args
    assert_equal("http://localhost:8080/api/xml", args[:jenkins])
end

def test_should_accept_serial_arg
    ARGV[0] = "--serial"
    ARGV[1] = "/dev/serial"
    
    args = ArdFeedbackArgs.parse_args
    assert_equal("/dev/serial", args[:serial])
end

def test_should_accept_short_serial_arg
    ARGV[0] = "-s"
    ARGV[1] = "/dev/serial"
    
    args = ArdFeedbackArgs.parse_args
    assert_equal("/dev/serial", args[:serial])
end

def test_should_have_default_serial_arg
    args = ArdFeedbackArgs.parse_args
    assert_equal("/dev/ttyACM0", args[:serial])
end

def test_should_accept_refresh_arg
    ARGV[0] = "--refresh"
    ARGV[1] = "60"
    
    args = ArdFeedbackArgs.parse_args
    assert_equal(60, args[:refresh])
end

def test_should_accept_short_refresh_arg
    ARGV[0] = "-r"
    ARGV[1] = "60"
    
    args = ArdFeedbackArgs.parse_args
    assert_equal(60, args[:refresh])
end

def test_should_have_default_serial_arg
    args = ArdFeedbackArgs.parse_args
    assert_equal(30, args[:refresh])
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