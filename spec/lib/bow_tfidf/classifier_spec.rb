require 'spec_helper'

RSpec.describe BowTfidf::Classifier do
  it 'raises exception if params not valid' do
    expect { described_class.new('') }.to raise_error(ArgumentError)
  end

  describe '.call' do
    let!(:words_by_labels) do
      {
        category1: %w[word word1],
        category2: %w[word word2],
        category3: %w[word word2 word3]
      }
    end
    let!(:bow) { BowTfidf::BagOfWords.new.add_labeled_data!(words_by_labels) }
    let!(:instance) { described_class.new(bow) }

    it 'raises exception if params not valid' do
      expect { instance.call('') }.to raise_error(ArgumentError)
      expect { instance.call({}) }.to raise_error(ArgumentError)
      expect { instance.call('word') }.to raise_error(ArgumentError)
    end

    it 'returns recognized category key and score' do
      result = instance.call(%w[word2 word3])

      expect(result).to eq(category_key: :category3,
                           score: {
                             category3: 0.27185717486836963,
                             category2: 0.09061905828945654
                           })
    end

    it 'returns recognized category key and score' do
      result = instance.call([])

      expect(result[:category_key]).to eq(nil)
      expect(result[:score]).to eq({})
    end

    it 'not recognize category if all given words not present in BOW' do
      result = instance.call(%w[unknown token])

      expect(result[:category_key]).to eq(nil)
      expect(result[:score]).to eq({})
    end

    it 'returns recognized category key and score' do
      result = instance.call(['word'])

      expect(result[:category_key]).to eq(nil)
      expect(result[:score]).to eq({})
    end
  end
end
