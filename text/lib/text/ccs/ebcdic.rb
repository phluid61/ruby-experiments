# encoding: UTF-8
# frozen_string_literal: true

require_relative '../ccs'

# rubocop:disable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral
CCS::EBCDIC_037 = TableCCS.new('EBCDIC 037', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, 0x009C, 0x0009, 0x0086, 0x007F, 0x0097, 0x008D, 0x008E, 0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, 0x009D, 0x0085, 0x0008, 0x0087, 0x0018, 0x0019, 0x0092, 0x008F, 0x001C, 0x001D, 0x001E, 0x001F,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x000A, 0x0017, 0x001B, 0x0088, 0x0089, 0x008A, 0x008B, 0x008C, 0x0005, 0x0006, 0x0007,
  0x0090, 0x0091, 0x0016, 0x0093, 0x0094, 0x0095, 0x0096, 0x0004, 0x0098, 0x0099, 0x009A, 0x009B, 0x0014, 0x0015, 0x009E, 0x001A,
  0x0020, 0x00A0, 0x00E2, 0x00E4, 0x00E0, 0x00E1, 0x00E3, 0x00E5, 0x00E7, 0x00F1, 0x00A2, 0x002E, 0x003C, 0x0028, 0x002B, 0x007C,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x00DF, 0x0021, 0x0024, 0x002A, 0x0029, 0x003B, 0x00AC,
  0x002D, 0x002F, 0x00C2, 0x00C4, 0x00C0, 0x00C1, 0x00C3, 0x00C5, 0x00C7, 0x00D1, 0x00A6, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00F8, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x0023, 0x0040, 0x0027, 0x003D, 0x0022,
  0x00D8, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x00E6, 0x00B8, 0x00C6, 0x00A4,
  0x00B5, 0x007E, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x005E, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x00A7, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x005B, 0x005D, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x007B, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5,
  0x007D, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x00FC, 0x00F9, 0x00FA, 0x00FF,
  0x005C, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x00D6, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x00DC, 0x00D9, 0x00DA, 0x009F,
].freeze)
CCS::CP37 = CCS::EBCDIC_037
CCS::CCSID_1140 = TableCCS.new('CCSID 1140', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, 0x009C, 0x0009, 0x0086, 0x007F, 0x0097, 0x008D, 0x008E, 0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, 0x009D, 0x0085, 0x0008, 0x0087, 0x0018, 0x0019, 0x0092, 0x008F, 0x001C, 0x001D, 0x001E, 0x001F,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x000A, 0x0017, 0x001B, 0x0088, 0x0089, 0x008A, 0x008B, 0x008C, 0x0005, 0x0006, 0x0007,
  0x0090, 0x0091, 0x0016, 0x0093, 0x0094, 0x0095, 0x0096, 0x0004, 0x0098, 0x0099, 0x009A, 0x009B, 0x0014, 0x0015, 0x009E, 0x001A,
  0x0020, 0x00A0, 0x00E2, 0x00E4, 0x00E0, 0x00E1, 0x00E3, 0x00E5, 0x00E7, 0x00F1, 0x00A2, 0x002E, 0x003C, 0x0028, 0x002B, 0x007C,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x00DF, 0x0021, 0x0024, 0x002A, 0x0029, 0x003B, 0x00AC,
  0x002D, 0x002F, 0x00C2, 0x00C4, 0x00C0, 0x00C1, 0x00C3, 0x00C5, 0x00C7, 0x00D1, 0x00A6, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00F8, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x0023, 0x0040, 0x0027, 0x003D, 0x0022,
  0x00D8, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x00E6, 0x00B8, 0x00C6, 0x20AC,
  0x00B5, 0x007E, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x005E, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x00A7, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x005B, 0x005D, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x007B, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5,
  0x007D, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x00FC, 0x00F9, 0x00FA, 0x00FF,
  0x005C, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x00D6, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x00DC, 0x00D9, 0x00DA, 0x009F,
].freeze)
CCS::EBCDIC_273 = TableCCS.new('EBCDIC 273', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, 0x009C, 0x0009, 0x0086, 0x007F, 0x0097, 0x008D, 0x008E, 0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, 0x009D, 0x0085, 0x0008, 0x0087, 0x0018, 0x0019, 0x0092, 0x008F, 0x001C, 0x001D, 0x001E, 0x001F,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x000A, 0x0017, 0x001B, 0x0088, 0x0089, 0x008A, 0x008B, 0x008C, 0x0005, 0x0006, 0x0007,
  0x0090, 0x0091, 0x0016, 0x0093, 0x0094, 0x0095, 0x0096, 0x0004, 0x0098, 0x0099, 0x009A, 0x009B, 0x0014, 0x0015, 0x009E, 0x001A,
  0x0020, 0x00A0, 0x00E2, 0x007B, 0x00E0, 0x00E1, 0x00E3, 0x00E5, 0x00E7, 0x00F1, 0x00C4, 0x002E, 0x003C, 0x0028, 0x002B, 0x0021,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x007E, 0x00DC, 0x0024, 0x002A, 0x0029, 0x003B, 0x005E,
  0x002D, 0x002F, 0x00C2, 0x005B, 0x00C0, 0x00C1, 0x00C3, 0x00C5, 0x00C7, 0x00D1, 0x00F6, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00F8, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x0023, 0x00A7, 0x0027, 0x003D, 0x0022,
  0x00D8, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x00E6, 0x00B8, 0x00C6, 0x00A4,
  0x00B5, 0x00DF, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x00A2, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x0040, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x00AC, 0x007C, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x00E4, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00A6, 0x00F2, 0x00F3, 0x00F5,
  0x00FC, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x007D, 0x00F9, 0x00FA, 0x00FF,
  0x00D6, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x005C, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x005D, 0x00D9, 0x00DA, 0x009F,
].freeze)
CCS::CCSID_1141 = TableCCS.new('CCSID 1141', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, 0x009C, 0x0009, 0x0086, 0x007F, 0x0097, 0x008D, 0x008E, 0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, 0x009D, 0x0085, 0x0008, 0x0087, 0x0018, 0x0019, 0x0092, 0x008F, 0x001C, 0x001D, 0x001E, 0x001F,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x000A, 0x0017, 0x001B, 0x0088, 0x0089, 0x008A, 0x008B, 0x008C, 0x0005, 0x0006, 0x0007,
  0x0090, 0x0091, 0x0016, 0x0093, 0x0094, 0x0095, 0x0096, 0x0004, 0x0098, 0x0099, 0x009A, 0x009B, 0x0014, 0x0015, 0x009E, 0x001A,
  0x0020, 0x00A0, 0x00E2, 0x007B, 0x00E0, 0x00E1, 0x00E3, 0x00E5, 0x00E7, 0x00F1, 0x00C4, 0x002E, 0x003C, 0x0028, 0x002B, 0x0021,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x007E, 0x00DC, 0x0024, 0x002A, 0x0029, 0x003B, 0x005E,
  0x002D, 0x002F, 0x00C2, 0x005B, 0x00C0, 0x00C1, 0x00C3, 0x00C5, 0x00C7, 0x00D1, 0x00F6, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00F8, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x0023, 0x00A7, 0x0027, 0x003D, 0x0022,
  0x00D8, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x00E6, 0x00B8, 0x00C6, 0x20AC,
  0x00B5, 0x00DF, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x00A2, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x0040, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x00AC, 0x007C, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x00E4, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00A6, 0x00F2, 0x00F3, 0x00F5,
  0x00FC, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x007D, 0x00F9, 0x00FA, 0x00FF,
  0x00D6, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x005C, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x005D, 0x00D9, 0x00DA, 0x009F,
].freeze)
CCS::EBCDIC_277 = TableCCS.new('EBCDIC 277', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, nil,    0x0009, nil,    0x007F, nil,    nil,    nil,    0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, nil,    0x0085, 0x0008, nil,    0x0018, 0x0019, nil,    nil,    0x001C, 0x001D, 0x001E, 0x001F,
  nil,    nil,    nil,    nil,    nil,    0x000A, 0x0017, 0x001B, nil,    nil,    nil,    nil,    nil,    0x0005, 0x0006, 0x0007,
  nil,    nil,    0x0016, nil,    nil,    nil,    nil,    0x0004, nil,    nil,    nil,    nil,    0x0014, 0x0015, nil,    0x001A,
  0x0020, 0x00A0, 0x00E2, 0x00E4, 0x00E0, 0x00E1, 0x00E3, 0x007D, 0x00E7, 0x00F1, 0x0023, 0x002E, 0x003C, 0x0028, 0x002B, 0x0021,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x00DF, 0x00A4, 0x00C5, 0x002A, 0x0029, 0x003B, 0x005E,
  0x002D, 0x002F, 0x00C2, 0x00C4, 0x00C0, 0x00C1, 0x00C3, 0x0024, 0x00C7, 0x00D1, 0x00F8, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00A6, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x00C6, 0x00D8, 0x0027, 0x003D, 0x0022,
  0x0040, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x007B, 0x00B8, 0x005B, 0x005D,
  0x00B5, 0x00FC, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x00A2, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x00A7, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x00AC, 0x007C, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x00E6, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5,
  0x00E5, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x007E, 0x00F9, 0x00FA, 0x00FF,
  0x005C, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x00D6, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x00DC, 0x00D9, 0x00DA, nil,
].freeze)
CCS::CCSID_1142 = TableCCS.new('CCSID 1142', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, nil,    0x0009, nil,    0x007F, nil,    nil,    nil,    0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, nil,    0x0085, 0x0008, nil,    0x0018, 0x0019, nil,    nil,    0x001C, 0x001D, 0x001E, 0x001F,
  nil,    nil,    nil,    nil,    nil,    0x000A, 0x0017, 0x001B, nil,    nil,    nil,    nil,    nil,    0x0005, 0x0006, 0x0007,
  nil,    nil,    0x0016, nil,    nil,    nil,    nil,    0x0004, nil,    nil,    nil,    nil,    0x0014, 0x0015, nil,    0x001A,
  0x0020, 0x00A0, 0x00E2, 0x00E4, 0x00E0, 0x00E1, 0x00E3, 0x007D, 0x00E7, 0x00F1, 0x0023, 0x002E, 0x003C, 0x0028, 0x002B, 0x0021,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x00DF, 0x00A4, 0x00C5, 0x002A, 0x0029, 0x003B, 0x005E,
  0x002D, 0x002F, 0x00C2, 0x00C4, 0x00C0, 0x00C1, 0x00C3, 0x0024, 0x00C7, 0x00D1, 0x00F8, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00A6, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x00C6, 0x00D8, 0x0027, 0x003D, 0x0022,
  0x0040, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x007B, 0x00B8, 0x005B, 0x20AC,
  0x00B5, 0x00FC, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x00DD, 0x00DE, 0x00AE,
  0x00A2, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x00A7, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x00AC, 0x007C, 0x00AF, 0x00A8, 0x00B4, 0x00D7,
  0x00E6, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5,
  0x00E5, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x007E, 0x00F9, 0x00FA, 0x00FF,
  0x005C, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x00D6, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x00DC, 0x00D9, 0x00DA, nil,
].freeze)
# TODO: take some other tables from https://en.wikipedia.org/wiki/EBCDIC_code_pages
CCS::EBCDIC_1047 = TableCCS.new('EBCDIC 1047', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, nil,    0x0009, nil,    0x007F, nil,    nil,    nil,    0x000B, 0x000C, 0x000D, 0x000E, 0x000F,
  0x0010, 0x0011, 0x0012, 0x0013, nil,    0x0085, 0x0008, nil,    0x0018, 0x0019, nil,    nil,    0x001C, 0x001D, 0x001E, 0x001F,
  nil,    nil,    nil,    nil,    nil,    0x000A, 0x0017, 0x001B, nil,    nil,    nil,    nil,    nil,    0x0005, 0x0006, 0x0007,
  nil,    nil,    0x0016, nil,    nil,    nil,    nil,    0x0004, nil,    nil,    nil,    nil,    0x0014, 0x0015, nil,    0x001A,
  0x0020, 0x00A0, 0x00E2, 0x00E4, 0x00E0, 0x00E1, 0x00E3, 0x00E5, 0x00E7, 0x00F1, 0x00A2, 0x002E, 0x003C, 0x0028, 0x002B, 0x007C,
  0x0026, 0x00E9, 0x00EA, 0x00EB, 0x00E8, 0x00ED, 0x00EE, 0x00EF, 0x00EC, 0x00DF, 0x0021, 0x0024, 0x002A, 0x0029, 0x003B, 0x005E,
  0x002D, 0x002F, 0x00C2, 0x00C4, 0x00C0, 0x00C1, 0x00C3, 0x00C5, 0x00C7, 0x00D1, 0x00A6, 0x002C, 0x0025, 0x005F, 0x003E, 0x003F,
  0x00F8, 0x00C9, 0x00CA, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF, 0x00CC, 0x0060, 0x003A, 0x0023, 0x0040, 0x0027, 0x003D, 0x0022,
  0x00D8, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067, 0x0068, 0x0069, 0x00AB, 0x00BB, 0x00F0, 0x00FD, 0x00FE, 0x00B1,
  0x00B0, 0x006A, 0x006B, 0x006C, 0x006D, 0x006E, 0x006F, 0x0070, 0x0071, 0x0072, 0x00AA, 0x00BA, 0x00E6, 0x00B8, 0x00C6, 0x00A4,
  0x00B5, 0x007E, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077, 0x0078, 0x0079, 0x007A, 0x00A1, 0x00BF, 0x00D0, 0x005B, 0x00DE, 0x00AE,
  0x00AC, 0x00A3, 0x00A5, 0x00B7, 0x00A9, 0x00A7, 0x00B6, 0x00BC, 0x00BD, 0x00BE, 0x00DD, 0x00A8, 0x00AF, 0x005D, 0x00B4, 0x00D7,
  0x007B, 0x0041, 0x0042, 0x0043, 0x0044, 0x0045, 0x0046, 0x0047, 0x0048, 0x0049, 0x00AD, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5,
  0x007D, 0x004A, 0x004B, 0x004C, 0x004D, 0x004E, 0x004F, 0x0050, 0x0051, 0x0052, 0x00B9, 0x00FB, 0x00FC, 0x00F9, 0x00FA, 0x00FF,
  0x005C, 0x00F7, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057, 0x0058, 0x0059, 0x005A, 0x00B2, 0x00D4, 0x00D6, 0x00D2, 0x00D3, 0x00D5,
  0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x00B3, 0x00DB, 0x00DC, 0x00D9, 0x00DA, nil,
].freeze)
CCS::CP1047 = CCS::EBCDIC_1047

