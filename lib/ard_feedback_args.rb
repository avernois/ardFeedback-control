require "trollop"

class ArdFeedbackArgs
    def self.parse_args
        Trollop::options do
            opt :jenkins, "jenkins api url", :default => "http://localhost:8080/api/xml", :short => "-j"
            opt :serial, "Serial port use to communicate with arduino", :short => "-s", :default => "/dev/ttyACM0"
            opt :refresh, "Delay between requests to jenkins (in seconds)", :short => "-r", :type => Integer, :default => 30
        end

    end
end