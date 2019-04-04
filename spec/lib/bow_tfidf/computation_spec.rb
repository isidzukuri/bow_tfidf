require 'spec_helper'

RSpec.describe BowTfidf::Computation do
  it 'raises exception if params not valid' do
    expect { described_class.new('') }.to raise_error(ArgumentError)
  end

  it 'computes tfidf' do
    result = described_class.new(BowMock.new).call

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
  end

  class BowMock < BowTfidf::BagOfWords
    def initialize
      @words = {
        'word' => { categories: { 0 => { entries: 1 }, 1 => { entries: 1 } } },
        'word1' => { categories: { 0 => { entries: 1 } } },
        'word2' => { categories: { 1 => { entries: 1 } } }
      }
      @categories = {
        category1: { id: 0, key: :category1, words: Set['word', 'word1'] },
        category2: { id: 1, key: :category2, words: Set['word', 'word2'] }
      }
    end
  end
end
