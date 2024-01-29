require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20163 do
  let( :ver )         { '2016.3.0' }
  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let( :answer_hash ) { answers.answers }

  context 'when generating a hiera config' do
    context 'for a monolithic install' do
      let( :basic_hosts ) { make_hosts( {'pe_ver' => ver }, 1 ) }
      let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent', 'dashboard', 'database']
                      basic_hosts }
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_console_password,
          "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end

    context 'for a split install' do
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_console_password,
          "puppet_enterprise::puppet_master_host" => basic_hosts[0].hostname,
          "puppet_enterprise::console_host" => basic_hosts[1].hostname,
          "puppet_enterprise::puppetdb_host" => basic_hosts[2].hostname,
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 1.0 pe.conf'
    end
  end
end
