require 'spec_helper'
require 'json'

describe ClientTool::DuplicateDetector do
  subject(:method) { described_class.run(data) }

  describe '#self.run' do
    context 'when there are duplicates' do
      let(:data) { JSON.parse(File.read('spec/fixtures/client.json')) }

      it 'returns an Hash of duplicates' do
        result = method
        expect(result).not_to be_empty
        expect(result).to be_instance_of Hash
      end
    end

    context 'when there are no duplicates' do
      let(:data) { JSON.parse(File.read('spec/fixtures/data.json')) }

      it 'returns an empty Hash' do
        result = method
        expect(result).to be_empty
        expect(result).to be_instance_of Hash
      end
    end
  end
end
