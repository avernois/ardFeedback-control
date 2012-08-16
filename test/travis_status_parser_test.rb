require "test/unit"

require_relative "../lib/travis_status_parser.rb"

class TravisStatusParserTest < Test::Unit::TestCase
	def setup
		@json_finished_success = <<EOL
		[{"id":2139755,
	     "repository_id":186901,
	     "number":"1",
	     "state":"finished",
	     "result":0,
	     "started_at":"2012-08-16T09:15:58Z",
	     "finished_at":"2012-08-16T09:18:40Z",
	     "duration":162,
	     "commit":"1f2d366046e0052016c73dfe2bb49149d6260095",
	     "branch":"travis_config",
	     "message":"Add basic Travis CI config file.",
	     "event_type":"push"}]
EOL
		@json_finished_failed= <<EOL
		[{"id":2141413,
		  "repository_id":185225,
		  "number":"3",
		  "state":"finished",
		  "result":1,
		  "started_at":"2012-08-16T13:30:10Z",
		  "finished_at":"2012-08-16T13:30:30Z",
		  "duration":48,
		  "commit":"805688828ecdeb8c95db6e7eeff435fba447634b",
		  "branch":"master",
		  "message":"Small update",
		  "event_type":"push"}]
EOL

		@json_started= <<EOL
		[{"id":2141559,
			"repository_id":179320,
			"number":"9",
			"state":"started",
			"result":null,
			"started_at":"2012-08-16T13:52:04Z",
			"finished_at":null,
			"duration":null,
			"commit":"06a4ca6aae6d2033702624fe80d463316832713c",
			"branch":"jsbuild",
			"message":"[RJA-xxx][fix] Static resources should be packed and minified",
			"event_type":"push"}]
EOL


		@travis_status_parser = TravisStatusParser.new
	end

	def test_finished_result_0_is_success
		status = @travis_status_parser.get_status @json_finished_success

		assert_equal(:success, status)
	end

	def test_finished_result_1_is_failed
		status = @travis_status_parser.get_status @json_finished_failed

		assert_equal(:failed, status)
	end

	def test_stared_is_building
		status = @travis_status_parser.get_status @json_started

		assert_equal(:building, status)
	end

end