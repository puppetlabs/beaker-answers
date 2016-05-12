require 'spec_helper'
require 'json'

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
  let( :upgrade_answers )     { BeakerAnswers::Answers.create(ver, hosts, options.merge( {:type => :upgrade}) ) }

  it 'adds orchestrator database answers to console' do
    expect( answer_hash['vm2'][:q_orchestrator_database_name] ).to be === 'pe-orchestrator'
    expect( answer_hash['vm2'][:q_orchestrator_database_user] ).to be === 'Orc3Str8R'
  end

  it 'generates valid answers if #answer_string is called' do
    expect( answers.answer_string(basic_hosts[2]) ).to match /q_orchestrator_database_name=pe-orchestrator/
  end

  context 'when generating a hiera config' do
    let( :options )      { { :format => 'hiera' } }
    let( :answer_hiera ) { answers.answer_hiera }
    let( :default_password ) { '~!@#$%^*-/ aZ' }
    let( :gold_role_answers ) do
      {
        "console_admin_password" => default_password,
        "puppet_enterprise::use_application_services" => true,
        "puppet_enterprise::certificate_authority_host" => basic_hosts[0].hostname,
        "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        "puppet_enterprise::console_host" => basic_hosts[1].hostname,
        "puppet_enterprise::puppetdb_host" => basic_hosts[2].hostname,
        "puppet_enterprise::database_host" => basic_hosts[2].hostname,
        "puppet_enterprise::pcp_broker_host" => basic_hosts[0].hostname,
        "puppet_enterprise::mcollective_middleware_hosts" => [basic_hosts[0].hostname],
      }
    end
    let( :gold_db_answers ) do
      {
        "puppet_enterprise::activity_database_name" => 'pe-activity',
        "puppet_enterprise::activity_database_user" => 'adsfglkj',
        "puppet_enterprise::classifier_database_name" => 'pe-classifier',
        "puppet_enterprise::classifier_database_user" => 'DFGhjlkj',
        "puppet_enterprise::orchestrator_database_name" => 'pe-orchestrator',
        "puppet_enterprise::orchestrator_database_user" => 'Orc3Str8R',
        "puppet_enterprise::puppetdb_database_name" => 'pe-puppetdb',
        "puppet_enterprise::puppetdb_database_user" => 'mYpdBu3r',
        "puppet_enterprise::rbac_database_name" => 'pe-rbac',
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

    it 'should not have nil keys or values' do
      answer_hash.each_pair { |k, v|
        expect([k, v]).not_to include(nil)
      }
    end

    it 'has the role and db password values for default install' do
      expect(answer_hash).to eq(
        gold_role_answers
          .merge(gold_db_password_answers)
      )
    end

    context "with cert auth" do
      let(:options) do
        {
          :format => 'hiera',
          :database_cert_auth => true,
        }
      end

      it 'has the role values' do
        expect(answer_hash).to eq(gold_role_answers)
      end
    end

    context 'when upgrading' do
      let(:options) do
        {
          :format => 'hiera',
          :type => :upgrade,
        }
      end

      it 'has the role and all database values' do
        expect(answer_hash).to eq(
          gold_role_answers
            .merge(gold_db_answers)
            .merge(gold_db_password_answers)
        )
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

    context 'when database cert auth is enabled' do
      let( :options ) do
        {
          :format             => 'hiera',
          :database_cert_auth => true
        }
      end

      it 'does not include the default database passwords' do
        expect(answer_hash).not_to include("puppet_enterprise::puppetdb_database_password")
        expect(answer_hash).not_to include("puppet_enterprise::classifier_database_password")
        expect(answer_hash).not_to include("puppet_enterprise::activity_database_password")
        expect(answer_hash).not_to include("puppet_enterprise::rbac_database_password")
        expect(answer_hash).not_to include("puppet_enterprise::orchestrator_database_password")
      end
    end

    context 'when overriding answers' do
      let( :options ) do
        {
          :format  => 'hiera',
          :answers => {
            'puppet_enterprise' =>  { 'certificate_authority_host' => 'enterpriseca.vm' },
            'puppet_enterprise::console_host' => 'enterpriseconsole.vm'
          }
        }
      end

      it 'overrides the defaults when multi-level hash :answers are given' do
        expect(answer_hash["puppet_enterprise::certificate_authority_host"]).to be === 'enterpriseca.vm'
      end

      it 'overrides the defaults when a :: delimited key is given' do
        expect(answer_hash["puppet_enterprise::console_host"]).to be === 'enterpriseconsole.vm'
      end
    end
  end
end
