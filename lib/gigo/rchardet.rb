######################## BEGIN LICENSE BLOCK ########################
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

require 'gigo/rchardet/charsetprober'
require 'gigo/rchardet/mbcharsetprober'

require 'gigo/rchardet/big5freq'
require 'gigo/rchardet/big5prober'
require 'gigo/rchardet/chardistribution'
require 'gigo/rchardet/charsetgroupprober'

require 'gigo/rchardet/codingstatemachine'
require 'gigo/rchardet/constants'
require 'gigo/rchardet/escprober'
require 'gigo/rchardet/escsm'
require 'gigo/rchardet/eucjpprober'
require 'gigo/rchardet/euckrfreq'
require 'gigo/rchardet/euckrprober'
require 'gigo/rchardet/euctwfreq'
require 'gigo/rchardet/euctwprober'
require 'gigo/rchardet/gb2312freq'
require 'gigo/rchardet/gb2312prober'
require 'gigo/rchardet/hebrewprober'
require 'gigo/rchardet/jisfreq'
require 'gigo/rchardet/jpcntx'
require 'gigo/rchardet/langbulgarianmodel'
require 'gigo/rchardet/langcyrillicmodel'
require 'gigo/rchardet/langgreekmodel'
require 'gigo/rchardet/langhebrewmodel'
require 'gigo/rchardet/langhungarianmodel'
require 'gigo/rchardet/langthaimodel'
require 'gigo/rchardet/latin1prober'

require 'gigo/rchardet/mbcsgroupprober'
require 'gigo/rchardet/mbcssm'
require 'gigo/rchardet/sbcharsetprober'
require 'gigo/rchardet/sbcsgroupprober'
require 'gigo/rchardet/sjisprober'
require 'gigo/rchardet/universaldetector'
require 'gigo/rchardet/utf8prober'

module GIGO
module CharDet
  VERSION = "1.3"
  def CharDet.detect(aBuf)
    u = UniversalDetector.new
    u.reset
    u.feed(aBuf)
    u.close
    u.result
  end
end
end