require 'bundler' ; Bundler.require :development, :test
require 'gigo'
require 'minitest/autorun'
require 'erb'

module GIGO
  class TestCase < MiniTest::Spec

    include ERB::Util
    @@default_internal_encoding = Encoding.default_internal

    before { reset_encodings }


    private

    def reset_encodings
      Encoding.default_internal = @@default_internal_encoding
      GIGO.reset_encoding!
    end


  end
end
