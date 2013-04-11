require 'active_support/multibyte'
require 'active_support/core_ext/object/acts_like'
require 'active_support/core_ext/string/behavior'
require 'ensure_valid_encoding'
require 'gigo/rchardet'
require 'gigo/version'

module GIGO

  def self.load(data)
    return data if data.nil? || !data.acts_like?(:string)
    encoded_string = safe_detect_and_encoder(data)
    return data if data.encoding == forced_encoding && data == encoded_string
    encoded_string
  end


  protected

  def self.safe_detect_and_encoder(data)
    string = data
    begin
      string = ActiveSupport::Multibyte.proxy_class.new(string).tidy_bytes
    rescue Exception => e
      begin
        encoding = CharDet.detect(string.dup)['encoding'] || string.encoding || Encoding.default_internal || forced_encoding
        string = string.force_encoding(encoding).encode forced_encoding, :undef => :replace, :invalid => :replace
      rescue Exception => e
        string = string.encode forced_encoding, :undef => :replace, :invalid => :replace
      end
    end
    string = EnsureValidEncoding.ensure_valid_encoding string, invalid: :replace, replace: "?"
    string.to_s
  end

  def self.forced_encoding
    Encoding.default_internal || Encoding::UTF_8
  end
  
end
