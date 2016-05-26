require 'spec_helper'

describe '#flatten_keys_to_joined_string' do
  it 'flattens a deep hash into a shallow one' do
    deep = {'a' => {'b' => {'c' => {'d' => 'e'}}}}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a::b::c::d' => 'e'})
  end

  it 'handles duplicate keys' do
    deep = {'a' => {'a' => {'a' => {'a' => 'a'}}}}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a::a::a::a' => 'a'})
  end

  it 'creates keys for each grandchilds values' do
    deep = {'a' => {'b' => 'c', 'd' => 'e'}}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a::b' => 'c'})
    expect(shallow).to include({'a::d' => 'e'})
  end

  it 'does not change keys with ::' do
    deep = {'a::b' => {'c::d' => 'e'}}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a::b::c::d' => 'e'})
  end

  it 'does not blow up on an empty hash' do
    deep = {}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({})
  end

  it 'converts key symbols to strings' do
    deep = {:a => 'b'}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a' => 'b'})
  end

  it 'converts nested key symbols to strings' do
    deep = {:a => {:b => 'c'}}
    shallow = flatten_keys_to_joined_string(deep)
    expect(shallow).to include({'a::b' => 'c'})
  end
end
