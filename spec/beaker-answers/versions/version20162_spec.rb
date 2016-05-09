require 'spec_helper'

describe BeakerAnswers::Version20162 do
  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => @ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Answers.create(@ver, hosts, options) }
  let( :upgrade_answers )     { BeakerAnswers::Answers.create(@ver, hosts, options.merge( {:type => :upgrade}) ) }

  before :each do
    @ver = '2016.2'
    @answers = answers.answers
  end

  it 'should add orchestrator database answers to console' do
    expect( @answers['vm2'][:q_orchestrator_database_name] ).to be === 'pe-orchestrator'
    expect( @answers['vm2'][:q_orchestrator_database_user] ).to be === 'Orc3Str8R'
  end

  context 'when generating a hiera config' do
    let( :answers )     { BeakerAnswers::Answers.create(@ver, hosts, options, :hiera) }

    it 'should not have nil keys or values' do
      @answers.each_pair { |k, v|
        expect([k, v]).not_to include(nil)
      }
    end

    it 'should have values equal to the default answers' do
      expect(@answers["console_admin_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppet_enterpriseconsole_auth_password]
      expect(@answers["puppet_enterprise::certificate_authority_host"]).to be === basic_hosts[0].name
      expect(@answers["puppet_enterprise::puppet_master_host"]).to be === basic_hosts[0].name
      expect(@answers["puppet_enterprise::console_host"]).to be === basic_hosts[1].name
      expect(@answers["puppet_enterprise::puppetdb_host"]).to be === basic_hosts[2].name
      expect(@answers["puppet_enterprise::database_host"]).to be === basic_hosts[2].name
      expect(@answers["puppet_enterprise::pcp_broker_host"]).to be === basic_hosts[0].name
      expect(@answers["puppet_enterprise::mcollective_middleware_hosts"]).to be === [basic_hosts[0].name]
      expect(@answers["puppet_enterprise::activity_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_name]
      expect(@answers["puppet_enterprise::activity_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_password]
      expect(@answers["puppet_enterprise::activity_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_activity_database_user]
      expect(@answers["puppet_enterprise::classifier_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_name]
      expect(@answers["puppet_enterprise::classifier_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_password]
      expect(@answers["puppet_enterprise::classifier_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_classifier_database_user]
      expect(@answers["puppet_enterprise::orchestrator_database_name"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_name]
      expect(@answers["puppet_enterprise::orchestrator_database_password"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_password]
      expect(@answers["puppet_enterprise::orchestrator_database_user"]). to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_orchestrator_database_user]
      expect(@answers["puppet_enterprise::puppetdb_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_database_name]
      expect(@answers["puppet_enterprise::puppetdb_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_password]
      expect(@answers["puppet_enterprise::puppetdb_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_puppetdb_database_user]
      expect(@answers["puppet_enterprise::rbac_database_name"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_name]
      expect(@answers["puppet_enterprise::rbac_database_password"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_password]
      expect(@answers["puppet_enterprise::rbac_database_user"]).to be === BeakerAnswers::Answers::DEFAULT_ANSWERS[:q_rbac_database_user]
    end

    context 'when database cert auth is enabled' do
      let( :options ) do
        {
          :database_cert_auth => true
        }
      end

      it 'should not include the default database passwords' do
        expect(@answers).not_to include("puppet_enterprise::puppetdb_database_password")
        expect(@answers).not_to include("puppet_enterprise::classifier_database_password")
        expect(@answers).not_to include("puppet_enterprise::activity_database_password")
        expect(@answers).not_to include("puppet_enterprise::rbac_database_password")
        expect(@answers).not_to include("puppet_enterprise::orchestrator_database_password")
      end
    end

    context 'when overriding answers' do
      let( :options ) do
        {
          :answers => {
            'puppet_enterprise' =>  { 'certificate_authority_host' => 'enterpriseca.vm' },
            'puppet_enterprise::console_host' => 'enterpriseconsole.vm'
          }
        }
      end

      it 'should override the defaults when multi-level hash :answers are given' do
        expect(@answers["puppet_enterprise::certificate_authority_host"]).to be === 'enterpriseca.vm'
      end

      it 'should override the defaults when a :: delimited key is given' do
        expect(@answers["puppet_enterprise::console_host"]).to be === 'enterpriseconsole.vm'
      end
    end
  end
end
