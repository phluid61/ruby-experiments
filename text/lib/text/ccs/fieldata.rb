# encoding: UTF-8
# frozen_string_literal: true

require_relative '../ccs'

# rubocop:disable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral
table = [
  0x0000,nil,   nil,   0x0009,0x000D,0x0020,0x0061,0x0062,0x0063,0x0064,0x0065,0x0066,0x0067,0x0068,0x0069,0x006A,
  0x006B,0x006C,0x006D,0x006E,0x006F,0x0070,0x0071,0x0072,0x0073,0x0074,0x0075,0x0076,0x0077,0x0078,0x0079,0x007A,
  nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   0x0001,nil,   nil,   nil,   nil,
  nil,   nil,   nil,   nil,   0x0017,nil,   nil,   0x0006,0x0015,nil,   nil,   nil,   nil,   nil,   0x001B,0x007F,
  0x0040,0x005B,0x005D,0x0023,0x0394,0x00A0,0x0041,0x0042,0x0043,0x0044,0x0045,0x0046,0x0047,0x0048,0x0049,0x004A,
  0x004B,0x004C,0x004D,0x004E,0x004F,0x0050,0x0051,0x0052,0x0053,0x0054,0x0055,0x0056,0x0057,0x0058,0x0059,0x005A,
  0x0029,0x002D,0x002B,0x003C,0x003D,0x003E,0x0026,0x0024,0x002A,0x0028,0x0025,0x003A,0x003F,0x0021,0x002C,0x005C,
  0x0030,0x0031,0x0032,0x0033,0x0034,0x0035,0x0036,0x0037,0x0038,0x0039,0x0027,0x003B,0x002F,0x002E,0x2311,0x2260,
]

CCS::FIELDATA = TableCCS.new('FIELDATA', 0, 127, table) do
  @names = %w[
    IDL CUC CLC CHT CCR CSP a   b   c   d   e   f   g   h   i   j
    k   l   m   n   o   p   q   r   s   t   u   v   w   x   y   z
    D0  D1  D2  D3  D4  D5  D6  D7  D8  D9  SCB SBK _   _   _   _
    RTT RTR NRR EBE EBK EOF ECB ACK RPT _   INS NIS CWF SAC SPC DEL
    @   [   ]   #   Δ   SP A   B   C   D   E   F   G   H   I   J
    K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z
    )   -   +   <   =   >   &   $   *   (   %   :   ?   !   ,   \\
    0   1   2   3   4   5   6   7   8   9   '   ;   /   .   ⌑   ≠
  ].map{|n| n == '_' ? nil : n }.freeze

  def valid? cp
    !(@names[cp].nil?)
  end

  def render_codepoint cp
    return sprintf('0x%02X [%s]', cp, @names[cp]) if valid? cp
    super(cp)
  end

  # Maps a codepoint to its UCS value.
  def to_ucs cp
    raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}" unless valid? cp
    @forward[cp] or raise CES::EncodingError, "codepoint '#{render_codepoint cp}' does not have a UCS equivalent"
  end
end
# rubocop:enable Metrics/LineLength, Layout/SpaceAfterComma, Style/TrailingCommaInLiteral

# vim: ts=2:sts=2:sw=2:expandtab
