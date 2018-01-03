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
  0x00A0,0x0104,0x0112,0x0122,0x012A,0x0128,0x0136,0x00A7,0x013B,0x0110,0x0160,0x0166,0x017D,0x00AD,0x016A,0x014A, # A_
  0x00B0,0x0105,0x0113,0x0123,0x012B,0x0129,0x0137,0x00B7,0x013C,0x0111,0x0161,0x0167,0x017E,0x2015,0x016B,0x014B, # B_
  0x0100,0x00C1,0x00C2,0x00C3,0x00C4,0x00C5,0x00C6,0x012E,0x010C,0x00C9,0x0118,0x00CB,0x0116,0x00CD,0x00CE,0x00CF, # C_
  0x00D0,0x0145,0x014C,0x00D3,0x00D4,0x00D5,0x00D6,0x0168,0x00D8,0x0172,0x00DA,0x00DB,0x00DC,0x00DD,0x00DE,0x00DF, # D_
  0x0101,0x00E1,0x00E2,0x00E3,0x00E4,0x00E5,0x00E6,0x012F,0x010D,0x00E9,0x0119,0x00EB,0x0117,0x00ED,0x00EE,0x00EF, # E_
  0x00F0,0x0146,0x014D,0x00F3,0x00F4,0x00F5,0x00F6,0x0169,0x00F8,0x0173,0x00FA,0x00FB,0x00FC,0x00FD,0x00FE,0x0138, # F_
  #   _0     _1     _2     _3     _4     _5     _6     _7     _8     _9     _A     _B     _C     _D     _E     _F
].freeze
# rubocop:enable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral

##
# ISO-8859-10 Latin alphabet No. 6
#
CCS::ISO_8859_10 = TableCCS.new('ISO-8859-10', 0, 255, table) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

CCS::LATIN_6       = CCS::ISO_8859_10
CCS::CP919         = CCS::ISO_8859_10
CCS::WINDOWS_28600 = CCS::ISO_8859_10

CCS::Nordic        = CCS::ISO_8859_10

##
# ISO-8859-10, strict mode (no control characters)
#
CCS::ISO_8859_10_Strict = TableCCS.new('ISO-8859-10 (strict)', 0x20, 0xFF, table) do
  def valid? cp
    (cp >= 0x20 && cp <= 0x7E) || (cp >= 0xA0 && cp <= 0xFF)
  end

  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
