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

static ID id_CLOCK_REALTIME, id_CLOCK_MONOTONIC,
    id_CLOCK_PROCESS_CPUTIME_ID, id_CLOCK_THREAD_CPUTIME_ID;

static VALUE v_CLOCK_REALTIME, v_CLOCK_MONOTONIC,
    v_CLOCK_PROCESS_CPUTIME_ID, v_CLOCK_THREAD_CPUTIME_ID;

#if defined(HAVE_SYS_TIME_H)
#  include <sys/time.h>
#endif

#ifdef HAVE_CLOCK_GETTIME

#  ifdef HAVE_LONG_LONG
#    define timespec2num(ts) { \
      if (!MUL_OVERFLOW_SIGNED_INTEGER_P(1000000000, (LONG_LONG)ts.tv_sec, LLONG_MIN, LLONG_MAX-999999999)) { \
	return LL2NUM(ts.tv_nsec + 1000000000 * (LONG_LONG)ts.tv_sec); \
      } \
      return rb_funcall(LONG2FIX((ts).tv_nsec), '+', 1, rb_funcall(LONG2FIX(1000000000), '*', 1, UINT2NUM((ts).tv_sec))); \
    }
#  else
#    define timespec2num(ts) { \
      return rb_funcall(LONG2FIX((ts).tv_nsec), '+', 1, rb_funcall(LONG2FIX(1000000000), '*', 1, UINT2NUM((ts).tv_sec))); \
    }
#  endif
/*
#    define timespec2num(ts) UINT2NUM((ts).tv_sec*1000000000 + (ts).tv_nsec)
*/

/*
 *  call-seq:
 *     Process.clock_gettime(clock_id)   -> Integer
 *
 *  Returns a timestamp from the clock identified by <i>clock_id</i>.
 *
 *     Process.clock_getres(Process::CLOCK_MONOTONIC)  # => 1023054562901423
 */

static VALUE
proc_clock_gettime(VALUE klass, VALUE clock_id)
{
    clockid_t clk_id;
    struct    timespec tp;

/*
    if (FIXNUM_P(clock_id)) {
	clk_id = (clockid_t)FIX2UINT(clock_id);
    } else {*/
	clk_id = (clockid_t)NUM2UINT(clock_id);
/*
    }*/

    if (clock_gettime(clk_id, &tp) == -1) {
	rb_sys_fail("clock_gettime");
    }
    return timespec2num(tp);
}

/*
 *  call-seq:
 *     Process.clock_getres(clock_id)   -> Integer
 *
 *  Returns the resolution of the clock identified by <i>clock_id</i>.
 *
 *     Process.clock_getres(Process::CLOCK_MONOTONIC)  # => 1
 */

static VALUE
proc_clock_getres(VALUE klass, VALUE clock_id)
{
    clockid_t clk_id;
    struct    timespec res;

    if (FIXNUM_P(clock_id)) {
	clk_id = (clockid_t)FIX2UINT(clock_id);
    } else {
	clk_id = (clockid_t)NUM2UINT(clock_id);
    }

    if (clock_getres(clk_id, &res) == -1) {
	rb_sys_fail("clock_getres");
    }
    return timespec2num(res);
}

/*
 *  call-seq:
 *     Process.clocks()   -> Hash
 *
 *  Returns a Hash of name to clock_id pairs.
 *
 *      Process.clocks  #=> {:CLOCK_REALTIME => 0, :CLOCK_MONOTONIC => 1}
 */

static VALUE
proc_clocks(VALUE klass)
{
    VALUE h = rb_hash_new();
    rb_hash_aset(h, ID2SYM(id_CLOCK_REALTIME), v_CLOCK_REALTIME);
#ifdef _POSIX_MONOTONIC_CLOCK
    rb_hash_aset(h, ID2SYM(id_CLOCK_MONOTONIC), v_CLOCK_MONOTONIC);
#endif
#ifdef _POSIX_CPUTIME
    rb_hash_aset(h, ID2SYM(id_CLOCK_PROCESS_CPUTIME_ID), v_CLOCK_PROCESS_CPUTIME_ID);
#endif
#ifdef _POSIX_THREAD_CPUTIME
    rb_hash_aset(h, ID2SYM(id_CLOCK_THREAD_CPUTIME_ID), v_CLOCK_THREAD_CPUTIME_ID);
#endif
    return h;
}

#else
#  define proc_clock_gettime rb_f_notimplement
#  define proc_clock_getres  rb_f_notimplement

static VALUE
proc_clocks(VALUE klass)
{
    return rb_hash_new();
}

#endif

void Init_gettime() {
#ifdef HAVE_CLOCK_GETTIME
    id_CLOCK_REALTIME = rb_intern("CLOCK_REALTIME");
    v_CLOCK_REALTIME = UINT2NUM(CLOCK_REALTIME);
    rb_define_const(rb_mProcess, "CLOCK_REALTIME",  v_CLOCK_REALTIME);
#  ifdef _POSIX_MONOTONIC_CLOCK
    id_CLOCK_REALTIME = rb_intern("CLOCK_MONOTONIC");
    v_CLOCK_REALTIME = UINT2NUM(CLOCK_MONOTONIC);
    rb_define_const(rb_mProcess, "CLOCK_MONOTONIC", v_CLOCK_MONOTONIC);
#  endif
#  ifdef _POSIX_CPUTIME
    id_CLOCK_REALTIME = rb_intern("CLOCK_PROCESS_CPUTIME_ID");
    v_CLOCK_REALTIME = UINT2NUM(CLOCK_PROCESS_CPUTIME_ID);
    rb_define_const(rb_mProcess, "CLOCK_PROCESS_CPUTIME_ID", v_CLOCK_PROCESS_CPUTIME_ID);
#  endif
#  ifdef _POSIX_THREAD_CPUTIME
    id_CLOCK_REALTIME = rb_intern("CLOCK_THREAD_CPUTIME_ID");
    v_CLOCK_REALTIME = UINT2NUM(CLOCK_THREAD_CPUTIME_ID);
    rb_define_const(rb_mProcess, "CLOCK_THREAD_CPUTIME_ID",  v_CLOCK_THREAD_CPUTIME_ID);
#  endif
#endif

    rb_define_singleton_method(rb_mProcess, "clock_gettime", proc_clock_gettime, 1);
    rb_define_singleton_method(rb_mProcess, "clock_getres", proc_clock_getres, 1);
    rb_define_singleton_method(rb_mProcess, "clocks", proc_clocks, 0);
}
