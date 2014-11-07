require 'iconv'
require 'charlock_holmes'

module GIGO
  module Transcoders
    module CharlockHolmes

      GIGO.transcoders << self

      def self.transcode(data)
        ::CharlockHolmes::Converter.convert data, detect_encoding(data), GIGO.encoding.name
      end

      private

      def self.detect_encoding(data)
        encoding = ::CharlockHolmes::EncodingDetector.detect(data)[:encoding]
        case encoding
        when 'UTF-16BE' then 'CP1252'
        else encoding
        end
      end

    end
  end
end
