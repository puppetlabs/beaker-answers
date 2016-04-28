module BeakerAnswers
  # In the case of upgrades, we lay down a much simpler file
  class Upgrade38 < Upgrade

    def self.upgrade_version_matcher
      /\A3\.8/
    end

    def generate_answers
      the_answers = super
      the_answers.map do |hostname, answers|
        # First check to see if there is a host option for this setting
        # and skip to the next object if it is already defined.
        if the_answers[hostname][:q_enable_future_parser]
          next
        # Check now if it was set in the global options.
        elsif @options[:answers] && @options[:answers][:q_enable_future_parser]
          the_answers[hostname][:q_enable_future_parser] = @options[:answers][:q_enable_future_parser]
          next
        # If we didn't set it on a per host or global option basis, set it to
        # 'y' here. We could have possibly set it in the DEFAULT_ANSWERS, but it
        # is unclear what kind of effect that might have on all the other answers
        # that rely on it defaulting to 'n'.
        else
          the_answers[hostname][:q_enable_future_parser] = 'y'
        end
      end

      the_answers.map do |hostname, answers|
        # First check to see if there is a host option for this setting
        # and skip to the next object if it is already defined.
        if the_answers[hostname][:q_exit_for_nc_migrate]
          next
        # Check now if it was set in the global options.
        elsif @options[:answers] && @options[:answers][:q_exit_for_nc_migrate]
          the_answers[hostname][:q_exit_for_nc_migrate] = @options[:answers][:q_exit_for_nc_migrate]
          next
        # If we didn't set it on a per host or global option basis, set it to
        # 'n' here. We could have possibly set it in the DEFAULT_ANSWERS, but it
        # is unclear what kind of effect that might have on all the other answers
        # that rely on it defaulting to 'n'.
        else
          the_answers[hostname][:q_exit_for_nc_migrate] = 'n'
        end
      end
      the_answers
    end
  end
end
