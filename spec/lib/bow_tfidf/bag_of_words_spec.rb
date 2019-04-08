require 'spec_helper'

RSpec.describe BowTfidf::BagOfWords do
  let!(:instance) { described_class.new }

  it 'has attributes' do
    expect(instance.words).to eq({})
    expect(instance.categories).to eq({})
  end

  describe '.add_labeled_data!' do
    let!(:words_by_labels) do
      {
        category1: %w[word word1],
        category2: %w[word word2]
      }
    end

    it 'returns bag of words' do
      result = instance.add_labeled_data!(words_by_labels)

      expect(result).to be_an_instance_of(described_class)
    end

    it 'returns computed tfidf' do
      result = instance.add_labeled_data!(words_by_labels)

      expect(result.words).to eq('word1' => {
                                   categories: {
                                     0 => {
                                       entries: 1,
                                       tf: 0.3010299956639812,
                                       tfidf: 0.14362780923945326
                                     }
                                   },
                                   idf: 0.47712125471966244
                                 },
                                 'word2' => {
                                   categories: {
                                     1 => {
                                       entries: 1,
                                       tf: 0.3010299956639812,
                                       tfidf: 0.14362780923945326
                                     }
                                   },
                                   idf: 0.47712125471966244
                                 })

      expect(result.categories).to eq(category1: {
                                        id: 0,
                                        key: :category1,
                                        words: Set['word', 'word1']
                                      },
                                      category2: {
                                        id: 1,
                                        key: :category2,
                                        words: Set['word', 'word2']
                                      })
    end

    it 'raises exception if params not valid' do
      expect { instance.add_labeled_data!('') }.to raise_error(ArgumentError)
      expect { instance.add_labeled_data!([]) }.to raise_error(ArgumentError)
      expect { instance.add_labeled_data!(key: '') }.to raise_error(ArgumentError)
      expect { instance.add_labeled_data!(key: [{}]) }.to raise_error(ArgumentError)
      expect { instance.add_labeled_data!(key: [11]) }.to raise_error(ArgumentError)
      expect { instance.add_labeled_data!(key: ['valid'], key2: '') }.to raise_error(ArgumentError)
    end
  end
end
