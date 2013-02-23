
# GIGO (Garbage In, Garbage Out)

Or better yet, Garbage In, Gold Out! - The GIGO gem aims to fix ruby string encodings at all costs!

The GIGO gem is not likely the proper solutions. If you have bad encodings in your database, you should fix them and write consistent encodings. That said, if you have no other choice, GIGO can help.

This gem depends on one of the many public forks of `CharDet` for ruby. Since `CharDet` is not a public gem and following proper semantic versioning, we have decided to vendor the [kirillrdy/rchardet](http://github.com/kirillrdy/rchardet) repo. We have even made sure that our vendored version stays in our namesacpe by using `GIGO::CharDet`. So if you have another version bundled, feel confident that the two will not conflict.

We use `GIGO::CharDet` to do the grunt work of finding the proper encoding of an untrusted string. Once found, we use the [EnsureValidEncoding](http://github.com/jrochkind/ensure_valid_encoding) gem to either force an encoding while removing any non-convertable characters.


## Usage

Simple, just pass a string to `GIGO.load`. Nil values or properly encoded strings are returned. Else, `GIGO` will do its best to convert and force your default internal (or UTF-8) encoding.

```ruby
  GIGO.load "€20 – “Woohoo”"
```

Lets say you have a `comments` column on an ActiveRecord model which is not guaranteed to come back per your default external encoding.

```ruby
def comments
  GIGO.load read_attribute(:comments)
end
```


## Contributing

GIGO is fully tested with ActiveSupport 3.0 to 4 and upward. If you detect a problem, open up a github issue or fork the repo and help out. After you fork or clone the repository, the following commands will get you up and running on the test suite. 

```shell
$ bundle install
$ bundle exec rake appraisal:setup
$ bundle exec rake appraisal test
```

We use the [appraisal](https://github.com/thoughtbot/appraisal) gem from Thoughtbot to help us generate the individual gemfiles for each ActiveSupport version and to run the tests locally against each generated Gemfile. The `rake appraisal test` command actually runs our test suite against all Rails versions in our `Appraisal` file. If you want to run the tests for a specific Rails version, use `rake -T` for a list. For example, the following command will run the tests for Rails 3.2 only.

```shell
$ bundle exec rake appraisal:rails32 test
```

