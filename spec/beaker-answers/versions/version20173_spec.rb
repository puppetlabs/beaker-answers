require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20173to9999 do
  versions = [
    '2017.3.0',
    '2017.3.9999',
    '2018.1.0',
    '2018.1.9999',
    '2018.2.0',
    '2019.0.0',
    '2019.1.0',
    '2019.2.0',
    '2019.3.0',
    '2019.3.99',
    '2019.9.99',
    '2020.0.0',
    '2029.0.0',
    '2099.0.0',
    '2099.99.99',
  ]

  versions.each do | version |
    let(:ver)         { version }
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
            "console_admin_password" => default_console_password,
            "puppet_enterprise::puppet_master_host" => hosts[0].hostname,
          }
        end

        it "is testing version #{version}" do
          expect(version).not_to be_empty
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

        it "is testing version #{version}" do
          expect(version).not_to be_empty
        end

        include_examples 'pe.conf'
        include_examples 'valid MEEP 2.0 pe.conf'
      end
    end
  end
end
