require 'spec_helper'

describe ClientTool::DataLoader do
  describe '#self.load' do
    let(:path) { 'spec/fixtures/client.json' }
    subject(:method) { described_class.load(path) }

    context 'when the file does not exist' do
      let(:path) { 'spec/fixtures/unknown.json' }

      it { is_expected.to be_nil }
    end

    context 'when the file exists' do
      let(:path) { 'spec/fixtures/client.json' }

      context 'when the file is empty' do
        before { allow(File).to receive(:zero?).and_return(true) }

        it { is_expected.to be_nil }
      end

      context 'when the file not empty' do
        context 'when the file is not readable' do
          before { allow(File).to receive(:readable?).and_return(false) }

          it { is_expected.to be_nil }
        end

        context 'when the file is readable' do
          context 'when the file is not a JSON file' do
            before { allow(File).to receive(:extname).and_return('.txt') }

            it { is_expected.to be_nil }
          end
        end
      end

      context 'when file is valid' do
        it 'loads the file and returns the Array of Hash' do
          result = method
          expect(result).not_to be_empty
          expect(result).to be_instance_of Array
        end
      end
    end

    context 'when raised error' do
      before { allow(JSON).to receive(:parse).and_raise(JSON::ParserError) }

      it { is_expected.to be_nil }
    end
  end
end
