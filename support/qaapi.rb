module QaApi
  class << self
    # stub

    def received_messages_count(to, from)
      # stub
      0
    end

    def method_missing(m, *args, &block)
      puts "      [STUB] any QaApi method call. Actual method: #{m}"
    end
  end
end