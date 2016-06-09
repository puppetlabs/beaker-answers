require 'spec_helper'
require 'json'

RSpec.shared_examples 'pe.conf' do
    let( :answer_hiera ) { answers.answer_hiera }
    let( :default_password ) { '~!@#$%^*-/ aZ' }
    let( :gold_db_answers ) do
      {
        "puppet_enterprise::activity_database_user" => 'adsfglkj',
        "puppet_enterprise::classifier_database_user" => 'DFGhjlkj',
        "puppet_enterprise::orchestrator_database_user" => 'Orc3Str8R',
        "puppet_enterprise::puppetdb_database_user" => 'mYpdBu3r',
        "puppet_enterprise::rbac_database_user" => 'RbhNBklm',
      }
    end
    let( :gold_db_password_answers ) do
      {
        "puppet_enterprise::activity_database_password" => default_password,
        "puppet_enterprise::classifier_database_password" => default_password,
        "puppet_enterprise::orchestrator_database_password" => default_password,
        "puppet_enterprise::puppetdb_database_password" => default_password,
        "puppet_enterprise::rbac_database_password" => default_password,
      }
    end
    # This is a set of database parameters specified in host.cfg :answers
    # (for an external postgres, for instance)
    let( :overridden_database_parameters ) do
      {
        "puppet_enterprise::activity_database_name" => 'custom-activity',
        "puppet_enterprise::activity_database_user" => 'custom-activity-user',
        "puppet_enterprise::classifier_database_name" => 'custom-classifier',
        "puppet_enterprise::classifier_database_user" => 'custom-classifier-user',
        "puppet_enterprise::orchestrator_database_name" => 'custom-orchestrator',
        "puppet_enterprise::orchestrator_database_user" => 'custom-orchestrator-user',
        "puppet_enterprise::puppetdb_database_name" => 'custom-puppetdb',
        "puppet_enterprise::puppetdb_database_user" => 'custom-puppetdb-user',
        "puppet_enterprise::rbac_database_name" => 'custom-rbac',
        "puppet_enterprise::rbac_database_user" => 'custom-rbac-user',
        "puppet_enterprise::activity_database_password" => 'custom-activity-password',
        "puppet_enterprise::classifier_database_password" => 'custom-classifier-password',
        "puppet_enterprise::orchestrator_database_password" => 'custom-orchestrator-password',
        "puppet_enterprise::puppetdb_database_password" => 'custom-puppetdb-password',
        "puppet_enterprise::rbac_database_password" => 'custom-rbac-password',
      }
    end
    let( :overridding_parameters ) do
      {
        'puppet_enterprise::certificate_authority_host' => 'enterpriseca.vm',
        'puppet_enterprise::console_host' => 'enterpriseconsole.vm',
        'console_admin_password' => 'testing123',
      }
    end
    let( :gold_answers_with_overrides ) { gold_role_answers.merge(overridding_parameters) }

    it 'should not have nil keys or values' do
      answer_hash.each_pair { |k, v|
        expect([k, v]).not_to include(nil)
      }
    end

    it 'has the just the role and values for default install' do
      expect(answer_hash).to eq(
        gold_role_answers
      )
    end

    context 'when include_legacy_database_defaults' do
      context 'is false' do
        let(:options) do
          {
            :include_legacy_database_defaults => false,
          }
        end

        it 'has only the role values' do
          expect(answer_hash).to eq(gold_role_answers)
        end

        it 'also includes any explicitly added database parameters' do
          options.merge!(:answers => overridden_database_parameters)
          expect(answer_hash).to eq(
            gold_role_answers
              .merge(overridden_database_parameters)
          )
        end
      end

      context 'is true' do
        let(:options) do
          {
            :include_legacy_database_defaults => true,
          }
        end

        it 'has the role values and database defaults' do
          expect(answer_hash).to eq(
            gold_role_answers
              .merge(gold_db_answers)
          )
        end

        it 'overrides defaults with explicitly added database parameters' do
          options.merge!(:answers => overridden_database_parameters)
          expect(answer_hash).to eq(
            gold_role_answers
              .merge(overridden_database_parameters)
          )
        end
      end
    end

    it 'generates valid json if #answer_hiera is called' do
      expect(answer_hiera).not_to be_empty
      expect { JSON.load(answer_hiera) }.not_to raise_error
      expect(answer_hiera).to match "puppet_enterprise::puppet_master_host.*:.*#{basic_hosts[0].hostname}"
    end

    context 'with legacy answers present' do
      let(:string_answer) { { 'q_puppet_enterpriseconsole_auth_password' => 'password' } }
      let(:symbol_answer) { { :q_puppet_enterpriseconsole_auth_password => 'password' } }
      let(:answers) { BeakerAnswers::Answers.create(ver, hosts, options) }

      context 'when key is a string' do
        let(:options) { { :answers => string_answer } }

        it 'raises a TypeError' do
          expect { answers.answers }.to raise_error(TypeError, /q_ answers are not supported/)
        end
      end

      context 'when key is a symbol' do
        let(:options) { { :answers => symbol_answer } }

        it 'raises a TypeError' do
          expect { answers.answers }.to raise_error(TypeError, /q_ answers are not supported/)
        end
      end
    end

    context 'when overriding answers' do
      let( :options ) do
        {
          :answers => {
            'puppet_enterprise' =>  { 'certificate_authority_host' => 'enterpriseca.vm' },
            'puppet_enterprise::console_host' => 'enterpriseconsole.vm',
            'console_admin_password' => 'testing123',
          }
        }
      end

      it 'matches expected answers' do
        expect(answer_hash).to eq(gold_answers_with_overrides)
      end
    end

    context 'when overriding answers using symbolic keys' do
      let( :options ) do
        {
          :answers => {
            :puppet_enterprise =>  {
              :certificate_authority_host => 'enterpriseca.vm',
              :console_host => 'enterpriseconsole.vm',
            },
            :console_admin_password => 'testing123',
          }
        }
      end

      it 'matches expected answers' do
        expect(answer_hash).to eq(gold_answers_with_overrides)
      end
    end
end
