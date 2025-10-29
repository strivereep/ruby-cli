require 'json'

module ClientTool
  class DataLoader
    # @params [String] path
    # @return [Array<Hash>] client data
    def self.load(path)
      # return if the file is invalid
      return unless valid_file?(path)

      JSON.parse(File.read(path))
    rescue => error
      $stderr.puts "Error: #{error}"
      nil
    end

    private

    def self.valid_file?(path)
      return false unless File.exist?(path)
      return false if File.zero?(path)
      return false unless File.readable?(path)
      return false unless File.extname(path) == '.json'

      true
    end
  end
end
