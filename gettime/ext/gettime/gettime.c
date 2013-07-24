/*
 * Copyright (c) 2013, Matthew Kerwin <matthew@kerwin.net.au>
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "ruby.h"
#include <time.h>

#if defined(HAVE_SYS_TIME_H)
#include <sys/time.h>
#endif

static ID id_CLOCK_REALTIME, id_CLOCK_MONOTONIC,
	  id_CLOCK_PROCESS_CPUTIME_ID, id_CLOCK_THREAD_CPUTIME_ID;

#ifdef HAVE_CLOCK_GETTIME

static clockid_t
__clk_id(VALUE sym)
{
    VALUE str;
    ID id;

    if (!(id = rb_check_id(&sym))) {
	str = rb_inspect(sym);
	rb_raise(rb_eTypeError, "%s is not a symbol", RSTRING_PTR(str));
    }

    if (id == id_CLOCK_REALTIME) {
	return CLOCK_REALTIME;
    } else if (id == id_CLOCK_MONOTONIC) {
#ifdef _POSIX_MONOTONIC_CLOCK
	return CLOCK_MONOTONIC;
#else
	rb_raise(rb_eArgError, "CLOCK_MONOTONIC is not supported on your system");
#endif
    } else if (id == id_CLOCK_PROCESS_CPUTIME_ID) {
#ifdef _POSIX_CPUTIME
	return CLOCK_PROCESS_CPUTIME_ID;
#else
	rb_raise(rb_eArgError, "CLOCK_PROCESS_CPUTIME_ID is not supported on your system");
#endif
    } else if (id == id_CLOCK_THREAD_CPUTIME_ID) {
#ifdef _POSIX_THREAD_CPUTIME
	return CLOCK_THREAD_CPUTIME_ID;
#else
	rb_raise(rb_eArgError, "CLOCK_THREAD_CPUTIME_ID is not supported on your system");
#endif
    } else {
	str = rb_inspect(sym);
        rb_raise(rb_eArgError, "%s is not a valid clock_id", RSTRING_PTR(str));
    }

    return (clockid_t)0;
}

static VALUE
proc_clock_gettime(VALUE klass, VALUE clock_id)
{
    clockid_t clk_id;
    struct    timespec tp;
    VALUE     t;

    clk_id = __clk_id(clock_id);

    if (clock_gettime(clk_id, &tp) == -1) {
	rb_sys_fail("clock_gettime");
    }
    t = rb_uint2big(tp.tv_sec*1000000000 + tp.tv_nsec);

    return t;
}

static VALUE
proc_clock_getres(VALUE klass, VALUE clock_id)
{
    clockid_t clk_id;
    struct    timespec res;
    VALUE     t;

    clk_id = __clk_id(clock_id);

    if (clock_getres(clk_id, &res) == -1) {
	rb_sys_fail("clock_getres");
    }
    t = rb_uint2big(res.tv_sec*1000000000 + res.tv_nsec);

    return t;
}

static VALUE
proc_clocks(VALUE klass)
{
    VALUE a = rb_ary_new();
    rb_ary_push(a, ID2SYM(id_CLOCK_REALTIME));
#ifdef _POSIX_MONOTONIC_CLOCK
    rb_ary_push(a, ID2SYM(id_CLOCK_MONOTONIC));
#endif
#ifdef _POSIX_CPUTIME
    rb_ary_push(a, ID2SYM(id_CLOCK_PROCESS_CPUTIME_ID));
#endif
#ifdef _POSIX_THREAD_CPUTIME
    rb_ary_push(a, ID2SYM(id_CLOCK_THREAD_CPUTIME_ID));
#endif
    return a;
}

#else
#  define proc_clock_gettime rb_f_notimplement
#  define proc_clock_getres  rb_f_notimplement
#endif

void Init_gettime() {
    id_CLOCK_REALTIME  = rb_intern("CLOCK_REALTIME");
    id_CLOCK_MONOTONIC = rb_intern("CLOCK_MONOTONIC");
    id_CLOCK_PROCESS_CPUTIME_ID = rb_intern("CLOCK_PROCESS_CPUTIME_ID");
    id_CLOCK_THREAD_CPUTIME_ID  = rb_intern("CLOCK_THREAD_CPUTIME_ID");

    rb_define_const(rb_mProcess, "CLOCK_REALTIME",  ID2SYM(id_CLOCK_REALTIME));
    rb_define_const(rb_mProcess, "CLOCK_MONOTONIC", ID2SYM(id_CLOCK_MONOTONIC));
    rb_define_const(rb_mProcess, "CLOCK_PROCESS_CPUTIME_ID", ID2SYM(id_CLOCK_PROCESS_CPUTIME_ID));
    rb_define_const(rb_mProcess, "CLOCK_THREAD_CPUTIME_ID",  ID2SYM(id_CLOCK_THREAD_CPUTIME_ID));

    rb_define_singleton_method(rb_mProcess, "clock_gettime", proc_clock_gettime, 1);
    rb_define_singleton_method(rb_mProcess, "clock_getres", proc_clock_getres, 1);
    rb_define_singleton_method(rb_mProcess, "clocks", proc_clocks, 0);
}

/*
 * vim: ts=8:sts=4:sw=4
 */
