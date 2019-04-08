module BowTfidf
  class BagOfWords
    attr_reader :words, :categories

    def initialize
      @words = {}
      @categories = {}
    end

    def add_labeled_data!(data)
      validate_labeled_data(data)

      data.each do |category_key, category_words|
        category = category_by_key(category_key)

        category_words.each do |word|
          add_word(word, category)
        end
      end

      compute_tfidf
    end

    private

    def validate_labeled_data(data)
      raise(ArgumentError, 'Hash with arrays expected') unless data.is_a?(Hash)

      data.values.each do |array|
        raise(ArgumentError, 'Hash with arrays expected') unless array.is_a?(Enumerable)

        raise(ArgumentError, 'Hash with arrays of strings expected') unless array.all? { |value| value.is_a?(String) }
      end
    end

    def add_word(word, category)
      words[word] = { categories: {} } unless words[word]
      words[word][:categories][category[:id]] ||= { entries: 0 }
      words[word][:categories][category[:id]][:entries] += 1

      categories[category[:key]][:words] << word
    end

    def category_by_key(key)
      unless categories[key]
        categories[key] = {
          id: categories.length,
          key: key,
          words: Set[]
        }
      end
      categories[key]
    end

    def compute_tfidf
      Computation.new(self).call
    end
  end
end
