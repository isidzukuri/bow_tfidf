module BowTfidf
  class Classifier
    attr_reader :bow, :score

    def initialize(bow)
      raise(ArgumentError, 'BowTfidf::BagOfWords instance expected') unless bow.is_a?(BowTfidf::BagOfWords)

      @bow = bow
    end

    def call(tokens)
      raise(ArgumentError, 'Array of strings expected') unless tokens.is_a?(Array)

      @score = {}

      tokens.each do |word|
        process_word(word)
      end

      result
    end

    private

    def find_word(word)
      bow.words[word]
    end

    def category_by_id(id)
      return nil unless id

      bow.categories.values.find { |category| category[:id] == id }
    end

    def process_word(word)
      return unless (word_data = find_word(word.to_s))

      word_data[:categories].each do |category_id, word_category_relation|
        score[category_id] = 0 unless score[category_id]
        score[category_id] += word_category_relation[:tfidf]
      end
    end

    def category_by_highest_score
      ranking = score.max_by { |_k, v| v }

      return unless ranking

      category_id = ranking[0]
      category_by_id(category_id)[:key]
    end

    def display_score
      sorted = score.sort_by { |_k, v| v }.reverse
      result_hash = {}
      sorted.each do |item|
        key = category_by_id(item[0])[:key]
        result_hash[key] = item[1]
      end

      result_hash
    end

    def result
      {
        category_key: category_by_highest_score,
        score: display_score
      }
    end
  end
end
