require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20172 do
  let(:ver)         { '2017.2.0' }
  let(:options)     { StringifyHash.new }
  let(:mono_hosts) do
    basic_hosts = make_hosts({'pe_ver' => ver }, 1)
    basic_hosts[0]['roles'] = ['master', 'agent', 'dashboard', 'database']
    basic_hosts[0]['platform'] = 'el-7-x86_64'
    basic_hosts
  end
  let(:split_hosts) do
    basic_hosts = make_hosts({'pe_ver' => ver }, 4)
    basic_hosts[0]['roles'] = ['master', 'agent']
    basic_hosts[0]['platform'] = 'el-6-x86_64'
    basic_hosts[1]['roles'] = ['dashboard', 'agent']
    basic_hosts[1]['platform'] = 'el-6-x86_64'
    basic_hosts[2]['roles'] = ['database', 'agent']
    basic_hosts[2]['platform'] = 'el-6-x86_64'
    basic_hosts[3]['roles'] = ['agent']
    basic_hosts[3]['platform'] = 'ubuntu-14.04-amd64'
    basic_hosts
  end
  let(:answers)     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let(:answer_hash) { answers.answers }

  context 'when generating a default 1.0 config' do
    context 'for a monolithic install' do
      let(:hosts) { mono_hosts }
      let(:gold_role_answers) do
        {
          "console_admin_password" => default_console_password,
          "puppet_enterprise::puppet_master_host" => hosts[0].hostname,
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end

    context 'for a split install' do
      let(:hosts) { split_hosts }
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_console_password,
          "puppet_enterprise::puppet_master_host" => hosts[0].hostname,
          "puppet_enterprise::console_host" => hosts[1].hostname,
          "puppet_enterprise::puppetdb_host" => hosts[2].hostname,
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end
  end

  context 'when generating a meep 2.0 config' do
    before(:each) do
      options[:meep_schema_version] = '2.0'
    end

    context 'for a monolithic install' do
      let(:hosts) { mono_hosts }
      let(:gold_role_answers) do
        {
          "console_admin_password" => default_console_password,
          "node_roles" => {
            "pe_role::monolithic::primary_master" => [hosts[0].hostname],
          },
          "agent_platforms" => match_array(['el_7_x86_64']),
          "meep_schema_version" => "2.0",
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 2.0 pe.conf'
    end

    context 'for a split install' do
      let(:hosts) { split_hosts }
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_console_password,
          "node_roles" => {
            "pe_role::split::primary_master" => [hosts[0].hostname],
            "pe_role::split::console" => [hosts[1].hostname],
            "pe_role::split::puppetdb" => [hosts[2].hostname],
          },
          "agent_platforms" => match_array(['el_6_x86_64', 'ubuntu_1404_amd64']),
          "meep_schema_version" => "2.0",
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 2.0 pe.conf'
    end
  end
end
