require 'spec_helper'
require 'json'

describe BeakerAnswers::Version20171 do
  let( :ver )         { '2017.1.0' }
  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[0]['platform'] = 'el-6-x86_64'
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[1]['platform'] = 'el-6-x86_64'
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts[2]['platform'] = 'ubuntu-14.04-amd64'
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Answers.create(ver, hosts, options) }
  let( :answer_hash ) { answers.answers }

  context 'when generating a hiera config' do
    context 'for a monolithic install' do
      let( :basic_hosts ) { make_hosts( {'pe_ver' => ver }, 1 ) }
      let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent', 'dashboard', 'database']
                      basic_hosts[0]['platform'] = 'el-7-x86_64'
                      basic_hosts }
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_password,
          "node_roles" => {
            "pe_role::monolithic::primary_master" => [basic_hosts[0].hostname],
          },
          "agent_platforms" => match_array(['el_7_x86_64'])
        }
      end

      it "accepts overrides to node_roles from beaker conf answers"

      include_examples 'pe.conf'
      include_examples 'valid MEEP 2.0 pe.conf'
    end

    context 'for a split install' do
      let( :gold_role_answers ) do
        {
          "console_admin_password" => default_password,
          "node_roles" => {
            "pe_role::split::primary_master" => [basic_hosts[0].hostname],
            "pe_role::split::console" => [basic_hosts[1].hostname],
            "pe_role::split::puppetdb" => [basic_hosts[2].hostname],
          },
          "agent_platforms" => match_array(['el_6_x86_64', 'ubuntu_1404_amd64'])
        }
      end

      include_examples 'pe.conf'
      include_examples 'valid MEEP 2.0 pe.conf'
    end
  end
end
