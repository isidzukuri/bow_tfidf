module BowTfidf
  class Tokenizer
    SPLIT_REGEX = /[\s\n\t\.,\-\!:()\/%\\+\|@^<«>*'~;=»\?—•$”\"’\[£“■‘\{#®♦°™€¥\]©§\}–]/

    attr_reader :tokens

    def initialize
      @tokens = Set[]
    end

    def call(text)
      raise(ArgumentError, 'String instance expected') unless text.is_a?(String)

      items = split(text)

      items.each do |token|
        process_item(token)
      end

      tokens
    end

    private

    def split(text)
      text.split(SPLIT_REGEX)
    end

    def process_item(token)
      return if token.length > 15
      return if token.length < 3
      return if token.scan(/\D/).empty? # skip if str contains only digits

      tokens << token.downcase
    end
  end
end