CCS::CCSID_290 = TableCCS.new('CCSID 290', 0, 0xFF, [
  #   _0      _1      _2      _3      _4      _5      _6      _7      _8      _9      _A      _B      _C      _D      _E      _F
  0x0000, 0x0001, 0x0002, 0x0003, 0x009C, 0x0009, 0x0086, 0x007F, 0x0097, 0x008D, 0x008E, 0x000B, 0x000C, 0x000D, false,  nil,    # 0E is Shift-In
  0x0010, 0x0011, 0x0012, 0x0013, 0x009D, 0x0085, 0x0008, 0x0087, 0x0018, 0x0019, 0x0092, 0x008F, 0x001C, 0x001D, 0x001E, 0x001F,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x000A, 0x0017, 0x001B, 0x0088, 0x0089, 0x008A, 0x008B, 0x008C, 0x0005, 0x0006, 0x0007,
  0x0090, 0x0091, 0x0016, 0x0093, 0x0094, 0x0095, 0x0096, 0x0004, 0x0098, 0x0099, 0x009A, 0x009B, 0x0014, 0x0015, 0x009E, 0x001A,
  0x0020, 0xFF61, 0xFF62, 0xFF63, 0xFF64, 0xFF65, 0xFF66, 0xFF67, 0xFF68, 0xFF69, 0x00A3, ?.,     ?<,     ?(,     ?+,     ?|,
  ?&,     0xFF6A, 0xFF6B, 0xFF6C, 0xFF6D, 0xFF6E, 0xFF6F, nil,    0xFF70, nil,    ?!,     0x00A5, ?*,     ?),     ?;,     0x00AC,
  ?-,     ?/,     ?a,     ?b,     ?c,     ?d,     ?e,     ?f,     ?g,     ?h,     nil,    ?,,     ?%,     ?_,     ?>,     ??,
  ?[,     ?i,     ?j,     ?k,     ?l,     ?m,     ?n,     ?o,     ?p,     ?`,     ?:,     ?#,     ?@,     ?',     ?=,     ?",
  ?],     0xFF71, 0xFF72, 0xFF73, 0xFF74, 0xFF75, 0xFF76, 0xFF77, 0xFF78, 0xFF79, 0xFF7A, ?q,     0xFF7B, 0xFF7C, 0xFF7D, 0xFF7E,
  0xFF7F, 0xFF80, 0xFF81, 0xFF82, 0xFF83, 0xFF84, 0xFF85, 0xFF86, 0xFF87, 0xFF88, 0xFF89, ?r,     nil,    0xFF8A, 0xFF8B, 0xFF8C,
  ?~,     0x203E, 0xFF8D, 0xFF8E, 0xFF8F, 0xFF90, 0xFF91, 0xFF92, 0xFF93, 0xFF94, 0xFF95, ?s,     0xFF96, 0xFF97, 0xFF98, 0xFF99,
  ?^,     0x00AC, ?\\,    ?t,     ?u,     ?v,     ?w,     ?x,     ?y,     ?z,     0xFF9A, 0xFF9B, 0xFF9C, 0xFF9D, 0xFF9E, 0xFF9F,
  ?{,     ?A,     ?B,     ?C,     ?D,     ?E,     ?F,     ?D,     ?H,     ?I,     nil,    nil,    nil,    nil,    nil,    nil,
  ?|,     ?J,     ?K,     ?L,     ?M,     ?N,     ?O,     ?P,     ?Q,     ?R,     nil,    nil,    nil,    nil,    nil,    nil,
  ?$,     nil,    ?S,     ?T,     ?U,     ?V,     ?W,     ?X,     ?Y,     ?Z,     nil,    nil,    nil,    nil,    nil,    nil,
  ?0,     ?1,     ?2,     ?3,     ?4,     ?5,     ?6,     ?7,     ?8,     ?9,     nil,    nil,    nil,    nil,    nil,    0x009F,
].map {|x| x.is_a?(String) ? x.ord : x }.freeze)
CCS::CCSID_930 = CCS::CCSID_290 # Not entirely true without CCSID 300 as well
CCS::EBCDIK = CCS::CCSID_290
# rubocop:enable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral

# vim: ts=2:sts=2:sw=2:expandtab