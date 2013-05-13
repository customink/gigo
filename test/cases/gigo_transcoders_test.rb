#encoding: utf-8
require 'test_helper'

module GIGO
  class BaseTest < TestCase
    include GIGO::Transcoders

    def self.test_transcoder(transcoder, input, output, options = {})
      input = input.dup.force_encoding(input.encoding)
      errant_encoding = options[:errant_encoding]
      output_encoding = options[:output_encoding] || output.encoding

      describe "#{transcoder.name}" do
        it "detects #{input.encoding}#{errant_encoding && " mislabed as #{errant_encoding}"} and transcodes to #{output_encoding}" do
          input.force_encoding(errant_encoding) unless errant_encoding.nil?
          GIGO.load(input, [ transcoder ]).must_equal output
        end
      end
    end

    data_medico_utf8 =      "Med\u00EDco".force_encoding('UTF-8')
    data_medico_iso88591 =  "Med\xEDco".force_encoding('iso8859-1')
    data_medico_unknown =   "Med\uFFFDco".force_encoding('UTF-8')

    [ [ ActiveSupportMultibyteTranscoder, data_medico_iso88591,   data_medico_utf8 ],
      [ CharDetTranscoder,                data_medico_iso88591,   data_medico_utf8 ],
      [ BlindTranscoder,                  data_medico_iso88591,   data_medico_utf8 ],

      [ ActiveSupportMultibyteTranscoder, data_medico_iso88591,   data_medico_utf8,     :errant_encoding => 'US-ASCII' ],
      [ CharDetTranscoder,                data_medico_iso88591,   data_medico_utf8,     :errant_encoding => 'US-ASCII' ],
      [ BlindTranscoder,                  data_medico_iso88591,   data_medico_unknown,  :errant_encoding => 'US-ASCII' ],

      [ ActiveSupportMultibyteTranscoder, data_medico_utf8,       data_medico_utf8,     :errant_encoding => 'US-ASCII' ],

      # This will fail because CharDet misinterprets as ISO8859-2
      [ CharDetTranscoder,                data_medico_utf8,       data_medico_utf8,     :errant_encoding => 'US-ASCII' ],
      
      # This would never be expected to pass.  Included for the sake of completeness.
      # [ BlindTranscoder,                  data_medico_utf8,       data_medico_unknown,  :errant_encoding => 'US-ASCII' ],
    ].each do |test_config|
      test_transcoder(*test_config)
    end

  end
end