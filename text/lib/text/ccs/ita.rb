# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

ita1_letters = [
  0x00,   # -----
  ?A,     # +----
  ?E,     # -+---
  0xC9,   # ++---
  ?Y,     # --+--
  ?U,     # +-+--
  ?I,     # -++--
  ?O,     # +++--
  0x1B,   # ---+-
  ?J,     # +--+-
  ?G,     # -+-+-
  ?H,     # ++-+-
  ?B,     # --++-
  ?C,     # +-++-
  ?F,     # -+++-
  ?D,     # ++++-
  0x20,   # ----+
  ?t,     # +---+
  ?X,     # -+--+
  ?Z,     # ++--+
  ?S,     # --+-+
  ?T,     # +-+-+
  ?W,     # -++-+
  ?V,     # +++-+
  0x7F,   # ---++
  ?K,     # +--++
  ?M,     # -+-++
  ?L,     # ++-++
  ?R,     # --+++
  ?Q,     # +-+++
  ?N,     # -++++
  ?P,     # +++++
]
ita1_figures = [
  0x00, ?1, ?2, ?&, ?3, ?4, ?o, ?5,
  0x20, ?6, ?7, ?h, ?8, ?9, ?f, ?0,
  0x1B, ?., ?,, ?:, ?;, ?!, ??, ?',
  0x7F, ?(, ?), ?=, ?-, ?/, 0x2116, ?%,  # could also be ?#
]

ita2_letters = [
  0x00, ?E,   0x0D, ?A,   0x20, ?S,   ?I,   ?U,
  0x0A, ?D,   ?R,   ?J,   ?N,   ?F,   ?C,   ?K,
  ?T,   ?Z,   ?L,   ?W,   ?H,   ?Y,   ?P,   ?Q,
  ?O,   ?B,   ?G,   0x1B, ?M,   ?X,   ?V,   ?V,
]
ita2_figures = [
  0x00, ?3,   0x0D, ?-,   0x20, ?',   ?8,   ?7,
  0x0A, 0x05, ?4,   0x07, ?,,   ?!,   ?:,   ?(,
  ?5,   ?+,   ?),   ?2,   0xA3, ?6,   ?0,   ?1,
  ?9,   ??,   ?&,   0x1B, ?.,   ?/,   ?;,   0x7F,
]

CCS::ITA1_Letters = TableCCS.new('ITA1 (Letters)', 0, 31, ita1_letters.map {|x| x.is_a?(String) ? x.ord : x })
CCS::ITA1_Figures = TableCCS.new('ITA1 (Figures)', 0, 31, ita1_figures.map {|x| x.is_a?(String) ? x.ord : x })
CCS::ITA2_Letters = TableCCS.new('ITA2 (Letters)', 0, 31, ita2_letters.map {|x| x.is_a?(String) ? x.ord : x })
CCS::ITA2_Figures = TableCCS.new('ITA2 (Figures)', 0, 31, ita2_figures.map {|x| x.is_a?(String) ? x.ord : x })

CCS::Baudot_Letters = CCS::ITA1_Letters
CCS::Baudot_Fitures = CCS::ITA1_Figures

# vim: ts=2:sts=2:sw=2:expandtab
