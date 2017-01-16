require 'spec_helper'

describe 'BeakerAnswers::PeConf' do
  let(:basic_hosts) { make_hosts({'pe_ver' => ver }, host_count) }

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

    context 'split' do
      let(:host_count) { 5 }
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
          'ubuntu_1404_amd64'
        ]),
        "meep_schema_version" => "2.0",
      }
    end

    include_examples 'pe.conf configuration'
  end
end
