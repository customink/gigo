module GIGO
  module Transcoders
    module Blind

      GIGO.transcoders << self

      def self.transcode(data)
        data.encode GIGO.encoding, :undef => :replace, :invalid => :replace
      end

    end
  end
end
