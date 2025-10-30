require 'optparse'

module ClientTool
  class Cli

    # @params [Array<String>] argv
    def self.run(argv)
      new(argv).run
    rescue => error
      $stderr.puts "Error: #{error}"
      exit 1
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      options = parse_arguments
      command = options[:command]
      raise 'No command present: Accepted commands: search, duplicates' unless command
      raise 'No file path present' unless options[:file]

      data = ClientTool::DataLoader.load(options[:file])
      raise 'Error reading and parsing the file' unless data

      case command
      when 'search'
        raise 'Search value cannot be empty' if options[:value].nil? || options[:value].empty?

        key = \
          if options[:key].nil? || options[:key].empty?
            'full_name'
          else
            options[:key]
          end

        results = ClientTool::Search.run(data, options[:value], key)
        raise 'Invalid Key' if results == ::ClientTool::Search::INVALID_KEY

        handle_output(results, 'results')
      when 'duplicates'
        dups = ClientTool::DuplicateDetector.run(data)
        handle_output(dups, 'duplicates')
      else
        raise "Unknown command: #{command}"
      end
    end

    private

    attr_reader :argv

    def parse_arguments
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: bin/cli [search|duplicates] [options], For e.g. bin/cli search --key=full_name --value=smith --file=data/client.json '

        opts.on('-fPATH', '--file=PATH', 'Path to the JSON client data file') do |f|
          options[:file] = f
        end

        opts.on('-kSTRING', '--key=STRING', 'Hash key for searching (By default takes full_name)') do |k|
          options[:key] = k
        end

        opts.on('-vSTRING', '--value=STRING', 'Search value for name') do |v|
          options[:value] = v
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end

      parser.parse!(argv)
      command = argv.shift
      options[:command] = command

      options
    end

    # @params [Array<Hash>|<Hash>] results
    # @params [String] out
    def handle_output(results, out)
      if results.empty?
        $stdout.puts "No #{out} found"
      else
        $stdout.puts JSON.pretty_generate(results)
      end
    end
  end
end
