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
  0x00A0,0x0E01,0x0E02,0x0E03,0x0E04,0x0E05,0x0E06,0x0E07,0x0E08,0x0E09,0x0E0A,0x0E0B,0x0E0C,0x0E0D,0x0E0E,0x0E0F, # A_
  0x0E10,0x0E11,0x0E12,0x0E13,0x0E14,0x0E15,0x0E16,0x0E17,0x0E18,0x0E19,0x0E1A,0x0E1B,0x0E1C,0x0E1D,0x0E1E,0x0E1F, # B_
  0x0E20,0x0E21,0x0E22,0x0E23,0x0E24,0x0E25,0x0E26,0x0E27,0x0E28,0x0E29,0x0E2A,0x0E2B,0x0E2C,0x0E2D,0x0E2E,0x0E2F, # C_
  0x0E30,0x0E31,0x0E32,0x0E33,0x0E34,0x0E35,0x0E36,0x0E37,0x0E38,0x0E39,0x0E3A,0x00DB,0x00DC,0x00DD,0x00DE,0x0E3F, # D_
  0x0E40,0x0E41,0x0E42,0x0E43,0x0E44,0x0E45,0x0E46,0x0E47,0x0E48,0x0E49,0x0E4A,0x0E4B,0x0E4C,0x0E4D,0x0E4E,0x0E4F, # E_
  0x0E50,0x0E51,0x0E52,0x0E53,0x0E54,0x0E55,0x0E56,0x0E57,0x0E58,0x0E59,0x0E5A,0x0E5B,0x00FC,0x00FD,0x00FE,0x00FF, # F_
  #   _0     _1     _2     _3     _4     _5     _6     _7     _8     _9     _A     _B     _C     _D     _E     _F
].freeze
# rubocop:enable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral

##
# Thai Industrial Standard 620-2533
#
CCS::TIS_620 = TableCCS.new('TIS-620', 0, 255, table) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

##
# ISO-8859-11 Latin/Thai alphabet
#
CCS::ISO_8859_1    = CCS::TIS_620
CCS::LATIN_THAI    = CCS::TIS_620
CCS::CP914         = CCS::TIS_620
CCS::WINDOWS_28601 = CCS::TIS_620

##
# TIS-620, strict mode (no control characters)
#
CCS::TIS_620_Strict = TableCCS.new('TIS-620 (strict)', 0, 255, table) do
  def valid? cp
    (cp >= 0x20 && cp <= 0x7E) || (cp >= 0xA1 && cp <= 0xDA) || (cp >= 0xDF && cp <= 0xFB)
  end

  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

##
# ISO-8859-11, strict mode (no control characters)
#
CCS::ISO_8859_11_Strict = TableCCS.new('ISO-8859-11 (strict)', 0, 255, table) do
  def valid? cp
    (cp >= 0x20 && cp <= 0x7E) || (cp >= 0xA0 && cp <= 0xDA) || (cp >= 0xDF && cp <= 0xFB)
  end

  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
