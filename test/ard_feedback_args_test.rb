require "test/unit"
require_relative "../lib/ard_feedback_args.rb"

module Trollop
  def with_standard_exception_handling parser
    yield
  end
  module_function :with_standard_exception_handling
end

class ArdFeedbackArgsTest < Test::Unit::TestCase
    def setup
        #as ARGV is system variable, we flush its content to prevent collision between test
        ARGV[0] = ""
        ARGV[1] = ""
    end

    def test_should_accept_url_arg
        ARGV[0] = "--url"
        ARGV[1] = "http://my-localhost:8080/api/xml"

        args = ArdFeedbackArgs.parse_args
        assert_equal("http://my-localhost:8080/api/xml", args[:url])
    end

    def test_should_accept_short_url_arg
        ARGV[0] = "-u"
        ARGV[1] = "http://my-localhost/api/xml"

        args = ArdFeedbackArgs.parse_args
        assert_equal("http://my-localhost/api/xml", args[:url])
    end

    def test_should_accept_jenkins_arg
        ARGV[0] = "--jenkins"

        args = ArdFeedbackArgs.parse_args
        assert_equal(true, args[:jenkins])
    end

    def test_should_accept_short_jenkins_arg
        ARGV[0] = "-j"

        args = ArdFeedbackArgs.parse_args
        assert_equal(true, args[:jenkins])
    end

    def test_jenkins_arg_should_be_false_when_not_define
        args = ArdFeedbackArgs.parse_args
        assert_equal(false, args[:jenkins])
    end

    def test_should_accept_travis_arg
        ARGV[0] = "--travis"

        args = ArdFeedbackArgs.parse_args
        assert_equal(true, args[:travis])
    end

    def test_should_accept_short_travis_arg
        ARGV[0] = "-t"

        args = ArdFeedbackArgs.parse_args
        assert_equal(true, args[:travis])
    end

    def test_travis_arg_should_be_false_when_not_define
        args = ArdFeedbackArgs.parse_args
        assert_equal(false, args[:travis])
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

    def test_should_not_accept_travis_and_jenkins
        ARGV[0] = "-t"
        ARGV[1] = "-j"
        assert_raise Trollop::CommandlineError do
          args = ArdFeedbackArgs.parse_args
        end
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