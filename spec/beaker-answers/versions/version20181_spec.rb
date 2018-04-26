require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20181 do
  let(:ver)         { '2018.1.0' }
  let(:options)     { StringifyHash.new }
  let(:mono_hosts) do
    basic_hosts = make_hosts({'pe_ver' => ver }, 1)
    basic_hosts[0]['roles'] = ['master', 'agent', 'dashboard', 'database']
    basic_hosts[0]['platform'] = 'el-7-x86_64'
    basic_hosts
  end
  let(:answers)     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let(:answer_hash) { answers.answers }

  context 'when generating a default 1.0 config' do
    context 'for a monolithic install' do
      let(:hosts) { mono_hosts }
      let(:gold_role_answers) do
        {
          "console_admin_password" => default_password,
          "puppet_enterprise::puppet_master_host" => hosts[0].hostname,
          "pe_infrastructure::agent::puppet_service_managed" => false,
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
          "console_admin_password" => default_password,
          "node_roles" => {
            "pe_role::monolithic::primary_master" => [hosts[0].hostname],
          },
          "agent_platforms" => match_array(['el_7_x86_64']),
          "pe_infrastructure::agent::puppet_service_managed" => false,
          "meep_schema_version" => "2.0",
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 2.0 pe.conf'
    end
  end
end
