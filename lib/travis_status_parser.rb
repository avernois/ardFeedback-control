require "json"

class TravisStatusParser
	def get_status (json_status)
		# travis return builds ordered by number. The most recent build come first.
		last_build = JSON.parse(json_status)[0]
		
		return :building if (last_build["state"] == "started") || (last_build["state"] == "created")
		return :success if (last_build["result"] == 0)
		return :failed
	end
end