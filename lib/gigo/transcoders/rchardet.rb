require 'gigo/rchardet'

module GIGO
  module Transcoders
    module CharDet

      GIGO.transcoders << self
    
      def self.transcode(data)
        source_encoding = detect_encoding(data) || data.encoding || Encoding.default_internal || Encoding::UTF_8
        data.force_encoding(source_encoding).encode GIGO.encoding, :undef => :replace, :invalid => :replace
      end

      private

      def self.detect_encoding(data)
        GIGO::CharDet.detect(data.dup)['encoding']
      end
      
    end
  end
end
