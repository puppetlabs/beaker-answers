require 'spec_helper'
require 'json'

RSpec.shared_examples 'pe.conf' do
    let( :options )      { { :format => 'hiera' } }
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
            :format => 'hiera',
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
            :format => 'hiera',
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
        let(:options) { { :format => 'hiera' }.merge(:answers => string_answer) }

        it 'raises a TypeError' do
          expect { answers.answers }.to raise_error(TypeError, /q_ answers are not supported/)
        end
      end

      context 'when key is a symbol' do
        let(:options) { { :format => 'hiera' }.merge(:answers => symbol_answer) }

        it 'raises a TypeError' do
          expect { answers.answers }.to raise_error(TypeError, /q_ answers are not supported/)
        end
      end
    end

    context 'when overriding answers' do
      let( :options ) do
        {
          :format  => 'hiera',
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
          :format  => 'hiera',
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

describe BeakerAnswers::Version20162 do
  let( :ver )         { '2016.2.0' }
  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let( :answer_hash ) { answers.answers }

  it 'adds orchestrator database answers to console' do
    expect( answer_hash['vm2'][:q_orchestrator_database_name] ).to be === 'pe-orchestrator'
    expect( answer_hash['vm2'][:q_orchestrator_database_user] ).to be === 'Orc3Str8R'
  end

  it 'generates valid answers if #answer_string is called' do
    expect( answers.answer_string(basic_hosts[2]) ).to match(/q_orchestrator_database_name=pe-orchestrator/)
  end

  context 'when generating a hiera config' do
    context 'for a monolithic install' do
      let( :basic_hosts ) { make_hosts( {'pe_ver' => ver }, 1 ) }
      let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent', 'dashboard', 'database']
                      basic_hosts }
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_password,
          "puppet_enterprise::use_application_services" => true,
          "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        }
      end

      include_examples 'pe.conf'
    end

    context 'for a split install' do
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_password,
          "puppet_enterprise::use_application_services" => true,
          "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
          "puppet_enterprise::console_host" => basic_hosts[1].hostname,
          "puppet_enterprise::puppetdb_host" => basic_hosts[2].hostname,
        }
      end

      include_examples 'pe.conf'
    end
  end

  # This spec is just providing a baseline for :bash answer generation/regression.
  # This and bash answer generation in 2016.2.0+ should be dropped once we've cutover.
  it 'continues to provide same set of :bash answers' do
    expect(answer_hash).to eq({
      "vm1" => {
        :q_install=>"y",
        :q_vendor_packages_install=>"y",
        :q_puppetagent_install=>"y",
        :q_verify_packages=>"y",
        :q_puppet_symlinks_install=>"y",
        :q_puppetagent_certname=>"vm1",
        :q_puppetmaster_install=>"y",
        :q_all_in_one_install=>"n",
        :q_puppet_enterpriseconsole_install=>"n",
        :q_puppetdb_install=>"n",
        :q_database_install=>"n",
        :q_puppetagent_server=>"vm1",
        :q_puppetdb_hostname=>"vm3",
        :q_puppetdb_port=>8081,
        :q_puppetmaster_dnsaltnames=>"vm1,ip.address.for.vm1,puppet",
        :q_puppetmaster_enterpriseconsole_hostname=>"vm2",
        :q_puppetmaster_enterpriseconsole_port=>443,
        :q_puppetmaster_certname=>"vm1",
        :q_pe_check_for_updates=>"n",
        :q_exit_for_nc_migrate=>"n",
        :q_enable_future_parser=>"n",
        :q_update_server_host=>"vm1",
        :q_install_update_server=>"y",
        :q_orchestrator_database_name=>"pe-orchestrator",
        :q_orchestrator_database_user=>"Orc3Str8R",
        :q_orchestrator_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_database_host=>"vm3",
        :q_database_port=>5432,
        :q_use_application_services=>"y"
      },
      "vm2" => {
        :q_install=>"y",
        :q_vendor_packages_install=>"y",
        :q_puppetagent_install=>"y",
        :q_verify_packages=>"y",
        :q_puppet_symlinks_install=>"y",
        :q_puppetagent_certname=>"vm2",
        :q_puppetmaster_install=>"n",
        :q_all_in_one_install=>"n",
        :q_puppet_enterpriseconsole_install=>"y",
        :q_puppetdb_install=>"n",
        :q_database_install=>"n",
        :q_puppetagent_server=>"vm1",
        :q_puppetdb_hostname=>"vm3",
        :q_puppetdb_port=>8081,
        :q_puppetdb_database_name=>"pe-puppetdb",
        :q_puppetdb_database_user=>"mYpdBu3r",
        :q_puppetdb_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_puppet_enterpriseconsole_auth_database_name=>"console_auth",
        :q_puppet_enterpriseconsole_auth_database_user=>"mYu7hu3r",
        :q_puppet_enterpriseconsole_auth_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_puppet_enterpriseconsole_database_name=>"console",
        :q_puppet_enterpriseconsole_database_user=>"mYc0nS03u3r",
        :q_puppet_enterpriseconsole_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_database_host=>"vm3",
        :q_database_port=>5432,
        :q_pe_database=>"y",
        :q_puppet_enterpriseconsole_inventory_hostname=>"vm2",
        :q_puppet_enterpriseconsole_inventory_certname=>"vm2",
        :q_puppet_enterpriseconsole_inventory_dnsaltnames=>"vm2",
        :q_puppet_enterpriseconsole_inventory_port=>8140,
        :q_puppet_enterpriseconsole_master_hostname=>"vm1",
        :q_puppet_enterpriseconsole_auth_user_email=>"'admin@example.com'",
        :q_puppet_enterpriseconsole_auth_password=>"'~!@\#$%^*-/ aZ'",
        :q_puppet_enterpriseconsole_httpd_port=>443,
        :q_puppet_enterpriseconsole_smtp_host=>"'vm2'",
        :q_puppet_enterpriseconsole_smtp_use_tls=>"'n'",
        :q_puppet_enterpriseconsole_smtp_port=>"'25'",
        :q_puppetmaster_certname=>"vm1",
        :q_pe_check_for_updates=>"n",
        :q_classifier_database_user=>"DFGhjlkj",
        :q_classifier_database_name=>"pe-classifier",
        :q_classifier_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_activity_database_user=>"adsfglkj",
        :q_activity_database_name=>"pe-activity",
        :q_activity_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_rbac_database_user=>"RbhNBklm",
        :q_rbac_database_name=>"pe-rbac",
        :q_rbac_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_exit_for_nc_migrate=>"n",
        :q_enable_future_parser=>"n",
        :q_update_server_host=>"vm1",
        :q_use_application_services=>"y",
        :q_orchestrator_database_name=>"pe-orchestrator",
        :q_orchestrator_database_user=>"Orc3Str8R"
      },
      "vm3" => {
        :q_install=>"y",
        :q_vendor_packages_install=>"y",
        :q_puppetagent_install=>"y",
        :q_verify_packages=>"y",
        :q_puppet_symlinks_install=>"y",
        :q_puppetagent_certname=>"vm3",
        :q_puppetmaster_install=>"n",
        :q_all_in_one_install=>"n",
        :q_puppet_enterpriseconsole_install=>"n",
        :q_puppetdb_install=>"y",
        :q_database_install=>"y",
        :q_puppetagent_server=>"vm1",
        :q_puppetmaster_certname=>"vm1",
        :q_database_root_password=>"'=ZYdjiP3jCwV5eo9s1MBd'",
        :q_database_root_user=>"pe-postgres",
        :q_puppetdb_database_name=>"pe-puppetdb",
        :q_puppetdb_database_user=>"mYpdBu3r",
        :q_puppetdb_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_puppet_enterpriseconsole_auth_database_name=>"console_auth",
        :q_puppet_enterpriseconsole_auth_database_user=>"mYu7hu3r",
        :q_puppet_enterpriseconsole_auth_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_puppet_enterpriseconsole_database_name=>"console",
        :q_puppet_enterpriseconsole_database_user=>"mYc0nS03u3r",
        :q_puppet_enterpriseconsole_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_database_host=>"vm3",
        :q_database_port=>5432,
        :q_classifier_database_user=>"DFGhjlkj",
        :q_classifier_database_name=>"pe-classifier",
        :q_classifier_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_activity_database_user=>"adsfglkj",
        :q_activity_database_name=>"pe-activity",
        :q_activity_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_rbac_database_user=>"RbhNBklm",
        :q_rbac_database_name=>"pe-rbac",
        :q_rbac_database_password=>"'~!@\#$%^*-/ aZ'",
        :q_exit_for_nc_migrate=>"n",
        :q_enable_future_parser=>"n",
        :q_update_server_host=>"vm1",
        :q_orchestrator_database_name=>"pe-orchestrator",
        :q_orchestrator_database_user=>"Orc3Str8R",
        :q_orchestrator_database_password=>"'~!@\#$%^*-/ aZ'"
      },
    })
  end
end
