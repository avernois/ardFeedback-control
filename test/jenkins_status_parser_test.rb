require "test/unit"

require_relative "../lib/jenkins_status_parser.rb"

class JenkinsStatusParserTest < Test::Unit::TestCase

    def setup 
        @jenkinsParser = JenkinsStatusParser.new
    end

	def test_blue_only_builds_is_success_build
        status = @jenkinsParser.get_status xml_jenkins ["blue"]

        assert_equal(:success, status)
    end

    def test_yellow_only_builds_is_unstable_build
        status = @jenkinsParser.get_status xml_jenkins ["yellow"]

        assert_equal(:unstable, status)
    end

    def test_blue_and_yellow_is_unstable_build
        status = @jenkinsParser.get_status xml_jenkins ["blue", "yellow"]

        assert_equal(:unstable, status)
    end

    def test_yellow_and_anime_is_building
        status = @jenkinsParser.get_status xml_jenkins ["yellow", "blue_anime"]

        assert_equal(:building, status)
    end

    def test_blue_and_red_builds_is_failed_build
        status = @jenkinsParser.get_status xml_jenkins ["blue", "red"]

        assert_equal(:failed, status)
    end

    def test_yellow_and_red_builds_is_failed_build
        status = @jenkinsParser.get_status xml_jenkins ["yellow", "red"]

        assert_equal(:failed, status)
    end

    def test_blue_and_anime_builds_is_building
        status = @jenkinsParser.get_status xml_jenkins ["blue", "blue_anime"]

        assert_equal(:building, status)
    end

    def test_red_and_anime_builds_is_building
        status = @jenkinsParser.get_status xml_jenkins ["red", "blue_anime"]

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
