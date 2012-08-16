require "xmlsimple"

class JenkinsStatusParser
	def get_status(xml_content)
		parse(xml_content)
        return :building if is_a_job_building
        return :failed if is_a_job 'red'
        return :unstable if is_a_job 'yellow'
        return :success if is_a_job 'blue'
	end

	private
    def parse(xmlContent)
        xmlContent = xmlContent
        @builds_result = XmlSimple.xml_in(xmlContent, 'ForceArray' => ["job"]) 
    end

    def is_a_job_building
        building= false

        @builds_result['job'].each { |job|
            building ||=  (job['color'].include? "_anime")
        }
        building
    end

    def is_a_job (color)
        result = false

        @builds_result['job'].each { |job|
            result ||=  (job['color'].eql? color)
        }
    
        result
    end


end