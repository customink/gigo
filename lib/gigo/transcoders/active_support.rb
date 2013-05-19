module GIGO
  module Transcoders
    module ActiveSupport

      GIGO.transcoders << self

      def self.transcode(data)
        ::ActiveSupport::Multibyte.proxy_class.new(data).tidy_bytes.to_s
      end
      
    end
  end
end
