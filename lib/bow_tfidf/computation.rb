module BowTfidf
  class Computation
    attr_reader :bow

    def initialize(bow)
      raise(ArgumentError, 'BowTfidf::BagOfWords instance expected') unless bow.is_a?(BowTfidf::BagOfWords)

      @bow = bow
    end

    def call
      compute_idf
      compute_tfidf
      bow
    end

    private

    def words
      bow.words
    end

    def categories
      bow.categories
    end

    def compute_idf
      words.each do |word, attrs|
        idf(attrs)

        words.delete(word) if attrs[:idf] == 0.0
      end
    end

    def idf(attrs)
      if categories.length == attrs[:categories].length
        attrs[:idf] = 0.0
      else
        # the number of categories / in how many occurs
        attrs[:idf] = Math.log10(1 + categories.length / attrs[:categories].length)
      end
    end

    def compute_tfidf
      categories.values.each do |category|
        category[:words].each do |category_word|
          next unless words[category_word]

          # how many times the word occurs in the category / the number of words in category
          # tf = category_word_attrs[:entries].to_f/category_attrs[:words].length
          tf = Math.log10(1 + words[category_word][:categories][category[:id]][:entries])

          words[category_word][:categories][category[:id]][:tf] = tf
          words[category_word][:categories][category[:id]][:tfidf] = tf * words[category_word][:idf]
        end
      end
    end
  end
end
