# -*- encoding: utf-8 -*-
require 'test_helper'

module GIGO
  class BaseTest < TestCase

    let(:data_utf8_emoji)   { "💖" }
    let(:data_utf8)         { "€20 – “Woohoo”" }
    let(:data_bad_readin)   { "�20 � �Woohoo�" }
    let(:data_cp1252)       { data_utf8.encode('CP1252') }
    let(:data_bin_apos)     { "won\x92t".force_encoding('binary') }
    let(:data_really_bad)   { "ed.Ã\u0083Ã\u0083\xC3" }

    let(:data_medico_utf8)     { "Med\u00EDco".force_encoding('UTF-8') }
    let(:data_medico_iso88591) { "Med\xEDco".force_encoding('iso8859-1') }
    let(:data_medico_unknown)  { "Med\uFFFDco".force_encoding('UTF-8') }


    describe '.encoding' do

      it 'defaults to UTF-8 encoding' do
        GIGO.encoding.must_equal Encoding::UTF_8
      end

      it 'can be set to any encoding' do
        GIGO.encoding = Encoding::CP1252
        GIGO.encoding.must_equal Encoding::CP1252
      end

    end

    describe '.load' do
      
      it 'ignores if string is not present' do
        GIGO.load('').must_equal ''
        GIGO.load(nil).must_be_nil
        o = Object.new
        GIGO.load(o).must_equal o
      end

      it 'always returns a String object' do
        GIGO.load(data_bin_apos).must_be_instance_of String
      end

      it 'fixes windows apostrophe' do
        GIGO.load(data_bin_apos).must_equal "won’t"
      end

      it 'should allow properly encoded and marked strings to be passed thru' do
        GIGO.load(data_utf8).must_equal data_utf8
        GIGO.load(data_utf8_emoji).must_equal data_utf8_emoji
      end

      it 'allows data already read in with question marks to pass thru' do
        GIGO.load(data_bad_readin).must_equal data_bad_readin
      end

      it 'allows really bad data to be encoded using default replace and question marks' do
        GIGO.load(data_medico_unknown).must_equal "Med�co"
      end

      it 'makes sure UTF-8 data read in as US-ASCII is fixed' do
        GIGO.load(data_medico_utf8.force_encoding('US-ASCII')).must_equal 'Medíco'
      end

      it 'converts windows codepages that are poorly marked as another encoding' do
        db_data1 = data_cp1252.dup.force_encoding('ASCII-8BIT')
        GIGO.load(db_data1).must_equal data_utf8
        db_data2 = data_cp1252.dup.force_encoding('US-ASCII')
        GIGO.load(db_data2).must_equal data_utf8
        db_data3 = data_cp1252.dup.force_encoding('UTF-8')
        GIGO.load(db_data3).must_equal data_utf8
        db_data4 = data_cp1252.dup
        GIGO.load(db_data4).must_equal data_utf8
      end

      it 'converts iso8859 when poorly marked as another encoding' do
        GIGO.load(data_medico_iso88591).must_equal 'Medíco'
        GIGO.load(data_medico_iso88591.force_encoding('US-ASCII')).must_equal 'Medíco'
      end

      it 'readly bad data can be html escaped afterward' do
        html_escape GIGO.load(data_really_bad)
      end

    end

    describe '.transcoders' do

      it 'is an array of default transcoders' do
        GIGO.transcoders.must_equal [
          GIGO::Transcoders::ActiveSupport,
          GIGO::Transcoders::Blind
        ]
      end

    end
    
  end
end
