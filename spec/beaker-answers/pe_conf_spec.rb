require 'spec_helper'

describe 'BeakerAnswers::PeConf' do
  let(:basic_hosts) { make_hosts({'pe_ver' => ver }, host_count) }
  let(:host) { Beaker::Host.create('host', {}, make_host_opts('host', options.merge(platform))) }

  RSpec.shared_examples 'pe.conf configuration' do
    context 'monolithic' do
      let(:host_count) { 2 }
      let(:hosts) do
        basic_hosts[0]['roles'] = ['master', 'dashboard', 'database', 'agent']
        basic_hosts[0]['platform'] = 'el-6-x86_64'
        basic_hosts[1]['roles'] = ['agent']
        basic_hosts[1]['platform'] = 'el-7-x86_64'
        basic_hosts
      end

      it 'generates a hash of monolithic configuration data' do
        expect(BeakerAnswers::PeConf.new(hosts, meep_schema_version).configuration_hash).to(
          match(gold_mono_configuration_hash)
        )
      end
    end

    context 'pe_postgres_cert' do
      let(:host_count) { 2 }
      let(:hosts) do
        basic_hosts[0][:pe_postgresql_options] = {:security=>"cert"}
        basic_hosts[0]['roles'] = ['master', 'dashboard', 'database', 'agent']
        basic_hosts[0]['platform'] = 'el-6-x86_64'
        basic_hosts[1]['roles'] = ['agent', 'pe_postgres']
        basic_hosts[1]['platform'] = 'el-6-x86_64'
        basic_hosts
      end

      it 'generates a hash of monolithic configuring that uses an external postgres with cert setup' do
        expect(BeakerAnswers::PeConf.new(hosts, meep_schema_version, {:pe_postgresql_options => {:security => "cert"}}).configuration_hash).to(
          match(gold_pe_postgres_cert_configuration_hash)
        )
      end
    end

    context 'pe_postgres_password' do
      let(:host_count) { 2 }
      let(:hosts) do
        basic_hosts[0]['roles'] = ['master', 'dashboard', 'database', 'agent']
        basic_hosts[0]['platform'] = 'el-6-x86_64'
        basic_hosts[1]['roles'] = ['agent', 'pe_postgres']
        basic_hosts[1]['platform'] = 'el-6-x86_64'
        basic_hosts
      end

      it 'generates a hash of monolithic configuring that uses an external postgres with passwords' do
        expect(BeakerAnswers::PeConf.new(hosts, meep_schema_version,  {:pe_postgresql_options => {:security => "password"}}).configuration_hash).to(
          match(gold_pe_postgres_password_configuration_hash)
        )
      end
    end

    context 'split' do
      let(:host_count) { 6 }
      let(:hosts) do
        basic_hosts[0]['roles'] = ['master', 'agent']
        basic_hosts[0]['platform'] = 'el-6-x86_64'
        basic_hosts[1]['roles'] = ['dashboard', 'agent']
        basic_hosts[1]['platform'] = 'el-6-x86_64'
        basic_hosts[2]['roles'] = ['database', 'agent']
        basic_hosts[2]['platform'] = 'el-6-x86_64'
        basic_hosts[3]['roles'] = ['agent']
        basic_hosts[3]['platform'] = 'el-7-x86_64'
        basic_hosts[4]['roles'] = ['agent']
        basic_hosts[4]['platform'] = 'ubuntu-14.04-amd64'
        basic_hosts[5]['roles'] = ['agent']
        basic_hosts[5]['platform'] = 'windows-2016-64'
        basic_hosts
      end

      it 'generates a hash of split configuration data' do
        expect(BeakerAnswers::PeConf.new(hosts, meep_schema_version).configuration_hash).to(
          match(gold_split_configuration_hash)
        )
      end
    end
  end

  context '1.0 schema' do
    let(:ver)         { '2016.2.0' }
    let(:meep_schema_version) { '1.0' }
    let(:gold_mono_configuration_hash) do
      {
        "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
      }
    end
    let(:gold_split_configuration_hash) do
      {
        "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        "puppet_enterprise::console_host" => basic_hosts[1].hostname,
        "puppet_enterprise::puppetdb_host" => basic_hosts[2].hostname,
      }
    end
    let(:gold_pe_postgres_cert_configuration_hash) do
      {
        "puppet_enterprise::database_cert_auth" => true,
        "puppet_enterprise::database_ssl" => true,
        "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        "puppet_enterprise::database_host" => basic_hosts[1].hostname,
        "puppet_enterprise::puppetdb::start_timeout" => 300
      }
    end
    let(:gold_pe_postgres_password_configuration_hash) do
      {
        "puppet_enterprise::database_cert_auth" => true,
        "puppet_enterprise::database_ssl" => true,
        "puppet_enterprise::activity_database_password" => "PASSWORD",
        "puppet_enterprise::classifier_database_password" => "PASSWORD",
        "puppet_enterprise::orchestrator_database_password" => "PASSWORD",
        "puppet_enterprise::puppetdb_database_password" => "PASSWORD",
        "puppet_enterprise::rbac_database_password" => "PASSWORD",
        "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        "puppet_enterprise::database_host" => basic_hosts[1].hostname,
        "puppet_enterprise::puppetdb::start_timeout" => 300,
      }
    end
    include_examples 'pe.conf configuration'
  end

  context '2.0 schema' do
    let(:ver)         { '2017.2.0' }
    let(:meep_schema_version) { '2.0' }
    let(:gold_mono_configuration_hash) do
      {
        "node_roles" => {
          "pe_role::monolithic::primary_master" => [basic_hosts[0].hostname],
        },
        "agent_platforms" => match_array(['el_6_x86_64', 'el_7_x86_64']),
        "meep_schema_version" => "2.0",
      }
    end
    let(:gold_pe_postgres_cert_configuration_hash) do
      {
        "node_roles" => {
          "pe_role::monolithic::primary_master" => [basic_hosts[0].hostname],
        },
        "puppet_enterprise::profile::database" => basic_hosts[1].hostname,
        "agent_platforms" => ['el_6_x86_64'],
        "meep_schema_version" => "2.0",
        "puppet_enterprise::database_cert_auth" => true,
        "puppet_enterprise::database_ssl" => true,
        "puppet_enterprise::puppetdb::start_timeout" => 300
      }
    end
    let(:gold_pe_postgres_password_configuration_hash) do
      {
        "node_roles" => {
          "pe_role::monolithic::primary_master" => [basic_hosts[0].hostname],
        },
        "puppet_enterprise::profile::database" => basic_hosts[1].hostname,
        "agent_platforms" => ['el_6_x86_64'],
        "meep_schema_version" => "2.0",
        "puppet_enterprise::database_cert_auth" => true,
        "puppet_enterprise::database_ssl" => true,
        "puppet_enterprise::activity_database_password" => "PASSWORD",
        "puppet_enterprise::classifier_database_password" => "PASSWORD",
        "puppet_enterprise::orchestrator_database_password" => "PASSWORD",
        "puppet_enterprise::puppetdb_database_password" => "PASSWORD",
        "puppet_enterprise::rbac_database_password" => "PASSWORD",
        "puppet_enterprise::puppetdb::start_timeout" => 300
      }
    end
    let(:gold_split_configuration_hash) do
      {
        "node_roles" => {
          "pe_role::split::primary_master" => [basic_hosts[0].hostname],
          "pe_role::split::console" => [basic_hosts[1].hostname],
          "pe_role::split::puppetdb" => [basic_hosts[2].hostname],
        },
        "agent_platforms" => match_array([
          'el_6_x86_64',
          'el_7_x86_64',
          'ubuntu_1404_amd64',
          'windows_x86_64',
        ]),
        "meep_schema_version" => "2.0",
      }
    end

    include_examples 'pe.conf configuration'
  end

  describe 'the_host_with_role' do
    let(:host_count) { 2 }
    let(:mono_basic_hosts)   { make_hosts( { :pe_ver => '3.0',
                                      :platform => 'linux',
                                      :roles => [ 'agent' ],
                                        :type => 'pe'}, 4 ) }
    let(:mono_hosts) do
      mono_basic_hosts[0]['roles'] = ['master', 'dashboard', 'database', 'agent']
      mono_basic_hosts[0]['platform'] = 'el-6-x86_64'
      mono_basic_hosts[1]['roles'] = ['agent']
      mono_basic_hosts[1]['platform'] = 'el-6-x86_64'
      mono_basic_hosts
    end
    let(:host_count) { 4 }
    let(:split_basic_hosts)   { make_hosts( { :pe_ver => '3.0',
                                      :platform => 'linux',
                                      :roles => [ 'agent' ],
                                             :type => 'pe'}, 4 ) }
    let(:split_hosts) do
      split_basic_hosts[0]['roles'] = ['master','agent']
      split_basic_hosts[0]['platform'] = 'el-6-x86_64'
      split_basic_hosts[1]['roles'] = ['database','agent']
      split_basic_hosts[1]['platform'] = 'el-6-x86_64'
      split_basic_hosts[2]['roles'] = ['dashboard','agent']
      split_basic_hosts[2]['platform'] = 'el-6-x86_64'
      split_basic_hosts[3]['roles'] = ['agent']
      split_basic_hosts[3]['platform'] = 'el-6-x86_64'
      split_basic_hosts
    end

    it 'returns master in monolithic' do
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'master')).to eq(mono_basic_hosts[0])
    end

    it 'returns database in monolithic' do
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'database')).to eq(mono_basic_hosts[0])
    end

    it 'returns dashboard in monolithic' do
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'dashboard')).to eq(mono_basic_hosts[0])
    end

    it 'returns master in split' do
      peconf = BeakerAnswers::PeConf.new(split_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'master')).to eq(split_basic_hosts[0])
    end

    it 'returns database in split' do
      peconf = BeakerAnswers::PeConf.new(split_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'database')).to eq(split_basic_hosts[1])
    end

    it 'returns dashboard in split' do
      peconf = BeakerAnswers::PeConf.new(split_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'dashboard')).to eq(split_basic_hosts[2])
    end

    it 'raises an error if multiple hosts have master role' do
      mono_hosts[1]['roles'] = ['master','agent']
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect{ peconf.send(:the_host_with_role, 'master') }.to raise_error(ArgumentError)
    end

    it 'raises an error if multiple hosts have database role' do
      mono_hosts[1]['roles'] = ['database','agent']
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect{ peconf.send(:the_host_with_role, 'database') }.to raise_error(ArgumentError)
    end

    it 'raises an error if multiple hosts have dashboard role' do
      mono_hosts[1]['roles'] = ['dashboard','agent']
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect{ peconf.send(:the_host_with_role, 'dashboard') }.to raise_error(ArgumentError)
    end

    it 'raises no error if multiple hosts have database role and flag is passed in' do
      mono_hosts[1]['roles'] = ['database','agent']
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'database', raise_error=false)).to eq(mono_basic_hosts[0])
    end

    it 'returns postgres node in monolithic if pe_postgres is set as a role' do
      mono_hosts[1]['roles'] = ['pe_postgres','agent']
      peconf = BeakerAnswers::PeConf.new(mono_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'pe_postgres')).to eq(mono_basic_hosts[1])
    end

    it 'returns postgres node in split if pe_postgres is set as a role' do
      split_hosts[3]['roles'] = ['pe_postgres','agent']
      peconf = BeakerAnswers::PeConf.new(split_hosts, "1.0")
      expect(peconf.send(:the_host_with_role, 'pe_postgres')).to eq(split_basic_hosts[3])
    end

  end

end
