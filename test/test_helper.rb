require 'bundler' ; Bundler.require :development, :test
require 'gigo'
require 'minitest/autorun'
require 'erb'

module GIGO
  class TestCase < MiniTest::Spec

    include ERB::Util

    before { setup_gigo }
    after  { teardown_gigo }


    private

    def setup_gigo
      @_default_gigo_encoding = GIGO.encoding
    end

    def teardown_gigo
      GIGO.encoding = @_default_gigo_encoding
    end
    
  end
end
