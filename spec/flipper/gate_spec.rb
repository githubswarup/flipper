require 'helper'

describe Flipper::Gate do
  let(:adapter) { double('Adapter', :name => 'memory', :read => '22') }
  let(:feature) { double('Feature', :name => :search, :adapter => adapter) }

  subject {
    gate = described_class.new(feature)
    # implemented in subclass
    gate.stub({
      :key => :actors,
      :description => 'enabled',
    })
    gate
  }

  describe "#initialize" do
    it "sets feature" do
      gate = described_class.new(feature)
      gate.feature.should be(feature)
    end

    it "defaults instrumenter" do
      gate = described_class.new(feature)
      gate.instrumenter.should be(Flipper::Instrumenters::Noop)
    end

    it "allows overriding instrumenter" do
      instrumenter = double('Instrumentor')
      gate = described_class.new(feature, :instrumenter => instrumenter)
      gate.instrumenter.should be(instrumenter)
    end
  end

  describe "#inspect" do
    it "returns easy to read string representation" do
      subject.stub(:value => 22)
      string = subject.inspect
      string.should include('Flipper::Gate')
      string.should include('feature=:search')
      string.should include('description="enabled"')
      string.should include('value=22')
    end
  end
end
