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

    it 'should not have nil keys or values' do
      answer_hash.each_pair { |k, v|
        expect([k, v]).not_to include(nil)
      }
    end

    it 'has values equal to the default answers' do
      expect(answer_hash["console_admin_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppet_enterpriseconsole_auth_password]
      expect(answer_hash["puppet_enterprise::certificate_authority_host"]).to be === basic_hosts[0].hostname
      expect(answer_hash["puppet_enterprise::puppet_master_host"]).to be === basic_hosts[0].hostname
      expect(answer_hash["puppet_enterprise::console_host"]).to be === basic_hosts[1].hostname
      expect(answer_hash["puppet_enterprise::puppetdb_host"]).to be === basic_hosts[2].hostname
      expect(answer_hash["puppet_enterprise::database_host"]).to be === basic_hosts[2].hostname
      expect(answer_hash["puppet_enterprise::pcp_broker_host"]).to be === basic_hosts[0].hostname
      expect(answer_hash["puppet_enterprise::mcollective_middleware_hosts"]).to be === [basic_hosts[0].hostname]
      expect(answer_hash["puppet_enterprise::activity_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_name]
      expect(answer_hash["puppet_enterprise::activity_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_password]
      expect(answer_hash["puppet_enterprise::activity_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_user]
      expect(answer_hash["puppet_enterprise::classifier_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_name]
      expect(answer_hash["puppet_enterprise::classifier_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_password]
      expect(answer_hash["puppet_enterprise::classifier_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_user]
      expect(answer_hash["puppet_enterprise::orchestrator_database_name"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_name]
      expect(answer_hash["puppet_enterprise::orchestrator_database_password"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_password]
      expect(answer_hash["puppet_enterprise::orchestrator_database_user"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_user]
      expect(answer_hash["puppet_enterprise::puppetdb_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_database_name]
      expect(answer_hash["puppet_enterprise::puppetdb_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_database_password]
      expect(answer_hash["puppet_enterprise::puppetdb_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_database_user]
      expect(answer_hash["puppet_enterprise::rbac_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_name]
      expect(answer_hash["puppet_enterprise::rbac_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_password]
      expect(answer_hash["puppet_enterprise::rbac_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_user]
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
