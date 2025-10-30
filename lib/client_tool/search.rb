module ClientTool
  class Search
    INVALID_KEY = 'invalid_key'.freeze

    # @params [Array<Hash>] data
    # @params [Array<Hash>|string(for invalid_key)] results
    def self.run(data, value, key='full_name')
      # considering all json objects have same keys
      keys = data.is_a?(Array) ? data.first.keys : data.keys
      return INVALID_KEY unless keys.include?(key)

      data.select { |client| client[key].downcase.include?(value.downcase) }
    end
  end
end
