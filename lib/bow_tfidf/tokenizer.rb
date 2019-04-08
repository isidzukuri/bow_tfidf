module BowTfidf
  class Tokenizer
    SPLIT_REGEX = /[\s\n\t\.,\-\!:()\/%\\+\|@^<«>*'~;=»\?—•$”\"’\[£“■‘\{#®♦°™€¥\]©§\}–]/
    TOKEN_MIN_LENGTH = 3
    TOKEN_MAX_LENGTH = 15

    attr_reader :tokens

    def initialize
      @tokens = Set[]
    end

    def call(text)
      raise(ArgumentError, 'String instance expected') unless text.is_a?(String)

      raw_tokens = split(text)

      raw_tokens.each do |token|
        process_token(token)
      end

      tokens
    end

    private

    def split(text)
      text.split(SPLIT_REGEX)
    end

    def process_token(token)
      return if token.length < TOKEN_MIN_LENGTH
      return if token.length > TOKEN_MAX_LENGTH
      return if token.scan(/\D/).empty? # skip if str contains only digits

      tokens << token.downcase
    end
  end
end
