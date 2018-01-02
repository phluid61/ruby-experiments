# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

# rubocop:disable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral
table = [
  #   _0     _1     _2     _3     _4     _5     _6     _7     _8     _9     _A     _B     _C     _D     _E     _F
  0x0000,0x0001,0x0002,0x0003,0x0004,0x0005,0x0006,0x0007,0x0008,0x0009,0x000A,0x000B,0x000C,0x000D,0x000E,0x000F, # 0_
  0x0010,0x0011,0x0012,0x0013,0x0014,0x0015,0x0016,0x0017,0x0018,0x0019,0x001A,0x001B,0x001C,0x001D,0x001E,0x001F, # 1_
  0x0020,0x0021,0x0022,0x0023,0x0024,0x0025,0x0026,0x0027,0x0028,0x0029,0x002A,0x002B,0x002C,0x002D,0x002E,0x002F, # 2_
  0x0030,0x0031,0x0032,0x0033,0x0034,0x0035,0x0036,0x0037,0x0038,0x0039,0x003A,0x003B,0x003C,0x003D,0x003E,0x003F, # 3_
  0x0040,0x0041,0x0042,0x0043,0x0044,0x0045,0x0046,0x0047,0x0048,0x0049,0x004A,0x004B,0x004C,0x004D,0x004E,0x004F, # 4_
  0x0050,0x0051,0x0052,0x0053,0x0054,0x0055,0x0056,0x0057,0x0058,0x0059,0x005A,0x005B,0x005C,0x005D,0x005E,0x005F, # 5_
  0x0060,0x0061,0x0062,0x0063,0x0064,0x0065,0x0066,0x0067,0x0068,0x0069,0x006A,0x006B,0x006C,0x006D,0x006E,0x006F, # 6_
  0x0070,0x0071,0x0072,0x0073,0x0074,0x0075,0x0076,0x0077,0x0078,0x0079,0x007A,0x007B,0x007C,0x007D,0x007E,0x007F, # 7_
  0x0080,0x0081,0x0082,0x0083,0x0084,0x0085,0x0086,0x0087,0x0088,0x0089,0x008A,0x008B,0x008C,0x008D,0x008E,0x008F, # 8_
  0x0090,0x0091,0x0092,0x0093,0x0094,0x0095,0x0096,0x0097,0x0098,0x0099,0x009A,0x009B,0x009C,0x009D,0x009E,0x009F, # 9_
  0x00A0,0x201D,0x00A2,0x00A3,0x00A4,0x201E,0x00A6,0x00A7,0x00D8,0x00A9,0x0156,0x00AB,0x00AC,0x00AD,0x00AE,0x00C6, # A_
  0x00B0,0x00B1,0x00B2,0x00B3,0x201C,0x00B5,0x00B6,0x00B7,0x00F8,0x00B9,0x0157,0x00BB,0x00BC,0x00BD,0x00BE,0x00E6, # B_
  0x0104,0x012E,0x0100,0x0106,0x00C4,0x00C5,0x0118,0x0112,0x010C,0x00C9,0x0179,0x0116,0x0122,0x0136,0x012A,0x013B, # C_
  0x0160,0x0143,0x0145,0x00D3,0x014C,0x00D5,0x00D6,0x00D7,0x0172,0x0141,0x015A,0x016A,0x00DC,0x017B,0x017D,0x00DF, # D_
  0x0105,0x012F,0x0101,0x0107,0x00E4,0x00E5,0x0119,0x0113,0x010D,0x00E9,0x017A,0x0117,0x0123,0x0137,0x012B,0x013C, # E_
  0x0161,0x0144,0x0146,0x00F3,0x014D,0x00F5,0x00F6,0x00F7,0x0173,0x0142,0x015B,0x016B,0x00FC,0x017C,0x017E,0x2019, # F_
  #   _0     _1     _2     _3     _4     _5     _6     _7     _8     _9     _A     _B     _C     _D     _E     _F
].freeze
# rubocop:enable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral

##
# ISO-8859-13 Latin alphabet No. 7
#
CCS::ISO_8859_13 = TableCCS.new('ISO-8859-13', 0, 255, table) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

CCS::LATIN_7       = CCS::ISO_8859_13
CCS::CP921         = CCS::ISO_8859_13
CCS::WINDOWS_28603 = CCS::ISO_8859_13

CCS::BalticRim     = CCS::ISO_8859_13

##
# ISO-8859-13, strict mode (no control characters)
#
CCS::ISO_8859_13_Strict = TableCCS.new('ISO-8859-13 (strict)', 0, 255, table) do
  def valid? cp
    # jinkies...
    (cp >= 0x20 && cp <= 0x7E) || (cp >= 0xA0 && cp <= 0xFF)
  end

  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
