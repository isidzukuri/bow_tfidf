# BowTfidf

Based on two concepts TFIDF and Bag-of-words.

### TFIDF
> TFIDF - In information retrieval, tf–idf or TFIDF, short for term frequency–inverse document frequency, is a numerical statistic that is intended to reflect how important a word is to a document in a collection or corpus. It is often used as a weighting factor in searches of information retrieval, text mining, and user modeling. The tf–idf value increases proportionally to the number of times a word appears in the document and is offset by the number of documents in the corpus that contain the word, which helps to adjust for the fact that some words appear more frequently in general. Tf–idf is one of the most popular term-weighting schemes today; 83% of text-based recommender systems in digital libraries use tf–idf.
Variations of the tf–idf weighting scheme are often used by search engines as a central tool in scoring and ranking a document's relevance given a user query. tf–idf can be successfully used for stop-words filtering in various subject fields, including text summarization and classification.

Read more about TFIDF on [Wikipedia](https://en.wikipedia.org/wiki/Tf%E2%80%93idf).


### Bag-of-words.
>The bag-of-words model is a simplifying representation used in natural language processing and information retrieval (IR). In this model, a text (such as a sentence or a document) is represented as the bag (multiset) of its words, disregarding grammar and even word order but keeping multiplicity. The bag-of-words model has also been used for computer vision.
The bag-of-words model is commonly used in methods of document classification where the (frequency of) occurrence of each word is used as a feature for training a classifier.

Read more about Bag-of-words on [Wikipedia](https://en.wikipedia.org/wiki/Bag-of-words_model).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bow_tfidf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bow_tfidf

## Usage

First of all bag of words with computed tfidf for each word should be created. For this add labeled words as a hash to bag of words:

```ruby
bow = BowTfidf::BagOfWords.new
bow.add_labeled_data!({
  category1: ['word', 'word1'],
  category2: ['word', 'word2']
  category3: ['word', 'word2', 'word3']
  })
```
Instance of `BowTfidf::BagOfWords` responds to `words` and `categories` methods:
```ruby
bow.words
#{
#    'word1' => {
#       categories: {
#         1 => {
#           tf: 0.3010299956639812,
#           tfidf: 0.14362780923945326
#         }
#       },
#       idf: 0.47712125471966244
#     },
#     ...
#}

bow.categories
#{
#    category1: {
#        id: 1,
#        key: :category1,
#        words: Set['word', 'word1']
#    },
#    ...
#}
```

To identify category of text pass array of words as argument to category classifier:
```ruby
classifier = BowTfidf::Classifier.new(bow)
classifier.call(['word2' 'word3'])
# {
#    category_key: :category3,
#    score: {
#        category3: 0.27185717486836963,
#        category2: 0.09061905828945654
#    }
# }
```
`:category_key` - assumption about category of text by given words. Is based on `:score`. The highest score wins.

`BowTfidf::Classifier` takes numerical interpretation of relation beetwen word and category, sums it up for each word and returns score.

### When classifier cannot recognize category:

1. all given words not in the BOW.
    - **Solution:** update BOW with new words.

2. each of given words belongs to all categories
    - In current implementation TFIDF tool ignores such words and not adding it to BOW. It is done with assumption that less frequent words should exists.

### Performance
To improve performance and memmory usage create dump of built BOW with light data structure(without unnecessary for classifier attributes) and custom classifier which can work with the dump.

### Split text into words(tokens)
```ruby
BowTfidf::Tokenizer.new.call('word word2, some! text')
# <Set: {"word", "word2", "some", "text"}>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isidzukuri/bow_tfidf.
