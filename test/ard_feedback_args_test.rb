require "test/unit"
require_relative "../lib/ard_feedback_args.rb"


class ArdFeedbackArgsTest < Test::Unit::TestCase
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