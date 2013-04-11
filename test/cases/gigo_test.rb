# -*- encoding: utf-8 -*-
require 'test_helper'

module GIGO
  class BaseTest < TestCase

    include ERB::Util

    let(:data_utf8_emoji)   { "💖" }
    let(:data_utf8)         { "€20 – “Woohoo”" }
    let(:data_bad_readin)   { "�20 � �Woohoo�" }
    let(:data_cp1252)       { data_utf8.encode('CP1252') }
    let(:data_bin_apos)     { "won\x92t".force_encoding('binary') }
    let(:data_really_bad)   { "ed.Ã\u0083Ã\u0083\xC3" }


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

      it 'should allows properly encoded and marked strings to be passed thru' do
        GIGO.load(data_utf8).must_equal data_utf8
        GIGO.load(data_utf8_emoji).must_equal data_utf8_emoji
      end

      it 'allows data already read in with question marks to pass thru' do
        GIGO.load(data_bad_readin).must_equal data_bad_readin
      end

      it 'allows really bad data to be encoded using default replace and question marks' do
        GIGO.load(data_utf8_emoji.force_encoding('ASCII-8BIT')).must_equal data_utf8_emoji
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

      it 'can make sure to it is really a valid encoding afteward' do
        html_escape GIGO.load(data_really_bad)
      end

    end

    
    
  end
end
