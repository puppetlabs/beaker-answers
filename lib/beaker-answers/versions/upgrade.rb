module BeakerAnswers
  # In the case of upgrades, we only start with the answer for installation
  class Upgrade < Answers
    def default_upgrade_answers
      { :q_install => answer_for(@options, :q_install) }
    end

    def generate_answers
      the_answers = {}
      @hosts.each do |host|
        the_answers[host.name] = default_upgrade_answers
      end
      the_answers
    end
  end
end
