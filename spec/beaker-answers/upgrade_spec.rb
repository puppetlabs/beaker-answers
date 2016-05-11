describe BeakerAnswers::Upgrade do
  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => @ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Upgrade.new(@ver, hosts, options.merge({:type => :upgrade}) ) }

  before :each do
    @ver = '3.8'
    @answers = answers.answers
  end

  context '#generate_answers' do
    it 'only adds the default yes for each host' do
      host_answers = answers.generate_answers
      host_answers.each do |host, host_answer|
        expect(host_answer).to eq({:q_install => 'y'})
        expect(host_answer.length).to eq(1)
      end
    end
  end

end

describe BeakerAnswers::Upgrade38 do

  let( :options )     { StringifyHash.new }
  let( :basic_hosts ) { make_hosts( {'pe_ver' => @ver } ) }
  let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                  basic_hosts[1]['roles'] = ['dashboard', 'agent']
                  basic_hosts[2]['roles'] = ['database', 'agent']
                  basic_hosts }
  let( :answers )     { BeakerAnswers::Answers.create(@ver, hosts, options.merge({:type => :upgrade}) ) }

  before :each do
    @ver = '3.8'
    @answers = answers.answers
  end

  context 'when no special answers are provided' do
    it "the master should have only three keys" do
      answer = @answers['vm1']
      expect(answer[:q_install]).to eq('y')
      expect(answer[:q_enable_future_parser]).to eq('y')
      expect(answer[:q_exit_for_nc_migrate]).to eq('n')
      expect(answer.length).to eq(3)
    end

    it 'the dashboard should have 19 keys provided' do
      answer = @answers['vm2']

      expect(answer[:q_install]).to eq('y')
      expect(answer[:q_enable_future_parser]).to eq('y')
      expect(answer[:q_exit_for_nc_migrate]).to eq('n')
      expect(answer[:q_rbac_database_name]).to eq(answers.answer_for(options, :q_rbac_database_name))
      expect(answer[:q_rbac_database_user]).to eq(answers.answer_for(options, :q_rbac_database_user))
      expect(answer[:q_rbac_database_password]).to eq("'#{(answers.answer_for(options, :q_rbac_database_password))}'")
      expect(answer[:q_activity_database_user]).to eq(answers.answer_for(options, :q_activity_database_user))
      expect(answer[:q_activity_database_name]).to eq(answers.answer_for(options, :q_activity_database_name))
      expect(answer[:q_activity_database_password]).to eq("'#{(answers.answer_for(options, :q_activity_database_password))}'")
      expect(answer[:q_classifier_database_name]).to eq(answers.answer_for(options, :q_database_name))
      expect(answer[:q_classifier_database_user]).to eq(answers.answer_for(options, :q_classifier_database_user))
      expect(answer[:q_classifier_database_password]).to eq("'#{(answers.answer_for(options, :q_classifier_database_password))}'")
      expect(answer[:q_puppetdb_database_name]).to eq(answers.answer_for(options, :q_puppetdb_database_name))
      expect(answer[:q_puppetdb_database_user]).to eq(answers.answer_for(options, :q_puppetdb_database_user))
      expect(answer[:q_puppetdb_database_password]).to eq(answers.answer_for(options, :q_puppetdb_database_password))
      expect(answer[:q_puppet_enterpriseconsole_auth_password]).to eq("'#{(answers.answer_for(options, :q_puppet_enterpriseconsole_auth_password))}'")
      expect(answer[:q_puppetdb_port]).to eq(answers.answer_for(options, :q_puppetdb_port))
      expect(answer[:q_install]).to eq('y')
      expect(answer[:q_enable_future_parser]).to eq('y')
      expect(answer[:q_exit_for_nc_migrate]).to eq('n')
      expect(answer.length).to eq(19)
    end
 
    it 'the database should have 13 keys provided' do
      answer = @answers['vm3']

      expect(answer[:q_install]).to eq('y')
      expect(answer[:q_enable_future_parser]).to eq('y')
      expect(answer[:q_exit_for_nc_migrate]).to eq('n')
      expect(answer[:q_rbac_database_name]).to eq(answers.answer_for(options, :q_rbac_database_name))
      expect(answer[:q_rbac_database_user]).to eq(answers.answer_for(options, :q_rbac_database_user))
      expect(answer[:q_rbac_database_password]).to eq("'#{(answers.answer_for(options, :q_rbac_database_password))}'")
      expect(answer[:q_activity_database_user]).to eq(answers.answer_for(options, :q_activity_database_user))
      expect(answer[:q_activity_database_name]).to eq(answers.answer_for(options, :q_activity_database_name))
      expect(answer[:q_activity_database_password]).to eq("'#{(answers.answer_for(options, :q_activity_database_password))}'")
      expect(answer[:q_classifier_database_name]).to eq(answers.answer_for(options, :q_database_name))
      expect(answer[:q_classifier_database_user]).to eq(answers.answer_for(options, :q_classifier_database_user))
      expect(answer[:q_classifier_database_password]).to eq("'#{(answers.answer_for(options, :q_classifier_database_password))}'")
      expect(answer[:q_install]).to eq('y')
      expect(answer[:q_enable_future_parser]).to eq('y')
      expect(answer[:q_exit_for_nc_migrate]).to eq('n')
      expect(answer.length).to eq(13)
    end
  end

  context 'when we set :q_enable_future_parser in global options' do
    let( :options ) {
      options = StringifyHash.new
      options[:answers] = { :q_enable_future_parser => 'thefutureparser!!!'}
      options
    }
    it 'sets that parser option from the global options' do
      @answers.each do |vmname, answer|
        expect(answer[:q_enable_future_parser]).to eq('thefutureparser!!!')
      end
    end

  context 'when per host custom answers are provided for the master and dashboard' do
    let( :hosts ) { basic_hosts[0]['roles'] = ['master', 'agent']
                    basic_hosts[0][:custom_answers] = { :q_custom0 => '0LOOK' }
                    basic_hosts[1]['roles'] = ['dashboard', 'agent']
                    basic_hosts[1][:custom_answers] = { :q_custom1 => 'LOOKLOOK',
                                                        :q_custom2 => "LOOK3"}
                    basic_hosts[2]['roles'] = ['database', 'agent']
                    basic_hosts }

    it 'adds those custom answers to the master' do
      expect( @answers['vm1'][:q_custom0] ).to be === '0LOOK'
      expect(@answers['vm1'].length).to eq(4)
    end

    it 'adds custom answers to the dashboard' do
      expect( @answers['vm2'][:q_custom1] ).to be === 'LOOKLOOK'
      expect( @answers['vm2'][:q_custom2] ).to be === 'LOOK3'
      expect( @answers['vm2'].length).to eq(21)
    end

    it 'does not add custom answers for the database' do
      expect(@answers['vm3'].length).to eq(13)
    end
  end

  end
end
