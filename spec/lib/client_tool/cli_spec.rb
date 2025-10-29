require 'spec_helper'

describe ClientTool::Cli do
  let(:argv) { ['search', '--file', 'spec/fixtures/client.json', '--value', 'John'] }

  describe '#self.run' do
    it 'calls run method' do
      expect(described_class).to receive(:run).with(argv)
      described_class.run(argv)
    end
  end

  describe '#run' do
    let(:data) { JSON.parse(File.read('spec/fixtures/client.json')) }
    subject(:method) { described_class.new(argv).run }

    context 'when no file tag' do
      let(:argv) { ['search', '--value', 'John'] }

      it { expect { method }.to raise_error(RuntimeError, 'No file path present') }
    end

    context 'when file present but dataload fails' do
      before { allow(ClientTool::DataLoader).to receive(:load).and_return(nil) }

      it { expect { method }.to raise_error(RuntimeError, 'Error reading and parsing the file') }
    end

    context 'when file tag present' do
      context 'when search command' do
        context 'when value tag not present' do
          let(:argv) { ['search', '--file', 'spec/fixtures/client.json'] }

          it { expect { method }.to raise_error(RuntimeError, 'Search value cannot be empty') }
        end

        context 'when value tag present' do
          context 'when value is empty' do
            let(:argv) { ['search', '--value', '', '--file', 'spec/fixtures/client.json', '--value', ''] }

            it { expect { method }.to raise_error(RuntimeError, 'Search value cannot be empty') }
          end

          context 'when value is present' do
            it 'calls ClientTool::Search.run' do
              expect(ClientTool::Search).to receive(:run).with(data, 'John', 'full_name').and_return([{'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com'}])
              method
            end
          end
        end
      end

      context 'when duplicates command' do
        let(:argv) { ['duplicates', '--file', 'spec/fixtures/client.json'] }

        it 'calls ClientTool::DuplicateDetector.run' do
          expect(ClientTool::DuplicateDetector).to receive(:run).with(data).and_return({'john.doe@gmail.com' => [{'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com'}, {'id' => 2, 'full_name' => 'John Roe', 'email' => 'john.doe@gmail.com'}]})
          method
        end
      end

      context 'when unknown command' do
        let(:argv) { ['unknown', '--file', 'spec/fixtures/client.json'] }

        it { expect { method }.to raise_error(RuntimeError, 'Unknown command: unknown') }
      end
    end
  end
end
