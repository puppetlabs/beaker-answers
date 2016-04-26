module BeakerAnswers
  # In the case of upgrades, we lay down a much simpler file
  class Upgrade < Answers

    def self.upgrade_version_matcher
      /\A2015\.[123]|\A2016\.[1234]/
    end

    def generate_answers
      the_answers = {}
      @hosts.each do |host|
        the_answers[host.name] = {:q_install => answer_for(@options, :q_install)}
        # merge custom host answers if available
        the_answers[host.name] = the_answers[host.name].merge(host[:custom_answers]) if host[:custom_answers]
      end
      the_answers
    end
  end
end
