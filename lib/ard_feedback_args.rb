require "trollop"

class ArdFeedbackArgs
    def self.parse_args
        opts = Trollop::options do 
        	opt :url, "Url to /xml/api for jenkins or builds.json for travis", :type => String, :short => "-u"
            opt :jenkins, "Use jenkins parser", :short => "-j"
            opt :travis, "travis api url", :short => "-t"
            opt :serial, "Serial port use to communicate with arduino", :short => "-s", :default => "/dev/ttyACM0"
            opt :refresh, "Delay between requests to jenkins (in seconds)", :short => "-r", :type => Integer, :default => 30
        end
		Trollop::die :jenkins, "cannot be define with travis" if (opts[:jenkins] && opts[:travis])

		opts
    end
end