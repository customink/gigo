require 'active_support/multibyte'
require 'active_support/core_ext/object/acts_like'
require 'active_support/core_ext/string/behavior'
require 'ensure_valid_encoding'
require 'gigo/rchardet'
require 'gigo/version'

module GIGO

  module Transcoders
    class ActiveSupportMultibyteTranscoder
      def self.transcode(data, encoding)
        ActiveSupport::Multibyte.proxy_class.new(data).tidy_bytes
      end
    end

    class CharDetTranscoder
      def self.detect_encoding(data)
        CharDet.detect(data.dup)['encoding']
      end

      def self.transcode(data, encoding)
        source_encoding = detect_encoding(data) || data.encoding || Encoding.default_internal || Encoding::UTF_8
        data.force_encoding(source_encoding).encode encoding, :undef => :replace, :invalid => :replace
      end
    end

    class BlindTranscoder
      def self.transcode(data, encoding)
        data.encode encoding, :undef => :replace, :invalid => :replace
      end
    end
  end

  def self.load(data, transcoders = nil)
    return data if data.nil? || !data.acts_like?(:string)
    encoded_string = safe_detect_and_encoder(data, transcoders)
    return data if data.encoding == forced_encoding && data == encoded_string
    encoded_string
  end

  def self.default_transcoders
    @default_transcoders ||= [
      Transcoders::ActiveSupportMultibyteTranscoder,
      Transcoders::CharDetTranscoder,
      Transcoders::BlindTranscoder
    ]
  end

  protected

  def self.safe_detect_and_encoder(data, transcoders = nil)
    transcoders = (transcoders || default_transcoders).dup
    string = data

    begin
      string = transcoders.shift.transcode(string, forced_encoding)
    rescue Exception => e
      retry unless transcoders.empty?
    end

    string = EnsureValidEncoding.ensure_valid_encoding string, invalid: :replace, replace: "?"
    string.to_s
  end

  def self.forced_encoding
    Encoding.default_internal || Encoding::UTF_8
  end

end
