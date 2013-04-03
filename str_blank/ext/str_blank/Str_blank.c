#include "ruby.h"
#include "ruby/encoding.h"

static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = rb_enc_from_index(ENCODING_GET(str));
  s = RSTRING_PTR(str);
  if (!s || RSTRING_LEN(str) == 0) return Qtrue;

  e = RSTRING_END(str);
  while (s < e) {
    int n;
    unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

    if (!rb_isspace(cc) && cc != 0) return Qfalse;
    s += n;
  }
  return Qtrue;
}

void Init_str_blank() {
  rb_define_method(rb_cString, "blank?", rb_str_blank, 0);
}

