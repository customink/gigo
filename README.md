
# GIGO (Garbage In, Garbage Out)

Or better yet, Garbage In, Gold Out! - The GIGO gem aims to fix ruby string encodings at all costs!

The GIGO gem is not likely the proper solutions. If you have bad encodings in your database, you should fix them and write consistent encodings. That said, if you have no other choice, GIGO can help.

This gem can utilize a series of transcoders but for now use the `ActiveSupport::Multibyte#tidy_bytes` to do most of the heavy lifting.


## Usage

Simple, just pass a string to `GIGO.load`. Nil values or properly encoded strings are returned. Else, `GIGO` will do its best to convert and force your default internal (or UTF-8) encoding.

```ruby
GIGO.load "€20 – “Woohoo”"
```

Lets say you have a `comments` column on an ActiveRecord model which is not guaranteed to come back per your default external encoding. However, take a look at the [gigo-activerecord](https://github.com/customink/gigo-activerecord) gem.

```ruby
def comments
  GIGO.load(super)
end
```

GIGO's encoding can be configured using the `GIGO.encoding` accessor. By default this is either `Encoding.default_internal` with a fallback to `Encoding::UTF_8`.


## Transcoders

GIGO transcoders can be any module or class that implements the `transcode` method. This method takes one argument, the string to transcode and can hook into the `GIGO.encoding` if needed. The default list of transcoders is.

* GIGO::Transcoders::ActiveSupport
* GIGO::Transcoders::Blind

GIGO attempts to use each in that order. Upon successful transcoding, we use the [EnsureValidEncoding](http://github.com/jrochkind/ensure_valid_encoding) gem to force an encoding to match the `GIGO.encoding` while removing any non-convertable characters.

#### Rails/ActiveSupport v2.3.x

When using GIGO with Rails/ActiveSupport 2.3., the `GIGO::Transcoders::CharlockHolmes` transcoder will be inserted before the `GIGO::Transcoders::ActiveSupport` one. This is needed because ActiveSupport's multibyte char support is weak in version 2.3.x. You will need to add this to your applications `Gemfile` since both `CharlockHolmes` and `Icon` are your responsibility to bundle it.

```ruby
gem 'iconv'
gem 'charlock_holmes', '~> 0.7'
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
$ bundle exec rake appraisal:activesupport32 test
```

