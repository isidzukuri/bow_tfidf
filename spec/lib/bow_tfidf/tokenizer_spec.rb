require 'spec_helper'
require 'awesome_print'

RSpec.describe BowTfidf::Tokenizer do
  describe '.call' do
    let!(:instance) { described_class.new }

    it 'raises exception if params not valid' do
      expect { instance.call }.to raise_error(ArgumentError)
    end

    it 'splits text into tokens' do
      result = instance.call('word word2, some! text')
      expect(result).to eq(Set['word', 'word2', 'some', 'text'])
    end

    it 'removes dublicates of tokens' do
      result = instance.call('word word')
      expect(result).to eq(Set['word'])
    end

    it 'ignores too short words' do
      result = instance.call('medal of honor')
      expect(result).to eq(Set['medal', 'honor'])
    end

    it 'ignores too long words' do
      result = instance.call('word: antidisestablishmentarianism')
      expect(result).to eq(Set['word'])
    end

    it 'ignores long digits' do
      result = instance.call('1234567')
      expect(result).to eq(Set[])
    end
  end
end
