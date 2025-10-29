require 'json'
require 'spec_helper'

describe ClientTool::Search do
  let(:data) { JSON.parse(File.read('spec/fixtures/client.json')) }
  let(:value) { 'John' }
  subject(:method) { described_class.run(data, value) }

  describe '#self.run' do
    context 'when value matches the client name' do
      it 'returns the matching clients' do
        result = method
        expect(result).not_to be_empty
        expect(result).to be_instance_of Array
        expect(result[0]['full_name']).to include(value)
      end
    end

    context 'when value does not match the client name' do
      let(:value) { 'Unknown' }

      it 'returns an empty array' do
        result = method
        expect(result).to be_empty
      end
    end
  end
end
