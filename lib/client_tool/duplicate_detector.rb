module ClientTool
  class DuplicateDetector
    # params [Array<Hash>] data
    # return [Hash] results
    def self.run(data)
      data.group_by { |client| client['email'] }.select { |_, clients| clients.size > 1 }
    end
  end
end
