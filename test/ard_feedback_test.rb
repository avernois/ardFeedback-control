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

    @yellow_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>yellow</color>
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

    @yellow_and_anime_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>yellow</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>yellow_anime</color>
    </job>
    </hudson>
EOL

    @blue_and_yellow_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>blue</color>
    </job>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>yellow</color>
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

    @yellow_and_red_xml = <<EOL
    <hudson>
    <job>
    <name>thats_my_job</name>
    <url>http://localhost:8080/job/thats_my_job/</url>
    <color>yellow</color>
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

    def test_unstable_should_light_yellow
        @ardFeedback.light_led :unstable
        assert_equal("Y", @serial.last_written)
    end
    
    def test_blue_only_builds_is_success_build
        status = @ardFeedback.get_status @blue_xml

        assert_equal(:success, status)
    end

    def test_yellow_only_builds_is_unstable_build
        status = @ardFeedback.get_status @yellow_xml

        assert_equal(:unstable, status)
    end

    def test_blue_and_yellow_is_unstable_build
        status = @ardFeedback.get_status @blue_and_yellow_xml

        assert_equal(:unstable, status)
    end

    def test_yellow_and_anime_is_building
        status = @ardFeedback.get_status @yellow_and_anime_xml

        assert_equal(:building, status)
    end

    def test_blue_and_red_builds_is_failed_build
        status = @ardFeedback.get_status @blue_and_red_xml

        assert_equal(:failed, status)
    end

    def test_yellow_and_red_builds_is_failed_build
        status = @ardFeedback.get_status @yellow_and_red_xml

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