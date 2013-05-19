require 'active_support/all'
require 'ensure_valid_encoding'
require 'gigo/transcoders'
require 'gigo/transcoders/active_support'
require 'gigo/transcoders/rchardet'
require 'gigo/transcoders/blind'
require 'gigo/version'

module GIGO

  mattr_accessor :encoding
  self.encoding = Encoding.default_internal || Encoding::UTF_8

  def self.load(data, options = {})
    return data if data.nil? || !data.acts_like?(:string)
    tcoders = options[:transcoders] || transcoders
    encoded_string = transcode(data, tcoders)
    return data if data.encoding == GIGO.encoding && data == encoded_string
    encoded_string
  end


  protected

  def self.transcode(data, tcoders)
    string = data
    tcoders.detect do |t|
      begin
        string = t.transcode(string)
      rescue Exception => e
        false
      end
    end
    string = EnsureValidEncoding.ensure_valid_encoding string, invalid: :replace, replace: "?"
    string
  end

end
