require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20162 do
  let(:ver)         { '2016.2.0' }
  let(:options)     { StringifyHash.new }
  let(:basic_hosts) { make_hosts('pe_ver' => ver) }
  let(:hosts) do
    basic_hosts[0]['roles'] = %w[master agent]
    basic_hosts[1]['roles'] = %w[dashboard agent]
    basic_hosts[2]['roles'] = %w[database agent]
    basic_hosts
  end
  let(:answers)     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let(:answer_hash) { answers.answers }

  context 'when generating a hiera config' do
    context 'for a monolithic install' do
      let(:basic_hosts) { make_hosts({ 'pe_ver' => ver }, 1) }
      let(:hosts) do
        basic_hosts[0]['roles'] = %w[master agent dashboard database]
        basic_hosts
      end
      let(:gold_role_answers) do
        {
          'console_admin_password' => default_password,
          'puppet_enterprise::use_application_services' => true,
          'puppet_enterprise::puppet_master_host' => basic_hosts[0].hostname
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end

    context 'for a split install' do
      let(:gold_role_answers) do
        {
          'console_admin_password' => default_password,
          'puppet_enterprise::use_application_services' => true,
          'puppet_enterprise::puppet_master_host' => basic_hosts[0].hostname,
          'puppet_enterprise::console_host' => basic_hosts[1].hostname,
          'puppet_enterprise::puppetdb_host' => basic_hosts[2].hostname
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end
  end
end
