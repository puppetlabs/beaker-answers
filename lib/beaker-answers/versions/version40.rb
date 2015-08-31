require 'beaker-answers/versions/version38'
module BeakerAnswers
  # This class provides answer file information for PE version 4.0
  #
  # @api private
  class Version40 < Version38

    # The version of PE that this set of answers is appropriate for
    def self.pe_version_matcher
      /(\A3\.99)|(\A4\.0)|(\A2015\.[012])/
    end

    def generate_answers
      masterless = @options[:masterless]
      return super if masterless

      master = only_host_with_role(@hosts, 'master')

      the_answers = super

      # remove some old answers
      # - q_puppet_cloud_install
      # - q_puppet_enterpriseconsole_database_name 
      # - q_puppet_enterpriseconsole_database_password 
      # - q_puppet_enterpriseconsole_database_user

      the_answers.map do |vm, as|
        if as
          as.delete_if do |key, value|
            key =~ /q_puppet_cloud_install/
            #to be deleted in the future
            #|q_puppet_enterpriseconsole_database_name|q_puppet_enterpriseconsole_database_password|q_puppet_enterpriseconsole_database_user/
          end
        end
      end

      # add some new answers
      update_server_host    = answer_for(@options, :q_update_server_host, master.to_s)
      install_update_server = answer_for(@options, :q_install_update_server, 'y')

      the_answers.map do |key, value|
        the_answers[key][:q_update_server_host] = update_server_host if the_answers[key]
      end
      the_answers[master.name][:q_install_update_server] = install_update_server

      return the_answers
    end
  end
end
