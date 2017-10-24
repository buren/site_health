require 'spec_helper'

RSpec.describe SiteHealth::KeyStruct do
  it 'works with all arguments present' do
    klass = described_class.new(:name, :age)
    instance = klass.new(name: 'buren', age: 28)

    expect(instance.name).to eq('buren')
    expect(instance.age).to eq(28)
  end

  it 'works with some arguments present' do
    klass = described_class.new(:name, :age)
    instance = klass.new(name: 'buren')

    expect(instance.name).to eq('buren')
    expect(instance.age).to be_nil
  end

  it 'works with no arguments present' do
    klass = described_class.new(:name, :age)
    instance = klass.new

    expect(instance.name).to be_nil
    expect(instance.age).to be_nil
  end

  it 'raises ArgumentError if passed unknown key' do
    klass = described_class.new(:name)

    expect { klass.new(watman: 'buren') }.to raise_error(ArgumentError)
  end
end
