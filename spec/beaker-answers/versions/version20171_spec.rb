require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20171 do
  let(:ver)         { '2017.1.0' }
  let(:options)     { StringifyHash.new }
  let(:mono_hosts) do
    basic_hosts = make_hosts({ 'pe_ver' => ver }, 1)
    basic_hosts[0]['roles'] = %w[master agent dashboard database]
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
          'console_admin_password' => default_password,
          'puppet_enterprise::puppet_master_host' => hosts[0].hostname
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end
  end
end
