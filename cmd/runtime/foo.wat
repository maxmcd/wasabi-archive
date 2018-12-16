(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32)))
  (type (;3;) (func (param i32)))
  (type (;4;) (func (param i32 i32 i32)))
  (type (;5;) (func (param i32 i32 i32) (result i32)))
  (type (;6;) (func))
  (type (;7;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;8;) (func (param i32) (result i64)))
  (type (;9;) (func (param i32 i32 i32 i32)))
  (type (;10;) (func (param i32) (result i32)))
  (type (;11;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;12;) (func (param i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;13;) (func (param i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;14;) (func (param i32 i32 i32 i32 i32)))
  (import "env" "println" (func $println (type 2)))
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::hf694c42c0d6ebc75 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=4
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Display$GT$::fmt::h1f20bf1bdcce3a04)
  (func $core::result::unwrap_failed::h5963e6ac49b25e32 (type 4) (param i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    get_local 1
    i32.store offset=4
    get_local 3
    get_local 0
    i32.store
    get_local 3
    i32.const 32
    i32.add
    i32.const 12
    i32.add
    i32.const 1
    i32.store
    get_local 3
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 3
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    get_local 3
    i32.const 2
    i32.store offset=36
    get_local 3
    get_local 2
    i32.store offset=40
    get_local 3
    i32.const 1055744
    i32.store offset=8
    get_local 3
    i32.const 2
    i32.store offset=12
    get_local 3
    i32.const 1048580
    i32.store offset=16
    get_local 3
    get_local 3
    i32.store offset=32
    get_local 3
    get_local 3
    i32.const 32
    i32.add
    i32.store offset=24
    get_local 3
    i32.const 8
    i32.add
    i32.const 1055760
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $main (type 1) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 80
    i32.sub
    tee_local 0
    set_global 0
    get_local 0
    i32.const 56
    i32.add
    call $std::env::current_dir::hc52d4032924dd87f
    block  ;; label = @1
      get_local 0
      i32.load offset=56
      i32.const 1
      i32.eq
      br_if 0 (;@1;)
      get_local 0
      i32.const 32
      i32.add
      get_local 0
      i32.const 56
      i32.add
      i32.const 12
      i32.add
      tee_local 1
      i32.load
      i32.store
      get_local 0
      get_local 0
      i64.load offset=60 align=4
      i64.store offset=24
      get_local 0
      i32.const 16
      i32.add
      get_local 0
      i32.const 24
      i32.add
      call $_$LT$std..path..PathBuf$u20$as$u20$core..ops..deref..Deref$GT$::deref::h6159c2510e36d6a3
      get_local 0
      i32.const 8
      i32.add
      get_local 0
      i32.load offset=16
      get_local 0
      i32.load offset=20
      call $std::path::Path::display::h53df5603e8599ba6
      get_local 1
      i32.const 1
      i32.store
      get_local 0
      i32.const 76
      i32.add
      tee_local 1
      i32.const 1
      i32.store
      get_local 0
      i32.const 3
      i32.store offset=44
      get_local 0
      i32.const 1055776
      i32.store offset=56
      get_local 0
      i32.const 2
      i32.store offset=60
      get_local 0
      i32.const 1048740
      i32.store offset=64
      get_local 0
      get_local 0
      i64.load offset=8
      i64.store offset=48
      get_local 0
      get_local 0
      i32.const 48
      i32.add
      i32.store offset=40
      get_local 0
      get_local 0
      i32.const 40
      i32.add
      i32.store offset=72
      get_local 0
      i32.const 56
      i32.add
      call $std::io::stdio::_print::hae1d3c39a68c680a
      get_local 1
      i32.const 0
      i32.store
      get_local 0
      i32.const 1055792
      i32.store offset=56
      get_local 0
      i64.const 1
      i64.store offset=60 align=4
      get_local 0
      i32.const 1048792
      i32.store offset=72
      get_local 0
      i32.const 56
      i32.add
      call $std::io::stdio::_print::hae1d3c39a68c680a
      i32.const 1048792
      i32.const 12
      call $println
      block  ;; label = @2
        get_local 0
        i32.load offset=28
        tee_local 1
        i32.eqz
        br_if 0 (;@2;)
        get_local 0
        i32.load offset=24
        get_local 1
        i32.const 1
        call $__rust_dealloc
      end
      get_local 0
      i32.const 80
      i32.add
      set_global 0
      i32.const 0
      return
    end
    get_local 0
    get_local 0
    i64.load offset=60 align=4
    i64.store offset=24
    i32.const 1048669
    i32.const 43
    get_local 0
    i32.const 24
    i32.add
    call $core::result::unwrap_failed::h5963e6ac49b25e32
    unreachable)
  (func $__rust_alloc (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $__rdl_alloc)
  (func $__rust_dealloc (type 4) (param i32 i32 i32)
    get_local 0
    get_local 1
    get_local 2
    call $__rdl_dealloc)
  (func $__rust_realloc (type 7) (param i32 i32 i32 i32) (result i32)
    get_local 0
    get_local 1
    get_local 2
    get_local 3
    call $__rdl_realloc)
  (func $std::path::Path::new::h18d47022d420b510 (type 2) (param i32 i32)
    get_local 0
    get_local 1
    i32.load offset=8
    i32.store offset=4
    get_local 0
    get_local 1
    i32.load
    i32.store)
  (func $std::path::Path::display::h53df5603e8599ba6 (type 4) (param i32 i32 i32)
    get_local 0
    get_local 2
    i32.store offset=4
    get_local 0
    get_local 1
    i32.store)
  (func $_$LT$std..path..Display$LT$$u27$a$GT$$u20$as$u20$core..fmt..Display$GT$::fmt::h3167292a36c61c19 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 8
    i32.add
    get_local 0
    i32.load
    get_local 0
    i32.load offset=4
    call $core::str::lossy::Utf8Lossy::from_bytes::hee82e80c1fd82afb
    get_local 2
    i32.load offset=8
    get_local 2
    i32.load offset=12
    get_local 1
    call $_$LT$core..str..lossy..Utf8Lossy$u20$as$u20$core..fmt..Display$GT$::fmt::hb35ced54affafa88
    set_local 0
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 0)
  (func $_$LT$std..path..PathBuf$u20$as$u20$core..ops..deref..Deref$GT$::deref::h6159c2510e36d6a3 (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 8
    i32.add
    get_local 1
    call $std::path::Path::new::h18d47022d420b510
    get_local 0
    get_local 2
    i64.load offset=8
    i64.store align=4
    get_local 2
    i32.const 16
    i32.add
    set_global 0)
  (func $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h51af4ad49d9e9a5c (type 8) (param i32) (result i64)
    i64.const 1229646359891580772)
  (func $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h925878a4893011a0 (type 8) (param i32) (result i64)
    i64.const 7549865886324542212)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$i32$GT$::fmt::hc2938f31b1162c1e (type 0) (param i32 i32) (result i32)
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_lower_hex::h92753715ffe745e5
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$::fmt::h7543c3fa290cf95c
      return
    end
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_upper_hex::h872e32477651ad01
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$::fmt::h1bef50aed415726b
      return
    end
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$::fmt::hcecd1e62e7515144)
  (func $core::ptr::drop_in_place::h1198034061628adf (type 3) (param i32))
  (func $core::ptr::drop_in_place::h80e2533b22b5a3bf (type 3) (param i32)
    (local i32)
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.load
      get_local 1
      i32.const 1
      call $__rust_dealloc
    end)
  (func $_$LT$F$u20$as$u20$alloc..boxed..FnBox$LT$A$GT$$GT$::call_box::h282eac7bd732b330 (type 3) (param i32)
    (local i32 i32)
    block  ;; label = @1
      get_local 0
      i32.load
      tee_local 1
      i32.load8_u offset=4
      br_if 0 (;@1;)
      get_local 1
      i32.const 4
      i32.add
      i32.const 0
      i32.store8
      get_local 1
      i32.load
      set_local 2
      get_local 1
      i32.const 1
      i32.store
      get_local 2
      i32.load
      tee_local 1
      get_local 1
      i32.load
      tee_local 1
      i32.const -1
      i32.add
      i32.store
      block  ;; label = @2
        get_local 1
        i32.const 1
        i32.ne
        br_if 0 (;@2;)
        get_local 2
        call $_$LT$alloc..sync..Arc$LT$T$GT$$GT$::drop_slow::hedbbe9076b8173b2
      end
      get_local 2
      i32.const 4
      i32.const 4
      call $__rust_dealloc
      get_local 0
      i32.const 4
      i32.const 4
      call $__rust_dealloc
      return
    end
    i32.const 1049525
    i32.const 32
    i32.const 1055964
    call $std::panicking::begin_panic::he1c3fcf48f83642e
    unreachable)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::h60ebfe1199844e78 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 1
    call $_$LT$std..io..error..ErrorKind$u20$as$u20$core..fmt..Debug$GT$::fmt::hff5c95ebe2c095ea)
  (func $_$LT$std..io..error..ErrorKind$u20$as$u20$core..fmt..Debug$GT$::fmt::hff5c95ebe2c095ea (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        get_local 0
                                        i32.load8_u
                                        i32.const -1
                                        i32.add
                                        tee_local 0
                                        i32.const 16
                                        i32.gt_u
                                        br_if 0 (;@18;)
                                        block  ;; label = @19
                                          get_local 0
                                          br_table 0 (;@19;) 2 (;@17;) 3 (;@16;) 4 (;@15;) 5 (;@14;) 6 (;@13;) 7 (;@12;) 8 (;@11;) 9 (;@10;) 10 (;@9;) 11 (;@8;) 12 (;@7;) 13 (;@6;) 14 (;@5;) 15 (;@4;) 16 (;@3;) 17 (;@2;) 0 (;@19;)
                                        end
                                        get_local 2
                                        get_local 1
                                        i32.const 1049477
                                        i32.const 16
                                        call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                                        br 17 (;@1;)
                                      end
                                      get_local 2
                                      get_local 1
                                      i32.const 1049493
                                      i32.const 8
                                      call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                                      br 16 (;@1;)
                                    end
                                    get_local 2
                                    get_local 1
                                    i32.const 1049460
                                    i32.const 17
                                    call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                                    br 15 (;@1;)
                                  end
                                  get_local 2
                                  get_local 1
                                  i32.const 1049445
                                  i32.const 15
                                  call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                                  br 14 (;@1;)
                                end
                                get_local 2
                                get_local 1
                                i32.const 1049428
                                i32.const 17
                                call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                                br 13 (;@1;)
                              end
                              get_local 2
                              get_local 1
                              i32.const 1049416
                              i32.const 12
                              call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                              br 12 (;@1;)
                            end
                            get_local 2
                            get_local 1
                            i32.const 1049407
                            i32.const 9
                            call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                            br 11 (;@1;)
                          end
                          get_local 2
                          get_local 1
                          i32.const 1049391
                          i32.const 16
                          call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                          br 10 (;@1;)
                        end
                        get_local 2
                        get_local 1
                        i32.const 1049381
                        i32.const 10
                        call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                        br 9 (;@1;)
                      end
                      get_local 2
                      get_local 1
                      i32.const 1049368
                      i32.const 13
                      call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                      br 8 (;@1;)
                    end
                    get_local 2
                    get_local 1
                    i32.const 1049358
                    i32.const 10
                    call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                    br 7 (;@1;)
                  end
                  get_local 2
                  get_local 1
                  i32.const 1049346
                  i32.const 12
                  call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                  br 6 (;@1;)
                end
                get_local 2
                get_local 1
                i32.const 1049335
                i32.const 11
                call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
                br 5 (;@1;)
              end
              get_local 2
              get_local 1
              i32.const 1049327
              i32.const 8
              call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
              br 4 (;@1;)
            end
            get_local 2
            get_local 1
            i32.const 1049318
            i32.const 9
            call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
            br 3 (;@1;)
          end
          get_local 2
          get_local 1
          i32.const 1049307
          i32.const 11
          call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
          br 2 (;@1;)
        end
        get_local 2
        get_local 1
        i32.const 1049302
        i32.const 5
        call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
        br 1 (;@1;)
      end
      get_local 2
      get_local 1
      i32.const 1049289
      i32.const 13
      call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
    end
    get_local 2
    call $core::fmt::builders::DebugTuple::finish::h49e80920431344b7
    set_local 1
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::hf7d2ad93e91a98c6 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    tee_local 0
    i32.load
    get_local 1
    get_local 0
    i32.load offset=4
    i32.load offset=32
    call_indirect (type 0))
  (func $_$LT$alloc..string..String$u20$as$u20$core..fmt..Debug$GT$::fmt::hd9ac2cca6a9e8ca1 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=8
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Debug$GT$::fmt::hd2afc455f5f6b65c)
  (func $_$LT$alloc..string..String$u20$as$u20$core..fmt..Display$GT$::fmt::h0585c26a34dbb6c1 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=8
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Display$GT$::fmt::h1f20bf1bdcce3a04)
  (func $_$LT$std..io..error..Error$u20$as$u20$core..fmt..Debug$GT$::fmt::h613a4cb9bb31a3f1 (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $_$LT$std..io..error..Repr$u20$as$u20$core..fmt..Debug$GT$::fmt::h730320a06bd0d049)
  (func $_$LT$std..io..error..Repr$u20$as$u20$core..fmt..Debug$GT$::fmt::h730320a06bd0d049 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 0
          i32.load8_u
          tee_local 3
          i32.const 3
          i32.and
          i32.const 1
          i32.eq
          br_if 0 (;@3;)
          get_local 3
          i32.const 2
          i32.ne
          br_if 1 (;@2;)
          get_local 0
          i32.const 4
          i32.add
          i32.load
          set_local 0
          get_local 2
          i32.const 32
          i32.add
          get_local 1
          i32.const 1049278
          i32.const 6
          call $core::fmt::Formatter::debug_struct::h52478105236d4ae6
          get_local 2
          get_local 0
          i32.const 8
          i32.add
          i32.store offset=16
          get_local 2
          i32.const 32
          i32.add
          i32.const 1049183
          i32.const 4
          get_local 2
          i32.const 16
          i32.add
          i32.const 1055932
          call $core::fmt::builders::DebugStruct::field::hec77dd286480bd94
          drop
          get_local 2
          get_local 0
          i32.store offset=16
          get_local 2
          i32.const 32
          i32.add
          i32.const 1049284
          i32.const 5
          get_local 2
          i32.const 16
          i32.add
          i32.const 1055948
          call $core::fmt::builders::DebugStruct::field::hec77dd286480bd94
          drop
          get_local 2
          i32.const 32
          i32.add
          call $core::fmt::builders::DebugStruct::finish::h3dd8d635d04004d8
          set_local 0
          br 2 (;@1;)
        end
        get_local 2
        get_local 0
        i32.load8_u offset=1
        i32.store8 offset=16
        get_local 2
        i32.const 32
        i32.add
        get_local 1
        i32.const 1049173
        i32.const 4
        call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
        get_local 2
        i32.const 32
        i32.add
        get_local 2
        i32.const 16
        i32.add
        i32.const 1055836
        call $core::fmt::builders::DebugTuple::field::hd3b43611deb92f36
        call $core::fmt::builders::DebugTuple::finish::h49e80920431344b7
        set_local 0
        br 1 (;@1;)
      end
      get_local 2
      get_local 0
      i32.const 4
      i32.add
      i32.load
      i32.store offset=12
      get_local 2
      i32.const 16
      i32.add
      get_local 1
      i32.const 1049177
      i32.const 2
      call $core::fmt::Formatter::debug_struct::h52478105236d4ae6
      get_local 2
      i32.const 16
      i32.add
      i32.const 1049179
      i32.const 4
      get_local 2
      i32.const 12
      i32.add
      i32.const 1055852
      call $core::fmt::builders::DebugStruct::field::hec77dd286480bd94
      set_local 0
      get_local 2
      i32.const 16
      i32.store8 offset=31
      get_local 0
      i32.const 1049183
      i32.const 4
      get_local 2
      i32.const 31
      i32.add
      i32.const 1055836
      call $core::fmt::builders::DebugStruct::field::hec77dd286480bd94
      set_local 0
      get_local 2
      i32.const 32
      i32.add
      i32.const 1049709
      i32.const 20
      call $_$LT$alloc..string..String$u20$as$u20$core..convert..From$LT$$RF$$u27$a$u20$str$GT$$GT$::from::hb3fb17fd74da80e4
      get_local 0
      i32.const 1049187
      i32.const 7
      get_local 2
      i32.const 32
      i32.add
      i32.const 1055868
      call $core::fmt::builders::DebugStruct::field::hec77dd286480bd94
      call $core::fmt::builders::DebugStruct::finish::h3dd8d635d04004d8
      set_local 0
      get_local 2
      i32.load offset=36
      tee_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 2
      i32.load offset=32
      get_local 1
      i32.const 1
      call $__rust_dealloc
    end
    get_local 2
    i32.const 48
    i32.add
    set_global 0
    get_local 0)
  (func $std::io::error::Error::new::h507e001db9edbb01 (type 9) (param i32 i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 4
    set_global 0
    get_local 4
    get_local 2
    get_local 3
    call $_$LT$alloc..string..String$u20$as$u20$core..convert..From$LT$$RF$$u27$a$u20$str$GT$$GT$::from::hb3fb17fd74da80e4
    get_local 4
    i32.const 16
    i32.add
    i32.const 8
    i32.add
    tee_local 2
    get_local 4
    i32.const 8
    i32.add
    i32.load
    i32.store
    get_local 4
    get_local 4
    i64.load
    i64.store offset=16
    block  ;; label = @1
      block  ;; label = @2
        i32.const 12
        i32.const 4
        call $__rust_alloc
        tee_local 3
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        get_local 4
        i64.load offset=16
        i64.store align=4
        get_local 3
        i32.const 8
        i32.add
        get_local 2
        i32.load
        i32.store
        i32.const 12
        i32.const 4
        call $__rust_alloc
        tee_local 2
        i32.eqz
        br_if 1 (;@1;)
        get_local 2
        i32.const 1055800
        i32.store offset=4
        get_local 2
        get_local 3
        i32.store
        get_local 2
        get_local 1
        i32.store8 offset=8
        get_local 2
        get_local 4
        i32.load16_u offset=16 align=1
        i32.store16 offset=9 align=1
        get_local 2
        i32.const 11
        i32.add
        get_local 4
        i32.const 16
        i32.add
        i32.const 2
        i32.add
        tee_local 3
        i32.load8_u
        i32.store8
        get_local 0
        i32.const 2
        i32.store8
        get_local 0
        i32.const 4
        i32.add
        get_local 2
        i32.store
        get_local 0
        get_local 4
        i32.load16_u offset=16 align=1
        i32.store16 offset=1 align=1
        get_local 0
        i32.const 3
        i32.add
        get_local 3
        i32.load8_u
        i32.store8
        get_local 4
        i32.const 32
        i32.add
        set_global 0
        return
      end
      i32.const 12
      i32.const 4
      call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
      unreachable
    end
    i32.const 12
    i32.const 4
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $_$LT$std..io..error..Error$u20$as$u20$core..fmt..Display$GT$::fmt::hf5e6a284176ba0b8 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              get_local 0
                                              i32.load8_u
                                              tee_local 3
                                              i32.const 3
                                              i32.and
                                              i32.const 1
                                              i32.eq
                                              br_if 0 (;@21;)
                                              get_local 3
                                              i32.const 2
                                              i32.ne
                                              br_if 1 (;@20;)
                                              get_local 0
                                              i32.const 4
                                              i32.add
                                              i32.load
                                              tee_local 0
                                              i32.load
                                              get_local 1
                                              get_local 0
                                              i32.load offset=4
                                              i32.load offset=28
                                              call_indirect (type 0)
                                              set_local 0
                                              br 20 (;@1;)
                                            end
                                            i32.const 16
                                            set_local 3
                                            get_local 0
                                            i32.load8_u offset=1
                                            i32.const -1
                                            i32.add
                                            tee_local 0
                                            i32.const 16
                                            i32.gt_u
                                            br_if 1 (;@19;)
                                            block  ;; label = @21
                                              get_local 0
                                              br_table 0 (;@21;) 3 (;@18;) 4 (;@17;) 5 (;@16;) 6 (;@15;) 7 (;@14;) 8 (;@13;) 9 (;@12;) 10 (;@11;) 11 (;@10;) 12 (;@9;) 13 (;@8;) 14 (;@7;) 15 (;@6;) 16 (;@5;) 17 (;@4;) 18 (;@3;) 0 (;@21;)
                                            end
                                            i32.const 1049140
                                            set_local 0
                                            i32.const 17
                                            set_local 3
                                            br 18 (;@2;)
                                          end
                                          get_local 2
                                          get_local 0
                                          i32.const 4
                                          i32.add
                                          i32.load
                                          i32.store offset=4
                                          get_local 2
                                          i32.const 8
                                          i32.add
                                          i32.const 1049709
                                          i32.const 20
                                          call $_$LT$alloc..string..String$u20$as$u20$core..convert..From$LT$$RF$$u27$a$u20$str$GT$$GT$::from::hb3fb17fd74da80e4
                                          get_local 2
                                          i32.const 24
                                          i32.add
                                          i32.const 12
                                          i32.add
                                          i32.const 4
                                          i32.store
                                          get_local 2
                                          i32.const 40
                                          i32.add
                                          i32.const 12
                                          i32.add
                                          i32.const 2
                                          i32.store
                                          get_local 2
                                          i32.const 40
                                          i32.add
                                          i32.const 20
                                          i32.add
                                          i32.const 2
                                          i32.store
                                          get_local 2
                                          i32.const 5
                                          i32.store offset=28
                                          get_local 2
                                          i32.const 1055892
                                          i32.store offset=40
                                          get_local 2
                                          i32.const 3
                                          i32.store offset=44
                                          get_local 2
                                          i32.const 1048804
                                          i32.store offset=48
                                          get_local 2
                                          get_local 2
                                          i32.const 8
                                          i32.add
                                          i32.store offset=24
                                          get_local 2
                                          get_local 2
                                          i32.const 4
                                          i32.add
                                          i32.store offset=32
                                          get_local 2
                                          get_local 2
                                          i32.const 24
                                          i32.add
                                          i32.store offset=56
                                          get_local 1
                                          get_local 2
                                          i32.const 40
                                          i32.add
                                          call $core::fmt::Formatter::write_fmt::h183bfc55f2f88031
                                          set_local 0
                                          get_local 2
                                          i32.load offset=12
                                          tee_local 1
                                          i32.eqz
                                          br_if 18 (;@1;)
                                          get_local 2
                                          i32.load offset=8
                                          get_local 1
                                          i32.const 1
                                          call $__rust_dealloc
                                          br 18 (;@1;)
                                        end
                                        i32.const 1049157
                                        set_local 0
                                        br 16 (;@2;)
                                      end
                                      i32.const 1049122
                                      set_local 0
                                      i32.const 18
                                      set_local 3
                                      br 15 (;@2;)
                                    end
                                    i32.const 1049106
                                    set_local 0
                                    br 14 (;@2;)
                                  end
                                  i32.const 1049088
                                  set_local 0
                                  i32.const 18
                                  set_local 3
                                  br 13 (;@2;)
                                end
                                i32.const 1049075
                                set_local 0
                                i32.const 13
                                set_local 3
                                br 12 (;@2;)
                              end
                              i32.const 1049061
                              set_local 0
                              i32.const 14
                              set_local 3
                              br 11 (;@2;)
                            end
                            i32.const 1049040
                            set_local 0
                            i32.const 21
                            set_local 3
                            br 10 (;@2;)
                          end
                          i32.const 1049029
                          set_local 0
                          i32.const 11
                          set_local 3
                          br 9 (;@2;)
                        end
                        i32.const 1049008
                        set_local 0
                        i32.const 21
                        set_local 3
                        br 8 (;@2;)
                      end
                      i32.const 1048987
                      set_local 0
                      i32.const 21
                      set_local 3
                      br 7 (;@2;)
                    end
                    i32.const 1048964
                    set_local 0
                    i32.const 23
                    set_local 3
                    br 6 (;@2;)
                  end
                  i32.const 1048952
                  set_local 0
                  i32.const 12
                  set_local 3
                  br 5 (;@2;)
                end
                i32.const 1048943
                set_local 0
                i32.const 9
                set_local 3
                br 4 (;@2;)
              end
              i32.const 1048933
              set_local 0
              i32.const 10
              set_local 3
              br 3 (;@2;)
            end
            i32.const 1048912
            set_local 0
            i32.const 21
            set_local 3
            br 2 (;@2;)
          end
          i32.const 1048898
          set_local 0
          i32.const 14
          set_local 3
          br 1 (;@2;)
        end
        i32.const 1048876
        set_local 0
        i32.const 22
        set_local 3
      end
      get_local 2
      i32.const 52
      i32.add
      i32.const 1
      i32.store
      get_local 2
      i32.const 60
      i32.add
      i32.const 1
      i32.store
      get_local 2
      get_local 3
      i32.store offset=28
      get_local 2
      get_local 0
      i32.store offset=24
      get_local 2
      i32.const 6
      i32.store offset=12
      get_local 2
      i32.const 1055884
      i32.store offset=40
      get_local 2
      i32.const 1
      i32.store offset=44
      get_local 2
      i32.const 1049196
      i32.store offset=48
      get_local 2
      get_local 2
      i32.const 24
      i32.add
      i32.store offset=8
      get_local 2
      get_local 2
      i32.const 8
      i32.add
      i32.store offset=56
      get_local 1
      get_local 2
      i32.const 40
      i32.add
      call $core::fmt::Formatter::write_fmt::h183bfc55f2f88031
      set_local 0
    end
    get_local 2
    i32.const 64
    i32.add
    set_global 0
    get_local 0)
  (func $_$LT$std..io..lazy..Lazy$LT$T$GT$$GT$::get::h409a0e6ce3800daa (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 0
            i32.load8_u offset=4
            br_if 0 (;@4;)
            get_local 0
            i32.const 4
            i32.add
            tee_local 2
            i32.const 1
            i32.store8
            i32.const 0
            set_local 3
            block  ;; label = @5
              get_local 0
              i32.load
              tee_local 4
              i32.const 1
              i32.eq
              br_if 0 (;@5;)
              block  ;; label = @6
                get_local 4
                br_if 0 (;@6;)
                i32.const 4
                i32.const 4
                call $__rust_alloc
                tee_local 3
                i32.eqz
                br_if 4 (;@2;)
                get_local 3
                get_local 0
                i32.store
                get_local 3
                i32.const 1056300
                call $std::sys_common::at_exit_imp::push::hf4ff580358497fe5
                set_local 4
                get_local 1
                call_indirect (type 1)
                set_local 3
                get_local 4
                i32.eqz
                br_if 1 (;@5;)
                get_local 3
                get_local 3
                i32.load
                tee_local 4
                i32.const 1
                i32.add
                i32.store
                get_local 4
                i32.const -1
                i32.le_s
                br_if 3 (;@3;)
                i32.const 4
                i32.const 4
                call $__rust_alloc
                tee_local 4
                i32.eqz
                br_if 5 (;@1;)
                get_local 0
                get_local 4
                i32.store
                get_local 4
                get_local 3
                i32.store
                get_local 2
                i32.const 0
                i32.store8
                get_local 3
                return
              end
              get_local 4
              i32.load
              tee_local 0
              get_local 0
              i32.load
              tee_local 0
              i32.const 1
              i32.add
              i32.store
              get_local 0
              i32.const -1
              i32.le_s
              br_if 2 (;@3;)
              get_local 4
              i32.load
              set_local 3
            end
            get_local 2
            i32.const 0
            i32.store8
            get_local 3
            return
          end
          i32.const 1049525
          i32.const 32
          i32.const 1055964
          call $std::panicking::begin_panic::he1c3fcf48f83642e
          unreachable
        end
        unreachable
        unreachable
      end
      i32.const 4
      i32.const 4
      call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
      unreachable
    end
    i32.const 4
    i32.const 4
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $std::alloc::default_alloc_error_hook::h5119c13a26248f94 (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    get_local 2
    i32.const 28
    i32.add
    i32.const 1
    i32.store
    get_local 2
    get_local 0
    i32.store offset=44
    get_local 2
    i32.const 7
    i32.store offset=36
    get_local 2
    i32.const 1055916
    i32.store offset=8
    get_local 2
    i32.const 2
    i32.store offset=12
    get_local 2
    i32.const 1049196
    i32.store offset=16
    get_local 2
    get_local 2
    i32.const 44
    i32.add
    i32.store offset=32
    get_local 2
    get_local 2
    i32.const 32
    i32.add
    i32.store offset=24
    get_local 2
    i32.const 8
    i32.add
    call $std::sys_common::util::dumb_print::h16349c6eb68bcf3a
    get_local 2
    i32.const 48
    i32.add
    set_global 0)
  (func $rust_oom (type 2) (param i32 i32)
    (local i32)
    get_local 0
    get_local 1
    i32.const 0
    i32.load offset=1058648
    tee_local 2
    i32.const 8
    get_local 2
    select
    call_indirect (type 2)
    unreachable
    unreachable)
  (func $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h7d8dbe5a24e1e982__.llvm.5600775270182012462_ (type 7) (param i32 i32 i32 i32) (result i32)
    (local i32 i32)
    i32.const 2
    set_local 4
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 5
      get_local 1
      i32.sub
      get_local 2
      i32.ge_u
      br_if 0 (;@1;)
      get_local 1
      get_local 2
      i32.add
      tee_local 2
      get_local 1
      i32.lt_u
      set_local 1
      block  ;; label = @2
        block  ;; label = @3
          get_local 3
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          set_local 4
          get_local 1
          br_if 2 (;@1;)
          get_local 5
          i32.const 1
          i32.shl
          tee_local 1
          get_local 2
          get_local 2
          get_local 1
          i32.lt_u
          select
          set_local 2
          br 1 (;@2;)
        end
        i32.const 0
        set_local 4
        get_local 1
        br_if 1 (;@1;)
      end
      i32.const 0
      set_local 4
      get_local 2
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 5
            i32.eqz
            br_if 0 (;@4;)
            get_local 0
            i32.load
            get_local 5
            i32.const 1
            get_local 2
            call $__rust_realloc
            tee_local 1
            i32.eqz
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          get_local 2
          i32.const 1
          call $__rust_alloc
          tee_local 1
          br_if 1 (;@2;)
        end
        get_local 2
        i32.const 1
        call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
        unreachable
      end
      get_local 0
      get_local 1
      i32.store
      get_local 0
      i32.const 4
      i32.add
      get_local 2
      i32.store
      i32.const 2
      set_local 4
    end
    get_local 4)
  (func $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve::h95549370b91dca7a (type 4) (param i32 i32 i32)
    (local i32 i64)
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 3
      get_local 1
      i32.sub
      get_local 2
      i32.ge_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          get_local 1
          get_local 2
          i32.add
          tee_local 2
          get_local 1
          i32.lt_u
          br_if 0 (;@3;)
          get_local 3
          i32.const 1
          i32.shl
          tee_local 1
          get_local 2
          get_local 2
          get_local 1
          i32.lt_u
          select
          tee_local 1
          i64.extend_u/i32
          i64.const 3
          i64.shl
          tee_local 4
          i64.const 32
          i64.shr_u
          i32.wrap/i64
          br_if 0 (;@3;)
          get_local 4
          i32.wrap/i64
          tee_local 2
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              get_local 3
              i32.eqz
              br_if 0 (;@5;)
              get_local 0
              i32.load
              get_local 3
              i32.const 3
              i32.shl
              i32.const 4
              get_local 2
              call $__rust_realloc
              tee_local 3
              i32.eqz
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            get_local 2
            i32.const 4
            call $__rust_alloc
            tee_local 3
            br_if 2 (;@2;)
          end
          get_local 2
          i32.const 4
          call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
          unreachable
        end
        call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
        unreachable
      end
      get_local 0
      get_local 3
      i32.store
      get_local 0
      i32.const 4
      i32.add
      get_local 1
      i32.store
    end)
  (func $core::result::unwrap_failed::h7a4474d5fceddfbf (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=12
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    i32.const 40
    i32.add
    i32.const 12
    i32.add
    i32.const 22
    i32.store
    get_local 2
    i32.const 16
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 36
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 6
    i32.store offset=44
    get_local 2
    i32.const 1056004
    i32.store offset=16
    get_local 2
    i32.const 2
    i32.store offset=20
    get_local 2
    i32.const 1049620
    i32.store offset=24
    get_local 2
    get_local 2
    i32.const 8
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 56
    i32.add
    i32.store offset=48
    get_local 2
    get_local 2
    i32.const 40
    i32.add
    i32.store offset=32
    get_local 2
    i32.const 16
    i32.add
    i32.const 1056020
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $core::result::unwrap_failed::ha12182d6d2f7067c (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=12
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    i32.const 40
    i32.add
    i32.const 12
    i32.add
    i32.const 23
    i32.store
    get_local 2
    i32.const 16
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 36
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 6
    i32.store offset=44
    get_local 2
    i32.const 1056004
    i32.store offset=16
    get_local 2
    i32.const 2
    i32.store offset=20
    get_local 2
    i32.const 1049620
    i32.store offset=24
    get_local 2
    get_local 2
    i32.const 8
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 56
    i32.add
    i32.store offset=48
    get_local 2
    get_local 2
    i32.const 40
    i32.add
    i32.store offset=32
    get_local 2
    i32.const 16
    i32.add
    i32.const 1056020
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $_$LT$std..io..buffered..BufWriter$LT$W$GT$$GT$::flush_buf::h034b4ff4b1f9df38__.llvm.10348248634257366068_ (type 2) (param i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 1
        i32.load offset=8
        i32.eqz
        br_if 0 (;@2;)
        get_local 1
        i32.load8_u offset=12
        i32.const 2
        i32.eq
        br_if 1 (;@1;)
        get_local 1
        i32.const 8
        i32.add
        i32.const 0
        i32.store
        get_local 1
        i32.const 13
        i32.add
        i32.const 0
        i32.store8
      end
      get_local 0
      i32.const 3
      i32.store
      return
    end
    get_local 1
    i32.const 13
    i32.add
    i32.const 1
    i32.store8
    i32.const 1056036
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$std..io..buffered..BufWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h70007b3576305aaf (type 9) (param i32 i32 i32 i32)
    (local i32 i32)
    get_local 1
    i32.load offset=4
    set_local 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 1
              i32.load offset=8
              tee_local 5
              i32.eqz
              br_if 0 (;@5;)
              get_local 5
              get_local 3
              i32.add
              get_local 4
              i32.le_u
              br_if 0 (;@5;)
              get_local 1
              i32.load8_u offset=12
              i32.const 2
              i32.eq
              br_if 1 (;@4;)
              i32.const 0
              set_local 5
              get_local 1
              i32.const 8
              i32.add
              i32.const 0
              i32.store
              get_local 1
              i32.const 13
              i32.add
              i32.const 0
              i32.store8
            end
            block  ;; label = @5
              get_local 4
              get_local 3
              i32.le_u
              br_if 0 (;@5;)
              get_local 1
              get_local 5
              get_local 3
              i32.const 1
              call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h7d8dbe5a24e1e982__.llvm.5600775270182012462_
              tee_local 4
              i32.const 255
              i32.and
              i32.const 2
              i32.ne
              br_if 2 (;@3;)
              get_local 1
              i32.const 8
              i32.add
              tee_local 4
              get_local 4
              i32.load
              tee_local 4
              get_local 3
              i32.add
              i32.store
              get_local 4
              get_local 1
              i32.load
              i32.add
              get_local 2
              get_local 3
              call $memcpy
              drop
              get_local 0
              i32.const 0
              i32.store
              get_local 0
              get_local 3
              i32.store offset=4
              return
            end
            get_local 1
            i32.const 1
            i32.store8 offset=13
            get_local 1
            i32.load8_u offset=12
            i32.const 2
            i32.eq
            br_if 2 (;@2;)
            get_local 0
            i32.const 0
            i32.store
            get_local 0
            get_local 3
            i32.store offset=4
            get_local 1
            i32.const 13
            i32.add
            i32.const 0
            i32.store8
            return
          end
          get_local 1
          i32.const 13
          i32.add
          i32.const 1
          i32.store8
          i32.const 1056036
          call $core::panicking::panic::h9b4aaddfe00d4a7f
          unreachable
        end
        get_local 4
        i32.const 1
        i32.and
        br_if 1 (;@1;)
        call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
        unreachable
      end
      i32.const 1056036
      call $core::panicking::panic::h9b4aaddfe00d4a7f
      unreachable
    end
    i32.const 1055980
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$std..io..buffered..LineWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h982081d0324ec441 (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 4
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 1
              i32.load8_u offset=16
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.load offset=8
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 1
                  i32.load8_u offset=12
                  i32.const 2
                  i32.eq
                  br_if 3 (;@4;)
                  get_local 1
                  i32.const 8
                  i32.add
                  i32.const 0
                  i32.store
                  get_local 1
                  i32.const 13
                  i32.add
                  i32.const 0
                  i32.store8
                  br 1 (;@6;)
                end
                get_local 1
                i32.load8_u offset=12
                i32.const 2
                i32.eq
                br_if 4 (;@2;)
              end
              get_local 1
              i32.const 16
              i32.add
              i32.const 0
              i32.store8
            end
            get_local 4
            i32.const 8
            i32.add
            i32.const 10
            get_local 2
            get_local 3
            call $core::slice::memchr::memrchr::hf4d2adc392d0f856
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 4
                      i32.load offset=8
                      i32.eqz
                      br_if 0 (;@9;)
                      get_local 4
                      i32.load offset=12
                      i32.const 1
                      i32.add
                      tee_local 5
                      get_local 3
                      i32.gt_u
                      br_if 4 (;@5;)
                      get_local 4
                      i32.const 16
                      i32.add
                      get_local 1
                      get_local 2
                      get_local 5
                      call $_$LT$std..io..buffered..BufWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h70007b3576305aaf
                      get_local 4
                      i32.load offset=20
                      set_local 6
                      get_local 4
                      i32.load offset=16
                      tee_local 7
                      i32.eqz
                      br_if 2 (;@7;)
                      get_local 4
                      i32.const 24
                      i32.add
                      i32.load
                      set_local 8
                      get_local 7
                      i32.const 1
                      i32.ne
                      br_if 1 (;@8;)
                      get_local 0
                      i32.const 1
                      i32.store
                      get_local 0
                      get_local 8
                      i64.extend_u/i32
                      i64.const 32
                      i64.shl
                      get_local 6
                      i64.extend_u/i32
                      i64.or
                      i64.store offset=4 align=4
                      br 3 (;@6;)
                    end
                    get_local 0
                    get_local 1
                    get_local 2
                    get_local 3
                    call $_$LT$std..io..buffered..BufWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h70007b3576305aaf
                    br 2 (;@6;)
                  end
                  get_local 6
                  i32.const 255
                  i32.and
                  i32.const 2
                  i32.lt_u
                  br_if 0 (;@7;)
                  get_local 8
                  i32.load
                  get_local 8
                  i32.load offset=4
                  i32.load
                  call_indirect (type 3)
                  block  ;; label = @8
                    get_local 8
                    i32.load offset=4
                    tee_local 7
                    i32.load offset=4
                    tee_local 9
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 8
                    i32.load
                    get_local 9
                    get_local 7
                    i32.load offset=8
                    call $__rust_dealloc
                  end
                  get_local 8
                  i32.const 12
                  i32.const 4
                  call $__rust_dealloc
                end
                get_local 1
                i32.const 16
                i32.add
                i32.const 1
                i32.store8
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 1
                    i32.load offset=8
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 1
                    i32.load8_u offset=12
                    i32.const 2
                    i32.eq
                    br_if 5 (;@3;)
                    get_local 1
                    i32.const 8
                    i32.add
                    i32.const 0
                    i32.store
                    get_local 1
                    i32.const 13
                    i32.add
                    i32.const 0
                    i32.store8
                    br 1 (;@7;)
                  end
                  get_local 1
                  i32.load8_u offset=12
                  i32.const 2
                  i32.eq
                  br_if 6 (;@1;)
                end
                get_local 1
                i32.const 16
                i32.add
                i32.const 0
                i32.store8
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 6
                    get_local 5
                    i32.ne
                    br_if 0 (;@8;)
                    get_local 4
                    i32.const 16
                    i32.add
                    get_local 1
                    get_local 2
                    get_local 5
                    i32.add
                    get_local 3
                    get_local 5
                    i32.sub
                    call $_$LT$std..io..buffered..BufWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h70007b3576305aaf
                    get_local 4
                    i32.load offset=16
                    i32.const 1
                    i32.ne
                    br_if 1 (;@7;)
                    get_local 0
                    i32.const 0
                    i32.store
                    get_local 0
                    get_local 5
                    i32.store offset=4
                    get_local 4
                    i32.load8_u offset=20
                    i32.const 2
                    i32.lt_u
                    br_if 2 (;@6;)
                    get_local 4
                    i32.const 24
                    i32.add
                    i32.load
                    tee_local 1
                    i32.load
                    get_local 1
                    i32.load offset=4
                    i32.load
                    call_indirect (type 3)
                    block  ;; label = @9
                      get_local 1
                      i32.load offset=4
                      tee_local 2
                      i32.load offset=4
                      tee_local 3
                      i32.eqz
                      br_if 0 (;@9;)
                      get_local 1
                      i32.load
                      get_local 3
                      get_local 2
                      i32.load offset=8
                      call $__rust_dealloc
                    end
                    get_local 1
                    i32.const 12
                    i32.const 4
                    call $__rust_dealloc
                    br 2 (;@6;)
                  end
                  get_local 0
                  i32.const 0
                  i32.store
                  get_local 0
                  get_local 6
                  i32.store offset=4
                  br 1 (;@6;)
                end
                get_local 0
                i32.const 0
                i32.store
                get_local 0
                get_local 4
                i32.load offset=20
                get_local 5
                i32.add
                i32.store offset=4
              end
              get_local 4
              i32.const 32
              i32.add
              set_global 0
              return
            end
            get_local 5
            get_local 3
            call $core::slice::slice_index_len_fail::h776973317ada24d7
            unreachable
          end
          get_local 1
          i32.const 13
          i32.add
          i32.const 1
          i32.store8
          i32.const 1056036
          call $core::panicking::panic::h9b4aaddfe00d4a7f
          unreachable
        end
        get_local 1
        i32.const 13
        i32.add
        i32.const 1
        i32.store8
        i32.const 1056036
        call $core::panicking::panic::h9b4aaddfe00d4a7f
        unreachable
      end
      i32.const 1056036
      call $core::panicking::panic::h9b4aaddfe00d4a7f
      unreachable
    end
    i32.const 1056036
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $std::sys_common::at_exit_imp::push::hf4ff580358497fe5 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load8_u offset=1058656
          br_if 0 (;@3;)
          i32.const 0
          i32.const 1
          i32.store8 offset=1058656
          block  ;; label = @4
            i32.const 0
            i32.load offset=1058652
            tee_local 2
            i32.const 1
            i32.eq
            br_if 0 (;@4;)
            block  ;; label = @5
              get_local 2
              br_if 0 (;@5;)
              i32.const 12
              i32.const 4
              call $__rust_alloc
              tee_local 2
              i32.eqz
              br_if 3 (;@2;)
              get_local 2
              i32.const 0
              i32.store offset=8
              get_local 2
              i64.const 4
              i64.store align=4
              i32.const 0
              get_local 2
              i32.store offset=1058652
            end
            block  ;; label = @5
              get_local 2
              i32.load offset=8
              tee_local 3
              get_local 2
              i32.load offset=4
              i32.ne
              br_if 0 (;@5;)
              get_local 2
              get_local 3
              i32.const 1
              call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve::h95549370b91dca7a
              get_local 2
              i32.const 8
              i32.add
              i32.load
              set_local 3
            end
            get_local 2
            i32.load
            get_local 3
            i32.const 3
            i32.shl
            i32.add
            tee_local 3
            get_local 1
            i32.store offset=4
            get_local 3
            get_local 0
            i32.store
            i32.const 1
            set_local 3
            get_local 2
            i32.const 8
            i32.add
            tee_local 2
            get_local 2
            i32.load
            i32.const 1
            i32.add
            i32.store
            i32.const 0
            i32.const 0
            i32.store8 offset=1058656
            br 3 (;@1;)
          end
          i32.const 0
          set_local 3
          i32.const 0
          i32.const 0
          i32.store8 offset=1058656
          get_local 0
          get_local 1
          i32.load
          call_indirect (type 3)
          get_local 1
          i32.load offset=4
          tee_local 2
          i32.eqz
          br_if 2 (;@1;)
          get_local 0
          get_local 2
          get_local 1
          i32.load offset=8
          call $__rust_dealloc
          i32.const 0
          return
        end
        i32.const 1049813
        i32.const 32
        i32.const 1056060
        call $std::panicking::begin_panic::he1c3fcf48f83642e
        unreachable
      end
      i32.const 12
      i32.const 4
      call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
      unreachable
    end
    get_local 3)
  (func $core::ptr::drop_in_place::h8c7bdd32f8c6814d (type 3) (param i32)
    (local i32 i32 i32)
    block  ;; label = @1
      i32.const 0
      br_if 0 (;@1;)
      get_local 0
      i32.load8_u offset=4
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      return
    end
    get_local 0
    i32.const 8
    i32.add
    tee_local 1
    i32.load
    tee_local 0
    i32.load
    get_local 0
    i32.load offset=4
    i32.load
    call_indirect (type 3)
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 2
      i32.load offset=4
      tee_local 3
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.load
      get_local 3
      get_local 2
      i32.load offset=8
      call $__rust_dealloc
    end
    get_local 1
    i32.load
    i32.const 12
    i32.const 4
    call $__rust_dealloc)
  (func $std::io::stdio::stdout::h7a394bc990386878 (type 1) (result i32)
    (local i32)
    block  ;; label = @1
      i32.const 1058660
      i32.const 24
      call $_$LT$std..io..lazy..Lazy$LT$T$GT$$GT$::get::h409a0e6ce3800daa
      tee_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      return
    end
    i32.const 1049861
    i32.const 36
    call $core::option::expect_failed::h0ee1e896fd083f84
    unreachable)
  (func $std::io::stdio::stdout::stdout_init::hb82f078796357a48 (type 1) (result i32)
    (local i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 0
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1024
        i32.const 1
        call $__rust_alloc
        tee_local 1
        i32.eqz
        br_if 0 (;@2;)
        get_local 0
        i32.const 10
        i32.add
        i32.const 2
        i32.add
        tee_local 2
        get_local 0
        i32.const 13
        i32.add
        i32.const 2
        i32.add
        i32.load8_u
        i32.store8
        get_local 0
        get_local 0
        i32.load16_u offset=13 align=1
        i32.store16 offset=10
        i32.const 40
        i32.const 4
        call $__rust_alloc
        tee_local 3
        i32.eqz
        br_if 1 (;@1;)
        get_local 3
        i64.const 4294967297
        i64.store align=4
        get_local 3
        i64.const 1
        i64.store offset=8 align=4
        get_local 3
        get_local 1
        i32.store offset=16
        get_local 3
        i64.const 1024
        i64.store offset=20 align=4
        get_local 3
        i32.const 0
        i32.store16 offset=28
        get_local 3
        i32.const 0
        i32.store8 offset=32
        get_local 3
        get_local 0
        i32.load16_u offset=10
        i32.store16 offset=33 align=1
        get_local 3
        i32.const 0
        i32.store8 offset=36
        get_local 3
        get_local 0
        i32.load16_u offset=7 align=1
        i32.store16 offset=37 align=1
        get_local 3
        i32.const 35
        i32.add
        get_local 2
        i32.load8_u
        i32.store8
        get_local 3
        i32.const 39
        i32.add
        get_local 0
        i32.const 7
        i32.add
        i32.const 2
        i32.add
        i32.load8_u
        i32.store8
        get_local 0
        i32.const 16
        i32.add
        set_global 0
        get_local 3
        return
      end
      i32.const 1024
      i32.const 1
      call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
      unreachable
    end
    i32.const 40
    i32.const 4
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $std::io::Write::write_all::he8d3adc3ba466ac5 (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 4
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 3
                i32.eqz
                br_if 0 (;@6;)
                get_local 4
                i32.const 8
                i32.add
                i32.const 5
                i32.or
                set_local 5
                loop  ;; label = @7
                  get_local 1
                  i32.load
                  tee_local 6
                  i32.load offset=4
                  br_if 4 (;@3;)
                  get_local 6
                  i32.const 4
                  i32.add
                  tee_local 7
                  i32.const -1
                  i32.store
                  get_local 4
                  i32.const 8
                  i32.add
                  get_local 6
                  i32.const 8
                  i32.add
                  get_local 2
                  get_local 3
                  call $_$LT$std..io..buffered..LineWriter$LT$W$GT$$u20$as$u20$std..io..Write$GT$::write::h982081d0324ec441
                  get_local 7
                  get_local 7
                  i32.load
                  i32.const 1
                  i32.add
                  i32.store
                  block  ;; label = @8
                    get_local 4
                    i32.load offset=8
                    i32.const 1
                    i32.ne
                    br_if 0 (;@8;)
                    get_local 5
                    set_local 7
                    block  ;; label = @9
                      get_local 4
                      i32.load8_u offset=12
                      tee_local 6
                      i32.const 3
                      i32.and
                      i32.const 1
                      i32.eq
                      br_if 0 (;@9;)
                      get_local 6
                      i32.const 2
                      i32.ne
                      br_if 4 (;@5;)
                      get_local 4
                      i32.const 8
                      i32.add
                      i32.const 8
                      i32.add
                      i32.load
                      i32.const 8
                      i32.add
                      set_local 7
                    end
                    get_local 7
                    i32.load8_u
                    i32.const 15
                    i32.ne
                    br_if 3 (;@5;)
                    block  ;; label = @9
                      get_local 6
                      i32.const 2
                      i32.lt_u
                      br_if 0 (;@9;)
                      get_local 4
                      i32.const 8
                      i32.add
                      i32.const 8
                      i32.add
                      i32.load
                      tee_local 6
                      i32.load
                      get_local 6
                      i32.load offset=4
                      i32.load
                      call_indirect (type 3)
                      block  ;; label = @10
                        get_local 6
                        i32.load offset=4
                        tee_local 7
                        i32.load offset=4
                        tee_local 8
                        i32.eqz
                        br_if 0 (;@10;)
                        get_local 6
                        i32.load
                        get_local 8
                        get_local 7
                        i32.load offset=8
                        call $__rust_dealloc
                      end
                      get_local 6
                      i32.const 12
                      i32.const 4
                      call $__rust_dealloc
                    end
                    get_local 3
                    br_if 1 (;@7;)
                    br 2 (;@6;)
                  end
                  get_local 4
                  i32.load offset=12
                  tee_local 6
                  i32.eqz
                  br_if 3 (;@4;)
                  get_local 3
                  get_local 6
                  i32.lt_u
                  br_if 5 (;@2;)
                  get_local 2
                  get_local 6
                  i32.add
                  set_local 2
                  get_local 3
                  get_local 6
                  i32.sub
                  tee_local 3
                  br_if 0 (;@7;)
                end
              end
              get_local 0
              i32.const 3
              i32.store8
              br 4 (;@1;)
            end
            get_local 0
            get_local 4
            i64.load offset=12 align=4
            i64.store align=4
            br 3 (;@1;)
          end
          get_local 4
          i32.const 24
          i32.add
          i32.const 14
          i32.const 1050016
          i32.const 28
          call $std::io::error::Error::new::h507e001db9edbb01
          get_local 0
          get_local 4
          i64.load offset=24
          i64.store align=4
          br 2 (;@1;)
        end
        i32.const 1049845
        i32.const 16
        call $core::result::unwrap_failed::h7a4474d5fceddfbf
        unreachable
      end
      get_local 6
      get_local 3
      call $core::slice::slice_index_order_fail::hc6db54a13869566a
      unreachable
    end
    get_local 4
    i32.const 32
    i32.add
    set_global 0)
  (func $_$LT$std..io..stdio..Stdout$u20$as$u20$std..io..Write$GT$::write_fmt::ha8a4101a34bce286 (type 4) (param i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 3
    set_global 0
    get_local 1
    i32.load
    set_local 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 0
            i32.load offset=1056316
            tee_local 5
            call_indirect (type 1)
            tee_local 1
            i32.eqz
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                get_local 1
                i32.load
                i32.const 1
                i32.ne
                br_if 0 (;@6;)
                get_local 1
                i32.const 4
                i32.add
                set_local 6
                get_local 1
                i32.load offset=4
                set_local 7
                br 1 (;@5;)
              end
              get_local 1
              i32.const 0
              i32.load offset=1056320
              call_indirect (type 1)
              tee_local 7
              i64.extend_u/i32
              i64.const 32
              i64.shl
              i64.const 1
              i64.or
              i64.store align=4
              get_local 1
              i32.const 4
              i32.add
              set_local 6
            end
            get_local 6
            get_local 7
            i32.store
            get_local 3
            get_local 4
            i32.const 8
            i32.add
            i32.store
            get_local 3
            get_local 7
            i32.const 0
            i32.ne
            i32.store8 offset=4
            get_local 3
            i32.const 3
            i32.store8 offset=12
            get_local 3
            get_local 3
            i32.store offset=8
            get_local 3
            i32.const 24
            i32.add
            i32.const 16
            i32.add
            get_local 2
            i32.const 16
            i32.add
            i64.load align=4
            i64.store
            get_local 3
            i32.const 24
            i32.add
            i32.const 8
            i32.add
            get_local 2
            i32.const 8
            i32.add
            i64.load align=4
            i64.store
            get_local 3
            get_local 2
            i64.load align=4
            i64.store offset=24
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 3
                    i32.const 8
                    i32.add
                    i32.const 1056116
                    get_local 3
                    i32.const 24
                    i32.add
                    call $core::fmt::write::hc8a86a45c34c9d88
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 3
                    i32.load8_u offset=12
                    i32.const 3
                    i32.ne
                    br_if 2 (;@6;)
                    get_local 3
                    i32.const 24
                    i32.add
                    i32.const 16
                    i32.const 1050044
                    i32.const 15
                    call $std::io::error::Error::new::h507e001db9edbb01
                    get_local 0
                    get_local 3
                    i64.load offset=24
                    i64.store align=4
                    i32.const 0
                    i32.eqz
                    br_if 1 (;@7;)
                    br 3 (;@5;)
                  end
                  get_local 0
                  i32.const 3
                  i32.store8
                  i32.const 0
                  br_if 2 (;@5;)
                end
                get_local 3
                i32.load8_u offset=12
                i32.const 2
                i32.eq
                br_if 1 (;@5;)
                get_local 3
                i32.load8_u offset=4
                br_if 4 (;@2;)
                br 3 (;@3;)
              end
              get_local 0
              get_local 3
              i64.load offset=12 align=4
              i64.store align=4
              get_local 3
              i32.load8_u offset=4
              br_if 3 (;@2;)
              br 2 (;@3;)
            end
            get_local 3
            i32.const 16
            i32.add
            tee_local 1
            i32.load
            tee_local 2
            i32.load
            get_local 2
            i32.load offset=4
            i32.load
            call_indirect (type 3)
            block  ;; label = @5
              get_local 2
              i32.load offset=4
              tee_local 7
              i32.load offset=4
              tee_local 0
              i32.eqz
              br_if 0 (;@5;)
              get_local 2
              i32.load
              get_local 0
              get_local 7
              i32.load offset=8
              call $__rust_dealloc
            end
            get_local 1
            i32.load
            i32.const 12
            i32.const 4
            call $__rust_dealloc
            get_local 3
            i32.load8_u offset=4
            br_if 2 (;@2;)
            br 1 (;@3;)
          end
          i32.const 1050406
          i32.const 57
          call $core::result::unwrap_failed::ha12182d6d2f7067c
          unreachable
        end
        get_local 3
        i32.load
        set_local 1
        get_local 5
        call_indirect (type 1)
        tee_local 2
        i32.eqz
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            get_local 2
            i32.load
            i32.const 1
            i32.ne
            br_if 0 (;@4;)
            get_local 2
            i32.const 4
            i32.add
            get_local 2
            i32.load offset=4
            tee_local 2
            i32.store
            get_local 2
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          get_local 2
          i32.const 0
          i32.load offset=1056320
          call_indirect (type 1)
          tee_local 7
          i64.extend_u/i32
          i64.const 32
          i64.shl
          i64.const 1
          i64.or
          i64.store align=4
          get_local 2
          i32.const 4
          i32.add
          get_local 7
          i32.store
          get_local 7
          i32.eqz
          br_if 1 (;@2;)
        end
        get_local 1
        i32.const 28
        i32.add
        i32.const 1
        i32.store8
      end
      get_local 3
      i32.const 48
      i32.add
      set_global 0
      return
    end
    i32.const 1050406
    i32.const 57
    call $core::result::unwrap_failed::ha12182d6d2f7067c
    unreachable)
  (func $std::io::stdio::_print::hae1d3c39a68c680a (type 3) (param i32)
    (local i32 i32 i32)
    get_global 0
    i32.const 96
    i32.sub
    tee_local 1
    set_global 0
    get_local 1
    i32.const 16
    i32.add
    get_local 0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 1
    i32.const 8
    i32.add
    get_local 0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 1
    get_local 0
    i64.load align=4
    i64.store
    get_local 1
    i32.const 1050010
    i32.store offset=32
    get_local 1
    i32.const 25
    i32.store offset=28
    get_local 1
    i32.const 6
    i32.store offset=36
    get_local 1
    i32.const 56
    i32.add
    i32.const 1056076
    get_local 1
    get_local 1
    i32.const 28
    i32.add
    call $_$LT$std..thread..local..LocalKey$LT$T$GT$$GT$::try_with::h3c7de852b216facd
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 1
          i32.load8_u offset=56
          i32.const 4
          i32.ne
          br_if 0 (;@3;)
          i32.const 1058660
          i32.const 24
          call $_$LT$std..io..lazy..Lazy$LT$T$GT$$GT$::get::h409a0e6ce3800daa
          tee_local 0
          i32.eqz
          br_if 2 (;@1;)
          get_local 1
          get_local 0
          i32.store offset=48
          get_local 1
          i32.const 72
          i32.add
          i32.const 16
          i32.add
          get_local 1
          i32.const 16
          i32.add
          i64.load
          i64.store
          get_local 1
          i32.const 72
          i32.add
          i32.const 8
          i32.add
          get_local 1
          i32.const 8
          i32.add
          i64.load
          i64.store
          get_local 1
          get_local 1
          i64.load
          i64.store offset=72
          get_local 1
          i32.const 40
          i32.add
          get_local 1
          i32.const 48
          i32.add
          get_local 1
          i32.const 72
          i32.add
          call $_$LT$std..io..stdio..Stdout$u20$as$u20$std..io..Write$GT$::write_fmt::ha8a4101a34bce286
          get_local 0
          get_local 0
          i32.load
          tee_local 2
          i32.const -1
          i32.add
          i32.store
          block  ;; label = @4
            get_local 2
            i32.const 1
            i32.ne
            br_if 0 (;@4;)
            get_local 1
            i32.const 48
            i32.add
            call $_$LT$alloc..sync..Arc$LT$T$GT$$GT$::drop_slow::hedbbe9076b8173b2
          end
          block  ;; label = @4
            get_local 1
            i32.load8_u offset=56
            tee_local 0
            i32.const 7
            i32.and
            i32.const 4
            i32.gt_u
            br_if 0 (;@4;)
            get_local 0
            i32.const 2
            i32.ne
            br_if 2 (;@2;)
          end
          get_local 1
          i32.load offset=60
          tee_local 0
          i32.load
          get_local 0
          i32.load offset=4
          i32.load
          call_indirect (type 3)
          block  ;; label = @4
            get_local 0
            i32.load offset=4
            tee_local 2
            i32.load offset=4
            tee_local 3
            i32.eqz
            br_if 0 (;@4;)
            get_local 0
            i32.load
            get_local 3
            get_local 2
            i32.load offset=8
            call $__rust_dealloc
          end
          get_local 0
          i32.const 12
          i32.const 4
          call $__rust_dealloc
          br 1 (;@2;)
        end
        get_local 1
        get_local 1
        i64.load offset=56
        i64.store offset=40
      end
      block  ;; label = @2
        get_local 1
        i32.load8_u offset=40
        i32.const 3
        i32.ne
        br_if 0 (;@2;)
        get_local 1
        i32.const 96
        i32.add
        set_global 0
        return
      end
      get_local 1
      get_local 1
      i64.load offset=40
      i64.store offset=48
      get_local 1
      i32.const 56
      i32.add
      i32.const 12
      i32.add
      i32.const 26
      i32.store
      get_local 1
      i32.const 72
      i32.add
      i32.const 12
      i32.add
      i32.const 2
      i32.store
      get_local 1
      i32.const 92
      i32.add
      i32.const 2
      i32.store
      get_local 1
      i32.const 6
      i32.store offset=60
      get_local 1
      i32.const 1056084
      i32.store offset=72
      get_local 1
      i32.const 2
      i32.store offset=76
      get_local 1
      i32.const 1049920
      i32.store offset=80
      get_local 1
      get_local 1
      i32.const 32
      i32.add
      i32.store offset=56
      get_local 1
      get_local 1
      i32.const 48
      i32.add
      i32.store offset=64
      get_local 1
      get_local 1
      i32.const 56
      i32.add
      i32.store offset=88
      get_local 1
      i32.const 72
      i32.add
      i32.const 1056100
      call $std::panicking::begin_panic_fmt::h27366d395d0e5753
      unreachable
    end
    i32.const 1049861
    i32.const 36
    call $core::option::expect_failed::h0ee1e896fd083f84
    unreachable)
  (func $std::io::stdio::LOCAL_STDOUT::__init::h94c1be4df9250ab3 (type 3) (param i32)
    get_local 0
    i64.const 0
    i64.store align=4)
  (func $std::io::stdio::LOCAL_STDOUT::__getit::hd86edd9cc0822ea6 (type 1) (result i32)
    i32.const 1058668)
  (func $core::fmt::Write::write_char::h08406ae678520f2d (type 0) (param i32 i32) (result i32)
    (local i32 i64 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 0
    i32.store offset=4
    block  ;; label = @1
      block  ;; label = @2
        get_local 1
        i32.const 127
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.store8 offset=4
        i32.const 1
        set_local 1
        br 1 (;@1;)
      end
      block  ;; label = @2
        get_local 1
        i32.const 2047
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=5
        get_local 2
        get_local 1
        i32.const 6
        i32.shr_u
        i32.const 31
        i32.and
        i32.const 192
        i32.or
        i32.store8 offset=4
        i32.const 2
        set_local 1
        br 1 (;@1;)
      end
      block  ;; label = @2
        get_local 1
        i32.const 65535
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=6
        get_local 2
        get_local 1
        i32.const 6
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=5
        get_local 2
        get_local 1
        i32.const 12
        i32.shr_u
        i32.const 15
        i32.and
        i32.const 224
        i32.or
        i32.store8 offset=4
        i32.const 3
        set_local 1
        br 1 (;@1;)
      end
      get_local 2
      get_local 1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=4
      get_local 2
      get_local 1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=7
      get_local 2
      get_local 1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=5
      get_local 2
      get_local 1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=6
      i32.const 4
      set_local 1
    end
    get_local 2
    i32.const 8
    i32.add
    get_local 0
    i32.load
    get_local 2
    i32.const 4
    i32.add
    get_local 1
    call $std::io::Write::write_all::he8d3adc3ba466ac5
    i32.const 0
    set_local 1
    block  ;; label = @1
      get_local 2
      i32.load8_u offset=8
      i32.const 3
      i32.eq
      br_if 0 (;@1;)
      get_local 2
      i64.load offset=8
      set_local 3
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          br_if 0 (;@3;)
          get_local 0
          i32.load8_u offset=4
          i32.const 2
          i32.ne
          br_if 1 (;@2;)
        end
        get_local 0
        i32.const 8
        i32.add
        tee_local 4
        i32.load
        tee_local 1
        i32.load
        get_local 1
        i32.load offset=4
        i32.load
        call_indirect (type 3)
        block  ;; label = @3
          get_local 1
          i32.load offset=4
          tee_local 5
          i32.load offset=4
          tee_local 6
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          i32.load
          get_local 6
          get_local 5
          i32.load offset=8
          call $__rust_dealloc
        end
        get_local 4
        i32.load
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      get_local 0
      i32.const 4
      i32.add
      get_local 3
      i64.store align=4
      i32.const 1
      set_local 1
    end
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $core::fmt::Write::write_fmt::h47ad4410c998f2f4 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 0
    i32.store offset=4
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 2
    i32.const 4
    i32.add
    i32.const 1056140
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $core::ptr::drop_in_place::h0de34b0aedc80776 (type 3) (param i32))
  (func $_$LT$std..io..Write..write_fmt..Adaptor$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h9cb7ff25da07d5f0 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i64 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    i32.const 8
    i32.add
    get_local 0
    i32.load
    get_local 1
    get_local 2
    call $std::io::Write::write_all::he8d3adc3ba466ac5
    i32.const 0
    set_local 1
    block  ;; label = @1
      get_local 3
      i32.load8_u offset=8
      i32.const 3
      i32.eq
      br_if 0 (;@1;)
      get_local 3
      i64.load offset=8
      set_local 4
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          br_if 0 (;@3;)
          get_local 0
          i32.load8_u offset=4
          i32.const 2
          i32.ne
          br_if 1 (;@2;)
        end
        get_local 0
        i32.const 8
        i32.add
        tee_local 2
        i32.load
        tee_local 1
        i32.load
        get_local 1
        i32.load offset=4
        i32.load
        call_indirect (type 3)
        block  ;; label = @3
          get_local 1
          i32.load offset=4
          tee_local 5
          i32.load offset=4
          tee_local 6
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          i32.load
          get_local 6
          get_local 5
          i32.load offset=8
          call $__rust_dealloc
        end
        get_local 2
        i32.load
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      get_local 0
      i32.const 4
      i32.add
      get_local 4
      i64.store align=4
      i32.const 1
      set_local 1
    end
    get_local 3
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $core::slice::_$LT$impl$u20$$u5b$T$u5d$$GT$::copy_from_slice::h627e58fe641268f4 (type 9) (param i32 i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 96
    i32.sub
    tee_local 4
    set_global 0
    get_local 4
    get_local 1
    i32.store offset=8
    get_local 4
    get_local 3
    i32.store offset=12
    get_local 4
    get_local 4
    i32.const 8
    i32.add
    i32.store offset=16
    get_local 4
    get_local 4
    i32.const 12
    i32.add
    i32.store offset=20
    block  ;; label = @1
      get_local 1
      get_local 3
      i32.ne
      br_if 0 (;@1;)
      get_local 0
      get_local 2
      get_local 1
      call $memcpy
      drop
      get_local 4
      i32.const 96
      i32.add
      set_global 0
      return
    end
    get_local 4
    i32.const 72
    i32.add
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    get_local 4
    i32.const 48
    i32.add
    i32.const 12
    i32.add
    i32.const 37
    i32.store
    get_local 4
    i32.const 48
    i32.add
    i32.const 20
    i32.add
    i32.const 38
    i32.store
    get_local 4
    i32.const 24
    i32.add
    i32.const 12
    i32.add
    i32.const 3
    i32.store
    get_local 4
    i32.const 24
    i32.add
    i32.const 20
    i32.add
    i32.const 3
    i32.store
    get_local 4
    i32.const 1056188
    i32.store offset=72
    get_local 4
    i64.const 1
    i64.store offset=76 align=4
    get_local 4
    i32.const 1050172
    i32.store offset=88
    get_local 4
    i32.const 37
    i32.store offset=52
    get_local 4
    i32.const 1056164
    i32.store offset=24
    get_local 4
    i32.const 3
    i32.store offset=28
    get_local 4
    i32.const 1050172
    i32.store offset=32
    get_local 4
    get_local 4
    i32.const 16
    i32.add
    i32.store offset=48
    get_local 4
    get_local 4
    i32.const 20
    i32.add
    i32.store offset=56
    get_local 4
    get_local 4
    i32.const 72
    i32.add
    i32.store offset=64
    get_local 4
    get_local 4
    i32.const 48
    i32.add
    i32.store offset=40
    get_local 4
    i32.const 24
    i32.add
    i32.const 1056196
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::h9d40d70d7b21b15b (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    set_local 0
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_lower_hex::h92753715ffe745e5
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$usize$GT$::fmt::hd9abdaddf8084036
      return
    end
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_upper_hex::h872e32477651ad01
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$usize$GT$::fmt::h7c305e4bc8e93fb6
      return
    end
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::h2a55ae0011bb0dc7 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=4
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Display$GT$::fmt::h1f20bf1bdcce3a04)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h5e851b0b920c40fb (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 1
    call $core::fmt::Write::write_char::h08406ae678520f2d)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h8e59789c90076a59 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 0
    i32.load
    set_local 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 1
                i32.const 128
                i32.ge_u
                br_if 0 (;@6;)
                block  ;; label = @7
                  get_local 0
                  i32.load offset=8
                  tee_local 3
                  get_local 0
                  i32.load offset=4
                  i32.ne
                  br_if 0 (;@7;)
                  get_local 0
                  get_local 3
                  i32.const 1
                  i32.const 1
                  call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h7d8dbe5a24e1e982__.llvm.5600775270182012462_
                  tee_local 3
                  i32.const 255
                  i32.and
                  i32.const 2
                  i32.ne
                  br_if 4 (;@3;)
                  get_local 0
                  i32.const 8
                  i32.add
                  i32.load
                  set_local 3
                end
                get_local 0
                i32.load
                get_local 3
                i32.add
                get_local 1
                i32.store8
                get_local 0
                i32.const 8
                i32.add
                tee_local 0
                get_local 0
                i32.load
                i32.const 1
                i32.add
                i32.store
                br 1 (;@5;)
              end
              get_local 2
              i32.const 0
              i32.store offset=12
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.const 2048
                  i32.ge_u
                  br_if 0 (;@7;)
                  get_local 2
                  get_local 1
                  i32.const 63
                  i32.and
                  i32.const 128
                  i32.or
                  i32.store8 offset=13
                  get_local 2
                  get_local 1
                  i32.const 6
                  i32.shr_u
                  i32.const 31
                  i32.and
                  i32.const 192
                  i32.or
                  i32.store8 offset=12
                  i32.const 2
                  set_local 1
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  get_local 1
                  i32.const 65535
                  i32.gt_u
                  br_if 0 (;@7;)
                  get_local 2
                  get_local 1
                  i32.const 63
                  i32.and
                  i32.const 128
                  i32.or
                  i32.store8 offset=14
                  get_local 2
                  get_local 1
                  i32.const 6
                  i32.shr_u
                  i32.const 63
                  i32.and
                  i32.const 128
                  i32.or
                  i32.store8 offset=13
                  get_local 2
                  get_local 1
                  i32.const 12
                  i32.shr_u
                  i32.const 15
                  i32.and
                  i32.const 224
                  i32.or
                  i32.store8 offset=12
                  i32.const 3
                  set_local 1
                  br 1 (;@6;)
                end
                get_local 2
                get_local 1
                i32.const 18
                i32.shr_u
                i32.const 240
                i32.or
                i32.store8 offset=12
                get_local 2
                get_local 1
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=15
                get_local 2
                get_local 1
                i32.const 12
                i32.shr_u
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=13
                get_local 2
                get_local 1
                i32.const 6
                i32.shr_u
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=14
                i32.const 4
                set_local 1
              end
              get_local 0
              get_local 0
              i32.load offset=8
              get_local 1
              i32.const 1
              call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h7d8dbe5a24e1e982__.llvm.5600775270182012462_
              tee_local 3
              i32.const 255
              i32.and
              i32.const 2
              i32.ne
              br_if 1 (;@4;)
              get_local 0
              i32.const 8
              i32.add
              tee_local 3
              get_local 3
              i32.load
              tee_local 3
              get_local 1
              i32.add
              i32.store
              get_local 3
              get_local 0
              i32.load
              i32.add
              get_local 1
              get_local 2
              i32.const 12
              i32.add
              get_local 1
              call $core::slice::_$LT$impl$u20$$u5b$T$u5d$$GT$::copy_from_slice::h627e58fe641268f4
            end
            get_local 2
            i32.const 16
            i32.add
            set_global 0
            i32.const 0
            return
          end
          get_local 3
          i32.const 1
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          i32.const 1055980
          call $core::panicking::panic::h9b4aaddfe00d4a7f
          unreachable
        end
        get_local 3
        i32.const 1
        i32.and
        br_if 1 (;@1;)
      end
      call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
      unreachable
    end
    i32.const 1055980
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::h05b6a806ce25ddb7 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 0
    i32.load
    i32.store offset=4
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 2
    i32.const 4
    i32.add
    i32.const 1056140
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::h232d2e9c1bb9d6d7 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 0
    i32.load
    i32.store offset=4
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 2
    i32.const 4
    i32.add
    i32.const 1056236
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h19f8ffc5c07cfa34 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i64 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    i32.const 8
    i32.add
    get_local 0
    i32.load
    tee_local 0
    i32.load
    get_local 1
    get_local 2
    call $std::io::Write::write_all::he8d3adc3ba466ac5
    i32.const 0
    set_local 1
    block  ;; label = @1
      get_local 3
      i32.load8_u offset=8
      i32.const 3
      i32.eq
      br_if 0 (;@1;)
      get_local 3
      i64.load offset=8
      set_local 4
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          br_if 0 (;@3;)
          get_local 0
          i32.load8_u offset=4
          i32.const 2
          i32.ne
          br_if 1 (;@2;)
        end
        get_local 0
        i32.const 8
        i32.add
        tee_local 2
        i32.load
        tee_local 1
        i32.load
        get_local 1
        i32.load offset=4
        i32.load
        call_indirect (type 3)
        block  ;; label = @3
          get_local 1
          i32.load offset=4
          tee_local 5
          i32.load offset=4
          tee_local 6
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          i32.load
          get_local 6
          get_local 5
          i32.load offset=8
          call $__rust_dealloc
        end
        get_local 2
        i32.load
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      get_local 0
      i32.const 4
      i32.add
      get_local 4
      i64.store align=4
      i32.const 1
      set_local 1
    end
    get_local 3
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hdac212800cc7ae5b (type 5) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      get_local 0
      i32.load
      tee_local 0
      get_local 0
      i32.load offset=8
      get_local 2
      i32.const 1
      call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h7d8dbe5a24e1e982__.llvm.5600775270182012462_
      tee_local 3
      i32.const 255
      i32.and
      i32.const 2
      i32.ne
      br_if 0 (;@1;)
      get_local 0
      i32.const 8
      i32.add
      tee_local 3
      get_local 3
      i32.load
      tee_local 3
      get_local 2
      i32.add
      i32.store
      get_local 3
      get_local 0
      i32.load
      i32.add
      get_local 2
      get_local 1
      get_local 2
      call $core::slice::_$LT$impl$u20$$u5b$T$u5d$$GT$::copy_from_slice::h627e58fe641268f4
      i32.const 0
      return
    end
    block  ;; label = @1
      get_local 3
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
      unreachable
    end
    i32.const 1055980
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$std..thread..local..AccessError$u20$as$u20$core..fmt..Debug$GT$::fmt::hd51ae23e44471b04 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 8
    i32.add
    get_local 1
    i32.const 1050395
    i32.const 11
    call $core::fmt::Formatter::debug_struct::h52478105236d4ae6
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::builders::DebugStruct::finish::h3dd8d635d04004d8
    set_local 1
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $_$LT$std..thread..local..LocalKey$LT$T$GT$$GT$::try_with::h3c7de852b216facd (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 4
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.load
                  call_indirect (type 1)
                  tee_local 5
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 5
                  i32.load
                  i32.const 1
                  i32.ne
                  br_if 1 (;@6;)
                  get_local 5
                  i32.const 4
                  i32.add
                  tee_local 1
                  i32.load
                  br_if 3 (;@4;)
                  br 2 (;@5;)
                end
                get_local 0
                i32.const 4
                i32.store8
                br 4 (;@2;)
              end
              get_local 4
              i32.const 24
              i32.add
              get_local 1
              i32.load offset=4
              call_indirect (type 3)
              get_local 5
              i32.load
              set_local 6
              get_local 5
              i32.const 1
              i32.store
              get_local 5
              get_local 4
              i32.load offset=24
              i32.store offset=4
              get_local 5
              i32.load offset=12
              set_local 7
              get_local 5
              i32.load offset=8
              set_local 1
              get_local 5
              get_local 4
              i64.load offset=28 align=4
              i64.store offset=8 align=4
              block  ;; label = @6
                get_local 6
                i32.eqz
                br_if 0 (;@6;)
                get_local 1
                i32.eqz
                br_if 0 (;@6;)
                get_local 1
                get_local 7
                i32.load
                call_indirect (type 3)
                get_local 7
                i32.load offset=4
                tee_local 6
                i32.eqz
                br_if 0 (;@6;)
                get_local 1
                get_local 6
                get_local 7
                i32.load offset=8
                call $__rust_dealloc
              end
              get_local 5
              i32.load
              i32.const 1
              i32.ne
              br_if 4 (;@1;)
              get_local 5
              i32.const 4
              i32.add
              tee_local 1
              i32.load
              br_if 1 (;@4;)
            end
            get_local 5
            i32.const 4
            i32.add
            tee_local 7
            i32.const -1
            i32.store
            block  ;; label = @5
              get_local 5
              i32.load offset=8
              tee_local 6
              i32.eqz
              br_if 0 (;@5;)
              get_local 5
              i32.load offset=12
              set_local 5
              get_local 4
              i32.const 24
              i32.add
              i32.const 16
              i32.add
              get_local 2
              i32.const 16
              i32.add
              i64.load align=4
              i64.store
              get_local 4
              i32.const 24
              i32.add
              i32.const 8
              i32.add
              get_local 2
              i32.const 8
              i32.add
              i64.load align=4
              i64.store
              get_local 4
              get_local 2
              i64.load align=4
              i64.store offset=24
              get_local 4
              i32.const 8
              i32.add
              get_local 6
              get_local 4
              i32.const 24
              i32.add
              get_local 5
              i32.load offset=24
              call_indirect (type 4)
              get_local 7
              get_local 7
              i32.load
              i32.const 1
              i32.add
              i32.store
              br 2 (;@3;)
            end
            get_local 1
            i32.const 0
            i32.store
          end
          get_local 4
          get_local 3
          i32.load
          call_indirect (type 1)
          i32.store offset=20
          get_local 4
          i32.const 24
          i32.add
          i32.const 16
          i32.add
          get_local 2
          i32.const 16
          i32.add
          i64.load align=4
          i64.store
          get_local 4
          i32.const 24
          i32.add
          i32.const 8
          i32.add
          get_local 2
          i32.const 8
          i32.add
          i64.load align=4
          i64.store
          get_local 4
          get_local 2
          i64.load align=4
          i64.store offset=24
          get_local 4
          i32.const 8
          i32.add
          get_local 4
          i32.const 20
          i32.add
          get_local 4
          i32.const 24
          i32.add
          call $_$LT$std..io..stdio..Stdout$u20$as$u20$std..io..Write$GT$::write_fmt::ha8a4101a34bce286
          get_local 4
          i32.load offset=20
          tee_local 5
          get_local 5
          i32.load
          tee_local 5
          i32.const -1
          i32.add
          i32.store
          get_local 5
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          get_local 4
          i32.const 20
          i32.add
          call $_$LT$alloc..sync..Arc$LT$T$GT$$GT$::drop_slow::hedbbe9076b8173b2
        end
        get_local 0
        get_local 4
        i64.load offset=8
        i64.store align=4
      end
      get_local 4
      i32.const 48
      i32.add
      set_global 0
      return
    end
    i32.const 1056212
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$alloc..sync..Arc$LT$T$GT$$GT$::drop_slow::hedbbe9076b8173b2 (type 3) (param i32)
    (local i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 1
    set_global 0
    get_local 0
    i32.load
    tee_local 2
    i32.const 16
    i32.add
    set_local 3
    block  ;; label = @1
      get_local 2
      i32.const 28
      i32.add
      i32.load8_u
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      get_local 2
      i32.const 29
      i32.add
      i32.load8_u
      br_if 0 (;@1;)
      get_local 1
      i32.const 8
      i32.add
      get_local 3
      call $_$LT$std..io..buffered..BufWriter$LT$W$GT$$GT$::flush_buf::h034b4ff4b1f9df38__.llvm.10348248634257366068_
      block  ;; label = @2
        i32.const 0
        br_if 0 (;@2;)
        get_local 1
        i32.load8_u offset=8
        i32.const 2
        i32.ne
        br_if 1 (;@1;)
      end
      get_local 1
      i32.load offset=12
      tee_local 4
      i32.load
      get_local 4
      i32.load offset=4
      i32.load
      call_indirect (type 3)
      block  ;; label = @2
        get_local 4
        i32.load offset=4
        tee_local 5
        i32.load offset=4
        tee_local 6
        i32.eqz
        br_if 0 (;@2;)
        get_local 4
        i32.load
        get_local 6
        get_local 5
        i32.load offset=8
        call $__rust_dealloc
      end
      get_local 4
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end
    block  ;; label = @1
      get_local 2
      i32.const 20
      i32.add
      i32.load
      tee_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 3
      i32.load
      get_local 2
      i32.const 1
      call $__rust_dealloc
    end
    get_local 0
    i32.load
    tee_local 2
    get_local 2
    i32.load offset=4
    tee_local 2
    i32.const -1
    i32.add
    i32.store offset=4
    block  ;; label = @1
      get_local 2
      i32.const 1
      i32.ne
      br_if 0 (;@1;)
      get_local 0
      i32.load
      i32.const 40
      i32.const 4
      call $__rust_dealloc
    end
    get_local 1
    i32.const 16
    i32.add
    set_global 0)
  (func $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h358447a6533dac2f (type 8) (param i32) (result i64)
    i64.const -4572523988785928430)
  (func $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h740591e78f6d2d59 (type 8) (param i32) (result i64)
    i64.const 4215341673387304881)
  (func $core::ptr::drop_in_place::h050223db4f2f03cc (type 3) (param i32))
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::he35686c8c6e5facb (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    tee_local 0
    i32.load
    get_local 0
    i32.load offset=8
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Debug$GT$::fmt::hd2afc455f5f6b65c)
  (func $std::sys_common::util::dumb_print::h16349c6eb68bcf3a (type 3) (param i32))
  (func $std::sys_common::util::abort::h2876ede54453dc3a (type 3) (param i32)
    unreachable
    unreachable)
  (func $std::env::current_dir::hc52d4032924dd87f (type 3) (param i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 1
    set_global 0
    get_local 1
    i32.const 8
    i32.add
    i32.const 16
    i32.const 1050300
    i32.const 35
    call $std::io::error::Error::new::h507e001db9edbb01
    get_local 0
    i32.const 1
    i32.store
    get_local 0
    get_local 1
    i64.load offset=8
    i64.store offset=4 align=4
    get_local 1
    i32.const 16
    i32.add
    set_global 0)
  (func $__rdl_alloc (type 0) (param i32 i32) (result i32)
    block  ;; label = @1
      i32.const 1058704
      call $dlmalloc::dlmalloc::Dlmalloc::malloc_alignment::ha71f1d16dd31f1a3
      get_local 1
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 1058704
      get_local 1
      get_local 0
      call $dlmalloc::dlmalloc::Dlmalloc::memalign::hc38379e02a35d971
      return
    end
    i32.const 1058704
    get_local 0
    call $dlmalloc::dlmalloc::Dlmalloc::malloc::hc4b4efc85b47ad98)
  (func $__rdl_dealloc (type 4) (param i32 i32 i32)
    i32.const 1058704
    get_local 0
    call $dlmalloc::dlmalloc::Dlmalloc::free::h0d2004392fdc1454)
  (func $__rdl_realloc (type 7) (param i32 i32 i32 i32) (result i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 1058704
            call $dlmalloc::dlmalloc::Dlmalloc::malloc_alignment::ha71f1d16dd31f1a3
            get_local 2
            i32.ge_u
            br_if 0 (;@4;)
            i32.const 1058704
            call $dlmalloc::dlmalloc::Dlmalloc::malloc_alignment::ha71f1d16dd31f1a3
            get_local 2
            i32.ge_u
            br_if 1 (;@3;)
            i32.const 1058704
            get_local 2
            get_local 3
            call $dlmalloc::dlmalloc::Dlmalloc::memalign::hc38379e02a35d971
            tee_local 2
            i32.eqz
            br_if 2 (;@2;)
            br 3 (;@1;)
          end
          i32.const 1058704
          get_local 0
          get_local 3
          call $dlmalloc::dlmalloc::Dlmalloc::realloc::h8cf6613b53581308
          return
        end
        i32.const 1058704
        get_local 3
        call $dlmalloc::dlmalloc::Dlmalloc::malloc::hc4b4efc85b47ad98
        tee_local 2
        br_if 1 (;@1;)
      end
      i32.const 0
      return
    end
    get_local 2
    get_local 0
    get_local 3
    get_local 1
    get_local 1
    get_local 3
    i32.gt_u
    select
    call $memcpy
    set_local 2
    i32.const 1058704
    get_local 0
    call $dlmalloc::dlmalloc::Dlmalloc::free::h0d2004392fdc1454
    get_local 2)
  (func $_$LT$core..option..Option$LT$T$GT$$GT$::unwrap::h7cfd60b0425d4355 (type 10) (param i32) (result i32)
    block  ;; label = @1
      get_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      return
    end
    i32.const 1056260
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$core..option..Option$LT$T$GT$$GT$::unwrap::h9f18e7a434a3be26 (type 10) (param i32) (result i32)
    block  ;; label = @1
      get_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      return
    end
    i32.const 1056260
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $core::ptr::drop_in_place::h07afdff9e8d2c6fa (type 3) (param i32))
  (func $core::ptr::drop_in_place::h3a08d5b0bfab5fda (type 3) (param i32)
    (local i32)
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.const 8
      i32.add
      i32.load
      tee_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      get_local 0
      i32.const 1
      call $__rust_dealloc
    end)
  (func $core::ptr::drop_in_place::h80e2533b22b5a3bf.1 (type 3) (param i32)
    (local i32)
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.load
      get_local 1
      i32.const 1
      call $__rust_dealloc
    end)
  (func $std::error::Error::cause::h92ea54f2367adbb6 (type 2) (param i32 i32)
    get_local 0
    i32.const 0
    i32.store)
  (func $std::error::Error::source::h251fc175156920a2 (type 2) (param i32 i32)
    get_local 0
    i32.const 0
    i32.store)
  (func $std::error::Error::type_id::h71d516fe603cd5ee (type 8) (param i32) (result i64)
    i64.const 2327175136055885134)
  (func $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$std..error..Error$GT$::description::ha8c9d55be0fd6129 (type 2) (param i32 i32)
    get_local 0
    get_local 1
    i32.load offset=8
    i32.store offset=4
    get_local 0
    get_local 1
    i32.load
    i32.store)
  (func $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$core..fmt..Display$GT$::fmt::h3176359b64c8ce76 (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=8
    get_local 1
    call $_$LT$str$u20$as$u20$core..fmt..Display$GT$::fmt::h1f20bf1bdcce3a04)
  (func $std::panicking::begin_panic::he1c3fcf48f83642e (type 4) (param i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    get_local 1
    i32.store offset=12
    get_local 3
    get_local 0
    i32.store offset=8
    get_local 3
    i32.const 8
    i32.add
    i32.const 1056360
    i32.const 0
    get_local 2
    call $std::panicking::rust_panic_with_hook::h4410f497acb60032
    unreachable)
  (func $std::panicking::begin_panic_fmt::h27366d395d0e5753 (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 32
    i32.add
    get_local 1
    i32.load
    get_local 1
    i32.load offset=4
    get_local 1
    i32.load offset=8
    get_local 1
    i32.load offset=12
    call $core::panic::Location::internal_constructor::haae95faa9a5f046b
    get_local 2
    i32.const 20
    i32.add
    get_local 2
    i32.const 40
    i32.add
    i64.load
    i64.store align=4
    get_local 2
    i32.const 1056284
    i32.store offset=4
    get_local 2
    i32.const 1050524
    i32.store
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    get_local 2
    i64.load offset=32
    i64.store offset=12 align=4
    get_local 2
    call $std::panicking::continue_panic_fmt::hb6ae0abd112a2b38
    unreachable)
  (func $rust_begin_unwind (type 3) (param i32)
    get_local 0
    call $std::panicking::continue_panic_fmt::hb6ae0abd112a2b38
    unreachable)
  (func $std::panicking::continue_panic_fmt::hb6ae0abd112a2b38 (type 3) (param i32)
    (local i32 i32 i32 i64 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 1
    set_global 0
    get_local 0
    call $core::panic::PanicInfo::location::h420838d3cb8d7c08
    call $_$LT$core..option..Option$LT$T$GT$$GT$::unwrap::h7cfd60b0425d4355
    set_local 2
    get_local 0
    call $core::panic::PanicInfo::message::h0efc9203d9a8183a
    call $_$LT$core..option..Option$LT$T$GT$$GT$::unwrap::h9f18e7a434a3be26
    set_local 3
    get_local 1
    i32.const 8
    i32.add
    get_local 2
    call $core::panic::Location::file::ha94f8b63a2f463dd
    get_local 1
    i64.load offset=8
    set_local 4
    get_local 2
    call $core::panic::Location::line::h7b805301c6ddc4c3
    set_local 5
    get_local 2
    call $core::panic::Location::column::h5635ec1f41441840
    set_local 2
    get_local 1
    get_local 4
    i64.store offset=16
    get_local 1
    get_local 5
    i32.store offset=24
    get_local 1
    get_local 2
    i32.store offset=28
    get_local 1
    i32.const 0
    i32.store offset=36
    get_local 1
    get_local 3
    i32.store offset=32
    get_local 1
    i32.const 32
    i32.add
    i32.const 1056324
    get_local 0
    call $core::panic::PanicInfo::message::h0efc9203d9a8183a
    get_local 1
    i32.const 16
    i32.add
    call $std::panicking::rust_panic_with_hook::h4410f497acb60032
    unreachable)
  (func $std::panicking::rust_panic_with_hook::h4410f497acb60032 (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 4
    set_global 0
    i32.const 1
    set_local 5
    get_local 3
    i32.load offset=12
    set_local 6
    get_local 3
    i32.load offset=8
    set_local 7
    get_local 3
    i32.load offset=4
    set_local 8
    get_local 3
    i32.load
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load offset=1058696
        i32.const 1
        i32.ne
        br_if 0 (;@2;)
        i32.const 0
        i32.const 0
        i32.load offset=1058700
        i32.const 1
        i32.add
        tee_local 5
        i32.store offset=1058700
        get_local 5
        i32.const 3
        i32.lt_u
        br_if 1 (;@1;)
        get_local 4
        i32.const 28
        i32.add
        i32.const 0
        i32.store
        get_local 4
        i32.const 1056412
        i32.store offset=8
        get_local 4
        i64.const 1
        i64.store offset=12 align=4
        get_local 4
        i32.const 1050524
        i32.store offset=24
        get_local 4
        i32.const 8
        i32.add
        call $std::sys_common::util::dumb_print::h16349c6eb68bcf3a
        unreachable
        unreachable
      end
      i32.const 0
      i64.const 4294967297
      i64.store offset=1058696
    end
    get_local 4
    i32.const 40
    i32.add
    get_local 3
    get_local 8
    get_local 7
    get_local 6
    call $core::panic::Location::internal_constructor::haae95faa9a5f046b
    get_local 4
    i32.const 8
    i32.add
    i32.const 20
    i32.add
    get_local 4
    i32.const 48
    i32.add
    i64.load
    i64.store align=4
    get_local 4
    i32.const 1056284
    i32.store offset=12
    get_local 4
    i32.const 1050524
    i32.store offset=8
    get_local 4
    get_local 2
    i32.store offset=16
    get_local 4
    get_local 4
    i64.load offset=40
    i64.store offset=20 align=4
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load offset=1058684
        tee_local 3
        i32.const -1
        i32.le_s
        br_if 0 (;@2;)
        i32.const 0
        get_local 3
        i32.const 1
        i32.add
        tee_local 3
        i32.store offset=1058684
        block  ;; label = @3
          i32.const 0
          i32.load offset=1058692
          tee_local 2
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          i32.load offset=1058688
          set_local 3
          get_local 4
          get_local 0
          get_local 1
          i32.load offset=16
          call_indirect (type 2)
          get_local 4
          get_local 4
          i64.load
          i64.store offset=8
          get_local 3
          get_local 4
          i32.const 8
          i32.add
          get_local 2
          i32.load offset=12
          call_indirect (type 2)
          i32.const 0
          i32.load offset=1058684
          set_local 3
        end
        i32.const 0
        get_local 3
        i32.const -1
        i32.add
        i32.store offset=1058684
        get_local 5
        i32.const 2
        i32.lt_u
        br_if 1 (;@1;)
        get_local 4
        i32.const 28
        i32.add
        i32.const 0
        i32.store
        get_local 4
        i32.const 1056420
        i32.store offset=8
        get_local 4
        i64.const 1
        i64.store offset=12 align=4
        get_local 4
        i32.const 1050524
        i32.store offset=24
        get_local 4
        i32.const 8
        i32.add
        call $std::sys_common::util::dumb_print::h16349c6eb68bcf3a
        unreachable
        unreachable
      end
      get_local 4
      i32.const 40
      i32.add
      i32.const 20
      i32.add
      i32.const 0
      i32.store
      get_local 4
      i32.const 1056452
      i32.store offset=40
      get_local 4
      i64.const 1
      i64.store offset=44 align=4
      get_local 4
      i32.const 1050524
      i32.store offset=56
      get_local 4
      i32.const 40
      i32.add
      call $std::sys_common::util::abort::h2876ede54453dc3a
      unreachable
    end
    get_local 0
    get_local 1
    call $rust_panic
    unreachable)
  (func $_$LT$std..panicking..continue_panic_fmt..PanicPayload$LT$$u27$a$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::box_me_up::h0f1df4ec4b1fb14a (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      get_local 1
      i32.load offset=4
      tee_local 3
      br_if 0 (;@1;)
      get_local 1
      i32.load
      set_local 3
      get_local 2
      i32.const 0
      i32.store offset=16
      get_local 2
      i64.const 1
      i64.store offset=8
      get_local 2
      get_local 2
      i32.const 8
      i32.add
      i32.store offset=20
      get_local 2
      i32.const 24
      i32.add
      i32.const 16
      i32.add
      get_local 3
      i32.const 16
      i32.add
      i64.load align=4
      i64.store
      get_local 2
      i32.const 24
      i32.add
      i32.const 8
      i32.add
      tee_local 4
      get_local 3
      i32.const 8
      i32.add
      i64.load align=4
      i64.store
      get_local 2
      get_local 3
      i64.load align=4
      i64.store offset=24
      get_local 2
      i32.const 20
      i32.add
      i32.const 1056236
      get_local 2
      i32.const 24
      i32.add
      call $core::fmt::write::hc8a86a45c34c9d88
      drop
      get_local 4
      get_local 2
      i32.load offset=16
      i32.store
      get_local 2
      get_local 2
      i64.load offset=8
      i64.store offset=24
      block  ;; label = @2
        get_local 1
        i32.const 4
        i32.add
        tee_local 3
        i32.load
        tee_local 5
        i32.eqz
        br_if 0 (;@2;)
        get_local 1
        i32.const 8
        i32.add
        i32.load
        tee_local 6
        i32.eqz
        br_if 0 (;@2;)
        get_local 5
        get_local 6
        i32.const 1
        call $__rust_dealloc
      end
      get_local 3
      get_local 2
      i64.load offset=24
      i64.store align=4
      get_local 3
      i32.const 8
      i32.add
      get_local 4
      i32.load
      i32.store
      get_local 3
      i32.load
      set_local 3
    end
    get_local 1
    i32.const 1
    i32.store offset=4
    get_local 1
    i32.const 12
    i32.add
    i32.load
    set_local 4
    get_local 1
    i32.const 8
    i32.add
    tee_local 1
    i32.load
    set_local 5
    get_local 1
    i64.const 0
    i64.store align=4
    block  ;; label = @1
      i32.const 12
      i32.const 4
      call $__rust_alloc
      tee_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      get_local 4
      i32.store offset=8
      get_local 1
      get_local 5
      i32.store offset=4
      get_local 1
      get_local 3
      i32.store
      get_local 0
      i32.const 1056344
      i32.store offset=4
      get_local 0
      get_local 1
      i32.store
      get_local 2
      i32.const 48
      i32.add
      set_global 0
      return
    end
    i32.const 12
    i32.const 4
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $_$LT$std..panicking..continue_panic_fmt..PanicPayload$LT$$u27$a$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::get::h1172a3d45c0df356 (type 2) (param i32 i32)
    (local i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 1
    i32.const 4
    i32.add
    set_local 3
    block  ;; label = @1
      get_local 1
      i32.load offset=4
      br_if 0 (;@1;)
      get_local 1
      i32.load
      set_local 4
      get_local 2
      i32.const 0
      i32.store offset=16
      get_local 2
      i64.const 1
      i64.store offset=8
      get_local 2
      get_local 2
      i32.const 8
      i32.add
      i32.store offset=20
      get_local 2
      i32.const 24
      i32.add
      i32.const 16
      i32.add
      get_local 4
      i32.const 16
      i32.add
      i64.load align=4
      i64.store
      get_local 2
      i32.const 24
      i32.add
      i32.const 8
      i32.add
      tee_local 5
      get_local 4
      i32.const 8
      i32.add
      i64.load align=4
      i64.store
      get_local 2
      get_local 4
      i64.load align=4
      i64.store offset=24
      get_local 2
      i32.const 20
      i32.add
      i32.const 1056236
      get_local 2
      i32.const 24
      i32.add
      call $core::fmt::write::hc8a86a45c34c9d88
      drop
      get_local 5
      get_local 2
      i32.load offset=16
      i32.store
      get_local 2
      get_local 2
      i64.load offset=8
      i64.store offset=24
      block  ;; label = @2
        get_local 3
        i32.load
        tee_local 4
        i32.eqz
        br_if 0 (;@2;)
        get_local 1
        i32.const 8
        i32.add
        i32.load
        tee_local 1
        i32.eqz
        br_if 0 (;@2;)
        get_local 4
        get_local 1
        i32.const 1
        call $__rust_dealloc
      end
      get_local 3
      get_local 2
      i64.load offset=24
      i64.store align=4
      get_local 3
      i32.const 8
      i32.add
      get_local 5
      i32.load
      i32.store
    end
    get_local 0
    i32.const 1056344
    i32.store offset=4
    get_local 0
    get_local 3
    i32.store
    get_local 2
    i32.const 48
    i32.add
    set_global 0)
  (func $_$LT$std..panicking..begin_panic..PanicPayload$LT$A$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::box_me_up::hcf9a6190219ec907 (type 2) (param i32 i32)
    (local i32 i32)
    get_local 1
    i32.load
    set_local 2
    get_local 1
    i32.const 0
    i32.store
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 2
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          i32.load offset=4
          set_local 3
          i32.const 8
          i32.const 4
          call $__rust_alloc
          tee_local 1
          i32.eqz
          br_if 2 (;@1;)
          get_local 1
          get_local 3
          i32.store offset=4
          get_local 1
          get_local 2
          i32.store
          i32.const 1056380
          set_local 2
          br 1 (;@2;)
        end
        i32.const 1
        set_local 1
        i32.const 1056396
        set_local 2
      end
      get_local 0
      get_local 2
      i32.store offset=4
      get_local 0
      get_local 1
      i32.store
      return
    end
    i32.const 8
    i32.const 4
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $_$LT$std..panicking..begin_panic..PanicPayload$LT$A$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::get::h60bfa704555f22d9 (type 2) (param i32 i32)
    (local i32)
    get_local 0
    i32.const 1056380
    i32.const 1056396
    get_local 1
    i32.load
    tee_local 2
    select
    i32.store offset=4
    get_local 0
    get_local 1
    i32.const 1050524
    get_local 2
    select
    i32.store)
  (func $rust_panic (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=4
    get_local 2
    get_local 0
    i32.store
    get_local 2
    get_local 2
    call $__rust_start_panic
    i32.store offset=12
    get_local 2
    i32.const 28
    i32.add
    i32.const 1
    i32.store
    get_local 2
    i32.const 36
    i32.add
    i32.const 1
    i32.store
    get_local 2
    i32.const 43
    i32.store offset=44
    get_local 2
    i32.const 1056428
    i32.store offset=16
    get_local 2
    i32.const 1
    i32.store offset=20
    get_local 2
    i32.const 1050652
    i32.store offset=24
    get_local 2
    get_local 2
    i32.const 12
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 40
    i32.add
    i32.store offset=32
    get_local 2
    i32.const 16
    i32.add
    call $std::sys_common::util::abort::h2876ede54453dc3a
    unreachable)
  (func $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$core..fmt..Debug$GT$::fmt::hfa94ec28b42f41e4 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.const 1050688
    i32.const 11
    call $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301
    get_local 2
    get_local 0
    i32.store offset=12
    get_local 2
    get_local 2
    i32.const 12
    i32.add
    i32.const 1056436
    call $core::fmt::builders::DebugTuple::field::hd3b43611deb92f36
    drop
    get_local 2
    call $core::fmt::builders::DebugTuple::finish::h49e80920431344b7
    set_local 0
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 0)
  (func $std::panicking::update_panic_count::PANIC_COUNT::__init::he13d019907e82236 (type 1) (result i32)
    i32.const 0)
  (func $std::panicking::update_panic_count::PANIC_COUNT::__getit::he94c221774b7706f (type 1) (result i32)
    i32.const 1058696)
  (func $__rust_start_panic (type 10) (param i32) (result i32)
    unreachable
    unreachable)
  (func $dlmalloc::dlmalloc::Dlmalloc::malloc_alignment::ha71f1d16dd31f1a3 (type 10) (param i32) (result i32)
    i32.const 8)
  (func $dlmalloc::dlmalloc::Dlmalloc::malloc::hc4b4efc85b47ad98 (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i64)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                block  ;; label = @31
                                                                  block  ;; label = @32
                                                                    block  ;; label = @33
                                                                      block  ;; label = @34
                                                                        block  ;; label = @35
                                                                          block  ;; label = @36
                                                                            block  ;; label = @37
                                                                              get_local 1
                                                                              i32.const 244
                                                                              i32.gt_u
                                                                              br_if 0 (;@37;)
                                                                              get_local 0
                                                                              i32.load
                                                                              tee_local 2
                                                                              i32.const 16
                                                                              get_local 1
                                                                              i32.const 11
                                                                              i32.add
                                                                              i32.const -8
                                                                              i32.and
                                                                              get_local 1
                                                                              i32.const 11
                                                                              i32.lt_u
                                                                              select
                                                                              tee_local 3
                                                                              i32.const 3
                                                                              i32.shr_u
                                                                              tee_local 4
                                                                              i32.const 31
                                                                              i32.and
                                                                              tee_local 5
                                                                              i32.shr_u
                                                                              tee_local 1
                                                                              i32.const 3
                                                                              i32.and
                                                                              i32.eqz
                                                                              br_if 1 (;@36;)
                                                                              get_local 0
                                                                              get_local 1
                                                                              i32.const -1
                                                                              i32.xor
                                                                              i32.const 1
                                                                              i32.and
                                                                              get_local 4
                                                                              i32.add
                                                                              tee_local 3
                                                                              i32.const 3
                                                                              i32.shl
                                                                              i32.add
                                                                              tee_local 5
                                                                              i32.const 16
                                                                              i32.add
                                                                              i32.load
                                                                              tee_local 1
                                                                              i32.const 8
                                                                              i32.add
                                                                              set_local 6
                                                                              get_local 1
                                                                              i32.load offset=8
                                                                              tee_local 4
                                                                              get_local 5
                                                                              i32.const 8
                                                                              i32.add
                                                                              tee_local 5
                                                                              i32.eq
                                                                              br_if 2 (;@35;)
                                                                              get_local 4
                                                                              get_local 5
                                                                              i32.store offset=12
                                                                              get_local 5
                                                                              i32.const 8
                                                                              i32.add
                                                                              get_local 4
                                                                              i32.store
                                                                              br 3 (;@34;)
                                                                            end
                                                                            i32.const 0
                                                                            set_local 2
                                                                            get_local 1
                                                                            i32.const -64
                                                                            i32.ge_u
                                                                            br_if 28 (;@8;)
                                                                            get_local 1
                                                                            i32.const 11
                                                                            i32.add
                                                                            tee_local 1
                                                                            i32.const -8
                                                                            i32.and
                                                                            set_local 3
                                                                            get_local 0
                                                                            i32.load offset=4
                                                                            tee_local 7
                                                                            i32.eqz
                                                                            br_if 9 (;@27;)
                                                                            i32.const 0
                                                                            set_local 8
                                                                            block  ;; label = @37
                                                                              get_local 1
                                                                              i32.const 8
                                                                              i32.shr_u
                                                                              tee_local 1
                                                                              i32.eqz
                                                                              br_if 0 (;@37;)
                                                                              i32.const 31
                                                                              set_local 8
                                                                              get_local 3
                                                                              i32.const 16777215
                                                                              i32.gt_u
                                                                              br_if 0 (;@37;)
                                                                              get_local 3
                                                                              i32.const 38
                                                                              get_local 1
                                                                              i32.clz
                                                                              tee_local 1
                                                                              i32.sub
                                                                              i32.const 31
                                                                              i32.and
                                                                              i32.shr_u
                                                                              i32.const 1
                                                                              i32.and
                                                                              i32.const 31
                                                                              get_local 1
                                                                              i32.sub
                                                                              i32.const 1
                                                                              i32.shl
                                                                              i32.or
                                                                              set_local 8
                                                                            end
                                                                            i32.const 0
                                                                            get_local 3
                                                                            i32.sub
                                                                            set_local 4
                                                                            get_local 0
                                                                            get_local 8
                                                                            i32.const 2
                                                                            i32.shl
                                                                            i32.add
                                                                            i32.const 272
                                                                            i32.add
                                                                            i32.load
                                                                            tee_local 1
                                                                            i32.eqz
                                                                            br_if 6 (;@30;)
                                                                            i32.const 0
                                                                            set_local 5
                                                                            get_local 3
                                                                            i32.const 0
                                                                            i32.const 25
                                                                            get_local 8
                                                                            i32.const 1
                                                                            i32.shr_u
                                                                            i32.sub
                                                                            i32.const 31
                                                                            i32.and
                                                                            get_local 8
                                                                            i32.const 31
                                                                            i32.eq
                                                                            select
                                                                            i32.shl
                                                                            set_local 2
                                                                            i32.const 0
                                                                            set_local 6
                                                                            loop  ;; label = @37
                                                                              block  ;; label = @38
                                                                                get_local 1
                                                                                i32.load offset=4
                                                                                i32.const -8
                                                                                i32.and
                                                                                tee_local 9
                                                                                get_local 3
                                                                                i32.lt_u
                                                                                br_if 0 (;@38;)
                                                                                get_local 9
                                                                                get_local 3
                                                                                i32.sub
                                                                                tee_local 9
                                                                                get_local 4
                                                                                i32.ge_u
                                                                                br_if 0 (;@38;)
                                                                                get_local 9
                                                                                set_local 4
                                                                                get_local 1
                                                                                set_local 6
                                                                                get_local 9
                                                                                i32.eqz
                                                                                br_if 6 (;@32;)
                                                                              end
                                                                              get_local 1
                                                                              i32.const 20
                                                                              i32.add
                                                                              i32.load
                                                                              tee_local 9
                                                                              get_local 5
                                                                              get_local 9
                                                                              get_local 1
                                                                              get_local 2
                                                                              i32.const 29
                                                                              i32.shr_u
                                                                              i32.const 4
                                                                              i32.and
                                                                              i32.add
                                                                              i32.const 16
                                                                              i32.add
                                                                              i32.load
                                                                              tee_local 1
                                                                              i32.ne
                                                                              select
                                                                              get_local 5
                                                                              get_local 9
                                                                              select
                                                                              set_local 5
                                                                              get_local 2
                                                                              i32.const 1
                                                                              i32.shl
                                                                              set_local 2
                                                                              get_local 1
                                                                              br_if 0 (;@37;)
                                                                            end
                                                                            get_local 5
                                                                            i32.eqz
                                                                            br_if 5 (;@31;)
                                                                            get_local 5
                                                                            set_local 1
                                                                            br 7 (;@29;)
                                                                          end
                                                                          get_local 3
                                                                          get_local 0
                                                                          i32.load offset=400
                                                                          i32.le_u
                                                                          br_if 8 (;@27;)
                                                                          get_local 1
                                                                          i32.eqz
                                                                          br_if 2 (;@33;)
                                                                          get_local 0
                                                                          get_local 1
                                                                          get_local 5
                                                                          i32.shl
                                                                          i32.const 2
                                                                          get_local 5
                                                                          i32.shl
                                                                          tee_local 1
                                                                          i32.const 0
                                                                          get_local 1
                                                                          i32.sub
                                                                          i32.or
                                                                          i32.and
                                                                          tee_local 1
                                                                          i32.const 0
                                                                          get_local 1
                                                                          i32.sub
                                                                          i32.and
                                                                          i32.ctz
                                                                          tee_local 4
                                                                          i32.const 3
                                                                          i32.shl
                                                                          i32.add
                                                                          tee_local 6
                                                                          i32.const 16
                                                                          i32.add
                                                                          i32.load
                                                                          tee_local 1
                                                                          i32.load offset=8
                                                                          tee_local 5
                                                                          get_local 6
                                                                          i32.const 8
                                                                          i32.add
                                                                          tee_local 6
                                                                          i32.eq
                                                                          br_if 10 (;@25;)
                                                                          get_local 5
                                                                          get_local 6
                                                                          i32.store offset=12
                                                                          get_local 6
                                                                          i32.const 8
                                                                          i32.add
                                                                          get_local 5
                                                                          i32.store
                                                                          br 11 (;@24;)
                                                                        end
                                                                        get_local 0
                                                                        get_local 2
                                                                        i32.const -2
                                                                        get_local 3
                                                                        i32.rotl
                                                                        i32.and
                                                                        i32.store
                                                                      end
                                                                      get_local 1
                                                                      get_local 3
                                                                      i32.const 3
                                                                      i32.shl
                                                                      tee_local 3
                                                                      i32.const 3
                                                                      i32.or
                                                                      i32.store offset=4
                                                                      get_local 1
                                                                      get_local 3
                                                                      i32.add
                                                                      tee_local 1
                                                                      get_local 1
                                                                      i32.load offset=4
                                                                      i32.const 1
                                                                      i32.or
                                                                      i32.store offset=4
                                                                      get_local 6
                                                                      return
                                                                    end
                                                                    get_local 0
                                                                    i32.load offset=4
                                                                    tee_local 1
                                                                    i32.eqz
                                                                    br_if 5 (;@27;)
                                                                    get_local 0
                                                                    get_local 1
                                                                    i32.const 0
                                                                    get_local 1
                                                                    i32.sub
                                                                    i32.and
                                                                    i32.ctz
                                                                    i32.const 2
                                                                    i32.shl
                                                                    i32.add
                                                                    i32.const 272
                                                                    i32.add
                                                                    i32.load
                                                                    tee_local 2
                                                                    i32.load offset=4
                                                                    i32.const -8
                                                                    i32.and
                                                                    get_local 3
                                                                    i32.sub
                                                                    set_local 4
                                                                    get_local 2
                                                                    set_local 5
                                                                    get_local 2
                                                                    i32.load offset=16
                                                                    tee_local 1
                                                                    i32.eqz
                                                                    br_if 20 (;@12;)
                                                                    i32.const 0
                                                                    set_local 10
                                                                    br 21 (;@11;)
                                                                  end
                                                                  i32.const 0
                                                                  set_local 4
                                                                  get_local 1
                                                                  set_local 6
                                                                  br 2 (;@29;)
                                                                end
                                                                get_local 6
                                                                br_if 2 (;@28;)
                                                              end
                                                              i32.const 0
                                                              set_local 6
                                                              i32.const 2
                                                              get_local 8
                                                              i32.const 31
                                                              i32.and
                                                              i32.shl
                                                              tee_local 1
                                                              i32.const 0
                                                              get_local 1
                                                              i32.sub
                                                              i32.or
                                                              get_local 7
                                                              i32.and
                                                              tee_local 1
                                                              i32.eqz
                                                              br_if 2 (;@27;)
                                                              get_local 0
                                                              get_local 1
                                                              i32.const 0
                                                              get_local 1
                                                              i32.sub
                                                              i32.and
                                                              i32.ctz
                                                              i32.const 2
                                                              i32.shl
                                                              i32.add
                                                              i32.const 272
                                                              i32.add
                                                              i32.load
                                                              tee_local 1
                                                              i32.eqz
                                                              br_if 2 (;@27;)
                                                            end
                                                            loop  ;; label = @29
                                                              get_local 1
                                                              i32.load offset=4
                                                              i32.const -8
                                                              i32.and
                                                              tee_local 5
                                                              get_local 3
                                                              i32.ge_u
                                                              get_local 5
                                                              get_local 3
                                                              i32.sub
                                                              tee_local 9
                                                              get_local 4
                                                              i32.lt_u
                                                              i32.and
                                                              set_local 2
                                                              block  ;; label = @30
                                                                get_local 1
                                                                i32.load offset=16
                                                                tee_local 5
                                                                br_if 0 (;@30;)
                                                                get_local 1
                                                                i32.const 20
                                                                i32.add
                                                                i32.load
                                                                set_local 5
                                                              end
                                                              get_local 1
                                                              get_local 6
                                                              get_local 2
                                                              select
                                                              set_local 6
                                                              get_local 9
                                                              get_local 4
                                                              get_local 2
                                                              select
                                                              set_local 4
                                                              get_local 5
                                                              set_local 1
                                                              get_local 5
                                                              br_if 0 (;@29;)
                                                            end
                                                            get_local 6
                                                            i32.eqz
                                                            br_if 1 (;@27;)
                                                          end
                                                          get_local 0
                                                          i32.load offset=400
                                                          tee_local 1
                                                          get_local 3
                                                          i32.lt_u
                                                          br_if 1 (;@26;)
                                                          get_local 4
                                                          get_local 1
                                                          get_local 3
                                                          i32.sub
                                                          i32.lt_u
                                                          br_if 1 (;@26;)
                                                        end
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                get_local 0
                                                                i32.load offset=400
                                                                tee_local 4
                                                                get_local 3
                                                                i32.ge_u
                                                                br_if 0 (;@30;)
                                                                get_local 0
                                                                i32.load offset=404
                                                                tee_local 1
                                                                get_local 3
                                                                i32.le_u
                                                                br_if 1 (;@29;)
                                                                get_local 0
                                                                i32.const 404
                                                                i32.add
                                                                get_local 1
                                                                get_local 3
                                                                i32.sub
                                                                tee_local 4
                                                                i32.store
                                                                get_local 0
                                                                get_local 0
                                                                i32.load offset=412
                                                                tee_local 1
                                                                get_local 3
                                                                i32.add
                                                                tee_local 5
                                                                i32.store offset=412
                                                                get_local 5
                                                                get_local 4
                                                                i32.const 1
                                                                i32.or
                                                                i32.store offset=4
                                                                get_local 1
                                                                get_local 3
                                                                i32.const 3
                                                                i32.or
                                                                i32.store offset=4
                                                                get_local 1
                                                                i32.const 8
                                                                i32.add
                                                                return
                                                              end
                                                              get_local 0
                                                              i32.load offset=408
                                                              set_local 1
                                                              get_local 4
                                                              get_local 3
                                                              i32.sub
                                                              tee_local 5
                                                              i32.const 16
                                                              i32.ge_u
                                                              br_if 1 (;@28;)
                                                              get_local 0
                                                              i32.const 408
                                                              i32.add
                                                              i32.const 0
                                                              i32.store
                                                              get_local 0
                                                              i32.const 400
                                                              i32.add
                                                              i32.const 0
                                                              i32.store
                                                              get_local 1
                                                              get_local 4
                                                              i32.const 3
                                                              i32.or
                                                              i32.store offset=4
                                                              get_local 1
                                                              get_local 4
                                                              i32.add
                                                              tee_local 4
                                                              i32.const 4
                                                              i32.add
                                                              set_local 3
                                                              get_local 4
                                                              i32.load offset=4
                                                              i32.const 1
                                                              i32.or
                                                              set_local 4
                                                              br 2 (;@27;)
                                                            end
                                                            i32.const 0
                                                            set_local 2
                                                            get_local 3
                                                            i32.const 65583
                                                            i32.add
                                                            tee_local 4
                                                            i32.const 16
                                                            i32.shr_u
                                                            memory.grow
                                                            tee_local 1
                                                            i32.const -1
                                                            i32.eq
                                                            br_if 20 (;@8;)
                                                            get_local 1
                                                            i32.const 16
                                                            i32.shl
                                                            tee_local 6
                                                            i32.eqz
                                                            br_if 20 (;@8;)
                                                            get_local 0
                                                            get_local 0
                                                            i32.load offset=416
                                                            get_local 4
                                                            i32.const -65536
                                                            i32.and
                                                            tee_local 8
                                                            i32.add
                                                            tee_local 1
                                                            i32.store offset=416
                                                            get_local 0
                                                            get_local 0
                                                            i32.load offset=420
                                                            tee_local 4
                                                            get_local 1
                                                            get_local 1
                                                            get_local 4
                                                            i32.lt_u
                                                            select
                                                            i32.store offset=420
                                                            get_local 0
                                                            i32.load offset=412
                                                            tee_local 4
                                                            i32.eqz
                                                            br_if 9 (;@19;)
                                                            get_local 0
                                                            i32.const 424
                                                            i32.add
                                                            tee_local 7
                                                            set_local 1
                                                            loop  ;; label = @29
                                                              get_local 1
                                                              i32.load
                                                              tee_local 5
                                                              get_local 1
                                                              i32.load offset=4
                                                              tee_local 9
                                                              i32.add
                                                              get_local 6
                                                              i32.eq
                                                              br_if 11 (;@18;)
                                                              get_local 1
                                                              i32.load offset=8
                                                              tee_local 1
                                                              br_if 0 (;@29;)
                                                              br 19 (;@10;)
                                                            end
                                                          end
                                                          get_local 0
                                                          i32.const 400
                                                          i32.add
                                                          get_local 5
                                                          i32.store
                                                          get_local 0
                                                          i32.const 408
                                                          i32.add
                                                          get_local 1
                                                          get_local 3
                                                          i32.add
                                                          tee_local 2
                                                          i32.store
                                                          get_local 2
                                                          get_local 5
                                                          i32.const 1
                                                          i32.or
                                                          i32.store offset=4
                                                          get_local 1
                                                          get_local 4
                                                          i32.add
                                                          get_local 5
                                                          i32.store
                                                          get_local 3
                                                          i32.const 3
                                                          i32.or
                                                          set_local 4
                                                          get_local 1
                                                          i32.const 4
                                                          i32.add
                                                          set_local 3
                                                        end
                                                        get_local 3
                                                        get_local 4
                                                        i32.store
                                                        get_local 1
                                                        i32.const 8
                                                        i32.add
                                                        return
                                                      end
                                                      get_local 0
                                                      get_local 6
                                                      call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
                                                      get_local 4
                                                      i32.const 15
                                                      i32.gt_u
                                                      br_if 2 (;@23;)
                                                      get_local 6
                                                      get_local 4
                                                      get_local 3
                                                      i32.add
                                                      tee_local 1
                                                      i32.const 3
                                                      i32.or
                                                      i32.store offset=4
                                                      get_local 6
                                                      get_local 1
                                                      i32.add
                                                      tee_local 1
                                                      get_local 1
                                                      i32.load offset=4
                                                      i32.const 1
                                                      i32.or
                                                      i32.store offset=4
                                                      br 12 (;@13;)
                                                    end
                                                    get_local 0
                                                    get_local 2
                                                    i32.const -2
                                                    get_local 4
                                                    i32.rotl
                                                    i32.and
                                                    i32.store
                                                  end
                                                  get_local 1
                                                  i32.const 8
                                                  i32.add
                                                  set_local 5
                                                  get_local 1
                                                  get_local 3
                                                  i32.const 3
                                                  i32.or
                                                  i32.store offset=4
                                                  get_local 1
                                                  get_local 3
                                                  i32.add
                                                  tee_local 2
                                                  get_local 4
                                                  i32.const 3
                                                  i32.shl
                                                  tee_local 4
                                                  get_local 3
                                                  i32.sub
                                                  tee_local 3
                                                  i32.const 1
                                                  i32.or
                                                  i32.store offset=4
                                                  get_local 1
                                                  get_local 4
                                                  i32.add
                                                  get_local 3
                                                  i32.store
                                                  get_local 0
                                                  i32.const 400
                                                  i32.add
                                                  tee_local 6
                                                  i32.load
                                                  tee_local 1
                                                  i32.eqz
                                                  br_if 3 (;@20;)
                                                  get_local 0
                                                  get_local 1
                                                  i32.const 3
                                                  i32.shr_u
                                                  tee_local 9
                                                  i32.const 3
                                                  i32.shl
                                                  i32.add
                                                  i32.const 8
                                                  i32.add
                                                  set_local 4
                                                  get_local 0
                                                  i32.const 408
                                                  i32.add
                                                  i32.load
                                                  set_local 1
                                                  get_local 0
                                                  i32.load
                                                  tee_local 8
                                                  i32.const 1
                                                  get_local 9
                                                  i32.const 31
                                                  i32.and
                                                  i32.shl
                                                  tee_local 9
                                                  i32.and
                                                  i32.eqz
                                                  br_if 1 (;@22;)
                                                  get_local 4
                                                  i32.load offset=8
                                                  set_local 9
                                                  br 2 (;@21;)
                                                end
                                                get_local 6
                                                get_local 3
                                                i32.const 3
                                                i32.or
                                                i32.store offset=4
                                                get_local 6
                                                get_local 3
                                                i32.add
                                                tee_local 1
                                                get_local 4
                                                i32.const 1
                                                i32.or
                                                i32.store offset=4
                                                get_local 1
                                                get_local 4
                                                i32.add
                                                get_local 4
                                                i32.store
                                                get_local 4
                                                i32.const 255
                                                i32.gt_u
                                                br_if 5 (;@17;)
                                                get_local 0
                                                get_local 4
                                                i32.const 3
                                                i32.shr_u
                                                tee_local 4
                                                i32.const 3
                                                i32.shl
                                                i32.add
                                                i32.const 8
                                                i32.add
                                                set_local 3
                                                get_local 0
                                                i32.load
                                                tee_local 5
                                                i32.const 1
                                                get_local 4
                                                i32.const 31
                                                i32.and
                                                i32.shl
                                                tee_local 4
                                                i32.and
                                                i32.eqz
                                                br_if 7 (;@15;)
                                                get_local 3
                                                i32.const 8
                                                i32.add
                                                set_local 5
                                                get_local 3
                                                i32.load offset=8
                                                set_local 4
                                                br 8 (;@14;)
                                              end
                                              get_local 0
                                              get_local 8
                                              get_local 9
                                              i32.or
                                              i32.store
                                              get_local 4
                                              set_local 9
                                            end
                                            get_local 4
                                            i32.const 8
                                            i32.add
                                            get_local 1
                                            i32.store
                                            get_local 9
                                            get_local 1
                                            i32.store offset=12
                                            get_local 1
                                            get_local 4
                                            i32.store offset=12
                                            get_local 1
                                            get_local 9
                                            i32.store offset=8
                                          end
                                          get_local 0
                                          i32.const 408
                                          i32.add
                                          get_local 2
                                          i32.store
                                          get_local 6
                                          get_local 3
                                          i32.store
                                          get_local 5
                                          return
                                        end
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            get_local 0
                                            i32.load offset=444
                                            tee_local 1
                                            i32.eqz
                                            br_if 0 (;@20;)
                                            get_local 1
                                            get_local 6
                                            i32.le_u
                                            br_if 1 (;@19;)
                                          end
                                          get_local 0
                                          i32.const 444
                                          i32.add
                                          get_local 6
                                          i32.store
                                        end
                                        get_local 0
                                        get_local 6
                                        i32.store offset=424
                                        get_local 0
                                        i32.const 4095
                                        i32.store offset=448
                                        get_local 0
                                        i32.const 428
                                        i32.add
                                        get_local 8
                                        i32.store
                                        i32.const 0
                                        set_local 1
                                        get_local 0
                                        i32.const 436
                                        i32.add
                                        i32.const 0
                                        i32.store
                                        loop  ;; label = @19
                                          get_local 0
                                          get_local 1
                                          i32.add
                                          tee_local 4
                                          i32.const 16
                                          i32.add
                                          get_local 4
                                          i32.const 8
                                          i32.add
                                          tee_local 5
                                          i32.store
                                          get_local 4
                                          i32.const 20
                                          i32.add
                                          get_local 5
                                          i32.store
                                          get_local 1
                                          i32.const 8
                                          i32.add
                                          tee_local 1
                                          i32.const 256
                                          i32.ne
                                          br_if 0 (;@19;)
                                        end
                                        get_local 0
                                        i32.const 404
                                        i32.add
                                        get_local 8
                                        i32.const -40
                                        i32.add
                                        tee_local 1
                                        i32.store
                                        get_local 0
                                        i32.const 412
                                        i32.add
                                        get_local 6
                                        i32.store
                                        get_local 6
                                        get_local 1
                                        i32.const 1
                                        i32.or
                                        i32.store offset=4
                                        get_local 6
                                        get_local 1
                                        i32.add
                                        i32.const 40
                                        i32.store offset=4
                                        get_local 0
                                        i32.const 2097152
                                        i32.store offset=440
                                        br 9 (;@9;)
                                      end
                                      get_local 1
                                      i32.load offset=12
                                      i32.eqz
                                      br_if 1 (;@16;)
                                      br 7 (;@10;)
                                    end
                                    get_local 0
                                    get_local 1
                                    get_local 4
                                    call $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e
                                    br 3 (;@13;)
                                  end
                                  get_local 6
                                  get_local 4
                                  i32.le_u
                                  br_if 5 (;@10;)
                                  get_local 5
                                  get_local 4
                                  i32.gt_u
                                  br_if 5 (;@10;)
                                  get_local 1
                                  i32.const 4
                                  i32.add
                                  get_local 9
                                  get_local 8
                                  i32.add
                                  i32.store
                                  get_local 0
                                  i32.const 412
                                  i32.add
                                  tee_local 1
                                  get_local 1
                                  i32.load
                                  tee_local 1
                                  i32.const 15
                                  i32.add
                                  i32.const -8
                                  i32.and
                                  tee_local 4
                                  i32.const -8
                                  i32.add
                                  tee_local 5
                                  i32.store
                                  get_local 0
                                  i32.const 404
                                  i32.add
                                  tee_local 6
                                  get_local 6
                                  i32.load
                                  get_local 8
                                  i32.add
                                  tee_local 6
                                  get_local 1
                                  i32.const 8
                                  i32.add
                                  get_local 4
                                  i32.sub
                                  i32.add
                                  tee_local 4
                                  i32.store
                                  get_local 5
                                  get_local 4
                                  i32.const 1
                                  i32.or
                                  i32.store offset=4
                                  get_local 1
                                  get_local 6
                                  i32.add
                                  i32.const 40
                                  i32.store offset=4
                                  get_local 0
                                  i32.const 2097152
                                  i32.store offset=440
                                  br 6 (;@9;)
                                end
                                get_local 0
                                get_local 5
                                get_local 4
                                i32.or
                                i32.store
                                get_local 3
                                i32.const 8
                                i32.add
                                set_local 5
                                get_local 3
                                set_local 4
                              end
                              get_local 5
                              get_local 1
                              i32.store
                              get_local 4
                              get_local 1
                              i32.store offset=12
                              get_local 1
                              get_local 3
                              i32.store offset=12
                              get_local 1
                              get_local 4
                              i32.store offset=8
                            end
                            get_local 6
                            i32.const 8
                            i32.add
                            set_local 2
                            br 4 (;@8;)
                          end
                          i32.const 1
                          set_local 10
                        end
                        loop  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              get_local 10
                                                              br_table 0 (;@29;) 1 (;@28;) 2 (;@27;) 4 (;@25;) 5 (;@24;) 6 (;@23;) 8 (;@21;) 9 (;@20;) 10 (;@19;) 7 (;@22;) 3 (;@26;) 3 (;@26;)
                                                            end
                                                            get_local 1
                                                            i32.load offset=4
                                                            i32.const -8
                                                            i32.and
                                                            get_local 3
                                                            i32.sub
                                                            tee_local 2
                                                            get_local 4
                                                            get_local 2
                                                            get_local 4
                                                            i32.lt_u
                                                            tee_local 2
                                                            select
                                                            set_local 4
                                                            get_local 1
                                                            get_local 5
                                                            get_local 2
                                                            select
                                                            set_local 5
                                                            get_local 1
                                                            tee_local 2
                                                            i32.load offset=16
                                                            tee_local 1
                                                            br_if 10 (;@18;)
                                                            i32.const 1
                                                            set_local 10
                                                            br 17 (;@11;)
                                                          end
                                                          get_local 2
                                                          i32.const 20
                                                          i32.add
                                                          i32.load
                                                          tee_local 1
                                                          br_if 10 (;@17;)
                                                          i32.const 2
                                                          set_local 10
                                                          br 16 (;@11;)
                                                        end
                                                        get_local 0
                                                        get_local 5
                                                        call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
                                                        get_local 4
                                                        i32.const 16
                                                        i32.ge_u
                                                        br_if 10 (;@16;)
                                                        i32.const 10
                                                        set_local 10
                                                        br 15 (;@11;)
                                                      end
                                                      get_local 5
                                                      get_local 4
                                                      get_local 3
                                                      i32.add
                                                      tee_local 1
                                                      i32.const 3
                                                      i32.or
                                                      i32.store offset=4
                                                      get_local 5
                                                      get_local 1
                                                      i32.add
                                                      tee_local 1
                                                      get_local 1
                                                      i32.load offset=4
                                                      i32.const 1
                                                      i32.or
                                                      i32.store offset=4
                                                      br 13 (;@12;)
                                                    end
                                                    get_local 5
                                                    get_local 3
                                                    i32.const 3
                                                    i32.or
                                                    i32.store offset=4
                                                    get_local 5
                                                    get_local 3
                                                    i32.add
                                                    tee_local 3
                                                    get_local 4
                                                    i32.const 1
                                                    i32.or
                                                    i32.store offset=4
                                                    get_local 3
                                                    get_local 4
                                                    i32.add
                                                    get_local 4
                                                    i32.store
                                                    get_local 0
                                                    i32.const 400
                                                    i32.add
                                                    tee_local 6
                                                    i32.load
                                                    tee_local 1
                                                    i32.eqz
                                                    br_if 9 (;@15;)
                                                    i32.const 4
                                                    set_local 10
                                                    br 13 (;@11;)
                                                  end
                                                  get_local 0
                                                  get_local 1
                                                  i32.const 3
                                                  i32.shr_u
                                                  tee_local 9
                                                  i32.const 3
                                                  i32.shl
                                                  i32.add
                                                  i32.const 8
                                                  i32.add
                                                  set_local 2
                                                  get_local 0
                                                  i32.const 408
                                                  i32.add
                                                  i32.load
                                                  set_local 1
                                                  get_local 0
                                                  i32.load
                                                  tee_local 8
                                                  i32.const 1
                                                  get_local 9
                                                  i32.const 31
                                                  i32.and
                                                  i32.shl
                                                  tee_local 9
                                                  i32.and
                                                  i32.eqz
                                                  br_if 9 (;@14;)
                                                  i32.const 5
                                                  set_local 10
                                                  br 12 (;@11;)
                                                end
                                                get_local 2
                                                i32.load offset=8
                                                set_local 9
                                                br 9 (;@13;)
                                              end
                                              get_local 0
                                              get_local 8
                                              get_local 9
                                              i32.or
                                              i32.store
                                              get_local 2
                                              set_local 9
                                              i32.const 6
                                              set_local 10
                                              br 10 (;@11;)
                                            end
                                            get_local 2
                                            i32.const 8
                                            i32.add
                                            get_local 1
                                            i32.store
                                            get_local 9
                                            get_local 1
                                            i32.store offset=12
                                            get_local 1
                                            get_local 2
                                            i32.store offset=12
                                            get_local 1
                                            get_local 9
                                            i32.store offset=8
                                            i32.const 7
                                            set_local 10
                                            br 9 (;@11;)
                                          end
                                          get_local 0
                                          i32.const 408
                                          i32.add
                                          get_local 3
                                          i32.store
                                          get_local 6
                                          get_local 4
                                          i32.store
                                          i32.const 8
                                          set_local 10
                                          br 8 (;@11;)
                                        end
                                        get_local 5
                                        i32.const 8
                                        i32.add
                                        return
                                      end
                                      i32.const 0
                                      set_local 10
                                      br 6 (;@11;)
                                    end
                                    i32.const 0
                                    set_local 10
                                    br 5 (;@11;)
                                  end
                                  i32.const 3
                                  set_local 10
                                  br 4 (;@11;)
                                end
                                i32.const 7
                                set_local 10
                                br 3 (;@11;)
                              end
                              i32.const 9
                              set_local 10
                              br 2 (;@11;)
                            end
                            i32.const 6
                            set_local 10
                            br 1 (;@11;)
                          end
                          i32.const 8
                          set_local 10
                          br 0 (;@11;)
                        end
                      end
                      get_local 0
                      get_local 0
                      i32.load offset=444
                      tee_local 1
                      get_local 6
                      get_local 1
                      get_local 6
                      i32.lt_u
                      select
                      i32.store offset=444
                      get_local 6
                      get_local 8
                      i32.add
                      set_local 5
                      get_local 7
                      set_local 1
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                loop  ;; label = @15
                                  get_local 1
                                  i32.load
                                  get_local 5
                                  i32.eq
                                  br_if 1 (;@14;)
                                  get_local 1
                                  i32.load offset=8
                                  tee_local 1
                                  br_if 0 (;@15;)
                                  br 2 (;@13;)
                                end
                              end
                              get_local 1
                              i32.load offset=12
                              i32.eqz
                              br_if 1 (;@12;)
                            end
                            get_local 7
                            set_local 1
                            block  ;; label = @13
                              loop  ;; label = @14
                                block  ;; label = @15
                                  get_local 1
                                  i32.load
                                  tee_local 5
                                  get_local 4
                                  i32.gt_u
                                  br_if 0 (;@15;)
                                  get_local 5
                                  get_local 1
                                  i32.load offset=4
                                  i32.add
                                  tee_local 5
                                  get_local 4
                                  i32.gt_u
                                  br_if 2 (;@13;)
                                end
                                get_local 1
                                i32.load offset=8
                                set_local 1
                                br 0 (;@14;)
                              end
                            end
                            get_local 0
                            i32.const 404
                            i32.add
                            get_local 8
                            i32.const -40
                            i32.add
                            tee_local 1
                            i32.store
                            get_local 0
                            i32.const 412
                            i32.add
                            get_local 6
                            i32.store
                            get_local 6
                            get_local 1
                            i32.const 1
                            i32.or
                            i32.store offset=4
                            get_local 6
                            get_local 1
                            i32.add
                            i32.const 40
                            i32.store offset=4
                            get_local 0
                            i32.const 2097152
                            i32.store offset=440
                            get_local 4
                            get_local 5
                            i32.const -32
                            i32.add
                            i32.const -8
                            i32.and
                            i32.const -8
                            i32.add
                            tee_local 1
                            get_local 1
                            get_local 4
                            i32.const 16
                            i32.add
                            i32.lt_u
                            select
                            tee_local 9
                            i32.const 27
                            i32.store offset=4
                            get_local 7
                            i64.load align=4
                            set_local 11
                            get_local 9
                            i32.const 16
                            i32.add
                            get_local 7
                            i32.const 8
                            i32.add
                            i64.load align=4
                            i64.store align=4
                            get_local 9
                            get_local 11
                            i64.store offset=8 align=4
                            get_local 0
                            i32.const 428
                            i32.add
                            get_local 8
                            i32.store
                            get_local 0
                            i32.const 424
                            i32.add
                            get_local 6
                            i32.store
                            get_local 0
                            i32.const 436
                            i32.add
                            i32.const 0
                            i32.store
                            get_local 0
                            i32.const 432
                            i32.add
                            get_local 9
                            i32.const 8
                            i32.add
                            i32.store
                            get_local 9
                            i32.const 28
                            i32.add
                            set_local 1
                            loop  ;; label = @13
                              get_local 1
                              i32.const 7
                              i32.store
                              get_local 5
                              get_local 1
                              i32.const 4
                              i32.add
                              tee_local 1
                              i32.gt_u
                              br_if 0 (;@13;)
                            end
                            get_local 9
                            get_local 4
                            i32.eq
                            br_if 3 (;@9;)
                            get_local 9
                            get_local 9
                            i32.load offset=4
                            i32.const -2
                            i32.and
                            i32.store offset=4
                            get_local 4
                            get_local 9
                            get_local 4
                            i32.sub
                            tee_local 1
                            i32.const 1
                            i32.or
                            i32.store offset=4
                            get_local 9
                            get_local 1
                            i32.store
                            block  ;; label = @13
                              get_local 1
                              i32.const 255
                              i32.gt_u
                              br_if 0 (;@13;)
                              get_local 0
                              get_local 1
                              i32.const 3
                              i32.shr_u
                              tee_local 5
                              i32.const 3
                              i32.shl
                              i32.add
                              i32.const 8
                              i32.add
                              set_local 1
                              get_local 0
                              i32.load
                              tee_local 6
                              i32.const 1
                              get_local 5
                              i32.const 31
                              i32.and
                              i32.shl
                              tee_local 5
                              i32.and
                              i32.eqz
                              br_if 2 (;@11;)
                              get_local 1
                              i32.load offset=8
                              set_local 5
                              br 3 (;@10;)
                            end
                            get_local 0
                            get_local 4
                            get_local 1
                            call $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e
                            br 3 (;@9;)
                          end
                          get_local 1
                          get_local 6
                          i32.store
                          get_local 1
                          get_local 1
                          i32.load offset=4
                          get_local 8
                          i32.add
                          i32.store offset=4
                          get_local 6
                          get_local 3
                          i32.const 3
                          i32.or
                          i32.store offset=4
                          get_local 6
                          get_local 3
                          i32.add
                          set_local 1
                          get_local 5
                          get_local 6
                          i32.sub
                          get_local 3
                          i32.sub
                          set_local 3
                          get_local 0
                          i32.const 412
                          i32.add
                          tee_local 4
                          i32.load
                          get_local 5
                          i32.eq
                          br_if 4 (;@7;)
                          get_local 0
                          i32.load offset=408
                          get_local 5
                          i32.eq
                          br_if 5 (;@6;)
                          get_local 5
                          i32.load offset=4
                          tee_local 4
                          i32.const 3
                          i32.and
                          i32.const 1
                          i32.ne
                          br_if 9 (;@2;)
                          get_local 4
                          i32.const -8
                          i32.and
                          tee_local 2
                          i32.const 255
                          i32.gt_u
                          br_if 6 (;@5;)
                          get_local 5
                          i32.load offset=12
                          tee_local 9
                          get_local 5
                          i32.load offset=8
                          tee_local 8
                          i32.eq
                          br_if 7 (;@4;)
                          get_local 8
                          get_local 9
                          i32.store offset=12
                          get_local 9
                          get_local 8
                          i32.store offset=8
                          br 8 (;@3;)
                        end
                        get_local 0
                        get_local 6
                        get_local 5
                        i32.or
                        i32.store
                        get_local 1
                        set_local 5
                      end
                      get_local 1
                      i32.const 8
                      i32.add
                      get_local 4
                      i32.store
                      get_local 5
                      get_local 4
                      i32.store offset=12
                      get_local 4
                      get_local 1
                      i32.store offset=12
                      get_local 4
                      get_local 5
                      i32.store offset=8
                    end
                    get_local 0
                    i32.const 404
                    i32.add
                    tee_local 1
                    i32.load
                    tee_local 4
                    get_local 3
                    i32.le_u
                    br_if 0 (;@8;)
                    get_local 1
                    get_local 4
                    get_local 3
                    i32.sub
                    tee_local 4
                    i32.store
                    get_local 0
                    i32.const 412
                    i32.add
                    tee_local 1
                    get_local 1
                    i32.load
                    tee_local 1
                    get_local 3
                    i32.add
                    tee_local 5
                    i32.store
                    get_local 5
                    get_local 4
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    get_local 1
                    get_local 3
                    i32.const 3
                    i32.or
                    i32.store offset=4
                    get_local 1
                    i32.const 8
                    i32.add
                    return
                  end
                  get_local 2
                  return
                end
                get_local 4
                get_local 1
                i32.store
                get_local 0
                i32.const 404
                i32.add
                tee_local 4
                get_local 4
                i32.load
                get_local 3
                i32.add
                tee_local 3
                i32.store
                get_local 1
                get_local 3
                i32.const 1
                i32.or
                i32.store offset=4
                br 5 (;@1;)
              end
              get_local 0
              i32.const 408
              i32.add
              get_local 1
              i32.store
              get_local 0
              i32.const 400
              i32.add
              tee_local 4
              get_local 4
              i32.load
              get_local 3
              i32.add
              tee_local 3
              i32.store
              get_local 1
              get_local 3
              i32.const 1
              i32.or
              i32.store offset=4
              get_local 1
              get_local 3
              i32.add
              get_local 3
              i32.store
              br 4 (;@1;)
            end
            get_local 0
            get_local 5
            call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
            br 1 (;@3;)
          end
          get_local 0
          get_local 0
          i32.load
          i32.const -2
          get_local 4
          i32.const 3
          i32.shr_u
          i32.rotl
          i32.and
          i32.store
        end
        get_local 2
        get_local 3
        i32.add
        set_local 3
        get_local 5
        get_local 2
        i32.add
        set_local 5
      end
      get_local 5
      get_local 5
      i32.load offset=4
      i32.const -2
      i32.and
      i32.store offset=4
      get_local 1
      get_local 3
      i32.const 1
      i32.or
      i32.store offset=4
      get_local 1
      get_local 3
      i32.add
      get_local 3
      i32.store
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 3
            i32.const 255
            i32.gt_u
            br_if 0 (;@4;)
            get_local 0
            get_local 3
            i32.const 3
            i32.shr_u
            tee_local 4
            i32.const 3
            i32.shl
            i32.add
            i32.const 8
            i32.add
            set_local 3
            get_local 0
            i32.load
            tee_local 5
            i32.const 1
            get_local 4
            i32.const 31
            i32.and
            i32.shl
            tee_local 4
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            get_local 3
            i32.const 8
            i32.add
            set_local 5
            get_local 3
            i32.load offset=8
            set_local 4
            br 2 (;@2;)
          end
          get_local 0
          get_local 1
          get_local 3
          call $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e
          br 2 (;@1;)
        end
        get_local 0
        get_local 5
        get_local 4
        i32.or
        i32.store
        get_local 3
        i32.const 8
        i32.add
        set_local 5
        get_local 3
        set_local 4
      end
      get_local 5
      get_local 1
      i32.store
      get_local 4
      get_local 1
      i32.store offset=12
      get_local 1
      get_local 3
      i32.store offset=12
      get_local 1
      get_local 4
      i32.store offset=8
    end
    get_local 6
    i32.const 8
    i32.add)
  (func $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636 (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    get_local 1
    i32.load offset=24
    set_local 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 1
            i32.load offset=12
            tee_local 3
            get_local 1
            i32.eq
            br_if 0 (;@4;)
            get_local 1
            i32.load offset=8
            tee_local 4
            get_local 3
            i32.store offset=12
            get_local 3
            get_local 4
            i32.store offset=8
            get_local 2
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          block  ;; label = @4
            get_local 1
            i32.const 20
            i32.const 16
            get_local 1
            i32.const 20
            i32.add
            tee_local 3
            i32.load
            tee_local 5
            select
            i32.add
            i32.load
            tee_local 4
            i32.eqz
            br_if 0 (;@4;)
            get_local 3
            get_local 1
            i32.const 16
            i32.add
            get_local 5
            select
            set_local 5
            block  ;; label = @5
              loop  ;; label = @6
                get_local 5
                set_local 6
                block  ;; label = @7
                  get_local 4
                  tee_local 3
                  i32.const 20
                  i32.add
                  tee_local 5
                  i32.load
                  tee_local 4
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 4
                  br_if 1 (;@6;)
                  br 2 (;@5;)
                end
                get_local 3
                i32.const 16
                i32.add
                set_local 5
                get_local 3
                i32.load offset=16
                tee_local 4
                br_if 0 (;@6;)
              end
            end
            get_local 6
            i32.const 0
            i32.store
            get_local 2
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          i32.const 0
          set_local 3
          get_local 2
          i32.eqz
          br_if 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            get_local 0
            get_local 1
            i32.load offset=28
            i32.const 2
            i32.shl
            i32.add
            i32.const 272
            i32.add
            tee_local 4
            i32.load
            get_local 1
            i32.eq
            br_if 0 (;@4;)
            get_local 2
            i32.const 16
            i32.const 20
            get_local 2
            i32.load offset=16
            get_local 1
            i32.eq
            select
            i32.add
            get_local 3
            i32.store
            get_local 3
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          get_local 4
          get_local 3
          i32.store
          get_local 3
          i32.eqz
          br_if 2 (;@1;)
        end
        get_local 3
        get_local 2
        i32.store offset=24
        block  ;; label = @3
          get_local 1
          i32.load offset=16
          tee_local 4
          i32.eqz
          br_if 0 (;@3;)
          get_local 3
          get_local 4
          i32.store offset=16
          get_local 4
          get_local 3
          i32.store offset=24
        end
        get_local 1
        i32.const 20
        i32.add
        i32.load
        tee_local 4
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        i32.const 20
        i32.add
        get_local 4
        i32.store
        get_local 4
        get_local 3
        i32.store offset=24
      end
      return
    end
    get_local 0
    get_local 0
    i32.load offset=4
    i32.const -2
    get_local 1
    i32.const 28
    i32.add
    i32.load
    i32.rotl
    i32.and
    i32.store offset=4)
  (func $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e (type 4) (param i32 i32 i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 2
        i32.const 8
        i32.shr_u
        tee_local 3
        i32.eqz
        br_if 0 (;@2;)
        i32.const 31
        set_local 4
        get_local 2
        i32.const 16777215
        i32.gt_u
        br_if 1 (;@1;)
        get_local 2
        i32.const 38
        get_local 3
        i32.clz
        tee_local 4
        i32.sub
        i32.const 31
        i32.and
        i32.shr_u
        i32.const 1
        i32.and
        i32.const 31
        get_local 4
        i32.sub
        i32.const 1
        i32.shl
        i32.or
        set_local 4
        br 1 (;@1;)
      end
      i32.const 0
      set_local 4
    end
    get_local 1
    get_local 4
    i32.store offset=28
    get_local 1
    i64.const 0
    i64.store offset=16 align=4
    get_local 0
    get_local 4
    i32.const 2
    i32.shl
    i32.add
    i32.const 272
    i32.add
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 0
              i32.load offset=4
              tee_local 5
              i32.const 1
              get_local 4
              i32.const 31
              i32.and
              i32.shl
              tee_local 6
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              get_local 3
              i32.load
              tee_local 3
              i32.load offset=4
              i32.const -8
              i32.and
              get_local 2
              i32.ne
              br_if 1 (;@4;)
              get_local 3
              set_local 4
              br 2 (;@3;)
            end
            get_local 0
            i32.const 4
            i32.add
            get_local 5
            get_local 6
            i32.or
            i32.store
            get_local 3
            get_local 1
            i32.store
            get_local 1
            get_local 3
            i32.store offset=24
            br 3 (;@1;)
          end
          get_local 2
          i32.const 0
          i32.const 25
          get_local 4
          i32.const 1
          i32.shr_u
          i32.sub
          i32.const 31
          i32.and
          get_local 4
          i32.const 31
          i32.eq
          select
          i32.shl
          set_local 0
          loop  ;; label = @4
            get_local 3
            get_local 0
            i32.const 29
            i32.shr_u
            i32.const 4
            i32.and
            i32.add
            i32.const 16
            i32.add
            tee_local 5
            i32.load
            tee_local 4
            i32.eqz
            br_if 2 (;@2;)
            get_local 0
            i32.const 1
            i32.shl
            set_local 0
            get_local 4
            set_local 3
            get_local 4
            i32.load offset=4
            i32.const -8
            i32.and
            get_local 2
            i32.ne
            br_if 0 (;@4;)
          end
        end
        get_local 4
        i32.load offset=8
        tee_local 0
        get_local 1
        i32.store offset=12
        get_local 4
        get_local 1
        i32.store offset=8
        get_local 1
        get_local 4
        i32.store offset=12
        get_local 1
        get_local 0
        i32.store offset=8
        get_local 1
        i32.const 0
        i32.store offset=24
        return
      end
      get_local 5
      get_local 1
      i32.store
      get_local 1
      get_local 3
      i32.store offset=24
    end
    get_local 1
    get_local 1
    i32.store offset=12
    get_local 1
    get_local 1
    i32.store offset=8)
  (func $dlmalloc::dlmalloc::Dlmalloc::realloc::h8cf6613b53581308 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const 0
    set_local 3
    block  ;; label = @1
      get_local 2
      i32.const -65
      i32.gt_u
      br_if 0 (;@1;)
      i32.const 16
      get_local 2
      i32.const 11
      i32.add
      i32.const -8
      i32.and
      get_local 2
      i32.const 11
      i32.lt_u
      select
      set_local 4
      get_local 1
      i32.const -4
      i32.add
      tee_local 5
      i32.load
      tee_local 6
      i32.const -8
      i32.and
      set_local 7
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 6
                          i32.const 3
                          i32.and
                          i32.eqz
                          br_if 0 (;@11;)
                          get_local 1
                          i32.const -8
                          i32.add
                          tee_local 8
                          get_local 7
                          i32.add
                          set_local 9
                          get_local 7
                          get_local 4
                          i32.ge_u
                          br_if 1 (;@10;)
                          get_local 0
                          i32.load offset=412
                          get_local 9
                          i32.eq
                          br_if 2 (;@9;)
                          get_local 0
                          i32.load offset=408
                          get_local 9
                          i32.eq
                          br_if 3 (;@8;)
                          get_local 9
                          i32.load offset=4
                          tee_local 6
                          i32.const 2
                          i32.and
                          br_if 4 (;@7;)
                          get_local 6
                          i32.const -8
                          i32.and
                          tee_local 10
                          get_local 7
                          i32.add
                          tee_local 7
                          get_local 4
                          i32.lt_u
                          br_if 4 (;@7;)
                          get_local 7
                          get_local 4
                          i32.sub
                          set_local 2
                          get_local 10
                          i32.const 255
                          i32.gt_u
                          br_if 6 (;@5;)
                          get_local 9
                          i32.load offset=12
                          tee_local 3
                          get_local 9
                          i32.load offset=8
                          tee_local 9
                          i32.eq
                          br_if 7 (;@4;)
                          get_local 9
                          get_local 3
                          i32.store offset=12
                          get_local 3
                          get_local 9
                          i32.store offset=8
                          br 8 (;@3;)
                        end
                        get_local 4
                        i32.const 256
                        i32.lt_u
                        br_if 3 (;@7;)
                        get_local 7
                        get_local 4
                        i32.const 4
                        i32.or
                        i32.lt_u
                        br_if 3 (;@7;)
                        get_local 7
                        get_local 4
                        i32.sub
                        i32.const 131073
                        i32.lt_u
                        br_if 8 (;@2;)
                        br 3 (;@7;)
                      end
                      get_local 7
                      get_local 4
                      i32.sub
                      tee_local 2
                      i32.const 16
                      i32.lt_u
                      br_if 7 (;@2;)
                      get_local 5
                      get_local 4
                      get_local 6
                      i32.const 1
                      i32.and
                      i32.or
                      i32.const 2
                      i32.or
                      i32.store
                      get_local 8
                      get_local 4
                      i32.add
                      tee_local 3
                      get_local 2
                      i32.const 3
                      i32.or
                      i32.store offset=4
                      get_local 9
                      get_local 9
                      i32.load offset=4
                      i32.const 1
                      i32.or
                      i32.store offset=4
                      get_local 0
                      get_local 3
                      get_local 2
                      call $dlmalloc::dlmalloc::Dlmalloc::dispose_chunk::h83b6b8854a7b250d
                      br 7 (;@2;)
                    end
                    get_local 0
                    i32.load offset=404
                    get_local 7
                    i32.add
                    tee_local 7
                    get_local 4
                    i32.le_u
                    br_if 1 (;@7;)
                    get_local 5
                    get_local 4
                    get_local 6
                    i32.const 1
                    i32.and
                    i32.or
                    i32.const 2
                    i32.or
                    i32.store
                    get_local 8
                    get_local 4
                    i32.add
                    tee_local 2
                    get_local 7
                    get_local 4
                    i32.sub
                    tee_local 3
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    get_local 0
                    i32.const 404
                    i32.add
                    get_local 3
                    i32.store
                    get_local 0
                    i32.const 412
                    i32.add
                    get_local 2
                    i32.store
                    br 6 (;@2;)
                  end
                  get_local 0
                  i32.load offset=400
                  get_local 7
                  i32.add
                  tee_local 7
                  get_local 4
                  i32.ge_u
                  br_if 1 (;@6;)
                end
                get_local 0
                get_local 2
                call $dlmalloc::dlmalloc::Dlmalloc::malloc::hc4b4efc85b47ad98
                tee_local 4
                i32.eqz
                br_if 5 (;@1;)
                get_local 4
                get_local 1
                get_local 2
                get_local 5
                i32.load
                tee_local 3
                i32.const -8
                i32.and
                i32.const 4
                i32.const 8
                get_local 3
                i32.const 3
                i32.and
                select
                i32.sub
                tee_local 3
                get_local 3
                get_local 2
                i32.gt_u
                select
                call $memcpy
                set_local 2
                get_local 0
                get_local 1
                call $dlmalloc::dlmalloc::Dlmalloc::free::h0d2004392fdc1454
                get_local 2
                return
              end
              block  ;; label = @6
                block  ;; label = @7
                  get_local 7
                  get_local 4
                  i32.sub
                  tee_local 2
                  i32.const 16
                  i32.ge_u
                  br_if 0 (;@7;)
                  get_local 5
                  get_local 6
                  i32.const 1
                  i32.and
                  get_local 7
                  i32.or
                  i32.const 2
                  i32.or
                  i32.store
                  get_local 8
                  get_local 7
                  i32.add
                  tee_local 2
                  get_local 2
                  i32.load offset=4
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  i32.const 0
                  set_local 2
                  i32.const 0
                  set_local 3
                  br 1 (;@6;)
                end
                get_local 5
                get_local 4
                get_local 6
                i32.const 1
                i32.and
                i32.or
                i32.const 2
                i32.or
                i32.store
                get_local 8
                get_local 4
                i32.add
                tee_local 3
                get_local 2
                i32.const 1
                i32.or
                i32.store offset=4
                get_local 8
                get_local 7
                i32.add
                tee_local 4
                get_local 2
                i32.store
                get_local 4
                get_local 4
                i32.load offset=4
                i32.const -2
                i32.and
                i32.store offset=4
              end
              get_local 0
              i32.const 408
              i32.add
              get_local 3
              i32.store
              get_local 0
              i32.const 400
              i32.add
              get_local 2
              i32.store
              br 3 (;@2;)
            end
            get_local 0
            get_local 9
            call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
            br 1 (;@3;)
          end
          get_local 0
          get_local 0
          i32.load
          i32.const -2
          get_local 6
          i32.const 3
          i32.shr_u
          i32.rotl
          i32.and
          i32.store
        end
        block  ;; label = @3
          get_local 2
          i32.const 15
          i32.gt_u
          br_if 0 (;@3;)
          get_local 5
          get_local 7
          get_local 5
          i32.load
          i32.const 1
          i32.and
          i32.or
          i32.const 2
          i32.or
          i32.store
          get_local 8
          get_local 7
          i32.add
          tee_local 2
          get_local 2
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          br 1 (;@2;)
        end
        get_local 5
        get_local 4
        get_local 5
        i32.load
        i32.const 1
        i32.and
        i32.or
        i32.const 2
        i32.or
        i32.store
        get_local 8
        get_local 4
        i32.add
        tee_local 3
        get_local 2
        i32.const 3
        i32.or
        i32.store offset=4
        get_local 8
        get_local 7
        i32.add
        tee_local 4
        get_local 4
        i32.load offset=4
        i32.const 1
        i32.or
        i32.store offset=4
        get_local 0
        get_local 3
        get_local 2
        call $dlmalloc::dlmalloc::Dlmalloc::dispose_chunk::h83b6b8854a7b250d
      end
      get_local 1
      set_local 3
    end
    get_local 3)
  (func $dlmalloc::dlmalloc::Dlmalloc::dispose_chunk::h83b6b8854a7b250d (type 4) (param i32 i32 i32)
    (local i32 i32 i32 i32)
    get_local 1
    get_local 2
    i32.add
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 1
                    i32.load offset=4
                    tee_local 4
                    i32.const 1
                    i32.and
                    br_if 0 (;@8;)
                    get_local 4
                    i32.const 3
                    i32.and
                    i32.eqz
                    br_if 1 (;@7;)
                    get_local 1
                    i32.load
                    tee_local 4
                    get_local 2
                    i32.add
                    set_local 2
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 0
                          i32.load offset=408
                          get_local 1
                          get_local 4
                          i32.sub
                          tee_local 1
                          i32.eq
                          br_if 0 (;@11;)
                          get_local 4
                          i32.const 255
                          i32.gt_u
                          br_if 1 (;@10;)
                          get_local 1
                          i32.load offset=12
                          tee_local 5
                          get_local 1
                          i32.load offset=8
                          tee_local 6
                          i32.eq
                          br_if 2 (;@9;)
                          get_local 6
                          get_local 5
                          i32.store offset=12
                          get_local 5
                          get_local 6
                          i32.store offset=8
                          br 3 (;@8;)
                        end
                        get_local 3
                        i32.load offset=4
                        i32.const 3
                        i32.and
                        i32.const 3
                        i32.ne
                        br_if 2 (;@8;)
                        get_local 0
                        get_local 2
                        i32.store offset=400
                        get_local 3
                        i32.const 4
                        i32.add
                        tee_local 0
                        get_local 0
                        i32.load
                        i32.const -2
                        i32.and
                        i32.store
                        get_local 1
                        get_local 2
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        get_local 3
                        get_local 2
                        i32.store
                        return
                      end
                      get_local 0
                      get_local 1
                      call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
                      br 1 (;@8;)
                    end
                    get_local 0
                    get_local 0
                    i32.load
                    i32.const -2
                    get_local 4
                    i32.const 3
                    i32.shr_u
                    i32.rotl
                    i32.and
                    i32.store
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 3
                      i32.load offset=4
                      tee_local 4
                      i32.const 2
                      i32.and
                      br_if 0 (;@9;)
                      get_local 0
                      i32.load offset=412
                      get_local 3
                      i32.eq
                      br_if 1 (;@8;)
                      get_local 0
                      i32.load offset=408
                      get_local 3
                      i32.eq
                      br_if 3 (;@6;)
                      get_local 4
                      i32.const -8
                      i32.and
                      tee_local 5
                      get_local 2
                      i32.add
                      set_local 2
                      get_local 5
                      i32.const 255
                      i32.gt_u
                      br_if 4 (;@5;)
                      get_local 3
                      i32.load offset=12
                      tee_local 5
                      get_local 3
                      i32.load offset=8
                      tee_local 3
                      i32.eq
                      br_if 6 (;@3;)
                      get_local 3
                      get_local 5
                      i32.store offset=12
                      get_local 5
                      get_local 3
                      i32.store offset=8
                      br 7 (;@2;)
                    end
                    get_local 3
                    i32.const 4
                    i32.add
                    get_local 4
                    i32.const -2
                    i32.and
                    i32.store
                    get_local 1
                    get_local 2
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    get_local 1
                    get_local 2
                    i32.add
                    get_local 2
                    i32.store
                    br 7 (;@1;)
                  end
                  get_local 0
                  i32.const 412
                  i32.add
                  get_local 1
                  i32.store
                  get_local 0
                  get_local 0
                  i32.load offset=404
                  get_local 2
                  i32.add
                  tee_local 2
                  i32.store offset=404
                  get_local 1
                  get_local 2
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  get_local 1
                  get_local 0
                  i32.load offset=408
                  i32.eq
                  br_if 3 (;@4;)
                end
                return
              end
              get_local 0
              i32.const 408
              i32.add
              get_local 1
              i32.store
              get_local 0
              get_local 0
              i32.load offset=400
              get_local 2
              i32.add
              tee_local 2
              i32.store offset=400
              get_local 1
              get_local 2
              i32.const 1
              i32.or
              i32.store offset=4
              get_local 1
              get_local 2
              i32.add
              get_local 2
              i32.store
              return
            end
            get_local 0
            get_local 3
            call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
            br 2 (;@2;)
          end
          get_local 0
          i32.const 0
          i32.store offset=400
          get_local 0
          i32.const 408
          i32.add
          i32.const 0
          i32.store
          return
        end
        get_local 0
        get_local 0
        i32.load
        i32.const -2
        get_local 4
        i32.const 3
        i32.shr_u
        i32.rotl
        i32.and
        i32.store
      end
      get_local 1
      get_local 2
      i32.const 1
      i32.or
      i32.store offset=4
      get_local 1
      get_local 2
      i32.add
      get_local 2
      i32.store
      get_local 1
      get_local 0
      i32.const 408
      i32.add
      i32.load
      i32.ne
      br_if 0 (;@1;)
      get_local 0
      get_local 2
      i32.store offset=400
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 2
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
          get_local 0
          get_local 2
          i32.const 3
          i32.shr_u
          tee_local 3
          i32.const 3
          i32.shl
          i32.add
          i32.const 8
          i32.add
          set_local 2
          get_local 0
          i32.load
          tee_local 4
          i32.const 1
          get_local 3
          i32.const 31
          i32.and
          i32.shl
          tee_local 3
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          get_local 2
          i32.load offset=8
          set_local 0
          br 2 (;@1;)
        end
        get_local 0
        get_local 1
        get_local 2
        call $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e
        return
      end
      get_local 0
      get_local 4
      get_local 3
      i32.or
      i32.store
      get_local 2
      set_local 0
    end
    get_local 2
    i32.const 8
    i32.add
    get_local 1
    i32.store
    get_local 0
    get_local 1
    i32.store offset=12
    get_local 1
    get_local 2
    i32.store offset=12
    get_local 1
    get_local 0
    i32.store offset=8)
  (func $dlmalloc::dlmalloc::Dlmalloc::free::h0d2004392fdc1454 (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    get_local 1
    i32.const -8
    i32.add
    tee_local 2
    get_local 1
    i32.const -4
    i32.add
    i32.load
    tee_local 3
    i32.const -8
    i32.and
    tee_local 1
    i32.add
    set_local 4
    block  ;; label = @1
      block  ;; label = @2
        get_local 3
        i32.const 1
        i32.and
        br_if 0 (;@2;)
        get_local 3
        i32.const 3
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        get_local 2
        i32.load
        tee_local 3
        get_local 1
        i32.add
        set_local 1
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 0
              i32.load offset=408
              get_local 2
              get_local 3
              i32.sub
              tee_local 2
              i32.eq
              br_if 0 (;@5;)
              get_local 3
              i32.const 255
              i32.gt_u
              br_if 1 (;@4;)
              get_local 2
              i32.load offset=12
              tee_local 5
              get_local 2
              i32.load offset=8
              tee_local 6
              i32.eq
              br_if 2 (;@3;)
              get_local 6
              get_local 5
              i32.store offset=12
              get_local 5
              get_local 6
              i32.store offset=8
              br 3 (;@2;)
            end
            get_local 4
            i32.load offset=4
            i32.const 3
            i32.and
            i32.const 3
            i32.ne
            br_if 2 (;@2;)
            get_local 0
            get_local 1
            i32.store offset=400
            get_local 4
            i32.const 4
            i32.add
            tee_local 0
            get_local 0
            i32.load
            i32.const -2
            i32.and
            i32.store
            get_local 2
            get_local 1
            i32.const 1
            i32.or
            i32.store offset=4
            get_local 2
            get_local 1
            i32.add
            get_local 1
            i32.store
            return
          end
          get_local 0
          get_local 2
          call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
          br 1 (;@2;)
        end
        get_local 0
        get_local 0
        i32.load
        i32.const -2
        get_local 3
        i32.const 3
        i32.shr_u
        i32.rotl
        i32.and
        i32.store
      end
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        get_local 4
                        i32.load offset=4
                        tee_local 3
                        i32.const 2
                        i32.and
                        br_if 0 (;@10;)
                        get_local 0
                        i32.load offset=412
                        get_local 4
                        i32.eq
                        br_if 1 (;@9;)
                        get_local 0
                        i32.load offset=408
                        get_local 4
                        i32.eq
                        br_if 2 (;@8;)
                        get_local 3
                        i32.const -8
                        i32.and
                        tee_local 5
                        get_local 1
                        i32.add
                        set_local 1
                        get_local 5
                        i32.const 255
                        i32.gt_u
                        br_if 3 (;@7;)
                        get_local 4
                        i32.load offset=12
                        tee_local 5
                        get_local 4
                        i32.load offset=8
                        tee_local 4
                        i32.eq
                        br_if 4 (;@6;)
                        get_local 4
                        get_local 5
                        i32.store offset=12
                        get_local 5
                        get_local 4
                        i32.store offset=8
                        br 5 (;@5;)
                      end
                      get_local 4
                      i32.const 4
                      i32.add
                      get_local 3
                      i32.const -2
                      i32.and
                      i32.store
                      get_local 2
                      get_local 1
                      i32.const 1
                      i32.or
                      i32.store offset=4
                      get_local 2
                      get_local 1
                      i32.add
                      get_local 1
                      i32.store
                      br 7 (;@2;)
                    end
                    get_local 0
                    i32.const 412
                    i32.add
                    get_local 2
                    i32.store
                    get_local 0
                    get_local 0
                    i32.load offset=404
                    get_local 1
                    i32.add
                    tee_local 1
                    i32.store offset=404
                    get_local 2
                    get_local 1
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    block  ;; label = @9
                      get_local 2
                      get_local 0
                      i32.load offset=408
                      i32.ne
                      br_if 0 (;@9;)
                      get_local 0
                      i32.const 0
                      i32.store offset=400
                      get_local 0
                      i32.const 408
                      i32.add
                      i32.const 0
                      i32.store
                    end
                    get_local 0
                    i32.load offset=440
                    tee_local 3
                    get_local 1
                    i32.ge_u
                    br_if 7 (;@1;)
                    get_local 0
                    i32.const 412
                    i32.add
                    i32.load
                    tee_local 1
                    i32.eqz
                    br_if 7 (;@1;)
                    block  ;; label = @9
                      get_local 0
                      i32.const 404
                      i32.add
                      i32.load
                      tee_local 5
                      i32.const 41
                      i32.lt_u
                      br_if 0 (;@9;)
                      get_local 0
                      i32.const 424
                      i32.add
                      set_local 2
                      loop  ;; label = @10
                        block  ;; label = @11
                          get_local 2
                          i32.load
                          tee_local 4
                          get_local 1
                          i32.gt_u
                          br_if 0 (;@11;)
                          get_local 4
                          get_local 2
                          i32.load offset=4
                          i32.add
                          get_local 1
                          i32.gt_u
                          br_if 2 (;@9;)
                        end
                        get_local 2
                        i32.load offset=8
                        tee_local 2
                        br_if 0 (;@10;)
                      end
                    end
                    get_local 0
                    i32.const 432
                    i32.add
                    i32.load
                    tee_local 1
                    i32.eqz
                    br_if 4 (;@4;)
                    i32.const 0
                    set_local 2
                    loop  ;; label = @9
                      get_local 2
                      i32.const 1
                      i32.add
                      set_local 2
                      get_local 1
                      i32.load offset=8
                      tee_local 1
                      br_if 0 (;@9;)
                    end
                    get_local 2
                    i32.const 4095
                    get_local 2
                    i32.const 4095
                    i32.gt_u
                    select
                    set_local 2
                    br 5 (;@3;)
                  end
                  get_local 0
                  i32.const 408
                  i32.add
                  get_local 2
                  i32.store
                  get_local 0
                  get_local 0
                  i32.load offset=400
                  get_local 1
                  i32.add
                  tee_local 1
                  i32.store offset=400
                  get_local 2
                  get_local 1
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  get_local 2
                  get_local 1
                  i32.add
                  get_local 1
                  i32.store
                  return
                end
                get_local 0
                get_local 4
                call $dlmalloc::dlmalloc::Dlmalloc::unlink_large_chunk::h5f69fa82f808e636
                br 1 (;@5;)
              end
              get_local 0
              get_local 0
              i32.load
              i32.const -2
              get_local 3
              i32.const 3
              i32.shr_u
              i32.rotl
              i32.and
              i32.store
            end
            get_local 2
            get_local 1
            i32.const 1
            i32.or
            i32.store offset=4
            get_local 2
            get_local 1
            i32.add
            get_local 1
            i32.store
            get_local 2
            get_local 0
            i32.const 408
            i32.add
            i32.load
            i32.ne
            br_if 2 (;@2;)
            get_local 0
            get_local 1
            i32.store offset=400
            return
          end
          i32.const 4095
          set_local 2
        end
        get_local 0
        get_local 2
        i32.store offset=448
        get_local 5
        get_local 3
        i32.le_u
        br_if 1 (;@1;)
        get_local 0
        i32.const 440
        i32.add
        i32.const -1
        i32.store
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 1
                i32.const 255
                i32.gt_u
                br_if 0 (;@6;)
                get_local 0
                get_local 1
                i32.const 3
                i32.shr_u
                tee_local 4
                i32.const 3
                i32.shl
                i32.add
                i32.const 8
                i32.add
                set_local 1
                get_local 0
                i32.load
                tee_local 3
                i32.const 1
                get_local 4
                i32.const 31
                i32.and
                i32.shl
                tee_local 4
                i32.and
                i32.eqz
                br_if 1 (;@5;)
                get_local 1
                i32.const 8
                i32.add
                set_local 4
                get_local 1
                i32.load offset=8
                set_local 0
                br 2 (;@4;)
              end
              get_local 0
              get_local 2
              get_local 1
              call $dlmalloc::dlmalloc::Dlmalloc::insert_large_chunk::hc595b2d0b29c409e
              get_local 0
              get_local 0
              i32.load offset=448
              i32.const -1
              i32.add
              tee_local 2
              i32.store offset=448
              get_local 2
              br_if 4 (;@1;)
              get_local 0
              i32.const 432
              i32.add
              i32.load
              tee_local 1
              i32.eqz
              br_if 2 (;@3;)
              i32.const 0
              set_local 2
              loop  ;; label = @6
                get_local 2
                i32.const 1
                i32.add
                set_local 2
                get_local 1
                i32.load offset=8
                tee_local 1
                br_if 0 (;@6;)
              end
              get_local 2
              i32.const 4095
              get_local 2
              i32.const 4095
              i32.gt_u
              select
              set_local 2
              br 3 (;@2;)
            end
            get_local 0
            get_local 3
            get_local 4
            i32.or
            i32.store
            get_local 1
            i32.const 8
            i32.add
            set_local 4
            get_local 1
            set_local 0
          end
          get_local 4
          get_local 2
          i32.store
          get_local 0
          get_local 2
          i32.store offset=12
          get_local 2
          get_local 1
          i32.store offset=12
          get_local 2
          get_local 0
          i32.store offset=8
          return
        end
        i32.const 4095
        set_local 2
      end
      get_local 0
      i32.const 448
      i32.add
      get_local 2
      i32.store
    end)
  (func $dlmalloc::dlmalloc::Dlmalloc::memalign::hc38379e02a35d971 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    i32.const 0
    set_local 3
    block  ;; label = @1
      i32.const -64
      get_local 1
      i32.const 16
      get_local 1
      i32.const 16
      i32.gt_u
      select
      tee_local 1
      i32.sub
      get_local 2
      i32.le_u
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      i32.const 16
      get_local 2
      i32.const 11
      i32.add
      i32.const -8
      i32.and
      get_local 2
      i32.const 11
      i32.lt_u
      select
      tee_local 4
      i32.add
      i32.const 12
      i32.add
      call $dlmalloc::dlmalloc::Dlmalloc::malloc::hc4b4efc85b47ad98
      tee_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 2
      i32.const -8
      i32.add
      set_local 3
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 1
            i32.const -1
            i32.add
            tee_local 5
            get_local 2
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            get_local 2
            i32.const -4
            i32.add
            tee_local 6
            i32.load
            tee_local 7
            i32.const -8
            i32.and
            get_local 5
            get_local 2
            i32.add
            i32.const 0
            get_local 1
            i32.sub
            i32.and
            i32.const -8
            i32.add
            tee_local 2
            get_local 2
            get_local 1
            i32.add
            get_local 2
            get_local 3
            i32.sub
            i32.const 16
            i32.gt_u
            select
            tee_local 1
            get_local 3
            i32.sub
            tee_local 2
            i32.sub
            set_local 5
            get_local 7
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            get_local 1
            get_local 5
            get_local 1
            i32.load offset=4
            i32.const 1
            i32.and
            i32.or
            i32.const 2
            i32.or
            i32.store offset=4
            get_local 1
            get_local 5
            i32.add
            tee_local 5
            get_local 5
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            get_local 6
            get_local 2
            get_local 6
            i32.load
            i32.const 1
            i32.and
            i32.or
            i32.const 2
            i32.or
            i32.store
            get_local 1
            get_local 1
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            get_local 0
            get_local 3
            get_local 2
            call $dlmalloc::dlmalloc::Dlmalloc::dispose_chunk::h83b6b8854a7b250d
            br 2 (;@2;)
          end
          get_local 3
          set_local 1
          br 1 (;@2;)
        end
        get_local 3
        i32.load
        set_local 3
        get_local 1
        get_local 5
        i32.store offset=4
        get_local 1
        get_local 3
        get_local 2
        i32.add
        i32.store
      end
      block  ;; label = @2
        get_local 1
        i32.load offset=4
        tee_local 2
        i32.const 3
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        get_local 2
        i32.const -8
        i32.and
        tee_local 3
        get_local 4
        i32.const 16
        i32.add
        i32.le_u
        br_if 0 (;@2;)
        get_local 1
        i32.const 4
        i32.add
        get_local 4
        get_local 2
        i32.const 1
        i32.and
        i32.or
        i32.const 2
        i32.or
        i32.store
        get_local 1
        get_local 4
        i32.add
        tee_local 2
        get_local 3
        get_local 4
        i32.sub
        tee_local 4
        i32.const 3
        i32.or
        i32.store offset=4
        get_local 1
        get_local 3
        i32.add
        tee_local 3
        get_local 3
        i32.load offset=4
        i32.const 1
        i32.or
        i32.store offset=4
        get_local 0
        get_local 2
        get_local 4
        call $dlmalloc::dlmalloc::Dlmalloc::dispose_chunk::h83b6b8854a7b250d
      end
      get_local 1
      i32.const 8
      i32.add
      set_local 3
    end
    get_local 3)
  (func $_$LT$alloc..string..String$u20$as$u20$core..convert..From$LT$$RF$$u27$a$u20$str$GT$$GT$::from::hb3fb17fd74da80e4 (type 4) (param i32 i32 i32)
    get_local 0
    get_local 1
    get_local 2
    call $alloc::slice::_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$$u5b$T$u5d$$GT$::to_owned::hf1a38ccfac4748f5)
  (func $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::allocate_in::_$u7b$$u7b$closure$u7d$$u7d$::h953aad8dc33cc9e0__.llvm.4757690692208659995_ (type 6)
    call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
    unreachable)
  (func $alloc::raw_vec::capacity_overflow::hbc659f170a622eae (type 6)
    i32.const 1056484
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h40f163e7c4ee673d__.llvm.4757690692208659995_ (type 11) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32)
    i32.const 2
    set_local 5
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 0
          i32.load offset=4
          tee_local 6
          get_local 1
          i32.sub
          get_local 2
          i32.ge_u
          br_if 0 (;@3;)
          get_local 1
          get_local 2
          i32.add
          tee_local 2
          get_local 1
          i32.lt_u
          set_local 1
          block  ;; label = @4
            block  ;; label = @5
              get_local 4
              i32.eqz
              br_if 0 (;@5;)
              i32.const 0
              set_local 5
              get_local 1
              br_if 2 (;@3;)
              get_local 6
              i32.const 1
              i32.shl
              tee_local 1
              get_local 2
              get_local 2
              get_local 1
              i32.lt_u
              select
              set_local 2
              br 1 (;@4;)
            end
            i32.const 0
            set_local 5
            get_local 1
            br_if 1 (;@3;)
          end
          i32.const 0
          set_local 5
          get_local 2
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 6
                i32.eqz
                br_if 0 (;@6;)
                get_local 0
                i32.load
                get_local 6
                i32.const 1
                get_local 2
                call $__rust_realloc
                tee_local 1
                i32.eqz
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              get_local 2
              i32.const 1
              call $__rust_alloc
              tee_local 1
              br_if 1 (;@4;)
            end
            get_local 3
            br_if 3 (;@1;)
          end
          get_local 1
          i32.eqz
          br_if 1 (;@2;)
          get_local 0
          get_local 1
          i32.store
          get_local 0
          i32.const 4
          i32.add
          get_local 2
          i32.store
          i32.const 2
          set_local 5
        end
        get_local 5
        return
      end
      i32.const 1
      return
    end
    get_local 2
    i32.const 1
    call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
    unreachable)
  (func $alloc::alloc::handle_alloc_error::h9e3787e5722c870d (type 2) (param i32 i32)
    get_local 0
    get_local 1
    call $rust_oom
    unreachable)
  (func $core::slice::_$LT$impl$u20$$u5b$T$u5d$$GT$::copy_from_slice::h7dcce653b07c008a (type 9) (param i32 i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 96
    i32.sub
    tee_local 4
    set_global 0
    get_local 4
    get_local 1
    i32.store offset=8
    get_local 4
    get_local 3
    i32.store offset=12
    get_local 4
    get_local 4
    i32.const 8
    i32.add
    i32.store offset=16
    get_local 4
    get_local 4
    i32.const 12
    i32.add
    i32.store offset=20
    block  ;; label = @1
      get_local 1
      get_local 3
      i32.ne
      br_if 0 (;@1;)
      get_local 0
      get_local 2
      get_local 1
      call $memcpy
      drop
      get_local 4
      i32.const 96
      i32.add
      set_global 0
      return
    end
    get_local 4
    i32.const 72
    i32.add
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    get_local 4
    i32.const 48
    i32.add
    i32.const 12
    i32.add
    i32.const 59
    i32.store
    get_local 4
    i32.const 48
    i32.add
    i32.const 20
    i32.add
    i32.const 38
    i32.store
    get_local 4
    i32.const 24
    i32.add
    i32.const 12
    i32.add
    i32.const 3
    i32.store
    get_local 4
    i32.const 24
    i32.add
    i32.const 20
    i32.add
    i32.const 3
    i32.store
    get_local 4
    i32.const 1056532
    i32.store offset=72
    get_local 4
    i64.const 1
    i64.store offset=76 align=4
    get_local 4
    i32.const 1050912
    i32.store offset=88
    get_local 4
    i32.const 59
    i32.store offset=52
    get_local 4
    i32.const 1056508
    i32.store offset=24
    get_local 4
    i32.const 3
    i32.store offset=28
    get_local 4
    i32.const 1050912
    i32.store offset=32
    get_local 4
    get_local 4
    i32.const 16
    i32.add
    i32.store offset=48
    get_local 4
    get_local 4
    i32.const 20
    i32.add
    i32.store offset=56
    get_local 4
    get_local 4
    i32.const 72
    i32.add
    i32.store offset=64
    get_local 4
    get_local 4
    i32.const 48
    i32.add
    i32.store offset=40
    get_local 4
    i32.const 24
    i32.add
    i32.const 1056540
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $alloc::slice::_$LT$impl$u20$alloc..borrow..ToOwned$u20$for$u20$$u5b$T$u5d$$GT$::to_owned::hf1a38ccfac4748f5 (type 4) (param i32 i32 i32)
    (local i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 3
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 2
            i32.const -1
            i32.le_s
            br_if 0 (;@4;)
            i32.const 1
            set_local 4
            block  ;; label = @5
              get_local 2
              i32.eqz
              br_if 0 (;@5;)
              get_local 2
              i32.const 1
              call $__rust_alloc
              tee_local 4
              i32.eqz
              br_if 3 (;@2;)
            end
            get_local 3
            get_local 4
            i32.store
            get_local 3
            get_local 2
            i32.store offset=4
            get_local 3
            i32.const 0
            i32.store offset=8
            get_local 3
            i32.const 0
            get_local 2
            i32.const 1
            i32.const 1
            call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::reserve_internal::h40f163e7c4ee673d__.llvm.4757690692208659995_
            i32.const 255
            i32.and
            tee_local 4
            i32.const 2
            i32.ne
            br_if 1 (;@3;)
            get_local 3
            i32.const 8
            i32.add
            tee_local 4
            get_local 4
            i32.load
            tee_local 5
            get_local 2
            i32.add
            i32.store
            get_local 5
            get_local 3
            i32.load
            i32.add
            get_local 2
            get_local 1
            get_local 2
            call $core::slice::_$LT$impl$u20$$u5b$T$u5d$$GT$::copy_from_slice::h7dcce653b07c008a
            get_local 0
            i32.const 8
            i32.add
            get_local 4
            i32.load
            i32.store
            get_local 0
            get_local 3
            i64.load
            i64.store align=4
            get_local 3
            i32.const 16
            i32.add
            set_global 0
            return
          end
          call $_$LT$alloc..raw_vec..RawVec$LT$T$C$$u20$A$GT$$GT$::allocate_in::_$u7b$$u7b$closure$u7d$$u7d$::h953aad8dc33cc9e0__.llvm.4757690692208659995_
          unreachable
        end
        get_local 4
        i32.const 1
        i32.and
        br_if 1 (;@1;)
        call $alloc::raw_vec::capacity_overflow::hbc659f170a622eae
        unreachable
      end
      get_local 2
      i32.const 1
      call $alloc::alloc::handle_alloc_error::h9e3787e5722c870d
      unreachable
    end
    i32.const 1056460
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::he390991cf7dc224a (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    set_local 0
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_lower_hex::h92753715ffe745e5
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$usize$GT$::fmt::hd9abdaddf8084036
      return
    end
    block  ;; label = @1
      get_local 1
      call $core::fmt::Formatter::debug_upper_hex::h872e32477651ad01
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      call $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$usize$GT$::fmt::h7c305e4bc8e93fb6
      return
    end
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$::fmt::h7543c3fa290cf95c (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32)
    get_global 0
    i32.const 128
    i32.sub
    tee_local 2
    set_global 0
    get_local 0
    i32.load
    set_local 3
    i32.const 0
    set_local 0
    loop  ;; label = @1
      get_local 2
      get_local 0
      i32.add
      i32.const 127
      i32.add
      get_local 3
      i32.const 15
      i32.and
      tee_local 4
      i32.const 48
      i32.or
      get_local 4
      i32.const 87
      i32.add
      get_local 4
      i32.const 10
      i32.lt_u
      select
      i32.store8
      get_local 0
      i32.const -1
      i32.add
      set_local 0
      get_local 3
      i32.const 4
      i32.shr_u
      tee_local 3
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      get_local 0
      i32.const 128
      i32.add
      tee_local 3
      i32.const 129
      i32.ge_u
      br_if 0 (;@1;)
      get_local 1
      i32.const 1
      i32.const 1051040
      i32.const 2
      get_local 2
      get_local 0
      i32.add
      i32.const 128
      i32.add
      i32.const 0
      get_local 0
      i32.sub
      call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
      set_local 0
      get_local 2
      i32.const 128
      i32.add
      set_global 0
      get_local 0
      return
    end
    get_local 3
    i32.const 128
    call $core::slice::slice_index_order_fail::hc6db54a13869566a
    unreachable)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$::fmt::h1bef50aed415726b (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32)
    get_global 0
    i32.const 128
    i32.sub
    tee_local 2
    set_global 0
    get_local 0
    i32.load
    set_local 3
    i32.const 0
    set_local 0
    loop  ;; label = @1
      get_local 2
      get_local 0
      i32.add
      i32.const 127
      i32.add
      get_local 3
      i32.const 15
      i32.and
      tee_local 4
      i32.const 48
      i32.or
      get_local 4
      i32.const 55
      i32.add
      get_local 4
      i32.const 10
      i32.lt_u
      select
      i32.store8
      get_local 0
      i32.const -1
      i32.add
      set_local 0
      get_local 3
      i32.const 4
      i32.shr_u
      tee_local 3
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      get_local 0
      i32.const 128
      i32.add
      tee_local 3
      i32.const 129
      i32.ge_u
      br_if 0 (;@1;)
      get_local 1
      i32.const 1
      i32.const 1051040
      i32.const 2
      get_local 2
      get_local 0
      i32.add
      i32.const 128
      i32.add
      i32.const 0
      get_local 0
      i32.sub
      call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
      set_local 0
      get_local 2
      i32.const 128
      i32.add
      set_global 0
      get_local 0
      return
    end
    get_local 3
    i32.const 128
    call $core::slice::slice_index_order_fail::hc6db54a13869566a
    unreachable)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$::fmt::hcecd1e62e7515144 (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    i32.const 39
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.load
        tee_local 4
        get_local 4
        i32.const 31
        i32.shr_s
        tee_local 0
        i32.add
        get_local 0
        i32.xor
        tee_local 0
        i32.const 10000
        i32.lt_u
        br_if 0 (;@2;)
        i32.const 39
        set_local 3
        loop  ;; label = @3
          get_local 2
          i32.const 9
          i32.add
          get_local 3
          i32.add
          tee_local 5
          i32.const -4
          i32.add
          get_local 0
          get_local 0
          i32.const 10000
          i32.div_u
          tee_local 6
          i32.const 10000
          i32.mul
          i32.sub
          tee_local 7
          i32.const 100
          i32.div_u
          tee_local 8
          i32.const 1
          i32.shl
          i32.const 1051042
          i32.add
          i32.load16_u align=1
          i32.store16 align=1
          get_local 5
          i32.const -2
          i32.add
          get_local 7
          get_local 8
          i32.const 100
          i32.mul
          i32.sub
          i32.const 1
          i32.shl
          i32.const 1051042
          i32.add
          i32.load16_u align=1
          i32.store16 align=1
          get_local 3
          i32.const -4
          i32.add
          set_local 3
          get_local 0
          i32.const 99999999
          i32.gt_u
          set_local 5
          get_local 6
          set_local 0
          get_local 5
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      get_local 0
      set_local 6
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 6
        i32.const 100
        i32.lt_s
        br_if 0 (;@2;)
        get_local 2
        i32.const 9
        i32.add
        get_local 3
        i32.const -2
        i32.add
        tee_local 3
        i32.add
        get_local 6
        get_local 6
        i32.const 65535
        i32.and
        i32.const 100
        i32.div_u
        tee_local 0
        i32.const 100
        i32.mul
        i32.sub
        i32.const 65535
        i32.and
        i32.const 1
        i32.shl
        i32.const 1051042
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        br 1 (;@1;)
      end
      get_local 6
      set_local 0
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.const 9
        i32.gt_s
        br_if 0 (;@2;)
        get_local 2
        i32.const 9
        i32.add
        get_local 3
        i32.const -1
        i32.add
        tee_local 3
        i32.add
        tee_local 6
        get_local 0
        i32.const 48
        i32.add
        i32.store8
        br 1 (;@1;)
      end
      get_local 2
      i32.const 9
      i32.add
      get_local 3
      i32.const -2
      i32.add
      tee_local 3
      i32.add
      tee_local 6
      get_local 0
      i32.const 1
      i32.shl
      i32.const 1051042
      i32.add
      i32.load16_u align=1
      i32.store16 align=1
    end
    get_local 1
    get_local 4
    i32.const -1
    i32.xor
    i32.const 31
    i32.shr_u
    i32.const 1051042
    i32.const 0
    get_local 6
    i32.const 39
    get_local 3
    i32.sub
    call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
    set_local 0
    get_local 2
    i32.const 48
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h94a2123718ad2fae (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    i32.const 39
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.load
        tee_local 0
        i32.const 10000
        i32.lt_u
        br_if 0 (;@2;)
        i32.const 39
        set_local 3
        loop  ;; label = @3
          get_local 2
          i32.const 9
          i32.add
          get_local 3
          i32.add
          tee_local 4
          i32.const -4
          i32.add
          get_local 0
          get_local 0
          i32.const 10000
          i32.div_u
          tee_local 5
          i32.const 10000
          i32.mul
          i32.sub
          tee_local 6
          i32.const 100
          i32.div_u
          tee_local 7
          i32.const 1
          i32.shl
          i32.const 1051042
          i32.add
          i32.load16_u align=1
          i32.store16 align=1
          get_local 4
          i32.const -2
          i32.add
          get_local 6
          get_local 7
          i32.const 100
          i32.mul
          i32.sub
          i32.const 1
          i32.shl
          i32.const 1051042
          i32.add
          i32.load16_u align=1
          i32.store16 align=1
          get_local 3
          i32.const -4
          i32.add
          set_local 3
          get_local 0
          i32.const 99999999
          i32.gt_u
          set_local 4
          get_local 5
          set_local 0
          get_local 4
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      get_local 0
      set_local 5
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 5
        i32.const 100
        i32.lt_s
        br_if 0 (;@2;)
        get_local 2
        i32.const 9
        i32.add
        get_local 3
        i32.const -2
        i32.add
        tee_local 3
        i32.add
        get_local 5
        get_local 5
        i32.const 65535
        i32.and
        i32.const 100
        i32.div_u
        tee_local 0
        i32.const 100
        i32.mul
        i32.sub
        i32.const 65535
        i32.and
        i32.const 1
        i32.shl
        i32.const 1051042
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        br 1 (;@1;)
      end
      get_local 5
      set_local 0
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.const 9
        i32.gt_s
        br_if 0 (;@2;)
        get_local 2
        i32.const 9
        i32.add
        get_local 3
        i32.const -1
        i32.add
        tee_local 3
        i32.add
        tee_local 5
        get_local 0
        i32.const 48
        i32.add
        i32.store8
        br 1 (;@1;)
      end
      get_local 2
      i32.const 9
      i32.add
      get_local 3
      i32.const -2
      i32.add
      tee_local 3
      i32.add
      tee_local 5
      get_local 0
      i32.const 1
      i32.shl
      i32.const 1051042
      i32.add
      i32.load16_u align=1
      i32.store16 align=1
    end
    get_local 1
    i32.const 1
    i32.const 1051042
    i32.const 0
    get_local 5
    i32.const 39
    get_local 3
    i32.sub
    call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
    set_local 0
    get_local 2
    i32.const 48
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$usize$GT$::fmt::hd9abdaddf8084036 (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$::fmt::h7543c3fa290cf95c)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$usize$GT$::fmt::h7c305e4bc8e93fb6 (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$::fmt::h1bef50aed415726b)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h94a2123718ad2fae)
  (func $core::slice::memchr::memchr::hc2eca95742004aba (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    i32.const 0
    set_local 4
    block  ;; label = @1
      block  ;; label = @2
        get_local 2
        i32.const 3
        i32.and
        tee_local 5
        i32.eqz
        br_if 0 (;@2;)
        i32.const 4
        get_local 5
        i32.sub
        tee_local 5
        i32.eqz
        br_if 0 (;@2;)
        get_local 2
        get_local 3
        get_local 5
        get_local 5
        get_local 3
        i32.gt_u
        select
        tee_local 4
        i32.add
        set_local 6
        i32.const 0
        set_local 5
        get_local 1
        i32.const 255
        i32.and
        set_local 7
        get_local 4
        set_local 8
        get_local 2
        set_local 9
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              get_local 6
              get_local 9
              i32.sub
              i32.const 3
              i32.le_u
              br_if 1 (;@4;)
              get_local 5
              get_local 9
              i32.load8_u
              tee_local 10
              get_local 7
              i32.ne
              i32.add
              set_local 5
              get_local 10
              get_local 7
              i32.eq
              br_if 2 (;@3;)
              get_local 5
              get_local 9
              i32.const 1
              i32.add
              i32.load8_u
              tee_local 10
              get_local 7
              i32.ne
              i32.add
              set_local 5
              get_local 10
              get_local 7
              i32.eq
              br_if 2 (;@3;)
              get_local 5
              get_local 9
              i32.const 2
              i32.add
              i32.load8_u
              tee_local 10
              get_local 7
              i32.ne
              i32.add
              set_local 5
              get_local 10
              get_local 7
              i32.eq
              br_if 2 (;@3;)
              get_local 5
              get_local 9
              i32.const 3
              i32.add
              i32.load8_u
              tee_local 10
              get_local 7
              i32.ne
              i32.add
              set_local 5
              get_local 8
              i32.const -4
              i32.add
              set_local 8
              get_local 9
              i32.const 4
              i32.add
              set_local 9
              get_local 10
              get_local 7
              i32.ne
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          i32.const 0
          set_local 7
          get_local 1
          i32.const 255
          i32.and
          set_local 6
          loop  ;; label = @4
            get_local 8
            i32.eqz
            br_if 2 (;@2;)
            get_local 9
            get_local 7
            i32.add
            set_local 10
            get_local 8
            i32.const -1
            i32.add
            set_local 8
            get_local 7
            i32.const 1
            i32.add
            set_local 7
            get_local 10
            i32.load8_u
            tee_local 10
            get_local 6
            i32.ne
            br_if 0 (;@4;)
          end
          get_local 10
          get_local 1
          i32.const 255
          i32.and
          i32.eq
          i32.const 1
          i32.add
          i32.const 1
          i32.and
          get_local 5
          i32.add
          get_local 7
          i32.add
          i32.const -1
          i32.add
          set_local 5
        end
        i32.const 1
        set_local 9
        br 1 (;@1;)
      end
      get_local 1
      i32.const 255
      i32.and
      set_local 7
      block  ;; label = @2
        block  ;; label = @3
          get_local 3
          i32.const 8
          i32.lt_u
          br_if 0 (;@3;)
          get_local 4
          get_local 3
          i32.const -8
          i32.add
          tee_local 10
          i32.gt_u
          br_if 0 (;@3;)
          get_local 7
          i32.const 16843009
          i32.mul
          set_local 5
          block  ;; label = @4
            loop  ;; label = @5
              get_local 2
              get_local 4
              i32.add
              tee_local 9
              i32.const 4
              i32.add
              i32.load
              get_local 5
              i32.xor
              tee_local 8
              i32.const -1
              i32.xor
              get_local 8
              i32.const -16843009
              i32.add
              i32.and
              get_local 9
              i32.load
              get_local 5
              i32.xor
              tee_local 9
              i32.const -1
              i32.xor
              get_local 9
              i32.const -16843009
              i32.add
              i32.and
              i32.or
              i32.const -2139062144
              i32.and
              br_if 1 (;@4;)
              get_local 4
              i32.const 8
              i32.add
              tee_local 4
              get_local 10
              i32.le_u
              br_if 0 (;@5;)
            end
          end
          get_local 4
          get_local 3
          i32.gt_u
          br_if 1 (;@2;)
        end
        get_local 2
        get_local 4
        i32.add
        set_local 9
        get_local 2
        get_local 3
        i32.add
        set_local 2
        get_local 3
        get_local 4
        i32.sub
        set_local 8
        i32.const 0
        set_local 5
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                get_local 2
                get_local 9
                i32.sub
                i32.const 3
                i32.le_u
                br_if 1 (;@5;)
                get_local 5
                get_local 9
                i32.load8_u
                tee_local 10
                get_local 7
                i32.ne
                i32.add
                set_local 5
                get_local 10
                get_local 7
                i32.eq
                br_if 2 (;@4;)
                get_local 5
                get_local 9
                i32.const 1
                i32.add
                i32.load8_u
                tee_local 10
                get_local 7
                i32.ne
                i32.add
                set_local 5
                get_local 10
                get_local 7
                i32.eq
                br_if 2 (;@4;)
                get_local 5
                get_local 9
                i32.const 2
                i32.add
                i32.load8_u
                tee_local 10
                get_local 7
                i32.ne
                i32.add
                set_local 5
                get_local 10
                get_local 7
                i32.eq
                br_if 2 (;@4;)
                get_local 5
                get_local 9
                i32.const 3
                i32.add
                i32.load8_u
                tee_local 10
                get_local 7
                i32.ne
                i32.add
                set_local 5
                get_local 8
                i32.const -4
                i32.add
                set_local 8
                get_local 9
                i32.const 4
                i32.add
                set_local 9
                get_local 10
                get_local 7
                i32.ne
                br_if 0 (;@6;)
                br 2 (;@4;)
              end
            end
            i32.const 0
            set_local 7
            get_local 1
            i32.const 255
            i32.and
            set_local 2
            loop  ;; label = @5
              get_local 8
              i32.eqz
              br_if 2 (;@3;)
              get_local 9
              get_local 7
              i32.add
              set_local 10
              get_local 8
              i32.const -1
              i32.add
              set_local 8
              get_local 7
              i32.const 1
              i32.add
              set_local 7
              get_local 10
              i32.load8_u
              tee_local 10
              get_local 2
              i32.ne
              br_if 0 (;@5;)
            end
            get_local 10
            get_local 1
            i32.const 255
            i32.and
            i32.eq
            i32.const 1
            i32.add
            i32.const 1
            i32.and
            get_local 5
            i32.add
            get_local 7
            i32.add
            i32.const -1
            i32.add
            set_local 5
          end
          i32.const 1
          set_local 9
          get_local 5
          get_local 4
          i32.add
          set_local 5
          br 2 (;@1;)
        end
        i32.const 0
        set_local 9
        get_local 5
        get_local 7
        i32.add
        get_local 4
        i32.add
        set_local 5
        br 1 (;@1;)
      end
      get_local 4
      get_local 3
      call $core::slice::slice_index_order_fail::hc6db54a13869566a
      unreachable
    end
    get_local 0
    get_local 5
    i32.store offset=4
    get_local 0
    get_local 9
    i32.store)
  (func $core::slice::memchr::memrchr::hf4d2adc392d0f856 (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const 0
    set_local 4
    get_local 3
    set_local 5
    get_local 3
    set_local 6
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 4
              get_local 2
              i32.const 3
              i32.and
              tee_local 7
              i32.sub
              i32.const 0
              get_local 7
              select
              tee_local 7
              get_local 3
              i32.gt_u
              br_if 0 (;@5;)
              get_local 3
              get_local 3
              get_local 7
              i32.sub
              i32.const 7
              i32.and
              tee_local 8
              i32.sub
              set_local 5
              get_local 8
              get_local 3
              i32.gt_u
              br_if 1 (;@4;)
              get_local 7
              set_local 6
            end
            get_local 2
            get_local 3
            i32.add
            tee_local 9
            get_local 2
            get_local 5
            i32.add
            tee_local 10
            i32.sub
            set_local 11
            get_local 5
            get_local 3
            i32.sub
            set_local 12
            get_local 1
            i32.const 255
            i32.and
            set_local 7
            get_local 9
            set_local 8
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        loop  ;; label = @11
                          get_local 8
                          get_local 10
                          i32.sub
                          i32.const 3
                          i32.le_u
                          br_if 1 (;@10;)
                          get_local 9
                          get_local 4
                          i32.add
                          tee_local 8
                          i32.const -1
                          i32.add
                          i32.load8_u
                          get_local 7
                          i32.eq
                          br_if 2 (;@9;)
                          get_local 8
                          i32.const -2
                          i32.add
                          i32.load8_u
                          get_local 7
                          i32.eq
                          br_if 3 (;@8;)
                          get_local 8
                          i32.const -3
                          i32.add
                          i32.load8_u
                          get_local 7
                          i32.eq
                          br_if 4 (;@7;)
                          get_local 4
                          i32.const -4
                          i32.add
                          set_local 4
                          get_local 8
                          i32.const -4
                          i32.add
                          tee_local 8
                          i32.load8_u
                          get_local 7
                          i32.ne
                          br_if 0 (;@11;)
                        end
                        get_local 11
                        get_local 4
                        i32.add
                        set_local 7
                        br 4 (;@6;)
                      end
                      get_local 12
                      get_local 4
                      i32.sub
                      set_local 7
                      get_local 9
                      get_local 4
                      i32.add
                      set_local 10
                      i32.const 0
                      set_local 8
                      get_local 1
                      i32.const 255
                      i32.and
                      set_local 12
                      loop  ;; label = @10
                        get_local 7
                        i32.eqz
                        br_if 5 (;@5;)
                        get_local 10
                        get_local 8
                        i32.add
                        set_local 9
                        get_local 7
                        i32.const 1
                        i32.add
                        set_local 7
                        get_local 8
                        i32.const -1
                        i32.add
                        set_local 8
                        get_local 9
                        i32.const -1
                        i32.add
                        i32.load8_u
                        get_local 12
                        i32.ne
                        br_if 0 (;@10;)
                      end
                      get_local 11
                      get_local 4
                      i32.add
                      get_local 8
                      i32.add
                      set_local 7
                      br 3 (;@6;)
                    end
                    get_local 11
                    get_local 4
                    i32.add
                    i32.const -1
                    i32.add
                    set_local 7
                    br 2 (;@6;)
                  end
                  get_local 11
                  get_local 4
                  i32.add
                  i32.const -2
                  i32.add
                  set_local 7
                  br 1 (;@6;)
                end
                get_local 11
                get_local 4
                i32.add
                i32.const -3
                i32.add
                set_local 7
              end
              get_local 7
              get_local 5
              i32.add
              set_local 7
              br 3 (;@2;)
            end
            get_local 1
            i32.const 255
            i32.and
            i32.const 16843009
            i32.mul
            set_local 8
            block  ;; label = @5
              loop  ;; label = @6
                get_local 5
                tee_local 7
                get_local 6
                i32.le_u
                br_if 1 (;@5;)
                get_local 7
                i32.const -8
                i32.add
                set_local 5
                get_local 2
                get_local 7
                i32.add
                tee_local 4
                i32.const -4
                i32.add
                i32.load
                get_local 8
                i32.xor
                tee_local 9
                i32.const -1
                i32.xor
                get_local 9
                i32.const -16843009
                i32.add
                i32.and
                get_local 4
                i32.const -8
                i32.add
                i32.load
                get_local 8
                i32.xor
                tee_local 4
                i32.const -1
                i32.xor
                get_local 4
                i32.const -16843009
                i32.add
                i32.and
                i32.or
                i32.const -2139062144
                i32.and
                i32.eqz
                br_if 0 (;@6;)
              end
            end
            get_local 7
            get_local 3
            i32.gt_u
            br_if 1 (;@3;)
            get_local 1
            i32.const 255
            i32.and
            set_local 8
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      loop  ;; label = @10
                        get_local 2
                        get_local 7
                        i32.add
                        set_local 4
                        get_local 7
                        i32.const 3
                        i32.le_u
                        br_if 1 (;@9;)
                        get_local 4
                        i32.const -1
                        i32.add
                        tee_local 4
                        i32.load8_u
                        get_local 8
                        i32.eq
                        br_if 2 (;@8;)
                        get_local 4
                        i32.const -1
                        i32.add
                        tee_local 4
                        i32.load8_u
                        get_local 8
                        i32.eq
                        br_if 3 (;@7;)
                        get_local 4
                        i32.const -1
                        i32.add
                        tee_local 4
                        i32.load8_u
                        get_local 8
                        i32.eq
                        br_if 4 (;@6;)
                        get_local 7
                        i32.const -4
                        i32.add
                        set_local 7
                        get_local 4
                        i32.const -1
                        i32.add
                        i32.load8_u
                        get_local 8
                        i32.ne
                        br_if 0 (;@10;)
                        br 8 (;@2;)
                      end
                    end
                    i32.const 0
                    set_local 8
                    get_local 1
                    i32.const 255
                    i32.and
                    set_local 5
                    loop  ;; label = @9
                      get_local 7
                      get_local 8
                      i32.add
                      tee_local 9
                      i32.eqz
                      br_if 4 (;@5;)
                      get_local 4
                      get_local 8
                      i32.add
                      set_local 9
                      get_local 8
                      i32.const -1
                      i32.add
                      set_local 8
                      get_local 9
                      i32.const -1
                      i32.add
                      i32.load8_u
                      get_local 5
                      i32.ne
                      br_if 0 (;@9;)
                    end
                    get_local 7
                    get_local 8
                    i32.add
                    set_local 7
                    br 6 (;@2;)
                  end
                  get_local 7
                  i32.const -1
                  i32.add
                  set_local 7
                  br 5 (;@2;)
                end
                get_local 7
                i32.const -2
                i32.add
                set_local 7
                br 4 (;@2;)
              end
              get_local 7
              i32.const -3
              i32.add
              set_local 7
              br 3 (;@2;)
            end
            i32.const 0
            set_local 8
            get_local 9
            set_local 7
            br 3 (;@1;)
          end
          get_local 5
          get_local 3
          call $core::slice::slice_index_order_fail::hc6db54a13869566a
          unreachable
        end
        get_local 7
        get_local 3
        call $core::slice::slice_index_len_fail::h776973317ada24d7
        unreachable
      end
      i32.const 1
      set_local 8
    end
    get_local 0
    get_local 7
    i32.store offset=4
    get_local 0
    get_local 8
    i32.store)
  (func $core::unicode::printable::check::hd50959afb6736fa2__.llvm.16502875661543772795_ (type 12) (param i32 i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    i32.const 1
    set_local 7
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 2
                i32.eqz
                br_if 0 (;@6;)
                get_local 1
                get_local 2
                i32.const 1
                i32.shl
                i32.add
                set_local 8
                get_local 0
                i32.const 65280
                i32.and
                i32.const 8
                i32.shr_u
                set_local 9
                i32.const 0
                set_local 10
                get_local 0
                i32.const 255
                i32.and
                set_local 11
                loop  ;; label = @7
                  get_local 1
                  i32.const 2
                  i32.add
                  set_local 12
                  get_local 10
                  get_local 1
                  i32.load8_u offset=1
                  tee_local 2
                  i32.add
                  set_local 13
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 1
                      i32.load8_u
                      tee_local 1
                      get_local 9
                      i32.ne
                      br_if 0 (;@9;)
                      get_local 13
                      get_local 10
                      i32.lt_u
                      br_if 7 (;@2;)
                      get_local 13
                      get_local 4
                      i32.gt_u
                      br_if 8 (;@1;)
                      get_local 3
                      get_local 10
                      i32.add
                      set_local 1
                      loop  ;; label = @10
                        get_local 2
                        i32.eqz
                        br_if 2 (;@8;)
                        get_local 2
                        i32.const -1
                        i32.add
                        set_local 2
                        get_local 1
                        i32.load8_u
                        set_local 10
                        get_local 1
                        i32.const 1
                        i32.add
                        set_local 1
                        get_local 10
                        get_local 11
                        i32.ne
                        br_if 0 (;@10;)
                        br 5 (;@5;)
                      end
                    end
                    get_local 1
                    get_local 9
                    i32.gt_u
                    br_if 2 (;@6;)
                    get_local 13
                    set_local 10
                    get_local 12
                    set_local 1
                    get_local 12
                    get_local 8
                    i32.ne
                    br_if 1 (;@7;)
                    br 2 (;@6;)
                  end
                  get_local 13
                  set_local 10
                  get_local 12
                  set_local 1
                  get_local 12
                  get_local 8
                  i32.ne
                  br_if 0 (;@7;)
                end
              end
              get_local 6
              i32.eqz
              br_if 1 (;@4;)
              get_local 5
              get_local 6
              i32.add
              set_local 11
              get_local 0
              i32.const 65535
              i32.and
              set_local 10
              get_local 5
              i32.const 1
              i32.add
              set_local 2
              i32.const 1
              set_local 7
              loop  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 5
                    i32.load8_u
                    tee_local 1
                    i32.const 24
                    i32.shl
                    i32.const 24
                    i32.shr_s
                    tee_local 13
                    i32.const -1
                    i32.le_s
                    br_if 0 (;@8;)
                    get_local 2
                    set_local 5
                    br 1 (;@7;)
                  end
                  get_local 2
                  get_local 11
                  i32.eq
                  br_if 4 (;@3;)
                  get_local 2
                  i32.const 1
                  i32.add
                  set_local 5
                  get_local 13
                  i32.const 127
                  i32.and
                  i32.const 8
                  i32.shl
                  get_local 2
                  i32.load8_u
                  i32.or
                  set_local 1
                end
                get_local 10
                get_local 1
                i32.sub
                tee_local 10
                i32.const 0
                i32.lt_s
                br_if 2 (;@4;)
                get_local 5
                i32.const 1
                i32.add
                set_local 2
                get_local 7
                i32.const 1
                i32.xor
                set_local 7
                get_local 5
                get_local 11
                i32.ne
                br_if 0 (;@6;)
                br 2 (;@4;)
              end
            end
            i32.const 0
            set_local 7
          end
          get_local 7
          i32.const 1
          i32.and
          return
        end
        i32.const 1056556
        call $core::panicking::panic::h9b4aaddfe00d4a7f
        unreachable
      end
      get_local 10
      get_local 13
      call $core::slice::slice_index_order_fail::hc6db54a13869566a
      unreachable
    end
    get_local 13
    get_local 4
    call $core::slice::slice_index_len_fail::h776973317ada24d7
    unreachable)
  (func $core::unicode::printable::is_printable::h4739125d958c237d (type 10) (param i32) (result i32)
    block  ;; label = @1
      get_local 0
      i32.const 65535
      i32.gt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 1051302
      i32.const 40
      i32.const 1051382
      i32.const 303
      i32.const 1051685
      i32.const 316
      call $core::unicode::printable::check::hd50959afb6736fa2__.llvm.16502875661543772795_
      return
    end
    block  ;; label = @1
      get_local 0
      i32.const 131071
      i32.gt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 1052001
      i32.const 33
      i32.const 1052067
      i32.const 158
      i32.const 1052225
      i32.const 381
      call $core::unicode::printable::check::hd50959afb6736fa2__.llvm.16502875661543772795_
      return
    end
    block  ;; label = @1
      get_local 0
      i32.const -195102
      i32.add
      i32.const 722658
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const -191457
      i32.add
      i32.const 3103
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const -183970
      i32.add
      i32.const 14
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 2097150
      i32.and
      i32.const 178206
      i32.eq
      br_if 0 (;@1;)
      get_local 0
      i32.const -173783
      i32.add
      i32.const 41
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const -177973
      i32.add
      i32.const 10
      i32.le_u
      br_if 0 (;@1;)
      get_local 0
      i32.const -918000
      i32.add
      i32.const 196111
      i32.gt_u
      return
    end
    i32.const 0)
  (func $core::slice::slice_index_len_fail::h776973317ada24d7 (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=4
    get_local 2
    get_local 0
    i32.store
    get_local 2
    i32.const 32
    i32.add
    i32.const 12
    i32.add
    i32.const 7
    i32.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 7
    i32.store offset=36
    get_local 2
    i32.const 1056580
    i32.store offset=8
    get_local 2
    i32.const 2
    i32.store offset=12
    get_local 2
    i32.const 1052608
    i32.store offset=16
    get_local 2
    get_local 2
    i32.store offset=32
    get_local 2
    get_local 2
    i32.const 4
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 32
    i32.add
    i32.store offset=24
    get_local 2
    i32.const 8
    i32.add
    i32.const 1056596
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $core::slice::slice_index_order_fail::hc6db54a13869566a (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=4
    get_local 2
    get_local 0
    i32.store
    get_local 2
    i32.const 32
    i32.add
    i32.const 12
    i32.add
    i32.const 7
    i32.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 7
    i32.store offset=36
    get_local 2
    i32.const 1056612
    i32.store offset=8
    get_local 2
    i32.const 2
    i32.store offset=12
    get_local 2
    i32.const 1052608
    i32.store offset=16
    get_local 2
    get_local 2
    i32.store offset=32
    get_local 2
    get_local 2
    i32.const 4
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 32
    i32.add
    i32.store offset=24
    get_local 2
    i32.const 8
    i32.add
    i32.const 1056628
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $core::str::slice_error_fail::hb9184500007bb4cb (type 9) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 112
    i32.sub
    tee_local 4
    set_global 0
    get_local 4
    get_local 3
    i32.store offset=12
    get_local 4
    get_local 2
    i32.store offset=8
    i32.const 1
    set_local 5
    get_local 1
    set_local 6
    block  ;; label = @1
      get_local 1
      i32.const 257
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 0
      get_local 1
      i32.sub
      set_local 7
      i32.const 256
      set_local 8
      block  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            get_local 8
            get_local 1
            i32.ge_u
            br_if 0 (;@4;)
            get_local 0
            get_local 8
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            br_if 2 (;@2;)
          end
          get_local 8
          i32.const -1
          i32.add
          set_local 6
          i32.const 0
          set_local 5
          get_local 8
          i32.const 1
          i32.eq
          br_if 2 (;@1;)
          get_local 7
          get_local 8
          i32.add
          set_local 9
          get_local 6
          set_local 8
          get_local 9
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      set_local 5
      get_local 8
      set_local 6
    end
    get_local 4
    get_local 6
    i32.store offset=20
    get_local 4
    get_local 0
    i32.store offset=16
    get_local 4
    i32.const 0
    i32.const 5
    get_local 5
    select
    i32.store offset=28
    get_local 4
    i32.const 1053096
    i32.const 1053091
    get_local 5
    select
    i32.store offset=24
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 2
                get_local 1
                i32.gt_u
                tee_local 8
                br_if 0 (;@6;)
                get_local 3
                get_local 1
                i32.gt_u
                br_if 0 (;@6;)
                get_local 2
                get_local 3
                i32.gt_u
                br_if 4 (;@2;)
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 2
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 1
                    get_local 2
                    i32.eq
                    br_if 0 (;@8;)
                    get_local 1
                    get_local 2
                    i32.le_u
                    br_if 1 (;@7;)
                    get_local 0
                    get_local 2
                    i32.add
                    i32.load8_s
                    i32.const -64
                    i32.lt_s
                    br_if 1 (;@7;)
                  end
                  get_local 3
                  set_local 2
                end
                get_local 4
                get_local 2
                i32.store offset=32
                get_local 2
                i32.eqz
                br_if 1 (;@5;)
                get_local 2
                get_local 1
                i32.eq
                br_if 1 (;@5;)
                get_local 1
                i32.const 1
                i32.add
                set_local 9
                block  ;; label = @7
                  loop  ;; label = @8
                    block  ;; label = @9
                      get_local 2
                      get_local 1
                      i32.ge_u
                      br_if 0 (;@9;)
                      get_local 0
                      get_local 2
                      i32.add
                      tee_local 6
                      i32.load8_s
                      i32.const -65
                      i32.gt_s
                      br_if 2 (;@7;)
                    end
                    get_local 2
                    i32.const -1
                    i32.add
                    set_local 8
                    get_local 2
                    i32.const 1
                    i32.eq
                    br_if 4 (;@4;)
                    get_local 9
                    get_local 2
                    i32.eq
                    set_local 6
                    get_local 8
                    set_local 2
                    get_local 6
                    i32.eqz
                    br_if 0 (;@8;)
                    br 4 (;@4;)
                  end
                end
                get_local 2
                set_local 8
                br 3 (;@3;)
              end
              get_local 4
              get_local 2
              get_local 3
              get_local 8
              select
              i32.store offset=40
              get_local 4
              i32.const 72
              i32.add
              i32.const 12
              i32.add
              i32.const 60
              i32.store
              get_local 4
              i32.const 72
              i32.add
              i32.const 20
              i32.add
              i32.const 60
              i32.store
              get_local 4
              i32.const 48
              i32.add
              i32.const 12
              i32.add
              i32.const 3
              i32.store
              get_local 4
              i32.const 48
              i32.add
              i32.const 20
              i32.add
              i32.const 3
              i32.store
              get_local 4
              i32.const 7
              i32.store offset=76
              get_local 4
              i32.const 1056668
              i32.store offset=48
              get_local 4
              i32.const 3
              i32.store offset=52
              get_local 4
              i32.const 1053132
              i32.store offset=56
              get_local 4
              get_local 4
              i32.const 40
              i32.add
              i32.store offset=72
              get_local 4
              get_local 4
              i32.const 16
              i32.add
              i32.store offset=80
              get_local 4
              get_local 4
              i32.const 24
              i32.add
              i32.store offset=88
              get_local 4
              get_local 4
              i32.const 72
              i32.add
              i32.store offset=64
              get_local 4
              i32.const 48
              i32.add
              i32.const 1056692
              call $core::panicking::panic_fmt::h2155aa66b67fe83c
              unreachable
            end
            get_local 2
            set_local 8
          end
          get_local 0
          get_local 8
          i32.add
          set_local 6
        end
        get_local 6
        get_local 0
        get_local 1
        i32.add
        tee_local 2
        i32.eq
        br_if 1 (;@1;)
        i32.const 1
        set_local 1
        i32.const 0
        set_local 9
        block  ;; label = @3
          block  ;; label = @4
            get_local 6
            i32.load8_s
            tee_local 6
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
            get_local 4
            get_local 6
            i32.const 255
            i32.and
            i32.store offset=36
            br 1 (;@3;)
          end
          get_local 2
          set_local 1
          block  ;; label = @4
            get_local 0
            get_local 8
            i32.add
            tee_local 0
            i32.const 1
            i32.add
            get_local 2
            i32.eq
            br_if 0 (;@4;)
            get_local 0
            i32.const 2
            i32.add
            set_local 1
            get_local 0
            i32.const 1
            i32.add
            i32.load8_u
            i32.const 63
            i32.and
            set_local 9
          end
          get_local 6
          i32.const 31
          i32.and
          set_local 0
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 6
                i32.const 255
                i32.and
                i32.const 224
                i32.lt_u
                br_if 0 (;@6;)
                i32.const 0
                set_local 5
                get_local 2
                set_local 7
                block  ;; label = @7
                  get_local 1
                  get_local 2
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 1
                  i32.const 1
                  i32.add
                  set_local 7
                  get_local 1
                  i32.load8_u
                  i32.const 63
                  i32.and
                  set_local 5
                end
                get_local 5
                get_local 9
                i32.const 6
                i32.shl
                i32.or
                set_local 1
                get_local 6
                i32.const 255
                i32.and
                i32.const 240
                i32.lt_u
                br_if 1 (;@5;)
                i32.const 0
                set_local 6
                block  ;; label = @7
                  get_local 7
                  get_local 2
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 7
                  i32.load8_u
                  i32.const 63
                  i32.and
                  set_local 6
                end
                get_local 1
                i32.const 6
                i32.shl
                get_local 0
                i32.const 18
                i32.shl
                i32.const 1835008
                i32.and
                i32.or
                get_local 6
                i32.or
                tee_local 2
                i32.const 1114112
                i32.ne
                br_if 2 (;@4;)
                br 5 (;@1;)
              end
              get_local 9
              get_local 0
              i32.const 6
              i32.shl
              i32.or
              set_local 2
              br 1 (;@4;)
            end
            get_local 1
            get_local 0
            i32.const 12
            i32.shl
            i32.or
            set_local 2
          end
          get_local 4
          get_local 2
          i32.store offset=36
          i32.const 1
          set_local 1
          get_local 2
          i32.const 128
          i32.lt_u
          br_if 0 (;@3;)
          i32.const 2
          set_local 1
          get_local 2
          i32.const 2048
          i32.lt_u
          br_if 0 (;@3;)
          i32.const 3
          i32.const 4
          get_local 2
          i32.const 65536
          i32.lt_u
          select
          set_local 1
        end
        get_local 4
        get_local 8
        i32.store offset=40
        get_local 4
        get_local 1
        get_local 8
        i32.add
        i32.store offset=44
        get_local 4
        i32.const 72
        i32.add
        i32.const 12
        i32.add
        i32.const 61
        i32.store
        get_local 4
        i32.const 72
        i32.add
        i32.const 20
        i32.add
        i32.const 62
        i32.store
        get_local 4
        i32.const 100
        i32.add
        i32.const 60
        i32.store
        get_local 4
        i32.const 108
        i32.add
        i32.const 60
        i32.store
        get_local 4
        i32.const 48
        i32.add
        i32.const 12
        i32.add
        i32.const 5
        i32.store
        get_local 4
        i32.const 48
        i32.add
        i32.const 20
        i32.add
        i32.const 5
        i32.store
        get_local 4
        i32.const 7
        i32.store offset=76
        get_local 4
        i32.const 1056756
        i32.store offset=48
        get_local 4
        i32.const 5
        i32.store offset=52
        get_local 4
        i32.const 1053488
        i32.store offset=56
        get_local 4
        get_local 4
        i32.const 32
        i32.add
        i32.store offset=72
        get_local 4
        get_local 4
        i32.const 36
        i32.add
        i32.store offset=80
        get_local 4
        get_local 4
        i32.const 40
        i32.add
        i32.store offset=88
        get_local 4
        get_local 4
        i32.const 16
        i32.add
        i32.store offset=96
        get_local 4
        get_local 4
        i32.const 24
        i32.add
        i32.store offset=104
        get_local 4
        get_local 4
        i32.const 72
        i32.add
        i32.store offset=64
        get_local 4
        i32.const 48
        i32.add
        i32.const 1056796
        call $core::panicking::panic_fmt::h2155aa66b67fe83c
        unreachable
      end
      get_local 4
      i32.const 72
      i32.add
      i32.const 12
      i32.add
      i32.const 7
      i32.store
      get_local 4
      i32.const 72
      i32.add
      i32.const 20
      i32.add
      i32.const 60
      i32.store
      get_local 4
      i32.const 100
      i32.add
      i32.const 60
      i32.store
      get_local 4
      i32.const 48
      i32.add
      i32.const 12
      i32.add
      i32.const 4
      i32.store
      get_local 4
      i32.const 48
      i32.add
      i32.const 20
      i32.add
      i32.const 4
      i32.store
      get_local 4
      i32.const 7
      i32.store offset=76
      get_local 4
      i32.const 1056708
      i32.store offset=48
      get_local 4
      i32.const 4
      i32.store offset=52
      get_local 4
      i32.const 1053292
      i32.store offset=56
      get_local 4
      get_local 4
      i32.const 8
      i32.add
      i32.store offset=72
      get_local 4
      get_local 4
      i32.const 12
      i32.add
      i32.store offset=80
      get_local 4
      get_local 4
      i32.const 16
      i32.add
      i32.store offset=88
      get_local 4
      get_local 4
      i32.const 24
      i32.add
      i32.store offset=96
      get_local 4
      get_local 4
      i32.const 72
      i32.add
      i32.store offset=64
      get_local 4
      i32.const 48
      i32.add
      i32.const 1056740
      call $core::panicking::panic_fmt::h2155aa66b67fe83c
      unreachable
    end
    i32.const 1056644
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$::fmt::h7ab41a41c2708e60 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    i32.const 63
    i32.store
    get_local 2
    i32.const 63
    i32.store offset=12
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    get_local 0
    i32.const 4
    i32.add
    i32.store offset=16
    get_local 1
    i32.const 28
    i32.add
    i32.load
    set_local 0
    get_local 1
    i32.load offset=24
    set_local 1
    get_local 2
    i32.const 24
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 44
    i32.add
    i32.const 2
    i32.store
    get_local 2
    i32.const 2
    i32.store offset=28
    get_local 2
    i32.const 1056812
    i32.store offset=24
    get_local 2
    i32.const 1053672
    i32.store offset=32
    get_local 2
    get_local 2
    i32.const 8
    i32.add
    i32.store offset=40
    get_local 1
    get_local 0
    get_local 2
    i32.const 24
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 48
    i32.add
    set_global 0
    get_local 1)
  (func $core::fmt::num::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$usize$GT$::fmt::hdd33c58fe3ba02da (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32)
    get_global 0
    i32.const 128
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 1
              i32.load
              tee_local 3
              i32.const 16
              i32.and
              br_if 0 (;@5;)
              get_local 3
              i32.const 32
              i32.and
              br_if 1 (;@4;)
              get_local 0
              get_local 1
              call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf
              set_local 0
              br 2 (;@3;)
            end
            get_local 0
            i32.load
            set_local 3
            i32.const 0
            set_local 0
            loop  ;; label = @5
              get_local 2
              get_local 0
              i32.add
              i32.const 127
              i32.add
              get_local 3
              i32.const 15
              i32.and
              tee_local 4
              i32.const 48
              i32.or
              get_local 4
              i32.const 87
              i32.add
              get_local 4
              i32.const 10
              i32.lt_u
              select
              i32.store8
              get_local 0
              i32.const -1
              i32.add
              set_local 0
              get_local 3
              i32.const 4
              i32.shr_u
              tee_local 3
              br_if 0 (;@5;)
            end
            get_local 0
            i32.const 128
            i32.add
            tee_local 3
            i32.const 129
            i32.ge_u
            br_if 2 (;@2;)
            get_local 1
            i32.const 1
            i32.const 1051040
            i32.const 2
            get_local 2
            get_local 0
            i32.add
            i32.const 128
            i32.add
            i32.const 0
            get_local 0
            i32.sub
            call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
            set_local 0
            br 1 (;@3;)
          end
          get_local 0
          i32.load
          set_local 3
          i32.const 0
          set_local 0
          loop  ;; label = @4
            get_local 2
            get_local 0
            i32.add
            i32.const 127
            i32.add
            get_local 3
            i32.const 15
            i32.and
            tee_local 4
            i32.const 48
            i32.or
            get_local 4
            i32.const 55
            i32.add
            get_local 4
            i32.const 10
            i32.lt_u
            select
            i32.store8
            get_local 0
            i32.const -1
            i32.add
            set_local 0
            get_local 3
            i32.const 4
            i32.shr_u
            tee_local 3
            br_if 0 (;@4;)
          end
          get_local 0
          i32.const 128
          i32.add
          tee_local 3
          i32.const 129
          i32.ge_u
          br_if 2 (;@1;)
          get_local 1
          i32.const 1
          i32.const 1051040
          i32.const 2
          get_local 2
          get_local 0
          i32.add
          i32.const 128
          i32.add
          i32.const 0
          get_local 0
          i32.sub
          call $core::fmt::Formatter::pad_integral::h1cd92cd8befec220
          set_local 0
        end
        get_local 2
        i32.const 128
        i32.add
        set_global 0
        get_local 0
        return
      end
      get_local 3
      i32.const 128
      call $core::slice::slice_index_order_fail::hc6db54a13869566a
      unreachable
    end
    get_local 3
    i32.const 128
    call $core::slice::slice_index_order_fail::hc6db54a13869566a
    unreachable)
  (func $_$LT$core..cell..BorrowMutError$u20$as$u20$core..fmt..Debug$GT$::fmt::h81cf23ef596fc4b8 (type 0) (param i32 i32) (result i32)
    get_local 1
    i32.load offset=24
    i32.const 1053744
    i32.const 14
    get_local 1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect (type 5))
  (func $core::unicode::bool_trie::BoolTrie::lookup::h62a25aa8bcb35afa (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.const 2048
                  i32.ge_u
                  br_if 0 (;@7;)
                  get_local 0
                  get_local 1
                  i32.const 3
                  i32.shr_u
                  i32.const 536870904
                  i32.and
                  i32.add
                  set_local 0
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  get_local 1
                  i32.const 65536
                  i32.ge_u
                  br_if 0 (;@7;)
                  get_local 1
                  i32.const 6
                  i32.shr_u
                  i32.const -32
                  i32.add
                  tee_local 2
                  i32.const 992
                  i32.ge_u
                  br_if 2 (;@5;)
                  get_local 0
                  i32.const 260
                  i32.add
                  i32.load
                  tee_local 3
                  get_local 0
                  get_local 2
                  i32.add
                  i32.const 280
                  i32.add
                  i32.load8_u
                  tee_local 2
                  i32.le_u
                  br_if 3 (;@4;)
                  get_local 0
                  i32.load offset=256
                  get_local 2
                  i32.const 3
                  i32.shl
                  i32.add
                  set_local 0
                  br 1 (;@6;)
                end
                get_local 1
                i32.const 12
                i32.shr_u
                i32.const -16
                i32.add
                tee_local 2
                i32.const 256
                i32.ge_u
                br_if 3 (;@3;)
                get_local 0
                get_local 2
                i32.add
                i32.const 1272
                i32.add
                i32.load8_u
                i32.const 6
                i32.shl
                get_local 1
                i32.const 6
                i32.shr_u
                i32.const 63
                i32.and
                i32.or
                tee_local 2
                get_local 0
                i32.const 268
                i32.add
                i32.load
                tee_local 3
                i32.ge_u
                br_if 4 (;@2;)
                get_local 0
                i32.const 276
                i32.add
                i32.load
                tee_local 3
                get_local 0
                i32.load offset=264
                get_local 2
                i32.add
                i32.load8_u
                tee_local 2
                i32.le_u
                br_if 5 (;@1;)
                get_local 0
                i32.load offset=272
                get_local 2
                i32.const 3
                i32.shl
                i32.add
                set_local 0
              end
              get_local 0
              i64.load
              i64.const 1
              get_local 1
              i32.const 63
              i32.and
              i64.extend_u/i32
              i64.shl
              i64.and
              i64.const 0
              i64.ne
              return
            end
            i32.const 1056828
            get_local 2
            i32.const 992
            call $core::panicking::panic_bounds_check::h083d97c982ea32c3
            unreachable
          end
          i32.const 1056844
          get_local 2
          get_local 3
          call $core::panicking::panic_bounds_check::h083d97c982ea32c3
          unreachable
        end
        i32.const 1056860
        get_local 2
        i32.const 256
        call $core::panicking::panic_bounds_check::h083d97c982ea32c3
        unreachable
      end
      i32.const 1056876
      get_local 2
      get_local 3
      call $core::panicking::panic_bounds_check::h083d97c982ea32c3
      unreachable
    end
    i32.const 1056892
    get_local 2
    get_local 3
    call $core::panicking::panic_bounds_check::h083d97c982ea32c3
    unreachable)
  (func $core::ptr::drop_in_place::hc3c175563f550c59 (type 3) (param i32))
  (func $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::h6d2e602fb5831b67 (type 3) (param i32)
    (local i32)
    get_local 0
    i32.load
    tee_local 1
    i32.load
    get_local 1
    i32.load offset=4
    get_local 0
    i32.load offset=4
    i32.load
    get_local 0
    i32.load offset=8
    i32.load
    call $core::str::slice_error_fail::hb9184500007bb4cb
    unreachable)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h005e9ac1ed3e1c92 (type 5) (param i32 i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 1
    get_local 2
    call $_$LT$core..fmt..builders..PadAdapter$LT$$u27$a$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hcf357fdfd5a3a874)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h7d70eff5afbbc1ab (type 0) (param i32 i32) (result i32)
    get_local 0
    i32.load
    get_local 1
    call $core::fmt::Write::write_char::hefa3b7e0a5e2a797)
  (func $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::hafb67904b8e1444a (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 0
    i32.load
    i32.store offset=4
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 2
    i32.const 4
    i32.add
    i32.const 1057036
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $core::fmt::write::hc8a86a45c34c9d88 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    i32.const 28
    i32.add
    tee_local 4
    get_local 1
    i32.store
    get_local 3
    i32.const 44
    i32.add
    tee_local 5
    get_local 2
    i32.const 20
    i32.add
    i32.load
    tee_local 1
    i32.store
    get_local 3
    i32.const 3
    i32.store8 offset=48
    get_local 3
    i32.const 36
    i32.add
    tee_local 6
    get_local 2
    i32.load offset=16
    tee_local 7
    get_local 1
    i32.const 3
    i32.shl
    tee_local 8
    i32.add
    i32.store
    get_local 3
    i64.const 137438953472
    i64.store
    i32.const 0
    set_local 1
    get_local 3
    i32.const 0
    i32.store offset=8
    get_local 3
    i32.const 0
    i32.store offset=16
    get_local 3
    get_local 0
    i32.store offset=24
    get_local 3
    get_local 7
    i32.store offset=32
    get_local 3
    get_local 7
    i32.store offset=40
    get_local 3
    get_local 2
    i32.load
    tee_local 9
    i32.store offset=56
    get_local 3
    get_local 9
    get_local 2
    i32.load offset=4
    i32.const 3
    i32.shl
    tee_local 10
    i32.add
    tee_local 11
    i32.store offset=60
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 2
                i32.load offset=8
                tee_local 0
                i32.eqz
                br_if 0 (;@6;)
                get_local 0
                i32.const 28
                i32.add
                set_local 7
                get_local 0
                get_local 2
                i32.const 12
                i32.add
                i32.load
                i32.const 36
                i32.mul
                i32.add
                set_local 12
                get_local 3
                i32.const 24
                i32.add
                set_local 13
                get_local 3
                i32.const 48
                i32.add
                set_local 14
                get_local 3
                i32.const 40
                i32.add
                set_local 15
                get_local 3
                i32.const 8
                i32.add
                set_local 16
                get_local 3
                i32.const 20
                i32.add
                set_local 17
                get_local 3
                i32.const 16
                i32.add
                set_local 18
                get_local 3
                i32.const 32
                i32.add
                set_local 19
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      loop  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              get_local 0
                              get_local 12
                              i32.eq
                              br_if 0 (;@13;)
                              get_local 10
                              get_local 1
                              i32.eq
                              br_if 8 (;@5;)
                              get_local 13
                              i32.load
                              get_local 9
                              get_local 1
                              i32.add
                              tee_local 20
                              i32.load
                              get_local 20
                              i32.const 4
                              i32.add
                              i32.load
                              get_local 4
                              i32.load
                              i32.load offset=12
                              call_indirect (type 5)
                              br_if 4 (;@9;)
                              get_local 14
                              get_local 0
                              i32.load8_u offset=32
                              i32.store8
                              get_local 3
                              get_local 0
                              i32.load offset=8
                              i32.store offset=4
                              get_local 3
                              get_local 0
                              i32.load offset=12
                              i32.store
                              i32.const 0
                              set_local 8
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    get_local 0
                                    i32.load offset=24
                                    tee_local 21
                                    i32.const 1
                                    i32.eq
                                    br_if 0 (;@16;)
                                    block  ;; label = @17
                                      get_local 21
                                      i32.const 2
                                      i32.eq
                                      br_if 0 (;@17;)
                                      get_local 21
                                      i32.const 3
                                      i32.eq
                                      br_if 6 (;@11;)
                                      get_local 7
                                      i32.load
                                      set_local 2
                                      br 2 (;@15;)
                                    end
                                    get_local 19
                                    i32.load
                                    tee_local 21
                                    get_local 6
                                    i32.load
                                    i32.eq
                                    br_if 2 (;@14;)
                                    get_local 19
                                    get_local 21
                                    i32.const 8
                                    i32.add
                                    i32.store
                                    get_local 21
                                    i32.load offset=4
                                    i32.const 64
                                    i32.ne
                                    br_if 5 (;@11;)
                                    get_local 21
                                    i32.load
                                    i32.load
                                    set_local 2
                                    br 1 (;@15;)
                                  end
                                  get_local 7
                                  i32.load
                                  tee_local 21
                                  get_local 5
                                  i32.load
                                  tee_local 2
                                  i32.ge_u
                                  br_if 3 (;@12;)
                                  get_local 15
                                  i32.load
                                  get_local 21
                                  i32.const 3
                                  i32.shl
                                  i32.add
                                  tee_local 21
                                  i32.load offset=4
                                  i32.const 64
                                  i32.ne
                                  br_if 4 (;@11;)
                                  get_local 21
                                  i32.load
                                  i32.load
                                  set_local 2
                                end
                                i32.const 1
                                set_local 8
                                br 3 (;@11;)
                              end
                              br 2 (;@11;)
                            end
                            get_local 9
                            get_local 1
                            i32.add
                            set_local 0
                            br 8 (;@4;)
                          end
                          i32.const 1056972
                          get_local 21
                          get_local 2
                          call $core::panicking::panic_bounds_check::h083d97c982ea32c3
                          unreachable
                        end
                        get_local 3
                        i32.const 12
                        i32.add
                        get_local 2
                        i32.store
                        get_local 16
                        get_local 8
                        i32.store
                        i32.const 0
                        set_local 8
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  get_local 0
                                  i32.load offset=16
                                  tee_local 21
                                  i32.const 1
                                  i32.eq
                                  br_if 0 (;@15;)
                                  block  ;; label = @16
                                    get_local 21
                                    i32.const 2
                                    i32.eq
                                    br_if 0 (;@16;)
                                    get_local 21
                                    i32.const 3
                                    i32.eq
                                    br_if 5 (;@11;)
                                    get_local 7
                                    i32.const -8
                                    i32.add
                                    i32.load
                                    set_local 2
                                    br 2 (;@14;)
                                  end
                                  get_local 19
                                  i32.load
                                  tee_local 21
                                  get_local 6
                                  i32.load
                                  i32.eq
                                  br_if 2 (;@13;)
                                  get_local 19
                                  get_local 21
                                  i32.const 8
                                  i32.add
                                  i32.store
                                  get_local 21
                                  i32.load offset=4
                                  i32.const 64
                                  i32.ne
                                  br_if 4 (;@11;)
                                  get_local 21
                                  i32.load
                                  i32.load
                                  set_local 2
                                  br 1 (;@14;)
                                end
                                get_local 7
                                i32.const -8
                                i32.add
                                i32.load
                                tee_local 21
                                get_local 5
                                i32.load
                                tee_local 2
                                i32.ge_u
                                br_if 2 (;@12;)
                                get_local 15
                                i32.load
                                get_local 21
                                i32.const 3
                                i32.shl
                                i32.add
                                tee_local 21
                                i32.load offset=4
                                i32.const 64
                                i32.ne
                                br_if 3 (;@11;)
                                get_local 21
                                i32.load
                                i32.load
                                set_local 2
                              end
                              i32.const 1
                              set_local 8
                              br 2 (;@11;)
                            end
                            br 1 (;@11;)
                          end
                          i32.const 1056972
                          get_local 21
                          get_local 2
                          call $core::panicking::panic_bounds_check::h083d97c982ea32c3
                          unreachable
                        end
                        get_local 17
                        get_local 2
                        i32.store
                        get_local 18
                        get_local 8
                        i32.store
                        block  ;; label = @11
                          block  ;; label = @12
                            get_local 0
                            i32.load
                            i32.const 1
                            i32.ne
                            br_if 0 (;@12;)
                            get_local 7
                            i32.const -24
                            i32.add
                            i32.load
                            tee_local 8
                            get_local 5
                            i32.load
                            tee_local 2
                            i32.ge_u
                            br_if 4 (;@8;)
                            get_local 15
                            i32.load
                            get_local 8
                            i32.const 3
                            i32.shl
                            i32.add
                            set_local 8
                            br 1 (;@11;)
                          end
                          get_local 19
                          i32.load
                          tee_local 8
                          get_local 6
                          i32.load
                          i32.eq
                          br_if 4 (;@7;)
                          get_local 19
                          get_local 8
                          i32.const 8
                          i32.add
                          i32.store
                        end
                        get_local 0
                        i32.const 36
                        i32.add
                        set_local 0
                        get_local 7
                        i32.const 36
                        i32.add
                        set_local 7
                        get_local 1
                        i32.const 8
                        i32.add
                        set_local 1
                        get_local 8
                        i32.load
                        get_local 3
                        get_local 8
                        i32.const 4
                        i32.add
                        i32.load
                        call_indirect (type 0)
                        i32.eqz
                        br_if 0 (;@10;)
                      end
                    end
                    get_local 3
                    get_local 20
                    i32.const 8
                    i32.add
                    i32.store offset=56
                    br 5 (;@3;)
                  end
                  i32.const 1056956
                  get_local 8
                  get_local 2
                  call $core::panicking::panic_bounds_check::h083d97c982ea32c3
                  unreachable
                end
                i32.const 1056908
                call $core::panicking::panic::h9b4aaddfe00d4a7f
                unreachable
              end
              get_local 3
              i32.const 24
              i32.add
              set_local 21
              loop  ;; label = @6
                get_local 9
                set_local 0
                get_local 8
                i32.eqz
                br_if 2 (;@4;)
                get_local 10
                i32.eqz
                br_if 1 (;@5;)
                block  ;; label = @7
                  get_local 21
                  i32.load
                  get_local 0
                  i32.load
                  get_local 0
                  i32.const 4
                  i32.add
                  i32.load
                  get_local 4
                  i32.load
                  i32.load offset=12
                  call_indirect (type 5)
                  br_if 0 (;@7;)
                  get_local 0
                  i32.const 8
                  i32.add
                  set_local 9
                  get_local 8
                  i32.const -8
                  i32.add
                  set_local 8
                  get_local 10
                  i32.const -8
                  i32.add
                  set_local 10
                  get_local 7
                  i32.load
                  set_local 1
                  get_local 7
                  i32.load offset=4
                  set_local 2
                  get_local 7
                  i32.const 8
                  i32.add
                  set_local 7
                  get_local 1
                  get_local 3
                  get_local 2
                  call_indirect (type 0)
                  i32.eqz
                  br_if 1 (;@6;)
                end
              end
              get_local 3
              get_local 0
              i32.const 8
              i32.add
              i32.store offset=56
              br 2 (;@3;)
            end
            get_local 11
            set_local 0
          end
          get_local 3
          get_local 0
          i32.store offset=56
          get_local 0
          get_local 11
          i32.eq
          br_if 1 (;@2;)
          get_local 3
          get_local 0
          i32.const 8
          i32.add
          i32.store offset=56
          get_local 3
          i32.const 24
          i32.add
          i32.load
          get_local 0
          i32.load
          get_local 0
          i32.load offset=4
          get_local 3
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect (type 5)
          i32.eqz
          br_if 1 (;@2;)
        end
        i32.const 1
        set_local 0
        br 1 (;@1;)
      end
      i32.const 0
      set_local 0
    end
    get_local 3
    i32.const 64
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::ArgumentV1::show_usize::h8b4f357c5a0b63d7__.llvm.3436319850126977588_ (type 0) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    call $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf)
  (func $_$LT$core..fmt..Arguments$LT$$u27$a$GT$$u20$as$u20$core..fmt..Display$GT$::fmt::h0d0eabd8a96d84a6 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 1
    i32.const 28
    i32.add
    i32.load
    set_local 3
    get_local 1
    i32.load offset=24
    set_local 1
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 0
    i64.load align=4
    i64.store offset=8
    get_local 1
    get_local 3
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 0
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::Formatter::pad_integral::h1cd92cd8befec220 (type 13) (param i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 6
    set_global 0
    get_local 6
    get_local 3
    i32.store offset=4
    get_local 6
    get_local 2
    i32.store
    get_local 6
    i32.const 1114112
    i32.store offset=8
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 1
          i32.eqz
          br_if 0 (;@3;)
          get_local 0
          i32.load
          tee_local 7
          i32.const 1
          i32.and
          br_if 1 (;@2;)
          get_local 5
          set_local 8
          br 2 (;@1;)
        end
        get_local 6
        i32.const 45
        i32.store offset=8
        get_local 5
        i32.const 1
        i32.add
        set_local 8
        get_local 0
        i32.load
        set_local 7
        br 1 (;@1;)
      end
      get_local 6
      i32.const 43
      i32.store offset=8
      get_local 5
      i32.const 1
      i32.add
      set_local 8
    end
    i32.const 0
    set_local 1
    get_local 6
    i32.const 0
    i32.store8 offset=15
    block  ;; label = @1
      get_local 7
      i32.const 4
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      get_local 6
      i32.const 1
      i32.store8 offset=15
      block  ;; label = @2
        get_local 3
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        set_local 1
        get_local 3
        set_local 9
        loop  ;; label = @3
          get_local 1
          get_local 2
          i32.load8_u
          i32.const 192
          i32.and
          i32.const 128
          i32.eq
          i32.add
          set_local 1
          get_local 2
          i32.const 1
          i32.add
          set_local 2
          get_local 9
          i32.const -1
          i32.add
          tee_local 9
          br_if 0 (;@3;)
        end
      end
      get_local 8
      get_local 3
      i32.add
      get_local 1
      i32.sub
      set_local 8
    end
    get_local 0
    i32.load offset=8
    set_local 2
    get_local 6
    get_local 6
    i32.const 15
    i32.add
    i32.store offset=20
    get_local 6
    get_local 6
    i32.const 8
    i32.add
    i32.store offset=16
    get_local 6
    get_local 6
    i32.store offset=24
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    get_local 2
                                    i32.const 1
                                    i32.ne
                                    br_if 0 (;@16;)
                                    get_local 0
                                    i32.const 12
                                    i32.add
                                    i32.load
                                    tee_local 2
                                    get_local 8
                                    i32.le_u
                                    br_if 1 (;@15;)
                                    get_local 7
                                    i32.const 8
                                    i32.and
                                    br_if 2 (;@14;)
                                    get_local 2
                                    get_local 8
                                    i32.sub
                                    set_local 2
                                    i32.const 1
                                    get_local 0
                                    i32.load8_u offset=48
                                    tee_local 1
                                    get_local 1
                                    i32.const 3
                                    i32.eq
                                    select
                                    i32.const 3
                                    i32.and
                                    tee_local 1
                                    i32.const 2
                                    i32.eq
                                    br_if 4 (;@12;)
                                    i32.const 0
                                    set_local 3
                                    get_local 1
                                    i32.eqz
                                    br_if 3 (;@13;)
                                    get_local 2
                                    set_local 9
                                    br 5 (;@11;)
                                  end
                                  get_local 6
                                  i32.const 16
                                  i32.add
                                  get_local 0
                                  call $core::fmt::Formatter::pad_integral::_$u7b$$u7b$closure$u7d$$u7d$::h9b74da02a08794e9
                                  br_if 12 (;@3;)
                                  get_local 0
                                  i32.load offset=24
                                  get_local 4
                                  get_local 5
                                  get_local 0
                                  i32.const 28
                                  i32.add
                                  i32.load
                                  i32.load offset=12
                                  call_indirect (type 5)
                                  set_local 2
                                  br 14 (;@1;)
                                end
                                get_local 6
                                i32.const 16
                                i32.add
                                get_local 0
                                call $core::fmt::Formatter::pad_integral::_$u7b$$u7b$closure$u7d$$u7d$::h9b74da02a08794e9
                                br_if 11 (;@3;)
                                get_local 0
                                i32.load offset=24
                                get_local 4
                                get_local 5
                                get_local 0
                                i32.const 28
                                i32.add
                                i32.load
                                i32.load offset=12
                                call_indirect (type 5)
                                set_local 2
                                br 13 (;@1;)
                              end
                              get_local 0
                              i32.const 1
                              i32.store8 offset=48
                              get_local 0
                              i32.const 48
                              i32.store offset=4
                              get_local 6
                              i32.const 16
                              i32.add
                              get_local 0
                              call $core::fmt::Formatter::pad_integral::_$u7b$$u7b$closure$u7d$$u7d$::h9b74da02a08794e9
                              br_if 10 (;@3;)
                              get_local 2
                              get_local 8
                              i32.sub
                              set_local 2
                              i32.const 1
                              get_local 0
                              i32.const 48
                              i32.add
                              i32.load8_u
                              tee_local 1
                              get_local 1
                              i32.const 3
                              i32.eq
                              select
                              i32.const 3
                              i32.and
                              tee_local 1
                              i32.const 2
                              i32.eq
                              br_if 4 (;@9;)
                              i32.const 0
                              set_local 3
                              get_local 1
                              i32.eqz
                              br_if 3 (;@10;)
                              get_local 2
                              set_local 9
                              br 5 (;@8;)
                            end
                            i32.const 0
                            set_local 9
                            get_local 2
                            set_local 3
                            br 1 (;@11;)
                          end
                          get_local 2
                          i32.const 1
                          i32.shr_u
                          set_local 9
                          get_local 2
                          i32.const 1
                          i32.add
                          i32.const 1
                          i32.shr_u
                          set_local 3
                        end
                        get_local 6
                        i32.const 0
                        i32.store offset=28
                        block  ;; label = @11
                          get_local 0
                          i32.load offset=4
                          tee_local 2
                          i32.const 127
                          i32.gt_u
                          br_if 0 (;@11;)
                          get_local 6
                          get_local 2
                          i32.store8 offset=28
                          i32.const 1
                          set_local 1
                          br 5 (;@6;)
                        end
                        block  ;; label = @11
                          get_local 2
                          i32.const 2047
                          i32.gt_u
                          br_if 0 (;@11;)
                          get_local 6
                          get_local 2
                          i32.const 63
                          i32.and
                          i32.const 128
                          i32.or
                          i32.store8 offset=29
                          get_local 6
                          get_local 2
                          i32.const 6
                          i32.shr_u
                          i32.const 31
                          i32.and
                          i32.const 192
                          i32.or
                          i32.store8 offset=28
                          i32.const 2
                          set_local 1
                          br 5 (;@6;)
                        end
                        get_local 2
                        i32.const 65535
                        i32.gt_u
                        br_if 3 (;@7;)
                        get_local 6
                        get_local 2
                        i32.const 63
                        i32.and
                        i32.const 128
                        i32.or
                        i32.store8 offset=30
                        get_local 6
                        get_local 2
                        i32.const 6
                        i32.shr_u
                        i32.const 63
                        i32.and
                        i32.const 128
                        i32.or
                        i32.store8 offset=29
                        get_local 6
                        get_local 2
                        i32.const 12
                        i32.shr_u
                        i32.const 15
                        i32.and
                        i32.const 224
                        i32.or
                        i32.store8 offset=28
                        i32.const 3
                        set_local 1
                        br 4 (;@6;)
                      end
                      i32.const 0
                      set_local 9
                      get_local 2
                      set_local 3
                      br 1 (;@8;)
                    end
                    get_local 2
                    i32.const 1
                    i32.shr_u
                    set_local 9
                    get_local 2
                    i32.const 1
                    i32.add
                    i32.const 1
                    i32.shr_u
                    set_local 3
                  end
                  get_local 6
                  i32.const 0
                  i32.store offset=28
                  block  ;; label = @8
                    get_local 0
                    i32.const 4
                    i32.add
                    i32.load
                    tee_local 2
                    i32.const 127
                    i32.gt_u
                    br_if 0 (;@8;)
                    get_local 6
                    get_local 2
                    i32.store8 offset=28
                    i32.const 1
                    set_local 1
                    br 4 (;@4;)
                  end
                  get_local 2
                  i32.const 2047
                  i32.gt_u
                  br_if 2 (;@5;)
                  get_local 6
                  get_local 2
                  i32.const 63
                  i32.and
                  i32.const 128
                  i32.or
                  i32.store8 offset=29
                  get_local 6
                  get_local 2
                  i32.const 6
                  i32.shr_u
                  i32.const 31
                  i32.and
                  i32.const 192
                  i32.or
                  i32.store8 offset=28
                  i32.const 2
                  set_local 1
                  br 3 (;@4;)
                end
                get_local 6
                get_local 2
                i32.const 18
                i32.shr_u
                i32.const 240
                i32.or
                i32.store8 offset=28
                get_local 6
                get_local 2
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=31
                get_local 6
                get_local 2
                i32.const 12
                i32.shr_u
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=29
                get_local 6
                get_local 2
                i32.const 6
                i32.shr_u
                i32.const 63
                i32.and
                i32.const 128
                i32.or
                i32.store8 offset=30
                i32.const 4
                set_local 1
              end
              i32.const -1
              set_local 2
              block  ;; label = @6
                loop  ;; label = @7
                  get_local 2
                  i32.const 1
                  i32.add
                  tee_local 2
                  get_local 9
                  i32.ge_u
                  br_if 1 (;@6;)
                  get_local 0
                  i32.const 24
                  i32.add
                  i32.load
                  get_local 6
                  i32.const 28
                  i32.add
                  get_local 1
                  get_local 0
                  i32.const 28
                  i32.add
                  i32.load
                  i32.load offset=12
                  call_indirect (type 5)
                  i32.eqz
                  br_if 0 (;@7;)
                  br 4 (;@3;)
                end
              end
              get_local 6
              i32.const 16
              i32.add
              get_local 0
              call $core::fmt::Formatter::pad_integral::_$u7b$$u7b$closure$u7d$$u7d$::h9b74da02a08794e9
              br_if 2 (;@3;)
              get_local 0
              i32.const 24
              i32.add
              tee_local 9
              i32.load
              get_local 4
              get_local 5
              get_local 0
              i32.const 28
              i32.add
              tee_local 0
              i32.load
              i32.load offset=12
              call_indirect (type 5)
              br_if 2 (;@3;)
              i32.const -1
              set_local 2
              loop  ;; label = @6
                get_local 2
                i32.const 1
                i32.add
                tee_local 2
                get_local 3
                i32.ge_u
                br_if 4 (;@2;)
                get_local 9
                i32.load
                get_local 6
                i32.const 28
                i32.add
                get_local 1
                get_local 0
                i32.load
                i32.load offset=12
                call_indirect (type 5)
                i32.eqz
                br_if 0 (;@6;)
                br 3 (;@3;)
              end
            end
            block  ;; label = @5
              get_local 2
              i32.const 65535
              i32.gt_u
              br_if 0 (;@5;)
              get_local 6
              get_local 2
              i32.const 63
              i32.and
              i32.const 128
              i32.or
              i32.store8 offset=30
              get_local 6
              get_local 2
              i32.const 6
              i32.shr_u
              i32.const 63
              i32.and
              i32.const 128
              i32.or
              i32.store8 offset=29
              get_local 6
              get_local 2
              i32.const 12
              i32.shr_u
              i32.const 15
              i32.and
              i32.const 224
              i32.or
              i32.store8 offset=28
              i32.const 3
              set_local 1
              br 1 (;@4;)
            end
            get_local 6
            get_local 2
            i32.const 18
            i32.shr_u
            i32.const 240
            i32.or
            i32.store8 offset=28
            get_local 6
            get_local 2
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=31
            get_local 6
            get_local 2
            i32.const 12
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=29
            get_local 6
            get_local 2
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=30
            i32.const 4
            set_local 1
          end
          i32.const -1
          set_local 2
          block  ;; label = @4
            loop  ;; label = @5
              get_local 2
              i32.const 1
              i32.add
              tee_local 2
              get_local 9
              i32.ge_u
              br_if 1 (;@4;)
              get_local 0
              i32.const 24
              i32.add
              i32.load
              get_local 6
              i32.const 28
              i32.add
              get_local 1
              get_local 0
              i32.const 28
              i32.add
              i32.load
              i32.load offset=12
              call_indirect (type 5)
              i32.eqz
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          get_local 0
          i32.const 24
          i32.add
          tee_local 9
          i32.load
          get_local 4
          get_local 5
          get_local 0
          i32.const 28
          i32.add
          tee_local 0
          i32.load
          i32.load offset=12
          call_indirect (type 5)
          br_if 0 (;@3;)
          i32.const -1
          set_local 2
          loop  ;; label = @4
            get_local 2
            i32.const 1
            i32.add
            tee_local 2
            get_local 3
            i32.ge_u
            br_if 2 (;@2;)
            get_local 9
            i32.load
            get_local 6
            i32.const 28
            i32.add
            get_local 1
            get_local 0
            i32.load
            i32.load offset=12
            call_indirect (type 5)
            i32.eqz
            br_if 0 (;@4;)
          end
        end
        i32.const 1
        set_local 2
        br 1 (;@1;)
      end
      i32.const 0
      set_local 2
    end
    get_local 6
    i32.const 32
    i32.add
    set_global 0
    get_local 2)
  (func $core::fmt::Formatter::pad_integral::_$u7b$$u7b$closure$u7d$$u7d$::h9b74da02a08794e9 (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.load
        i32.load
        tee_local 3
        i32.const 1114112
        i32.eq
        br_if 0 (;@2;)
        get_local 1
        i32.const 28
        i32.add
        i32.load
        set_local 4
        get_local 1
        i32.load offset=24
        set_local 5
        get_local 2
        i32.const 0
        i32.store offset=12
        block  ;; label = @3
          block  ;; label = @4
            get_local 3
            i32.const 127
            i32.gt_u
            br_if 0 (;@4;)
            get_local 2
            get_local 3
            i32.store8 offset=12
            i32.const 1
            set_local 6
            br 1 (;@3;)
          end
          block  ;; label = @4
            get_local 3
            i32.const 2047
            i32.gt_u
            br_if 0 (;@4;)
            get_local 2
            get_local 3
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            get_local 2
            get_local 3
            i32.const 6
            i32.shr_u
            i32.const 31
            i32.and
            i32.const 192
            i32.or
            i32.store8 offset=12
            i32.const 2
            set_local 6
            br 1 (;@3;)
          end
          block  ;; label = @4
            get_local 3
            i32.const 65535
            i32.gt_u
            br_if 0 (;@4;)
            get_local 2
            get_local 3
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            get_local 2
            get_local 3
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            get_local 2
            get_local 3
            i32.const 12
            i32.shr_u
            i32.const 15
            i32.and
            i32.const 224
            i32.or
            i32.store8 offset=12
            i32.const 3
            set_local 6
            br 1 (;@3;)
          end
          get_local 2
          get_local 3
          i32.const 18
          i32.shr_u
          i32.const 240
          i32.or
          i32.store8 offset=12
          get_local 2
          get_local 3
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=15
          get_local 2
          get_local 3
          i32.const 12
          i32.shr_u
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=13
          get_local 2
          get_local 3
          i32.const 6
          i32.shr_u
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=14
          i32.const 4
          set_local 6
        end
        i32.const 1
        set_local 3
        get_local 5
        get_local 2
        i32.const 12
        i32.add
        get_local 6
        get_local 4
        i32.load offset=12
        call_indirect (type 5)
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        get_local 0
        i32.load offset=4
        i32.load8_u
        i32.eqz
        br_if 0 (;@2;)
        get_local 1
        i32.load offset=24
        get_local 0
        i32.load offset=8
        tee_local 0
        i32.load
        get_local 0
        i32.load offset=4
        get_local 1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect (type 5)
        set_local 3
        br 1 (;@1;)
      end
      i32.const 0
      set_local 3
    end
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 3)
  (func $core::fmt::Formatter::pad::hcb6d9b95eaf1d310 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 3
    set_global 0
    get_local 0
    i32.load offset=16
    set_local 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 0
                          i32.load offset=8
                          tee_local 5
                          i32.const 1
                          i32.ne
                          br_if 0 (;@11;)
                          get_local 4
                          br_if 1 (;@10;)
                          br 8 (;@3;)
                        end
                        get_local 4
                        i32.eqz
                        br_if 1 (;@9;)
                      end
                      get_local 2
                      i32.eqz
                      br_if 1 (;@8;)
                      get_local 1
                      get_local 2
                      i32.add
                      set_local 6
                      get_local 0
                      i32.const 20
                      i32.add
                      i32.load
                      set_local 7
                      get_local 1
                      i32.const 1
                      i32.add
                      set_local 4
                      i32.const 0
                      set_local 8
                      get_local 1
                      i32.load8_s
                      tee_local 9
                      i32.const 0
                      i32.ge_s
                      br_if 4 (;@5;)
                      get_local 6
                      set_local 10
                      block  ;; label = @10
                        get_local 2
                        i32.const 1
                        i32.eq
                        br_if 0 (;@10;)
                        get_local 1
                        i32.const 1
                        i32.add
                        i32.load8_u
                        i32.const 63
                        i32.and
                        set_local 8
                        get_local 1
                        i32.const 2
                        i32.add
                        tee_local 4
                        set_local 10
                      end
                      get_local 9
                      i32.const 255
                      i32.and
                      i32.const 224
                      i32.lt_u
                      br_if 4 (;@5;)
                      get_local 10
                      get_local 6
                      i32.eq
                      br_if 2 (;@7;)
                      get_local 10
                      i32.load8_u
                      i32.const 63
                      i32.and
                      set_local 11
                      get_local 10
                      i32.const 1
                      i32.add
                      tee_local 4
                      set_local 10
                      br 3 (;@6;)
                    end
                    get_local 0
                    i32.load offset=24
                    get_local 1
                    get_local 2
                    get_local 0
                    i32.const 28
                    i32.add
                    i32.load
                    i32.load offset=12
                    call_indirect (type 5)
                    set_local 4
                    br 7 (;@1;)
                  end
                  i32.const 0
                  set_local 2
                  get_local 5
                  br_if 4 (;@3;)
                  br 5 (;@2;)
                end
                i32.const 0
                set_local 11
                get_local 6
                set_local 10
              end
              get_local 9
              i32.const 255
              i32.and
              i32.const 240
              i32.lt_u
              br_if 0 (;@5;)
              get_local 9
              i32.const 31
              i32.and
              set_local 12
              get_local 11
              get_local 8
              i32.const 6
              i32.shl
              i32.or
              set_local 8
              block  ;; label = @6
                block  ;; label = @7
                  get_local 10
                  get_local 6
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 10
                  i32.const 1
                  i32.add
                  set_local 4
                  get_local 10
                  i32.load8_u
                  i32.const 63
                  i32.and
                  set_local 9
                  br 1 (;@6;)
                end
                i32.const 0
                set_local 9
              end
              get_local 8
              i32.const 6
              i32.shl
              get_local 12
              i32.const 18
              i32.shl
              i32.const 1835008
              i32.and
              i32.or
              get_local 9
              i32.or
              i32.const 1114112
              i32.eq
              br_if 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 7
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 4
                    get_local 1
                    i32.sub
                    set_local 9
                    loop  ;; label = @9
                      get_local 9
                      set_local 8
                      get_local 6
                      get_local 4
                      tee_local 9
                      i32.eq
                      br_if 5 (;@4;)
                      get_local 9
                      i32.const 1
                      i32.add
                      set_local 4
                      block  ;; label = @10
                        get_local 9
                        i32.load8_s
                        tee_local 10
                        i32.const 0
                        i32.ge_s
                        br_if 0 (;@10;)
                        block  ;; label = @11
                          block  ;; label = @12
                            get_local 4
                            get_local 6
                            i32.eq
                            br_if 0 (;@12;)
                            get_local 4
                            i32.load8_u
                            i32.const 63
                            i32.and
                            set_local 13
                            get_local 9
                            i32.const 2
                            i32.add
                            tee_local 11
                            set_local 4
                            br 1 (;@11;)
                          end
                          i32.const 0
                          set_local 13
                          get_local 6
                          set_local 11
                        end
                        get_local 10
                        i32.const 255
                        i32.and
                        tee_local 12
                        i32.const 224
                        i32.lt_u
                        br_if 0 (;@10;)
                        block  ;; label = @11
                          block  ;; label = @12
                            get_local 11
                            get_local 6
                            i32.eq
                            br_if 0 (;@12;)
                            get_local 11
                            i32.load8_u
                            i32.const 63
                            i32.and
                            set_local 14
                            get_local 11
                            i32.const 1
                            i32.add
                            tee_local 4
                            set_local 11
                            get_local 12
                            i32.const 240
                            i32.ge_u
                            br_if 1 (;@11;)
                            br 2 (;@10;)
                          end
                          i32.const 0
                          set_local 14
                          get_local 6
                          set_local 11
                          get_local 12
                          i32.const 240
                          i32.lt_u
                          br_if 1 (;@10;)
                        end
                        get_local 10
                        i32.const 31
                        i32.and
                        set_local 10
                        get_local 14
                        get_local 13
                        i32.const 6
                        i32.shl
                        i32.or
                        set_local 12
                        block  ;; label = @11
                          block  ;; label = @12
                            get_local 11
                            get_local 6
                            i32.eq
                            br_if 0 (;@12;)
                            get_local 11
                            i32.const 1
                            i32.add
                            set_local 4
                            get_local 11
                            i32.load8_u
                            i32.const 63
                            i32.and
                            set_local 11
                            br 1 (;@11;)
                          end
                          i32.const 0
                          set_local 11
                        end
                        get_local 12
                        i32.const 6
                        i32.shl
                        get_local 10
                        i32.const 18
                        i32.shl
                        i32.const 1835008
                        i32.and
                        i32.or
                        get_local 11
                        i32.or
                        i32.const 1114112
                        i32.eq
                        br_if 6 (;@4;)
                      end
                      get_local 8
                      get_local 9
                      i32.sub
                      get_local 4
                      i32.add
                      set_local 9
                      get_local 7
                      i32.const -1
                      i32.add
                      tee_local 7
                      br_if 0 (;@9;)
                    end
                    get_local 8
                    i32.eqz
                    br_if 2 (;@6;)
                    br 1 (;@7;)
                  end
                  i32.const 0
                  set_local 8
                  i32.const 0
                  i32.eqz
                  br_if 1 (;@6;)
                end
                get_local 8
                get_local 2
                i32.eq
                br_if 0 (;@6;)
                i32.const 0
                set_local 4
                get_local 8
                get_local 2
                i32.ge_u
                br_if 1 (;@5;)
                get_local 1
                get_local 8
                i32.add
                i32.load8_s
                i32.const -64
                i32.lt_s
                br_if 1 (;@5;)
              end
              get_local 1
              set_local 4
            end
            get_local 8
            get_local 2
            get_local 4
            select
            set_local 2
            get_local 4
            get_local 1
            get_local 4
            select
            set_local 1
          end
          get_local 5
          i32.eqz
          br_if 1 (;@2;)
        end
        i32.const 0
        set_local 9
        block  ;; label = @3
          get_local 2
          i32.eqz
          br_if 0 (;@3;)
          get_local 2
          set_local 8
          get_local 1
          set_local 4
          loop  ;; label = @4
            get_local 9
            get_local 4
            i32.load8_u
            i32.const 192
            i32.and
            i32.const 128
            i32.eq
            i32.add
            set_local 9
            get_local 4
            i32.const 1
            i32.add
            set_local 4
            get_local 8
            i32.const -1
            i32.add
            tee_local 8
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 2
                get_local 9
                i32.sub
                get_local 0
                i32.const 12
                i32.add
                i32.load
                tee_local 6
                i32.ge_u
                br_if 0 (;@6;)
                i32.const 0
                set_local 7
                i32.const 0
                set_local 9
                block  ;; label = @7
                  get_local 2
                  i32.eqz
                  br_if 0 (;@7;)
                  i32.const 0
                  set_local 9
                  get_local 2
                  set_local 8
                  get_local 1
                  set_local 4
                  loop  ;; label = @8
                    get_local 9
                    get_local 4
                    i32.load8_u
                    i32.const 192
                    i32.and
                    i32.const 128
                    i32.eq
                    i32.add
                    set_local 9
                    get_local 4
                    i32.const 1
                    i32.add
                    set_local 4
                    get_local 8
                    i32.const -1
                    i32.add
                    tee_local 8
                    br_if 0 (;@8;)
                  end
                end
                get_local 9
                get_local 2
                i32.sub
                get_local 6
                i32.add
                set_local 4
                i32.const 0
                get_local 0
                i32.load8_u offset=48
                tee_local 9
                get_local 9
                i32.const 3
                i32.eq
                select
                i32.const 3
                i32.and
                tee_local 9
                i32.const 2
                i32.eq
                br_if 1 (;@5;)
                get_local 9
                i32.eqz
                br_if 2 (;@4;)
                get_local 4
                set_local 8
                br 3 (;@3;)
              end
              get_local 0
              i32.load offset=24
              get_local 1
              get_local 2
              get_local 0
              i32.const 28
              i32.add
              i32.load
              i32.load offset=12
              call_indirect (type 5)
              set_local 4
              br 4 (;@1;)
            end
            get_local 4
            i32.const 1
            i32.shr_u
            set_local 8
            get_local 4
            i32.const 1
            i32.add
            i32.const 1
            i32.shr_u
            set_local 7
            br 1 (;@3;)
          end
          i32.const 0
          set_local 8
          get_local 4
          set_local 7
        end
        get_local 3
        i32.const 0
        i32.store offset=12
        block  ;; label = @3
          block  ;; label = @4
            get_local 0
            i32.load offset=4
            tee_local 4
            i32.const 127
            i32.gt_u
            br_if 0 (;@4;)
            get_local 3
            get_local 4
            i32.store8 offset=12
            i32.const 1
            set_local 9
            br 1 (;@3;)
          end
          block  ;; label = @4
            get_local 4
            i32.const 2047
            i32.gt_u
            br_if 0 (;@4;)
            get_local 3
            get_local 4
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            get_local 3
            get_local 4
            i32.const 6
            i32.shr_u
            i32.const 31
            i32.and
            i32.const 192
            i32.or
            i32.store8 offset=12
            i32.const 2
            set_local 9
            br 1 (;@3;)
          end
          block  ;; label = @4
            get_local 4
            i32.const 65535
            i32.gt_u
            br_if 0 (;@4;)
            get_local 3
            get_local 4
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            get_local 3
            get_local 4
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            get_local 3
            get_local 4
            i32.const 12
            i32.shr_u
            i32.const 15
            i32.and
            i32.const 224
            i32.or
            i32.store8 offset=12
            i32.const 3
            set_local 9
            br 1 (;@3;)
          end
          get_local 3
          get_local 4
          i32.const 18
          i32.shr_u
          i32.const 240
          i32.or
          i32.store8 offset=12
          get_local 3
          get_local 4
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=15
          get_local 3
          get_local 4
          i32.const 12
          i32.shr_u
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=13
          get_local 3
          get_local 4
          i32.const 6
          i32.shr_u
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=14
          i32.const 4
          set_local 9
        end
        i32.const -1
        set_local 4
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                get_local 4
                i32.const 1
                i32.add
                tee_local 4
                get_local 8
                i32.ge_u
                br_if 1 (;@5;)
                get_local 0
                i32.const 24
                i32.add
                i32.load
                get_local 3
                i32.const 12
                i32.add
                get_local 9
                get_local 0
                i32.const 28
                i32.add
                i32.load
                i32.load offset=12
                call_indirect (type 5)
                i32.eqz
                br_if 0 (;@6;)
                br 2 (;@4;)
              end
            end
            get_local 0
            i32.const 24
            i32.add
            tee_local 8
            i32.load
            get_local 1
            get_local 2
            get_local 0
            i32.const 28
            i32.add
            tee_local 0
            i32.load
            i32.load offset=12
            call_indirect (type 5)
            br_if 0 (;@4;)
            i32.const -1
            set_local 4
            loop  ;; label = @5
              get_local 4
              i32.const 1
              i32.add
              tee_local 4
              get_local 7
              i32.ge_u
              br_if 2 (;@3;)
              get_local 8
              i32.load
              get_local 3
              i32.const 12
              i32.add
              get_local 9
              get_local 0
              i32.load
              i32.load offset=12
              call_indirect (type 5)
              i32.eqz
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          set_local 4
          br 2 (;@1;)
        end
        i32.const 0
        set_local 4
        br 1 (;@1;)
      end
      get_local 0
      i32.load offset=24
      get_local 1
      get_local 2
      get_local 0
      i32.const 28
      i32.add
      i32.load
      i32.load offset=12
      call_indirect (type 5)
      set_local 4
    end
    get_local 3
    i32.const 16
    i32.add
    set_global 0
    get_local 4)
  (func $core::fmt::Formatter::write_fmt::h183bfc55f2f88031 (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 0
    i32.const 28
    i32.add
    i32.load
    set_local 3
    get_local 0
    i32.load offset=24
    set_local 0
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 0
    get_local 3
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $core::fmt::Formatter::debug_lower_hex::h92753715ffe745e5 (type 10) (param i32) (result i32)
    get_local 0
    i32.load8_u
    i32.const 16
    i32.and
    i32.const 4
    i32.shr_u)
  (func $core::fmt::Formatter::debug_upper_hex::h872e32477651ad01 (type 10) (param i32) (result i32)
    get_local 0
    i32.load8_u
    i32.const 32
    i32.and
    i32.const 5
    i32.shr_u)
  (func $core::fmt::Formatter::debug_struct::h52478105236d4ae6 (type 9) (param i32 i32 i32 i32)
    get_local 0
    get_local 1
    i32.load offset=24
    get_local 2
    get_local 3
    get_local 1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect (type 5)
    i32.store8 offset=4
    get_local 0
    get_local 1
    i32.store
    get_local 0
    i32.const 0
    i32.store8 offset=5)
  (func $core::fmt::Formatter::debug_tuple::h3b2ce75eb3d47301 (type 9) (param i32 i32 i32 i32)
    get_local 0
    get_local 1
    i32.load offset=24
    get_local 2
    get_local 3
    get_local 1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect (type 5)
    i32.store8 offset=8
    get_local 0
    get_local 1
    i32.store
    get_local 0
    i32.const 0
    i32.store offset=4
    get_local 0
    get_local 3
    i32.eqz
    i32.store8 offset=9)
  (func $_$LT$str$u20$as$u20$core..fmt..Debug$GT$::fmt::hd2afc455f5f6b65c (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 3
    set_global 0
    i32.const 1
    set_local 4
    block  ;; label = @1
      get_local 2
      i32.load offset=24
      i32.const 34
      get_local 2
      i32.const 28
      i32.add
      i32.load
      i32.load offset=16
      call_indirect (type 0)
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          get_local 1
          i32.eqz
          br_if 0 (;@3;)
          get_local 0
          get_local 1
          i32.add
          set_local 5
          get_local 2
          i32.const 24
          i32.add
          set_local 6
          get_local 2
          i32.const 28
          i32.add
          set_local 7
          get_local 0
          set_local 8
          i32.const 0
          set_local 9
          i32.const 0
          set_local 10
          get_local 0
          set_local 11
          loop  ;; label = @4
            get_local 8
            i32.const 1
            i32.add
            set_local 12
            block  ;; label = @5
              block  ;; label = @6
                get_local 8
                i32.load8_s
                tee_local 13
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                get_local 13
                i32.const 255
                i32.and
                set_local 14
                get_local 12
                set_local 8
                br 1 (;@5;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  get_local 12
                  get_local 5
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 12
                  i32.load8_u
                  i32.const 63
                  i32.and
                  set_local 14
                  get_local 8
                  i32.const 2
                  i32.add
                  tee_local 8
                  set_local 12
                  br 1 (;@6;)
                end
                i32.const 0
                set_local 14
                get_local 5
                set_local 8
              end
              get_local 13
              i32.const 31
              i32.and
              set_local 15
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 13
                    i32.const 255
                    i32.and
                    tee_local 13
                    i32.const 224
                    i32.lt_u
                    br_if 0 (;@8;)
                    get_local 8
                    get_local 5
                    i32.eq
                    br_if 1 (;@7;)
                    get_local 8
                    i32.load8_u
                    i32.const 63
                    i32.and
                    set_local 16
                    get_local 8
                    i32.const 1
                    i32.add
                    tee_local 12
                    set_local 17
                    br 2 (;@6;)
                  end
                  get_local 14
                  get_local 15
                  i32.const 6
                  i32.shl
                  i32.or
                  set_local 14
                  get_local 12
                  set_local 8
                  br 2 (;@5;)
                end
                i32.const 0
                set_local 16
                get_local 5
                set_local 17
              end
              get_local 16
              get_local 14
              i32.const 6
              i32.shl
              i32.or
              set_local 14
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 13
                    i32.const 240
                    i32.lt_u
                    br_if 0 (;@8;)
                    get_local 17
                    get_local 5
                    i32.eq
                    br_if 1 (;@7;)
                    get_local 17
                    i32.const 1
                    i32.add
                    set_local 8
                    get_local 17
                    i32.load8_u
                    i32.const 63
                    i32.and
                    set_local 13
                    br 2 (;@6;)
                  end
                  get_local 14
                  get_local 15
                  i32.const 12
                  i32.shl
                  i32.or
                  set_local 14
                  get_local 12
                  set_local 8
                  br 2 (;@5;)
                end
                i32.const 0
                set_local 13
                get_local 12
                set_local 8
              end
              get_local 14
              i32.const 6
              i32.shl
              get_local 15
              i32.const 18
              i32.shl
              i32.const 1835008
              i32.and
              i32.or
              get_local 13
              i32.or
              tee_local 14
              i32.const 1114112
              i32.eq
              br_if 3 (;@2;)
            end
            i32.const 2
            set_local 12
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 14
                          i32.const -9
                          i32.add
                          tee_local 13
                          i32.const 30
                          i32.gt_u
                          br_if 0 (;@11;)
                          get_local 14
                          set_local 15
                          block  ;; label = @12
                            get_local 13
                            br_table 0 (;@12;) 4 (;@8;) 2 (;@10;) 2 (;@10;) 3 (;@9;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 6 (;@6;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 2 (;@10;) 6 (;@6;) 0 (;@12;)
                          end
                          i32.const 116
                          set_local 15
                          br 4 (;@7;)
                        end
                        get_local 14
                        set_local 15
                        get_local 14
                        i32.const 92
                        i32.eq
                        br_if 4 (;@6;)
                      end
                      block  ;; label = @10
                        i32.const 1057120
                        get_local 14
                        call $core::unicode::bool_trie::BoolTrie::lookup::h62a25aa8bcb35afa
                        br_if 0 (;@10;)
                        get_local 14
                        call $core::unicode::printable::is_printable::h4739125d958c237d
                        br_if 5 (;@5;)
                      end
                      get_local 14
                      i32.const 1
                      i32.or
                      i32.clz
                      i32.const 2
                      i32.shr_u
                      i32.const 7
                      i32.xor
                      i64.extend_u/i32
                      i64.const 21474836480
                      i64.or
                      set_local 18
                      i32.const 3
                      set_local 12
                      get_local 14
                      set_local 15
                      br 3 (;@6;)
                    end
                    i32.const 114
                    set_local 15
                    br 1 (;@7;)
                  end
                  i32.const 110
                  set_local 15
                end
              end
              get_local 3
              get_local 1
              i32.store offset=4
              get_local 3
              get_local 0
              i32.store
              get_local 3
              get_local 9
              i32.store offset=8
              get_local 3
              get_local 10
              i32.store offset=12
              block  ;; label = @6
                get_local 10
                get_local 9
                i32.lt_u
                br_if 0 (;@6;)
                block  ;; label = @7
                  get_local 9
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 9
                  get_local 1
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 9
                  get_local 1
                  i32.ge_u
                  br_if 1 (;@6;)
                  get_local 0
                  get_local 9
                  i32.add
                  i32.load8_s
                  i32.const -65
                  i32.le_s
                  br_if 1 (;@6;)
                end
                block  ;; label = @7
                  get_local 10
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 10
                  get_local 1
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 10
                  get_local 1
                  i32.ge_u
                  br_if 1 (;@6;)
                  get_local 0
                  get_local 10
                  i32.add
                  i32.load8_s
                  i32.const -65
                  i32.le_s
                  br_if 1 (;@6;)
                end
                block  ;; label = @7
                  get_local 6
                  i32.load
                  get_local 0
                  get_local 9
                  i32.add
                  get_local 10
                  get_local 9
                  i32.sub
                  get_local 7
                  i32.load
                  i32.load offset=12
                  call_indirect (type 5)
                  br_if 0 (;@7;)
                  loop  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  get_local 12
                                  i32.const 3
                                  i32.and
                                  tee_local 9
                                  i32.const 1
                                  i32.eq
                                  br_if 0 (;@15;)
                                  i32.const 92
                                  set_local 13
                                  block  ;; label = @16
                                    get_local 9
                                    i32.const 2
                                    i32.eq
                                    br_if 0 (;@16;)
                                    get_local 9
                                    i32.const 3
                                    i32.ne
                                    br_if 6 (;@10;)
                                    get_local 18
                                    i64.const 32
                                    i64.shr_u
                                    i32.wrap/i64
                                    i32.const 7
                                    i32.and
                                    i32.const -1
                                    i32.add
                                    tee_local 9
                                    i32.const 4
                                    i32.gt_u
                                    br_if 6 (;@10;)
                                    block  ;; label = @17
                                      get_local 9
                                      br_table 0 (;@17;) 6 (;@11;) 4 (;@13;) 5 (;@12;) 3 (;@14;) 0 (;@17;)
                                    end
                                    get_local 18
                                    i64.const -1095216660481
                                    i64.and
                                    set_local 18
                                    i32.const 125
                                    set_local 13
                                    br 7 (;@9;)
                                  end
                                  i32.const 1
                                  set_local 12
                                  br 6 (;@9;)
                                end
                                i32.const 0
                                set_local 12
                                get_local 15
                                set_local 13
                                br 5 (;@9;)
                              end
                              get_local 18
                              i64.const -1095216660481
                              i64.and
                              i64.const 17179869184
                              i64.or
                              set_local 18
                              br 4 (;@9;)
                            end
                            get_local 18
                            i64.const -1095216660481
                            i64.and
                            i64.const 8589934592
                            i64.or
                            set_local 18
                            i32.const 123
                            set_local 13
                            br 3 (;@9;)
                          end
                          get_local 18
                          i64.const -1095216660481
                          i64.and
                          i64.const 12884901888
                          i64.or
                          set_local 18
                          i32.const 117
                          set_local 13
                          br 2 (;@9;)
                        end
                        get_local 15
                        get_local 18
                        i32.wrap/i64
                        tee_local 17
                        i32.const 2
                        i32.shl
                        i32.const 28
                        i32.and
                        i32.shr_u
                        i32.const 15
                        i32.and
                        tee_local 9
                        i32.const 48
                        i32.or
                        get_local 9
                        i32.const 87
                        i32.add
                        get_local 9
                        i32.const 10
                        i32.lt_u
                        select
                        set_local 13
                        block  ;; label = @11
                          get_local 17
                          i32.eqz
                          br_if 0 (;@11;)
                          get_local 18
                          i64.const -1
                          i64.add
                          i64.const 4294967295
                          i64.and
                          get_local 18
                          i64.const -4294967296
                          i64.and
                          i64.or
                          set_local 18
                          br 2 (;@9;)
                        end
                        get_local 18
                        i64.const -1095216660481
                        i64.and
                        i64.const 4294967296
                        i64.or
                        set_local 18
                        br 1 (;@9;)
                      end
                      i32.const 1
                      set_local 9
                      block  ;; label = @10
                        get_local 14
                        i32.const 128
                        i32.lt_u
                        br_if 0 (;@10;)
                        i32.const 2
                        set_local 9
                        get_local 14
                        i32.const 2048
                        i32.lt_u
                        br_if 0 (;@10;)
                        i32.const 3
                        i32.const 4
                        get_local 14
                        i32.const 65536
                        i32.lt_u
                        select
                        set_local 9
                      end
                      get_local 9
                      get_local 10
                      i32.add
                      set_local 9
                      br 4 (;@5;)
                    end
                    get_local 6
                    i32.load
                    get_local 13
                    get_local 7
                    i32.load
                    i32.load offset=16
                    call_indirect (type 0)
                    i32.eqz
                    br_if 0 (;@8;)
                  end
                end
                i32.const 1
                set_local 4
                br 5 (;@1;)
              end
              get_local 3
              get_local 3
              i32.const 8
              i32.add
              i32.store offset=20
              get_local 3
              get_local 3
              i32.store offset=16
              get_local 3
              get_local 3
              i32.const 12
              i32.add
              i32.store offset=24
              get_local 3
              i32.const 16
              i32.add
              call $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::h6d2e602fb5831b67
              unreachable
            end
            get_local 10
            get_local 11
            i32.sub
            get_local 8
            i32.add
            set_local 10
            get_local 8
            set_local 11
            get_local 5
            get_local 8
            i32.ne
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        set_local 9
      end
      get_local 3
      get_local 1
      i32.store offset=4
      get_local 3
      get_local 0
      i32.store
      get_local 3
      get_local 9
      i32.store offset=8
      get_local 3
      get_local 1
      i32.store offset=12
      block  ;; label = @2
        block  ;; label = @3
          get_local 9
          i32.eqz
          br_if 0 (;@3;)
          get_local 9
          get_local 1
          i32.eq
          br_if 0 (;@3;)
          block  ;; label = @4
            get_local 9
            get_local 1
            i32.ge_u
            br_if 0 (;@4;)
            get_local 0
            get_local 9
            i32.add
            tee_local 10
            i32.load8_s
            i32.const -65
            i32.gt_s
            br_if 2 (;@2;)
          end
          get_local 3
          get_local 3
          i32.const 8
          i32.add
          i32.store offset=20
          get_local 3
          get_local 3
          i32.store offset=16
          get_local 3
          get_local 3
          i32.const 12
          i32.add
          i32.store offset=24
          get_local 3
          i32.const 16
          i32.add
          call $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::h6d2e602fb5831b67
          unreachable
        end
        get_local 0
        get_local 9
        i32.add
        set_local 10
      end
      get_local 2
      i32.const 24
      i32.add
      tee_local 8
      i32.load
      get_local 10
      get_local 1
      get_local 9
      i32.sub
      get_local 2
      i32.const 28
      i32.add
      tee_local 9
      i32.load
      i32.load offset=12
      call_indirect (type 5)
      br_if 0 (;@1;)
      get_local 8
      i32.load
      i32.const 34
      get_local 9
      i32.load
      i32.load offset=16
      call_indirect (type 0)
      set_local 4
    end
    get_local 3
    i32.const 32
    i32.add
    set_global 0
    get_local 4)
  (func $_$LT$str$u20$as$u20$core..fmt..Display$GT$::fmt::h1f20bf1bdcce3a04 (type 5) (param i32 i32 i32) (result i32)
    get_local 2
    get_local 0
    get_local 1
    call $core::fmt::Formatter::pad::hcb6d9b95eaf1d310)
  (func $_$LT$char$u20$as$u20$core..fmt..Debug$GT$::fmt::hc7d0373599c7e949 (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i64 i32 i32)
    i32.const 1
    set_local 2
    block  ;; label = @1
      get_local 1
      i32.load offset=24
      i32.const 39
      get_local 1
      i32.const 28
      i32.add
      i32.load
      i32.load offset=16
      call_indirect (type 0)
      br_if 0 (;@1;)
      i32.const 2
      set_local 3
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 0
                    i32.load
                    tee_local 4
                    i32.const -9
                    i32.add
                    tee_local 2
                    i32.const 30
                    i32.gt_u
                    br_if 0 (;@8;)
                    block  ;; label = @9
                      get_local 2
                      br_table 0 (;@9;) 3 (;@6;) 2 (;@7;) 2 (;@7;) 4 (;@5;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 7 (;@2;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 2 (;@7;) 7 (;@2;) 0 (;@9;)
                    end
                    i32.const 116
                    set_local 4
                    br 6 (;@2;)
                  end
                  get_local 4
                  i32.const 92
                  i32.ne
                  br_if 0 (;@7;)
                  br 5 (;@2;)
                end
                i32.const 1057120
                get_local 4
                call $core::unicode::bool_trie::BoolTrie::lookup::h62a25aa8bcb35afa
                i32.eqz
                br_if 2 (;@4;)
                get_local 4
                i32.const 1
                i32.or
                i32.clz
                i32.const 2
                i32.shr_u
                i32.const 7
                i32.xor
                i64.extend_u/i32
                i64.const 21474836480
                i64.or
                set_local 5
                br 3 (;@3;)
              end
              i32.const 110
              set_local 4
              br 3 (;@2;)
            end
            i32.const 114
            set_local 4
            br 2 (;@2;)
          end
          block  ;; label = @4
            get_local 4
            call $core::unicode::printable::is_printable::h4739125d958c237d
            i32.eqz
            br_if 0 (;@4;)
            i32.const 1
            set_local 3
            br 2 (;@2;)
          end
          get_local 4
          i32.const 1
          i32.or
          i32.clz
          i32.const 2
          i32.shr_u
          i32.const 7
          i32.xor
          i64.extend_u/i32
          i64.const 21474836480
          i64.or
          set_local 5
        end
        i32.const 3
        set_local 3
      end
      get_local 1
      i32.const 24
      i32.add
      set_local 6
      loop  ;; label = @2
        i32.const 92
        set_local 0
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 3
                          i32.const 3
                          i32.and
                          tee_local 2
                          i32.const 3
                          i32.eq
                          br_if 0 (;@11;)
                          get_local 2
                          i32.const 2
                          i32.eq
                          br_if 1 (;@10;)
                          get_local 2
                          i32.const 1
                          i32.ne
                          br_if 7 (;@4;)
                          i32.const 0
                          set_local 3
                          get_local 4
                          set_local 0
                          br 8 (;@3;)
                        end
                        get_local 5
                        i64.const 32
                        i64.shr_u
                        i32.wrap/i64
                        i32.const 7
                        i32.and
                        i32.const -1
                        i32.add
                        tee_local 2
                        i32.const 4
                        i32.gt_u
                        br_if 6 (;@4;)
                        block  ;; label = @11
                          get_local 2
                          br_table 0 (;@11;) 2 (;@9;) 3 (;@8;) 4 (;@7;) 5 (;@6;) 0 (;@11;)
                        end
                        get_local 5
                        i64.const -1095216660481
                        i64.and
                        set_local 5
                        i32.const 125
                        set_local 0
                        br 7 (;@3;)
                      end
                      i32.const 1
                      set_local 3
                      br 6 (;@3;)
                    end
                    get_local 4
                    get_local 5
                    i32.wrap/i64
                    tee_local 7
                    i32.const 2
                    i32.shl
                    i32.const 28
                    i32.and
                    i32.shr_u
                    i32.const 15
                    i32.and
                    tee_local 2
                    i32.const 48
                    i32.or
                    get_local 2
                    i32.const 87
                    i32.add
                    get_local 2
                    i32.const 10
                    i32.lt_u
                    select
                    set_local 0
                    get_local 7
                    i32.eqz
                    br_if 3 (;@5;)
                    get_local 5
                    i64.const -1
                    i64.add
                    i64.const 4294967295
                    i64.and
                    get_local 5
                    i64.const -4294967296
                    i64.and
                    i64.or
                    set_local 5
                    br 5 (;@3;)
                  end
                  get_local 5
                  i64.const -1095216660481
                  i64.and
                  i64.const 8589934592
                  i64.or
                  set_local 5
                  i32.const 123
                  set_local 0
                  br 4 (;@3;)
                end
                get_local 5
                i64.const -1095216660481
                i64.and
                i64.const 12884901888
                i64.or
                set_local 5
                i32.const 117
                set_local 0
                br 3 (;@3;)
              end
              get_local 5
              i64.const -1095216660481
              i64.and
              i64.const 17179869184
              i64.or
              set_local 5
              br 2 (;@3;)
            end
            get_local 5
            i64.const -1095216660481
            i64.and
            i64.const 4294967296
            i64.or
            set_local 5
            br 1 (;@3;)
          end
          get_local 1
          i32.const 24
          i32.add
          i32.load
          i32.const 39
          get_local 1
          i32.const 28
          i32.add
          i32.load
          i32.load offset=16
          call_indirect (type 0)
          set_local 2
          br 2 (;@1;)
        end
        get_local 6
        i32.load
        get_local 0
        get_local 1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=16
        call_indirect (type 0)
        i32.eqz
        br_if 0 (;@2;)
      end
      i32.const 1
      return
    end
    get_local 2)
  (func $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::hffa0bd3a8d11115d (type 0) (param i32 i32) (result i32)
    get_local 1
    get_local 0
    i32.load
    get_local 0
    i32.load offset=4
    call $core::fmt::Formatter::pad::hcb6d9b95eaf1d310)
  (func $core::ptr::drop_in_place::h1210a22abf3aa466 (type 3) (param i32))
  (func $core::str::lossy::Utf8Lossy::from_bytes::hee82e80c1fd82afb (type 4) (param i32 i32 i32)
    get_local 0
    get_local 2
    i32.store offset=4
    get_local 0
    get_local 1
    i32.store)
  (func $_$LT$core..str..lossy..Utf8LossyChunksIter$LT$$u27$a$GT$$u20$as$u20$core..iter..iterator..Iterator$GT$::next::h5047905b35814b4e (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                get_local 1
                                i32.load offset=4
                                tee_local 2
                                i32.eqz
                                br_if 0 (;@14;)
                                get_local 1
                                i32.load
                                set_local 3
                                i32.const 0
                                set_local 4
                                block  ;; label = @15
                                  loop  ;; label = @16
                                    get_local 4
                                    i32.const 1
                                    i32.add
                                    set_local 5
                                    block  ;; label = @17
                                      get_local 3
                                      get_local 4
                                      i32.add
                                      tee_local 6
                                      i32.load8_u
                                      tee_local 7
                                      i32.const 24
                                      i32.shl
                                      i32.const 24
                                      i32.shr_s
                                      tee_local 8
                                      i32.const -1
                                      i32.le_s
                                      br_if 0 (;@17;)
                                      get_local 5
                                      tee_local 4
                                      get_local 2
                                      i32.lt_u
                                      br_if 1 (;@16;)
                                      br 2 (;@15;)
                                    end
                                    block  ;; label = @17
                                      get_local 7
                                      i32.const 1052835
                                      i32.add
                                      i32.load8_u
                                      tee_local 7
                                      i32.const 4
                                      i32.eq
                                      br_if 0 (;@17;)
                                      block  ;; label = @18
                                        get_local 7
                                        i32.const 3
                                        i32.eq
                                        br_if 0 (;@18;)
                                        get_local 7
                                        i32.const 2
                                        i32.ne
                                        br_if 5 (;@13;)
                                        get_local 2
                                        get_local 5
                                        i32.le_u
                                        br_if 6 (;@12;)
                                        get_local 3
                                        get_local 5
                                        i32.add
                                        i32.load8_u
                                        i32.const 192
                                        i32.and
                                        i32.const 128
                                        i32.ne
                                        br_if 6 (;@12;)
                                        get_local 4
                                        i32.const 2
                                        i32.add
                                        tee_local 4
                                        get_local 2
                                        i32.lt_u
                                        br_if 2 (;@16;)
                                        br 3 (;@15;)
                                      end
                                      get_local 2
                                      get_local 5
                                      i32.le_u
                                      br_if 10 (;@7;)
                                      get_local 3
                                      get_local 5
                                      i32.add
                                      i32.load8_u
                                      set_local 7
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          get_local 8
                                          i32.const -32
                                          i32.ne
                                          br_if 0 (;@19;)
                                          get_local 7
                                          i32.const -32
                                          i32.and
                                          i32.const 255
                                          i32.and
                                          i32.const 160
                                          i32.eq
                                          br_if 1 (;@18;)
                                        end
                                        block  ;; label = @19
                                          get_local 7
                                          i32.const 255
                                          i32.and
                                          tee_local 9
                                          i32.const 191
                                          i32.gt_u
                                          tee_local 10
                                          br_if 0 (;@19;)
                                          get_local 8
                                          i32.const 31
                                          i32.add
                                          i32.const 255
                                          i32.and
                                          i32.const 11
                                          i32.gt_u
                                          br_if 0 (;@19;)
                                          get_local 7
                                          i32.const 24
                                          i32.shl
                                          i32.const 24
                                          i32.shr_s
                                          i32.const 0
                                          i32.lt_s
                                          br_if 1 (;@18;)
                                        end
                                        block  ;; label = @19
                                          get_local 9
                                          i32.const 159
                                          i32.gt_u
                                          br_if 0 (;@19;)
                                          get_local 8
                                          i32.const -19
                                          i32.ne
                                          br_if 0 (;@19;)
                                          get_local 7
                                          i32.const 24
                                          i32.shl
                                          i32.const 24
                                          i32.shr_s
                                          i32.const 0
                                          i32.lt_s
                                          br_if 1 (;@18;)
                                        end
                                        get_local 10
                                        br_if 11 (;@7;)
                                        get_local 8
                                        i32.const 254
                                        i32.and
                                        i32.const 238
                                        i32.ne
                                        br_if 11 (;@7;)
                                        get_local 7
                                        i32.const 24
                                        i32.shl
                                        i32.const 24
                                        i32.shr_s
                                        i32.const -1
                                        i32.gt_s
                                        br_if 11 (;@7;)
                                      end
                                      get_local 2
                                      get_local 4
                                      i32.const 2
                                      i32.add
                                      tee_local 5
                                      i32.le_u
                                      br_if 6 (;@11;)
                                      get_local 3
                                      get_local 5
                                      i32.add
                                      i32.load8_u
                                      i32.const 192
                                      i32.and
                                      i32.const 128
                                      i32.ne
                                      br_if 6 (;@11;)
                                      get_local 4
                                      i32.const 3
                                      i32.add
                                      tee_local 4
                                      get_local 2
                                      i32.lt_u
                                      br_if 1 (;@16;)
                                      br 2 (;@15;)
                                    end
                                    get_local 2
                                    get_local 5
                                    i32.le_u
                                    br_if 8 (;@8;)
                                    get_local 3
                                    get_local 5
                                    i32.add
                                    i32.load8_u
                                    set_local 7
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        get_local 8
                                        i32.const -16
                                        i32.ne
                                        br_if 0 (;@18;)
                                        get_local 7
                                        i32.const 112
                                        i32.add
                                        i32.const 255
                                        i32.and
                                        i32.const 48
                                        i32.lt_u
                                        br_if 1 (;@17;)
                                      end
                                      block  ;; label = @18
                                        get_local 7
                                        i32.const 255
                                        i32.and
                                        tee_local 9
                                        i32.const 191
                                        i32.gt_u
                                        br_if 0 (;@18;)
                                        get_local 8
                                        i32.const 15
                                        i32.add
                                        i32.const 255
                                        i32.and
                                        i32.const 2
                                        i32.gt_u
                                        br_if 0 (;@18;)
                                        get_local 7
                                        i32.const 24
                                        i32.shl
                                        i32.const 24
                                        i32.shr_s
                                        i32.const 0
                                        i32.lt_s
                                        br_if 1 (;@17;)
                                      end
                                      get_local 9
                                      i32.const 143
                                      i32.gt_u
                                      br_if 9 (;@8;)
                                      get_local 8
                                      i32.const -12
                                      i32.ne
                                      br_if 9 (;@8;)
                                      get_local 7
                                      i32.const 24
                                      i32.shl
                                      i32.const 24
                                      i32.shr_s
                                      i32.const -1
                                      i32.gt_s
                                      br_if 9 (;@8;)
                                    end
                                    get_local 2
                                    get_local 4
                                    i32.const 2
                                    i32.add
                                    tee_local 5
                                    i32.le_u
                                    br_if 6 (;@10;)
                                    get_local 3
                                    get_local 5
                                    i32.add
                                    i32.load8_u
                                    i32.const 192
                                    i32.and
                                    i32.const 128
                                    i32.ne
                                    br_if 6 (;@10;)
                                    get_local 2
                                    get_local 4
                                    i32.const 3
                                    i32.add
                                    tee_local 5
                                    i32.le_u
                                    br_if 7 (;@9;)
                                    get_local 3
                                    get_local 5
                                    i32.add
                                    i32.load8_u
                                    i32.const 192
                                    i32.and
                                    i32.const 128
                                    i32.ne
                                    br_if 7 (;@9;)
                                    get_local 4
                                    i32.const 4
                                    i32.add
                                    tee_local 4
                                    get_local 2
                                    i32.lt_u
                                    br_if 0 (;@16;)
                                  end
                                end
                                get_local 1
                                i32.const 1053948
                                i32.store
                                get_local 0
                                get_local 3
                                i32.store
                                get_local 0
                                get_local 2
                                i32.store offset=4
                                get_local 1
                                i32.const 4
                                i32.add
                                i32.const 0
                                i32.store
                                get_local 0
                                i32.const 8
                                i32.add
                                i32.const 1053948
                                i32.store
                                get_local 0
                                i32.const 12
                                i32.add
                                i32.const 0
                                i32.store
                                return
                              end
                              get_local 0
                              i32.const 0
                              i32.store
                              return
                            end
                            get_local 2
                            get_local 4
                            i32.lt_u
                            br_if 6 (;@6;)
                            get_local 2
                            get_local 5
                            i32.lt_u
                            br_if 7 (;@5;)
                            get_local 0
                            get_local 3
                            i32.store
                            get_local 0
                            get_local 4
                            i32.store offset=4
                            get_local 1
                            i32.const 4
                            i32.add
                            get_local 2
                            get_local 5
                            i32.sub
                            i32.store
                            get_local 1
                            get_local 3
                            get_local 5
                            i32.add
                            i32.store
                            get_local 0
                            i32.const 8
                            i32.add
                            get_local 6
                            i32.store
                            get_local 0
                            i32.const 12
                            i32.add
                            i32.const 1
                            i32.store
                            return
                          end
                          get_local 2
                          get_local 4
                          i32.lt_u
                          br_if 5 (;@6;)
                          get_local 2
                          get_local 5
                          i32.lt_u
                          br_if 6 (;@5;)
                          get_local 0
                          get_local 3
                          i32.store
                          get_local 0
                          get_local 4
                          i32.store offset=4
                          get_local 1
                          i32.const 4
                          i32.add
                          get_local 2
                          get_local 5
                          i32.sub
                          i32.store
                          get_local 1
                          get_local 3
                          get_local 5
                          i32.add
                          i32.store
                          get_local 0
                          i32.const 8
                          i32.add
                          get_local 6
                          i32.store
                          get_local 0
                          i32.const 12
                          i32.add
                          i32.const 1
                          i32.store
                          return
                        end
                        get_local 2
                        get_local 4
                        i32.lt_u
                        br_if 4 (;@6;)
                        get_local 2
                        get_local 5
                        i32.lt_u
                        br_if 6 (;@4;)
                        get_local 0
                        get_local 3
                        i32.store
                        get_local 0
                        get_local 4
                        i32.store offset=4
                        get_local 1
                        i32.const 4
                        i32.add
                        get_local 2
                        get_local 5
                        i32.sub
                        i32.store
                        get_local 1
                        get_local 3
                        get_local 5
                        i32.add
                        i32.store
                        get_local 0
                        i32.const 8
                        i32.add
                        get_local 6
                        i32.store
                        get_local 0
                        i32.const 12
                        i32.add
                        i32.const 2
                        i32.store
                        return
                      end
                      get_local 2
                      get_local 4
                      i32.lt_u
                      br_if 3 (;@6;)
                      get_local 2
                      get_local 5
                      i32.lt_u
                      br_if 6 (;@3;)
                      get_local 0
                      get_local 3
                      i32.store
                      get_local 0
                      get_local 4
                      i32.store offset=4
                      get_local 1
                      i32.const 4
                      i32.add
                      get_local 2
                      get_local 5
                      i32.sub
                      i32.store
                      get_local 1
                      get_local 3
                      get_local 5
                      i32.add
                      i32.store
                      get_local 0
                      i32.const 8
                      i32.add
                      get_local 6
                      i32.store
                      get_local 0
                      i32.const 12
                      i32.add
                      i32.const 2
                      i32.store
                      return
                    end
                    get_local 2
                    get_local 4
                    i32.lt_u
                    br_if 2 (;@6;)
                    get_local 4
                    i32.const -3
                    i32.ge_u
                    br_if 6 (;@2;)
                    get_local 2
                    get_local 5
                    i32.lt_u
                    br_if 7 (;@1;)
                    get_local 0
                    get_local 3
                    i32.store
                    get_local 0
                    get_local 4
                    i32.store offset=4
                    get_local 1
                    i32.const 4
                    i32.add
                    get_local 2
                    get_local 5
                    i32.sub
                    i32.store
                    get_local 1
                    get_local 3
                    get_local 5
                    i32.add
                    i32.store
                    get_local 0
                    i32.const 8
                    i32.add
                    get_local 6
                    i32.store
                    get_local 0
                    i32.const 12
                    i32.add
                    i32.const 3
                    i32.store
                    return
                  end
                  get_local 2
                  get_local 4
                  i32.lt_u
                  br_if 1 (;@6;)
                  get_local 2
                  get_local 5
                  i32.lt_u
                  br_if 2 (;@5;)
                  get_local 0
                  get_local 3
                  i32.store
                  get_local 0
                  get_local 4
                  i32.store offset=4
                  get_local 1
                  i32.const 4
                  i32.add
                  get_local 2
                  get_local 5
                  i32.sub
                  i32.store
                  get_local 1
                  get_local 3
                  get_local 5
                  i32.add
                  i32.store
                  get_local 0
                  i32.const 8
                  i32.add
                  get_local 6
                  i32.store
                  get_local 0
                  i32.const 12
                  i32.add
                  i32.const 1
                  i32.store
                  return
                end
                get_local 2
                get_local 4
                i32.lt_u
                br_if 0 (;@6;)
                get_local 2
                get_local 5
                i32.lt_u
                br_if 1 (;@5;)
                get_local 0
                get_local 3
                i32.store
                get_local 0
                get_local 4
                i32.store offset=4
                get_local 1
                i32.const 4
                i32.add
                get_local 2
                get_local 5
                i32.sub
                i32.store
                get_local 1
                get_local 3
                get_local 5
                i32.add
                i32.store
                get_local 0
                i32.const 8
                i32.add
                get_local 6
                i32.store
                get_local 0
                i32.const 12
                i32.add
                i32.const 1
                i32.store
                return
              end
              get_local 4
              get_local 2
              call $core::slice::slice_index_len_fail::h776973317ada24d7
              unreachable
            end
            get_local 5
            get_local 2
            call $core::slice::slice_index_len_fail::h776973317ada24d7
            unreachable
          end
          get_local 5
          get_local 2
          call $core::slice::slice_index_len_fail::h776973317ada24d7
          unreachable
        end
        get_local 5
        get_local 2
        call $core::slice::slice_index_len_fail::h776973317ada24d7
        unreachable
      end
      get_local 4
      get_local 5
      call $core::slice::slice_index_order_fail::hc6db54a13869566a
      unreachable
    end
    get_local 5
    get_local 2
    call $core::slice::slice_index_len_fail::h776973317ada24d7
    unreachable)
  (func $_$LT$core..str..lossy..Utf8Lossy$u20$as$u20$core..fmt..Display$GT$::fmt::hb35ced54affafa88 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 3
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 1
            i32.eqz
            br_if 0 (;@4;)
            get_local 3
            get_local 1
            i32.store offset=12
            get_local 3
            get_local 0
            i32.store offset=8
            get_local 3
            i32.const 16
            i32.add
            get_local 3
            i32.const 8
            i32.add
            call $_$LT$core..str..lossy..Utf8LossyChunksIter$LT$$u27$a$GT$$u20$as$u20$core..iter..iterator..Iterator$GT$::next::h5047905b35814b4e
            block  ;; label = @5
              get_local 3
              i32.load offset=16
              tee_local 0
              i32.eqz
              br_if 0 (;@5;)
              get_local 3
              i32.const 28
              i32.add
              set_local 4
              get_local 2
              i32.const 24
              i32.add
              set_local 5
              get_local 2
              i32.const 28
              i32.add
              set_local 6
              loop  ;; label = @6
                get_local 4
                i32.load
                set_local 7
                get_local 3
                i32.load offset=20
                tee_local 8
                get_local 1
                i32.eq
                br_if 3 (;@3;)
                i32.const 1
                set_local 9
                get_local 5
                i32.load
                get_local 0
                get_local 8
                get_local 6
                i32.load
                i32.load offset=12
                call_indirect (type 5)
                br_if 4 (;@2;)
                block  ;; label = @7
                  get_local 7
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 5
                  i32.load
                  i32.const 65533
                  get_local 6
                  i32.load
                  i32.load offset=16
                  call_indirect (type 0)
                  br_if 5 (;@2;)
                end
                get_local 3
                i32.const 16
                i32.add
                get_local 3
                i32.const 8
                i32.add
                call $_$LT$core..str..lossy..Utf8LossyChunksIter$LT$$u27$a$GT$$u20$as$u20$core..iter..iterator..Iterator$GT$::next::h5047905b35814b4e
                get_local 3
                i32.load offset=16
                tee_local 0
                br_if 0 (;@6;)
              end
            end
            i32.const 0
            set_local 9
            br 2 (;@2;)
          end
          get_local 2
          i32.const 1053948
          i32.const 0
          call $core::fmt::Formatter::pad::hcb6d9b95eaf1d310
          set_local 9
          br 1 (;@2;)
        end
        get_local 7
        br_if 1 (;@1;)
        get_local 2
        get_local 0
        get_local 1
        call $core::fmt::Formatter::pad::hcb6d9b95eaf1d310
        set_local 9
      end
      get_local 3
      i32.const 32
      i32.add
      set_global 0
      get_local 9
      return
    end
    i32.const 1056988
    call $core::panicking::panic::h9b4aaddfe00d4a7f
    unreachable)
  (func $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::h6d2e602fb5831b67.1 (type 3) (param i32)
    (local i32)
    get_local 0
    i32.load
    tee_local 1
    i32.load
    get_local 1
    i32.load offset=4
    get_local 0
    i32.load offset=4
    i32.load
    get_local 0
    i32.load offset=8
    i32.load
    call $core::str::slice_error_fail::hb9184500007bb4cb
    unreachable)
  (func $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..RangeTo$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::hddf86f66fcc98b2f (type 2) (param i32 i32)
    get_local 0
    i32.load
    get_local 0
    i32.load offset=4
    i32.const 0
    get_local 1
    i32.load
    call $core::str::slice_error_fail::hb9184500007bb4cb
    unreachable)
  (func $_$LT$core..fmt..builders..PadAdapter$LT$$u27$a$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hcf357fdfd5a3a874 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 64
    i32.sub
    tee_local 3
    set_global 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 2
              i32.eqz
              br_if 0 (;@5;)
              get_local 3
              i32.const 56
              i32.add
              set_local 4
              get_local 0
              i32.const 8
              i32.add
              set_local 5
              get_local 3
              i32.const 44
              i32.add
              set_local 6
              get_local 3
              i32.const 48
              i32.add
              set_local 7
              get_local 3
              i32.const 52
              i32.add
              set_local 8
              get_local 0
              i32.const 4
              i32.add
              set_local 9
              loop  ;; label = @6
                block  ;; label = @7
                  get_local 5
                  i32.load8_u
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 0
                  i32.load
                  i32.const 1054003
                  i32.const 4
                  get_local 9
                  i32.load
                  i32.load offset=12
                  call_indirect (type 5)
                  br_if 3 (;@4;)
                end
                get_local 3
                i32.const 32
                i32.add
                i32.const 8
                i32.add
                tee_local 10
                i32.const 0
                i32.store
                get_local 6
                get_local 2
                i32.store
                get_local 7
                i64.const 4294967306
                i64.store
                get_local 4
                i32.const 10
                i32.store
                get_local 3
                get_local 2
                i32.store offset=36
                get_local 3
                get_local 1
                i32.store offset=32
                get_local 3
                i32.const 8
                i32.add
                i32.const 10
                get_local 1
                get_local 2
                call $core::slice::memchr::memchr::hc2eca95742004aba
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 3
                          i32.load offset=8
                          i32.const 1
                          i32.ne
                          br_if 0 (;@11;)
                          get_local 3
                          i32.load offset=12
                          set_local 11
                          loop  ;; label = @12
                            get_local 10
                            get_local 11
                            get_local 10
                            i32.load
                            i32.add
                            i32.const 1
                            i32.add
                            tee_local 11
                            i32.store
                            block  ;; label = @13
                              block  ;; label = @14
                                get_local 11
                                get_local 8
                                i32.load
                                tee_local 12
                                i32.ge_u
                                br_if 0 (;@14;)
                                get_local 3
                                i32.load offset=36
                                set_local 13
                                br 1 (;@13;)
                              end
                              get_local 3
                              i32.load offset=36
                              tee_local 13
                              get_local 11
                              i32.lt_u
                              br_if 0 (;@13;)
                              get_local 12
                              i32.const 5
                              i32.ge_u
                              br_if 5 (;@8;)
                              get_local 3
                              i32.load offset=32
                              get_local 11
                              get_local 12
                              i32.sub
                              tee_local 14
                              i32.add
                              tee_local 15
                              get_local 4
                              i32.eq
                              br_if 4 (;@9;)
                              get_local 15
                              get_local 4
                              get_local 12
                              call $memcmp
                              i32.eqz
                              br_if 4 (;@9;)
                            end
                            get_local 6
                            i32.load
                            tee_local 15
                            get_local 11
                            i32.lt_u
                            br_if 2 (;@10;)
                            get_local 13
                            get_local 15
                            i32.lt_u
                            br_if 2 (;@10;)
                            get_local 3
                            get_local 3
                            i32.const 32
                            i32.add
                            get_local 12
                            i32.add
                            i32.const 23
                            i32.add
                            i32.load8_u
                            get_local 3
                            i32.load offset=32
                            get_local 11
                            i32.add
                            get_local 15
                            get_local 11
                            i32.sub
                            call $core::slice::memchr::memchr::hc2eca95742004aba
                            get_local 3
                            i32.load offset=4
                            set_local 11
                            get_local 3
                            i32.load
                            i32.const 1
                            i32.eq
                            br_if 0 (;@12;)
                          end
                        end
                        get_local 10
                        get_local 6
                        i32.load
                        i32.store
                      end
                      get_local 5
                      i32.const 0
                      i32.store8
                      get_local 2
                      set_local 11
                      br 2 (;@7;)
                    end
                    get_local 5
                    i32.const 1
                    i32.store8
                    get_local 14
                    i32.const 1
                    i32.add
                    set_local 11
                    br 1 (;@7;)
                  end
                  get_local 12
                  i32.const 4
                  call $core::slice::slice_index_len_fail::h776973317ada24d7
                  unreachable
                end
                get_local 9
                i32.load
                set_local 15
                get_local 0
                i32.load
                set_local 12
                get_local 3
                get_local 1
                i32.store offset=32
                get_local 3
                get_local 2
                i32.store offset=36
                get_local 3
                get_local 11
                i32.store offset=16
                block  ;; label = @7
                  get_local 11
                  i32.eqz
                  get_local 2
                  get_local 11
                  i32.eq
                  i32.or
                  tee_local 10
                  br_if 0 (;@7;)
                  get_local 2
                  get_local 11
                  i32.le_u
                  br_if 5 (;@2;)
                  get_local 1
                  get_local 11
                  i32.add
                  i32.load8_s
                  i32.const -65
                  i32.le_s
                  br_if 5 (;@2;)
                end
                get_local 12
                get_local 1
                get_local 11
                get_local 15
                i32.load offset=12
                call_indirect (type 5)
                br_if 2 (;@4;)
                get_local 3
                get_local 2
                i32.store offset=20
                get_local 3
                get_local 1
                i32.store offset=16
                get_local 3
                get_local 11
                i32.store offset=24
                get_local 3
                get_local 2
                i32.store offset=28
                block  ;; label = @7
                  get_local 10
                  i32.eqz
                  br_if 0 (;@7;)
                  get_local 1
                  get_local 11
                  i32.add
                  set_local 1
                  get_local 2
                  get_local 11
                  i32.sub
                  tee_local 2
                  br_if 1 (;@6;)
                  br 2 (;@5;)
                end
                get_local 2
                get_local 11
                i32.le_u
                br_if 5 (;@1;)
                get_local 1
                get_local 11
                i32.add
                tee_local 1
                i32.load8_s
                i32.const -65
                i32.le_s
                br_if 5 (;@1;)
                get_local 2
                get_local 11
                i32.sub
                tee_local 2
                br_if 0 (;@6;)
              end
            end
            i32.const 0
            set_local 11
            br 1 (;@3;)
          end
          i32.const 1
          set_local 11
        end
        get_local 3
        i32.const 64
        i32.add
        set_global 0
        get_local 11
        return
      end
      get_local 3
      i32.const 32
      i32.add
      get_local 3
      i32.const 16
      i32.add
      call $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..RangeTo$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::hddf86f66fcc98b2f
      unreachable
    end
    get_local 3
    get_local 3
    i32.const 24
    i32.add
    i32.store offset=36
    get_local 3
    get_local 3
    i32.const 16
    i32.add
    i32.store offset=32
    get_local 3
    get_local 3
    i32.const 28
    i32.add
    i32.store offset=40
    get_local 3
    i32.const 32
    i32.add
    call $core::str::traits::_$LT$impl$u20$core..slice..SliceIndex$LT$str$GT$$u20$for$u20$core..ops..range..Range$LT$usize$GT$$GT$::index::_$u7b$$u7b$closure$u7d$$u7d$::h6d2e602fb5831b67.1
    unreachable)
  (func $core::fmt::builders::DebugStruct::field::hec77dd286480bd94 (type 11) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i64 i32 i32)
    get_global 0
    i32.const 96
    i32.sub
    tee_local 5
    set_global 0
    get_local 5
    get_local 2
    i32.store offset=12
    get_local 5
    get_local 1
    i32.store offset=8
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.load8_u offset=4
        br_if 0 (;@2;)
        get_local 5
        i32.const 1054007
        i32.const 1054008
        get_local 0
        i32.load8_u offset=5
        tee_local 1
        select
        tee_local 2
        i32.store offset=16
        get_local 5
        i32.const 1
        i32.const 2
        get_local 1
        select
        tee_local 6
        i32.store offset=20
        block  ;; label = @3
          get_local 0
          i32.load
          tee_local 1
          i32.load8_u
          i32.const 4
          i32.and
          br_if 0 (;@3;)
          get_local 5
          i32.const 80
          i32.add
          i32.const 12
          i32.add
          i32.const 60
          i32.store
          get_local 5
          i32.const 60
          i32.store offset=84
          get_local 1
          i32.const 28
          i32.add
          i32.load
          set_local 2
          get_local 5
          get_local 5
          i32.const 16
          i32.add
          i32.store offset=80
          get_local 5
          get_local 5
          i32.const 8
          i32.add
          i32.store offset=88
          get_local 1
          i32.load offset=24
          set_local 1
          get_local 5
          i32.const 24
          i32.add
          i32.const 12
          i32.add
          i32.const 2
          i32.store
          get_local 5
          i32.const 44
          i32.add
          i32.const 2
          i32.store
          get_local 5
          i32.const 3
          i32.store offset=28
          get_local 5
          i32.const 1057012
          i32.store offset=24
          get_local 5
          i32.const 1053876
          i32.store offset=32
          get_local 5
          get_local 5
          i32.const 80
          i32.add
          i32.store offset=40
          get_local 1
          get_local 2
          get_local 5
          i32.const 24
          i32.add
          call $core::fmt::write::hc8a86a45c34c9d88
          br_if 1 (;@2;)
          get_local 3
          get_local 0
          i32.load
          get_local 4
          i32.load offset=12
          call_indirect (type 0)
          set_local 1
          br 2 (;@1;)
        end
        get_local 5
        get_local 1
        i64.load offset=24 align=4
        i64.store offset=80
        get_local 1
        i32.const 12
        i32.add
        i32.load
        set_local 7
        get_local 5
        i32.const 0
        i32.store8 offset=88
        get_local 1
        i64.load align=4
        set_local 8
        get_local 5
        i32.const 24
        i32.add
        i32.const 12
        i32.add
        get_local 7
        i32.store
        get_local 5
        i32.const 24
        i32.add
        i32.const 20
        i32.add
        get_local 1
        i32.const 20
        i32.add
        i32.load
        i32.store
        get_local 5
        get_local 1
        i32.load8_u offset=48
        i32.store8 offset=72
        get_local 5
        get_local 8
        i64.store offset=24
        get_local 5
        get_local 1
        i32.load offset=8
        i32.store offset=32
        get_local 5
        get_local 1
        i32.load offset=16
        i32.store offset=40
        get_local 1
        i32.const 44
        i32.add
        i32.load
        set_local 7
        get_local 1
        i32.const 36
        i32.add
        i32.load
        set_local 9
        get_local 5
        get_local 5
        i32.const 80
        i32.add
        i32.store offset=48
        get_local 1
        i32.load offset=40
        set_local 10
        get_local 1
        i32.load offset=32
        set_local 1
        get_local 5
        i32.const 52
        i32.add
        i32.const 1056932
        i32.store
        get_local 5
        get_local 1
        i32.store offset=56
        get_local 5
        i32.const 24
        i32.add
        i32.const 36
        i32.add
        get_local 9
        i32.store
        get_local 5
        get_local 10
        i32.store offset=64
        get_local 5
        i32.const 24
        i32.add
        i32.const 44
        i32.add
        get_local 7
        i32.store
        get_local 5
        i32.const 80
        i32.add
        get_local 2
        get_local 6
        i32.const 0
        i32.load offset=1056944
        tee_local 1
        call_indirect (type 5)
        br_if 0 (;@2;)
        get_local 5
        i32.const 80
        i32.add
        i32.const 1054010
        i32.const 1
        get_local 1
        call_indirect (type 5)
        br_if 0 (;@2;)
        get_local 5
        i32.const 80
        i32.add
        get_local 5
        i32.load offset=8
        get_local 5
        i32.load offset=12
        get_local 1
        call_indirect (type 5)
        br_if 0 (;@2;)
        get_local 5
        i32.const 80
        i32.add
        i32.const 1054011
        i32.const 2
        get_local 1
        call_indirect (type 5)
        br_if 0 (;@2;)
        get_local 3
        get_local 5
        i32.const 24
        i32.add
        get_local 4
        i32.load offset=12
        call_indirect (type 0)
        set_local 1
        br 1 (;@1;)
      end
      i32.const 1
      set_local 1
    end
    get_local 0
    i32.const 5
    i32.add
    i32.const 1
    i32.store8
    get_local 0
    i32.const 4
    i32.add
    get_local 1
    i32.store8
    get_local 5
    i32.const 96
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::builders::DebugStruct::finish::h3dd8d635d04004d8 (type 10) (param i32) (result i32)
    (local i32 i32)
    get_local 0
    i32.load8_u offset=4
    set_local 1
    block  ;; label = @1
      get_local 0
      i32.load8_u offset=5
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      i32.const 255
      i32.and
      set_local 2
      i32.const 1
      set_local 1
      block  ;; label = @2
        get_local 2
        br_if 0 (;@2;)
        get_local 0
        i32.load
        tee_local 1
        i32.load offset=24
        i32.const 1054014
        i32.const 1054016
        get_local 1
        i32.load
        i32.const 4
        i32.and
        select
        i32.const 2
        get_local 1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect (type 5)
        set_local 1
      end
      get_local 0
      i32.const 4
      i32.add
      get_local 1
      i32.store8
    end
    get_local 1
    i32.const 255
    i32.and
    i32.const 0
    i32.ne)
  (func $core::fmt::builders::DebugTuple::field::hd3b43611deb92f36 (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i64 i32)
    get_global 0
    i32.const 80
    i32.sub
    tee_local 3
    set_global 0
    i32.const 1
    set_local 4
    block  ;; label = @1
      get_local 0
      i32.load8_u offset=8
      br_if 0 (;@1;)
      i32.const 1054007
      i32.const 1054018
      get_local 0
      i32.const 4
      i32.add
      i32.load
      tee_local 6
      select
      set_local 7
      block  ;; label = @2
        get_local 0
        i32.load
        tee_local 5
        i32.load8_u
        i32.const 4
        i32.and
        br_if 0 (;@2;)
        i32.const 1
        set_local 4
        get_local 5
        i32.load offset=24
        get_local 7
        i32.const 1
        get_local 5
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect (type 5)
        br_if 1 (;@1;)
        get_local 0
        i32.load
        tee_local 5
        i32.load offset=24
        i32.const 1054013
        i32.const 1053948
        get_local 6
        select
        get_local 6
        i32.const 0
        i32.ne
        get_local 5
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect (type 5)
        br_if 1 (;@1;)
        get_local 1
        get_local 0
        i32.load
        get_local 2
        i32.load offset=12
        call_indirect (type 0)
        set_local 4
        br 1 (;@1;)
      end
      get_local 3
      get_local 5
      i64.load offset=24 align=4
      i64.store offset=8
      get_local 5
      i32.const 12
      i32.add
      i32.load
      set_local 4
      get_local 3
      i32.const 0
      i32.store8 offset=16
      get_local 5
      i64.load align=4
      set_local 8
      get_local 3
      i32.const 24
      i32.add
      i32.const 12
      i32.add
      get_local 4
      i32.store
      get_local 3
      i32.const 24
      i32.add
      i32.const 20
      i32.add
      get_local 5
      i32.const 20
      i32.add
      i32.load
      i32.store
      get_local 3
      get_local 5
      i32.load8_u offset=48
      i32.store8 offset=72
      get_local 3
      get_local 8
      i64.store offset=24
      get_local 3
      get_local 5
      i32.load offset=8
      i32.store offset=32
      get_local 3
      get_local 5
      i32.load offset=16
      i32.store offset=40
      get_local 5
      i32.const 44
      i32.add
      i32.load
      set_local 4
      get_local 5
      i32.const 36
      i32.add
      i32.load
      set_local 6
      get_local 3
      get_local 3
      i32.const 8
      i32.add
      i32.store offset=48
      get_local 5
      i32.load offset=40
      set_local 9
      get_local 5
      i32.load offset=32
      set_local 5
      get_local 3
      i32.const 52
      i32.add
      i32.const 1056932
      i32.store
      get_local 3
      get_local 5
      i32.store offset=56
      get_local 3
      i32.const 24
      i32.add
      i32.const 36
      i32.add
      get_local 6
      i32.store
      get_local 3
      get_local 9
      i32.store offset=64
      get_local 3
      i32.const 24
      i32.add
      i32.const 44
      i32.add
      get_local 4
      i32.store
      i32.const 1
      set_local 4
      get_local 3
      i32.const 8
      i32.add
      get_local 7
      i32.const 1
      i32.const 0
      i32.load offset=1056944
      tee_local 5
      call_indirect (type 5)
      br_if 0 (;@1;)
      get_local 3
      i32.const 8
      i32.add
      i32.const 1054010
      i32.const 1
      get_local 5
      call_indirect (type 5)
      br_if 0 (;@1;)
      get_local 1
      get_local 3
      i32.const 24
      i32.add
      get_local 2
      i32.load offset=12
      call_indirect (type 0)
      set_local 4
    end
    get_local 0
    i32.const 8
    i32.add
    get_local 4
    i32.store8
    get_local 0
    i32.const 4
    i32.add
    tee_local 5
    get_local 5
    i32.load
    i32.const 1
    i32.add
    i32.store
    get_local 3
    i32.const 80
    i32.add
    set_global 0
    get_local 0)
  (func $core::fmt::builders::DebugTuple::finish::h49e80920431344b7 (type 10) (param i32) (result i32)
    (local i32 i32 i32)
    get_local 0
    i32.load8_u offset=8
    set_local 1
    block  ;; label = @1
      get_local 0
      i32.load offset=4
      tee_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      i32.const 255
      i32.and
      set_local 3
      i32.const 1
      set_local 1
      block  ;; label = @2
        get_local 3
        br_if 0 (;@2;)
        block  ;; label = @3
          get_local 0
          i32.load
          tee_local 3
          i32.load8_u
          i32.const 4
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          i32.const 1
          set_local 1
          get_local 3
          i32.load offset=24
          i32.const 1054010
          i32.const 1
          get_local 3
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect (type 5)
          br_if 1 (;@2;)
          get_local 0
          i32.const 4
          i32.add
          i32.load
          set_local 2
        end
        block  ;; label = @3
          get_local 2
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          get_local 0
          i32.load8_u offset=9
          i32.eqz
          br_if 0 (;@3;)
          i32.const 1
          set_local 1
          get_local 0
          i32.load
          tee_local 3
          i32.load offset=24
          i32.const 1054007
          i32.const 1
          get_local 3
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect (type 5)
          br_if 1 (;@2;)
        end
        get_local 0
        i32.load
        tee_local 1
        i32.load offset=24
        i32.const 1054019
        i32.const 1
        get_local 1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect (type 5)
        set_local 1
      end
      get_local 0
      i32.const 8
      i32.add
      get_local 1
      i32.store8
    end
    get_local 1
    i32.const 255
    i32.and
    i32.const 0
    i32.ne)
  (func $core::fmt::Write::write_char::hefa3b7e0a5e2a797 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    i32.const 0
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        get_local 1
        i32.const 127
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.store8 offset=12
        i32.const 1
        set_local 1
        br 1 (;@1;)
      end
      block  ;; label = @2
        get_local 1
        i32.const 2047
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        get_local 2
        get_local 1
        i32.const 6
        i32.shr_u
        i32.const 31
        i32.and
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        set_local 1
        br 1 (;@1;)
      end
      block  ;; label = @2
        get_local 1
        i32.const 65535
        i32.gt_u
        br_if 0 (;@2;)
        get_local 2
        get_local 1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=14
        get_local 2
        get_local 1
        i32.const 6
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        get_local 2
        get_local 1
        i32.const 12
        i32.shr_u
        i32.const 15
        i32.and
        i32.const 224
        i32.or
        i32.store8 offset=12
        i32.const 3
        set_local 1
        br 1 (;@1;)
      end
      get_local 2
      get_local 1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      get_local 2
      get_local 1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      get_local 2
      get_local 1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      get_local 2
      get_local 1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      i32.const 4
      set_local 1
    end
    get_local 0
    get_local 2
    i32.const 12
    i32.add
    get_local 1
    call $_$LT$core..fmt..builders..PadAdapter$LT$$u27$a$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hcf357fdfd5a3a874
    set_local 1
    get_local 2
    i32.const 16
    i32.add
    set_global 0
    get_local 1)
  (func $core::fmt::Write::write_fmt::h18dd003781431812 (type 0) (param i32 i32) (result i32)
    (local i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 0
    i32.store offset=4
    get_local 2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    get_local 1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    get_local 1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    get_local 2
    get_local 1
    i64.load align=4
    i64.store offset=8
    get_local 2
    i32.const 4
    i32.add
    i32.const 1057036
    get_local 2
    i32.const 8
    i32.add
    call $core::fmt::write::hc8a86a45c34c9d88
    set_local 1
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 1)
  (func $core::ptr::drop_in_place::h028cb9a57ccf759b (type 3) (param i32))
  (func $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::hdabee12c40cb5e1b (type 8) (param i32) (result i64)
    i64.const -4572523988785928430)
  (func $core::panicking::panic_bounds_check::h083d97c982ea32c3 (type 4) (param i32 i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 3
    set_global 0
    get_local 3
    get_local 2
    i32.store offset=4
    get_local 3
    get_local 1
    i32.store
    get_local 3
    i32.const 32
    i32.add
    i32.const 12
    i32.add
    i32.const 7
    i32.store
    get_local 3
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    i32.const 2
    i32.store
    get_local 3
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    get_local 3
    i32.const 7
    i32.store offset=36
    get_local 3
    i32.const 1057076
    i32.store offset=8
    get_local 3
    i32.const 2
    i32.store offset=12
    get_local 3
    i32.const 1054108
    i32.store offset=16
    get_local 3
    get_local 3
    i32.const 4
    i32.add
    i32.store offset=32
    get_local 3
    get_local 3
    i32.store offset=40
    get_local 3
    get_local 3
    i32.const 32
    i32.add
    i32.store offset=24
    get_local 3
    i32.const 8
    i32.add
    get_local 0
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $core::panic::PanicInfo::message::h0efc9203d9a8183a (type 10) (param i32) (result i32)
    get_local 0
    i32.load offset=8)
  (func $core::panic::PanicInfo::location::h420838d3cb8d7c08 (type 10) (param i32) (result i32)
    get_local 0
    i32.const 12
    i32.add)
  (func $core::panic::Location::internal_constructor::haae95faa9a5f046b (type 14) (param i32 i32 i32 i32 i32)
    get_local 0
    get_local 2
    i32.store offset=4
    get_local 0
    get_local 1
    i32.store
    get_local 0
    get_local 3
    i32.store offset=8
    get_local 0
    get_local 4
    i32.store offset=12)
  (func $core::panic::Location::file::ha94f8b63a2f463dd (type 2) (param i32 i32)
    get_local 0
    get_local 1
    i64.load align=4
    i64.store align=4)
  (func $core::panic::Location::line::h7b805301c6ddc4c3 (type 10) (param i32) (result i32)
    get_local 0
    i32.load offset=8)
  (func $core::panic::Location::column::h5635ec1f41441840 (type 10) (param i32) (result i32)
    get_local 0
    i32.load offset=12)
  (func $core::panicking::panic::h9b4aaddfe00d4a7f (type 3) (param i32)
    (local i32 i64 i64 i64)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 1
    set_global 0
    get_local 0
    i64.load offset=16 align=4
    set_local 2
    get_local 0
    i64.load offset=8 align=4
    set_local 3
    get_local 0
    i64.load align=4
    set_local 4
    get_local 1
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    get_local 1
    get_local 4
    i64.store offset=24
    get_local 1
    i64.const 1
    i64.store offset=4 align=4
    get_local 1
    i32.const 1054020
    i32.store offset=16
    get_local 1
    get_local 1
    i32.const 24
    i32.add
    i32.store
    get_local 1
    get_local 3
    i64.store offset=32
    get_local 1
    get_local 2
    i64.store offset=40
    get_local 1
    get_local 1
    i32.const 32
    i32.add
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $core::panicking::panic_fmt::h2155aa66b67fe83c (type 2) (param i32 i32)
    (local i32 i64)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    get_local 1
    i64.load align=4
    set_local 3
    get_local 2
    i32.const 20
    i32.add
    get_local 1
    i64.load offset=8 align=4
    i64.store align=4
    get_local 2
    i32.const 1057060
    i32.store offset=4
    get_local 2
    i32.const 1054020
    i32.store
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    get_local 3
    i64.store offset=12 align=4
    get_local 2
    call $rust_begin_unwind
    unreachable)
  (func $core::option::expect_failed::h0ee1e896fd083f84 (type 2) (param i32 i32)
    (local i32)
    get_global 0
    i32.const 48
    i32.sub
    tee_local 2
    set_global 0
    get_local 2
    get_local 1
    i32.store offset=12
    get_local 2
    get_local 0
    i32.store offset=8
    get_local 2
    i32.const 28
    i32.add
    i32.const 1
    i32.store
    get_local 2
    i32.const 36
    i32.add
    i32.const 1
    i32.store
    get_local 2
    i32.const 60
    i32.store offset=44
    get_local 2
    i32.const 1057092
    i32.store offset=16
    get_local 2
    i32.const 1
    i32.store offset=20
    get_local 2
    i32.const 1054020
    i32.store offset=24
    get_local 2
    get_local 2
    i32.const 8
    i32.add
    i32.store offset=40
    get_local 2
    get_local 2
    i32.const 40
    i32.add
    i32.store offset=32
    get_local 2
    i32.const 16
    i32.add
    i32.const 1057100
    call $core::panicking::panic_fmt::h2155aa66b67fe83c
    unreachable)
  (func $memcpy (type 5) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      get_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      set_local 3
      loop  ;; label = @2
        get_local 3
        get_local 1
        i32.load8_u
        i32.store8
        get_local 1
        i32.const 1
        i32.add
        set_local 1
        get_local 3
        i32.const 1
        i32.add
        set_local 3
        get_local 2
        i32.const -1
        i32.add
        tee_local 2
        br_if 0 (;@2;)
      end
    end
    get_local 0)
  (func $memcmp (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 2
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        set_local 3
        loop  ;; label = @3
          get_local 0
          get_local 3
          i32.add
          i32.load8_u
          tee_local 4
          get_local 1
          get_local 3
          i32.add
          i32.load8_u
          tee_local 5
          i32.ne
          br_if 2 (;@1;)
          get_local 3
          i32.const 1
          i32.add
          tee_local 3
          get_local 2
          i32.lt_u
          br_if 0 (;@3;)
        end
        i32.const 0
        return
      end
      i32.const 0
      return
    end
    get_local 4
    get_local 5
    i32.sub)
  (table (;0;) 75 75 anyfunc)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1059156))
  (global (;2;) i32 (i32.const 1059156))
  (export "memory" (memory 0))
  (export "__indirect_function_table" (table 0))
  (export "__heap_base" (global 1))
  (export "__data_end" (global 2))
  (export "main" (func $main))
  (elem (;0;) (i32.const 1) $_$LT$std..io..error..Error$u20$as$u20$core..fmt..Debug$GT$::fmt::h613a4cb9bb31a3f1 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::hf694c42c0d6ebc75 $_$LT$std..path..Display$LT$$u27$a$GT$$u20$as$u20$core..fmt..Display$GT$::fmt::h3167292a36c61c19 $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$::fmt::hcecd1e62e7515144 $_$LT$alloc..string..String$u20$as$u20$core..fmt..Display$GT$::fmt::h0585c26a34dbb6c1 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::h2a55ae0011bb0dc7 $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$::fmt::he95f10a4d9a87fbf $std::alloc::default_alloc_error_hook::h5119c13a26248f94 $core::ptr::drop_in_place::h80e2533b22b5a3bf $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$std..error..Error$GT$::description::ha8c9d55be0fd6129 $std::error::Error::cause::h92ea54f2367adbb6 $std::error::Error::source::h251fc175156920a2 $std::error::Error::type_id::h71d516fe603cd5ee $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$core..fmt..Display$GT$::fmt::h3176359b64c8ce76 $_$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$$LP$dyn$u20$std..error..Error$u20$$u2b$$u20$core..marker..Sync$u20$$u2b$$u20$core..marker..Send$u20$$u2b$$u20$$u27$static$RP$$GT$$GT$..from..StringError$u20$as$u20$core..fmt..Debug$GT$::fmt::hfa94ec28b42f41e4 $core::ptr::drop_in_place::h1198034061628adf $_$LT$std..io..error..ErrorKind$u20$as$u20$core..fmt..Debug$GT$::fmt::hff5c95ebe2c095ea $core::fmt::num::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$i32$GT$::fmt::hc2938f31b1162c1e $_$LT$alloc..string..String$u20$as$u20$core..fmt..Debug$GT$::fmt::hd9ac2cca6a9e8ca1 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::h60ebfe1199844e78 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::hf7d2ad93e91a98c6 $_$LT$core..cell..BorrowMutError$u20$as$u20$core..fmt..Debug$GT$::fmt::h81cf23ef596fc4b8 $_$LT$std..thread..local..AccessError$u20$as$u20$core..fmt..Debug$GT$::fmt::hd51ae23e44471b04 $std::io::stdio::stdout::stdout_init::hb82f078796357a48 $std::io::stdio::stdout::h7a394bc990386878 $_$LT$std..io..error..Error$u20$as$u20$core..fmt..Display$GT$::fmt::hf5e6a284176ba0b8 $std::io::stdio::LOCAL_STDOUT::__getit::hd86edd9cc0822ea6 $std::io::stdio::LOCAL_STDOUT::__init::h94c1be4df9250ab3 $core::ptr::drop_in_place::h8c7bdd32f8c6814d $_$LT$std..io..Write..write_fmt..Adaptor$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h9cb7ff25da07d5f0 $core::fmt::Write::write_char::h08406ae678520f2d $core::fmt::Write::write_fmt::h47ad4410c998f2f4 $core::ptr::drop_in_place::h0de34b0aedc80776 $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h19f8ffc5c07cfa34 $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h5e851b0b920c40fb $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::h05b6a806ce25ddb7 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::h9d40d70d7b21b15b $_$LT$core..fmt..Arguments$LT$$u27$a$GT$$u20$as$u20$core..fmt..Display$GT$::fmt::h0d0eabd8a96d84a6 $core::ptr::drop_in_place::h050223db4f2f03cc $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hdac212800cc7ae5b $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h8e59789c90076a59 $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::h232d2e9c1bb9d6d7 $core::fmt::num::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h94a2123718ad2fae $core::ptr::drop_in_place::h07afdff9e8d2c6fa $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h358447a6533dac2f $_$LT$F$u20$as$u20$alloc..boxed..FnBox$LT$A$GT$$GT$::call_box::h282eac7bd732b330 $std::panicking::update_panic_count::PANIC_COUNT::__getit::he94c221774b7706f $std::panicking::update_panic_count::PANIC_COUNT::__init::he13d019907e82236 $core::ptr::drop_in_place::h3a08d5b0bfab5fda $_$LT$std..panicking..continue_panic_fmt..PanicPayload$LT$$u27$a$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::box_me_up::h0f1df4ec4b1fb14a $_$LT$std..panicking..continue_panic_fmt..PanicPayload$LT$$u27$a$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::get::h1172a3d45c0df356 $core::ptr::drop_in_place::h80e2533b22b5a3bf.1 $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h740591e78f6d2d59 $_$LT$std..panicking..begin_panic..PanicPayload$LT$A$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::box_me_up::hcf9a6190219ec907 $_$LT$std..panicking..begin_panic..PanicPayload$LT$A$GT$$u20$as$u20$core..panic..BoxMeUp$GT$::get::h60bfa704555f22d9 $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h51af4ad49d9e9a5c $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::h925878a4893011a0 $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::he35686c8c6e5facb $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Debug$GT$::fmt::he390991cf7dc224a $_$LT$$RF$$u27$a$u20$T$u20$as$u20$core..fmt..Display$GT$::fmt::hffa0bd3a8d11115d $_$LT$char$u20$as$u20$core..fmt..Debug$GT$::fmt::hc7d0373599c7e949 $_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$::fmt::h7ab41a41c2708e60 $core::fmt::num::_$LT$impl$u20$core..fmt..Debug$u20$for$u20$usize$GT$::fmt::hdd33c58fe3ba02da $core::fmt::ArgumentV1::show_usize::h8b4f357c5a0b63d7__.llvm.3436319850126977588_ $core::ptr::drop_in_place::hc3c175563f550c59 $_$LT$core..fmt..builders..PadAdapter$LT$$u27$a$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::hcf357fdfd5a3a874 $core::fmt::Write::write_char::hefa3b7e0a5e2a797 $core::fmt::Write::write_fmt::h18dd003781431812 $core::ptr::drop_in_place::h1210a22abf3aa466 $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_str::h005e9ac1ed3e1c92 $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_char::h7d70eff5afbbc1ab $_$LT$core..fmt..Write..write_fmt..Adapter$LT$$u27$a$C$$u20$T$GT$$u20$as$u20$core..fmt..Write$GT$::write_fmt::hafb67904b8e1444a $core::ptr::drop_in_place::h028cb9a57ccf759b $_$LT$T$u20$as$u20$core..any..Any$GT$::get_type_id::hdabee12c40cb5e1b)
  (data (;0;) (i32.const 1048576) ": \00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/result.rscalled `Result::unwrap()` on an `Err` valueThe current directory is \0a\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00Hello macro!\0a\00\00\00Hello world!\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00unexpected end of fileother os erroroperation interruptedwrite zerotimed outinvalid datainvalid input parameteroperation would blockentity already existsbroken pipeaddress not availableaddress in usenot connectedconnection abortedconnection resetconnection refusedpermission deniedentity not foundKindOscodekindmessage\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00 (os error )memory allocation of  bytes failedCustomerrorUnexpectedEofOtherInterruptedWriteZeroTimedOutInvalidDataInvalidInputWouldBlockAlreadyExistsBrokenPipeAddrNotAvailableAddrInUseNotConnectedConnectionAbortedConnectionResetConnectionRefusedPermissionDeniedNotFoundlibstd/sys/wasm/mutex.rscannot recursively acquire mutexinternal error: entered unreachable codeliballoc/raw_vec.rs: \00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/result.rsoperation successfulcalled `Option::unwrap()` on a `None` valuelibcore/option.rslibstd/sys/wasm/mutex.rscannot recursively acquire mutexalready borrowedcannot access stdout during shutdownfailed printing to : \00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libstd/io/stdio.rsstdoutfailed to write whole bufferformatter errorassertion failed: `(left == right)`\0a  left: ``,\0a right: ``: destination and source slices have different lengths\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\02\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/slice/mod.rsoperation not supported on wasm yetcalled `Option::unwrap()` on a `None` valuelibcore/option.rsAccessErrorcannot access a TLS value during or after it is destroyedcalled `Option::unwrap()` on a `None` valuelibcore/option.rs\00thread panicked while processing panic. aborting.\0athread panicked while panicking. aborting.\0afailed to initiate panic, error \00\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00StringErrorrwlock locked for writinginternal error: entered unreachable codeliballoc/raw_vec.rscapacity overflowassertion failed: `(left == right)`\0a  left: ``,\0a right: ``: destination and source slices have different lengths\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\02\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/slice/mod.rs0x00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899called `Option::unwrap()` on a `None` valuelibcore/option.rs\00\01\03\05\05\06\06\03\07\06\08\08\09\11\0a\1c\0b\19\0c\14\0d\12\0e\16\0f\04\10\03\12\12\13\09\16\01\17\05\18\02\19\03\1a\07\1c\02\1d\01\1f\16 \03+\06,\02-\0b.\010\031\022\02\a9\02\aa\04\ab\08\fa\02\fb\05\fd\04\fe\03\ff\09\adxy\8b\8d\a20WX\8b\8c\90\1c\1d\dd\0e\0fKL\fb\fc./?\5c]_\b5\e2\84\8d\8e\91\92\a9\b1\ba\bb\c5\c6\c9\ca\de\e4\e5\ff\00\04\11\12)147:;=IJ]\84\8e\92\a9\b1\b4\ba\bb\c6\ca\ce\cf\e4\e5\00\04\0d\0e\11\12)14:;EFIJ^de\84\91\9b\9d\c9\ce\cf\0d\11)EIWde\8d\91\a9\b4\ba\bb\c5\c9\df\e4\e5\f0\04\0d\11EIde\80\81\84\b2\bc\be\bf\d5\d7\f0\f1\83\85\86\89\8b\8c\98\a0\a4\a6\a8\a9\ac\ba\be\bf\c5\c7\ce\cf\da\dbH\98\bd\cd\c6\ce\cfINOWY^_\89\8e\8f\b1\b6\b7\bf\c1\c6\c7\d7\11\16\17[\5c\f6\f7\fe\ff\80\0dmq\de\df\0e\0f\1fno\1c\1d_}~\ae\af\bb\bc\fa\16\17\1e\1fFGNOXZ\5c^~\7f\b5\c5\d4\d5\dc\f0\f1\f5rs\8ftu\96\97\c9\ff/_&./\a7\af\b7\bf\c7\cf\d7\df\9a@\97\980\8f\1f\ff\ce\ffNOZ[\07\08\0f\10'/\ee\efno7=?BE\90\91\fe\ffSgu\c8\c9\d0\d1\d8\d9\e7\fe\ff\00 _\22\82\df\04\82D\08\1b\04\06\11\81\ac\0e\80\ab5\1e\15\80\e0\03\19\08\01\04/\044\04\07\03\01\07\06\07\11\0aP\0f\12\07U\08\02\04\1c\0a\09\03\08\03\07\03\02\03\03\03\0c\04\05\03\0b\06\01\0e\15\05:\03\11\07\06\05\10\08V\07\02\07\15\0dP\04C\03-\03\01\04\11\06\0f\0c:\04\1d%\0d\06L m\04j%\80\c8\05\82\b0\03\1a\06\82\fd\03Y\07\15\0b\17\09\14\0c\14\0cj\06\0a\06\1a\06Y\07+\05F\0a,\04\0c\04\01\031\0b,\04\1a\06\0b\03\80\ac\06\0a\06\1fAL\04-\03t\08<\03\0f\03<\078\08*\06\82\ff\11\18\08/\11-\03 \10!\0f\80\8c\04\82\97\19\0b\15\88\94\05/\05;\07\02\0e\18\09\80\af1t\0c\80\d6\1a\0c\05\80\ff\05\80\b6\05$\0c\9b\c6\0a\d20\10\84\8d\037\09\81\5c\14\80\b8\08\80\ba=5\04\0a\068\08F\08\0c\06t\0b\1e\03Z\04Y\09\80\83\18\1c\0a\16\09F\0a\80\8a\06\ab\a4\0c\17\041\a1\04\81\da&\07\0c\05\05\80\a5\11\81m\10x(*\06L\04\80\8d\04\80\be\03\1b\03\0f\0d\00\06\01\01\03\01\04\02\08\08\09\02\0a\05\0b\02\10\01\11\04\12\05\13\11\14\02\15\02\17\02\1a\02\1c\05\1d\08$\01j\03k\02\bc\02\d1\02\d4\0c\d5\09\d6\02\d7\02\da\01\e0\05\e8\02\ee \f0\04\f9\04\0c';>NO\8f\9e\9e\9f\06\07\096=>V\f3\d0\d1\04\14\1867VW\bd5\ce\cf\e0\12\87\89\8e\9e\04\0d\0e\11\12)14:EFIJNOdeZ\5c\b6\b7\1b\1c\84\85\097\90\91\a8\07\0a;>fi\8f\92o_\ee\efZb\9a\9b'(U\9d\a0\a1\a3\a4\a7\a8\ad\ba\bc\c4\06\0b\0c\15\1d:?EQ\a6\a7\cc\cd\a0\07\19\1a\22%\c5\c6\04 #%&(38:HJLPSUVXZ\5c^`cefksx}\7f\8a\a4\aa\af\b0\c0\d0?qr{^\22{\05\03\04-\03e\04\01/.\80\82\1d\031\0f\1c\04$\09\1e\05+\05D\04\0e*\80\aa\06$\04$\04(\084\0b\01\80\90\817\09\16\0a\08\80\989\03c\08\090\16\05!\03\1b\05\01@8\04K\05/\04\0a\07\09\07@ '\04\0c\096\03:\05\1a\07\04\0c\07PI73\0d3\07.\08\0a\81&\1f\80\81(\08*\80\a6N\04\1e\0fC\0e\19\07\0a\06G\09'\09u\0b?A*\06;\05\0a\06Q\06\01\05\10\03\05\80\8b_!H\08\0a\80\a6^\22E\0b\0a\06\0d\138\08\0a6,\04\10\80\c0<dS\0c\01\81\00H\08S\1d9\81\07F\0a\1d\03GI7\03\0e\08\0a\069\07\0a\816\19\81\07\83\9afu\0b\80\c4\8a\bc\84/\8f\d1\82G\a1\b9\829\07*\04\02`&\0aF\0a(\05\13\82\b0[eE\0b/\10\11@\02\1e\97\f2\0e\82\f3\a5\0d\81\1fQ\81\8c\89\04k\05\0d\03\09\07\10\93`\80\f6\0as\08n\17F\80\9a\14\0cW\09\19\80\87\81G\03\85B\0f\15\85P+\87\d5\80\d7)K\05\0a\04\02\83\11D\81K<\06\01\04U\05\1b4\02\81\0e,\04d\0cV\0a\0d\03\5c\04=9\1d\0d,\04\09\07\02\0e\06\80\9a\83\d5\0b\0d\03\0a\06t\0cY'\0c\048\08\0a\06(\08\1eR\0c\04g\03)\0d\0a\06\03\0d0`\0e\85\92\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/slice/mod.rsindex  out of range for slice of length slice index starts at  but ends at called `Option::unwrap()` on a `None` valuelibcore/option.rs\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\04\04\04\04\04\00\00\00\00\00\00\00\00\00\00\00[...]byte index  is out of bounds of ``\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\02\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/str/mod.rsbegin <= end ( <= ) when slicing `\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\02\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\03\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00 is not a char boundary; it is inside  (bytes ) of `\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\02\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\03\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\04\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00..\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00BorrowMutError\00\00libcore/unicode/bool_trie.rscalled `Option::unwrap()` on a `None` valuelibcore/option.rs\00\00\00\00\00\00\00\00libcore/fmt/mod.rs\00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00assertion failed: broken.is_empty()libcore/str/lossy.rs    , {\0a:  \0a} }()\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00index out of bounds: the len is  but the index is \00\00\01\00\00\00\00\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\01\00\00\00\01\00\00\00 \00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\03\00\00\00libcore/option.rs\00\00\00\00\00\c0\fb\ef>\00\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f8\ff\fb\ff\ff\ff\07\00\00\00\00\00\00\14\fe!\fe\00\0c\00\00\00\02\00\00\00\00\00\00P\1e \80\00\0c\00\00@\06\00\00\00\00\00\00\10\869\02\00\00\00#\00\be!\00\00\0c\00\00\fc\02\00\00\00\00\00\00\d0\1e \c0\00\0c\00\00\00\04\00\00\00\00\00\00@\01 \80\00\00\00\00\00\11\00\00\00\00\00\00\c0\c1=`\00\0c\00\00\00\02\00\00\00\00\00\00\90D0`\00\0c\00\00\00\03\00\00\00\00\00\00X\1e \80\00\0c\00\00\00\00\84\5c\80\00\00\00\00\00\00\00\00\00\00\f2\07\80\7f\00\00\00\00\00\00\00\00\00\00\00\00\f2\1b\00?\00\00\00\00\00\00\00\00\00\03\00\00\a0\02\00\00\00\00\00\00\fe\7f\df\e0\ff\fe\ff\ff\ff\1f@\00\00\00\00\00\00\00\00\00\00\00\00\e0\fdf\00\00\00\c3\01\00\1e\00d \00 \00\00\00\00\00\00\00\e0\00\00\00\00\00\00\1c\00\00\00\1c\00\00\00\0c\00\00\00\0c\00\00\00\00\00\00\00\b0?@\fe\0f \00\00\00\00\008\00\00\00\00\00\00`\00\00\00\00\02\00\00\00\00\00\00\87\01\04\0e\00\00\80\09\00\00\00\00\00\00@\7f\e5\1f\f8\9f\00\00\00\00\00\00\ff\7f\0f\00\00\00\00\00\d0\17\04\00\00\00\00\f8\0f\00\03\00\00\00<;\00\00\00\00\00\00@\a3\03\00\00\00\00\00\00\f0\cf\00\00\00\f7\ff\fd!\10\03\ff\ff\ff\ff\ff\ff\ff\fb\00\10\00\00\00\00\00\00\00\00\ff\ff\ff\ff\01\00\00\00\00\00\00\80\03\00\00\00\00\00\00\00\00\80\00\00\00\00\ff\ff\ff\ff\00\00\00\00\00\fc\00\00\00\00\00\06\00\00\00\00\00\00\00\00\00\80\f7?\00\00\00\c0\00\00\00\00\00\00\00\00\00\00\03\00D\08\00\00`\00\00\000\00\00\00\ff\ff\03\80\00\00\00\00\c0?\00\00\80\ff\03\00\00\00\00\00\07\00\00\00\00\00\c8\13\00\00\00\00 \00\00\00\00\00\00\00\00~f\00\08\10\00\00\00\00\00\10\00\00\00\00\00\00\9d\c1\02\00\00\00\000@\00\00\00\00\00 !\00\00\00\00\00@\00\00\00\00\ff\ff\00\00\ff\ff\00\00\00\00\00\00\00\00\00\01\00\00\00\02\00\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04\00\00\05\00\00\00\00\00\00\00\00\06\00\00\00\00\00\00\00\00\07\00\00\08\09\0a\00\0b\0c\0d\0e\0f\00\00\10\11\12\00\00\13\14\15\16\00\00\17\18\19\1a\1b\00\1c\00\00\00\1d\00\00\00\00\00\00\00\1e\1f \00\00\00\00\00!\00\22\00#$%\00\00\00\00&\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00'(\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00)\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00*\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00+,\00\00-\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00./0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\001\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\002\003\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0045\00\005556\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00 \00\00\00\00\01\00\00\00\00\00\00\00\00\00\c0\07n\f0\00\00\00\00\00\87\00\00\00\00`\00\00\00\00\00\00\00\f0\00\00\00\c0\ff\01\00\00\00\00\00\02\00\00\00\00\00\00\ff\7f\00\00\00\00\00\00\80\03\00\00\00\00\00x\06\07\00\00\00\80\ef\1f\00\00\00\00\00\00\00\08\00\03\00\00\00\00\00\c0\7f\00\1e\00\00\00\00\00\00\00\00\00\00\00\80\d3@\00\00\00\80\f8\07\00\00\03\00\00\00\00\00\00X\01\00\80\00\c0\1f\1f\00\00\00\00\00\00\00\00\ff\5c\00\00@\00\00\00\00\00\00\00\00\00\00\f9\a5\0d\00\00\00\00\00\00\00\00\00\00\00\00\80<\b0\01\00\000\00\00\00\00\00\00\00\00\00\00\f8\a7\01\00\00\00\00\00\00\00\00\00\00\00\00(\bf\00\00\00\00\e0\bc\0f\00\00\00\00\00\00\00\80\ff\06\fe\07\00\00\00\00\f8y\80\00~\0e\00\00\00\00\00\fc\7f\03\00\00\00\00\00\00\00\00\00\00\7f\bf\00\00\fc\ff\ff\fcm\00\00\00\00\00\00\00~\b4\bf\00\00\00\00\00\00\00\00\00\a3\00\00\00\00\00\00\00\00\00\00\00\18\00\00\00\00\00\00\00\1f\00\00\00\00\00\00\00\7f\00\00\80\07\00\00\00\00\00\00\00\00`\00\00\00\00\00\00\00\00\a0\c3\07\f8\e7\0f\00\00\00<\00\00\1c\00\00\00\00\00\00\00\ff\ff\ff\ff\ff\ff\7f\f8\ff\ff\ff\ff\ff\1f \00\10\00\00\f8\fe\ff\00\00\7f\ff\ff\f9\db\07\00\00\00\00\7f\00\00\00\00\00\f0\07\00\00\00\00\00\00\00\00\00\00\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\00")
  (data (;1;) (i32.const 1055744) "\00\00\10\00\00\00\00\00\00\00\10\00\02\00\00\00L\00\10\00\11\00\00\00\f1\03\00\00\05\00\00\00\88\00\10\00\19\00\00\00\a1\00\10\00\01\00\00\00\c8\00\10\00\0d\00\00\00\09\00\00\00\0c\00\00\00\04\00\00\00\0a\00\00\00\0b\00\00\00\0c\00\00\00\0d\00\00\00\0e\00\00\00\0f\00\00\00\10\00\00\00\01\00\00\00\01\00\00\00\11\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\12\00\00\00\09\00\00\00\0c\00\00\00\04\00\00\00\13\00\00\00l\02\10\00\00\00\00\00l\02\10\00\00\00\00\00\90\02\10\00\0b\00\00\00\9b\02\10\00\01\00\00\00\9c\02\10\00\15\00\00\00\b1\02\10\00\0d\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\14\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\15\00\00\00\9d\03\10\00\18\00\00\00 \00\00\00\09\00\00\00\d5\03\10\00(\00\00\00\fd\03\10\00\13\00\00\00\f8\01\00\00\1e\00\00\00\10\04\10\00\00\00\00\00\10\04\10\00\02\00\00\00\5c\04\10\00\11\00\00\00\f1\03\00\00\05\00\00\00\81\04\10\00+\00\00\00\ac\04\10\00\11\00\00\00Y\01\00\00\15\00\00\00\bd\04\10\00\18\00\00\00 \00\00\00\09\00\00\00\1b\00\00\00\1c\00\00\00)\05\10\00\13\00\00\00<\05\10\00\02\00\00\00\88\05\10\00\12\00\00\00\bc\02\00\00\09\00\00\00\1d\00\00\00\0c\00\00\00\04\00\00\00\1e\00\00\00\1f\00\00\00 \00\00\00!\00\00\00\04\00\00\00\04\00\00\00\22\00\00\00#\00\00\00$\00\00\00\cb\05\10\00-\00\00\00\f8\05\10\00\0c\00\00\00\04\06\10\00\03\00\00\00\07\06\10\004\00\00\00\a8\06\10\00\14\00\00\00M\06\00\00\09\00\00\00\df\06\10\00+\00\00\00\0a\07\10\00\11\00\00\00Y\01\00\00\15\00\00\00'\00\00\00\04\00\00\00\04\00\00\00(\00\00\00)\00\00\00*\00\00\00_\07\10\00+\00\00\00\8a\07\10\00\11\00\00\00Y\01\00\00\15\00\00\00,\00\00\00\00\00\00\00\01\00\00\00-\00\00\00,\00\00\00\04\00\00\00\04\00\00\00.\00\00\00/\00\00\000\00\00\001\00\00\00\10\00\00\00\04\00\00\002\00\00\003\00\00\004\00\00\00\0c\00\00\00\04\00\00\005\00\00\00,\00\00\00\08\00\00\00\04\00\00\006\00\00\007\00\00\00,\00\00\00\08\00\00\00\04\00\00\008\00\00\00,\00\00\00\00\00\00\00\01\00\00\009\00\00\00\9c\07\10\002\00\00\00\ce\07\10\00+\00\00\00\f9\07\10\00 \00\00\00,\00\00\00\04\00\00\00\04\00\00\00:\00\00\00K\08\10\00\19\00\00\00d\08\10\00(\00\00\00\8c\08\10\00\13\00\00\00\f8\01\00\00\1e\00\00\00\9f\08\10\00\11\00\00\00\8c\08\10\00\13\00\00\00\f5\02\00\00\05\00\00\00\b0\08\10\00-\00\00\00\dd\08\10\00\0c\00\00\00\e9\08\10\00\03\00\00\00\ec\08\10\004\00\00\00\8c\09\10\00\14\00\00\00M\06\00\00\09\00\00\00j\0a\10\00+\00\00\00\95\0a\10\00\11\00\00\00Y\01\00\00\15\00\00\00\1c\10\10\00\06\00\00\00\22\10\10\00\22\00\00\00\08\10\10\00\14\00\00\00\8c\07\00\00\05\00\00\00D\10\10\00\16\00\00\00Z\10\10\00\0d\00\00\00\08\10\10\00\14\00\00\00\92\07\00\00\05\00\00\00g\10\10\00+\00\00\00\92\10\10\00\11\00\00\00Y\01\00\00\15\00\00\00\a8\11\10\00\0b\00\00\00\b3\11\10\00\16\00\00\00\c9\11\10\00\01\00\00\008\12\10\00\12\00\00\00.\08\00\00\09\00\00\00J\12\10\00\0e\00\00\00X\12\10\00\04\00\00\00\5c\12\10\00\10\00\00\00\c9\11\10\00\01\00\00\008\12\10\00\12\00\00\002\08\00\00\05\00\00\00\a8\11\10\00\0b\00\00\00\fc\12\10\00&\00\00\00\22\13\10\00\08\00\00\00*\13\10\00\06\00\00\00\c9\11\10\00\01\00\00\008\12\10\00\12\00\00\00?\08\00\00\05\00\00\00\e8\13\10\00\00\00\00\00\e4\13\10\00\02\00\00\00@\14\10\00\1c\00\00\001\00\00\00\19\00\00\00@\14\10\00\1c\00\00\002\00\00\00 \00\00\00@\14\10\00\1c\00\00\004\00\00\00\19\00\00\00@\14\10\00\1c\00\00\005\00\00\00\18\00\00\00@\14\10\00\1c\00\00\006\00\00\00 \00\00\00\5c\14\10\00+\00\00\00\87\14\10\00\11\00\00\00Y\01\00\00\15\00\00\00A\00\00\00\0c\00\00\00\04\00\00\00B\00\00\00C\00\00\00D\00\00\00\a0\14\10\00\12\00\00\00K\04\00\00(\00\00\00\a0\14\10\00\12\00\00\00W\04\00\00\11\00\00\00\fc\14\10\00#\00\00\00\1f\15\10\00\14\00\00\00\a7\00\00\00\11\00\00\00\fc\14\10\00\00\00\00\00=\15\10\00\01\00\00\00;\15\10\00\02\00\00\00E\00\00\00\04\00\00\00\04\00\00\00F\00\00\00G\00\00\00H\00\00\00I\00\00\00\00\00\00\00\01\00\00\00J\00\00\00h\15\10\00 \00\00\00\88\15\10\00\12\00\00\00D\15\10\00\00\00\00\00\e4\15\10\00\11\00\00\00\e8\03\00\00\05\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f8\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\fe\ff\ff\ff\ff\bf\b6\00\00\00\00\00\00\00\00\00\ff\07\00\00\00\00\00\f8\ff\ff\00\00\01\00\00\00\00\00\00\00\00\00\00\00\c0\9f\9f=\00\00\00\00\02\00\00\00\ff\ff\ff\07\00\00\00\00\00\00\00\00\00\00\c0\ff\01\00\00\00\00\00\00\f8\0f \f8\15\10\00J\00\00\00H\18\10\00\00\02\00\00H\1a\10\007\00\00\00\00\01\02\03\04\05\06\07\08\09\08\0a\0b\0c\0d\0e\0f\10\11\12\13\14\02\15\16\17\18\19\1a\1b\1c\1d\1e\1f \02\02\02\02\02\02\02\02\02\02!\02\02\02\02\02\02\02\02\02\02\02\02\02\02\22#$%&\02'\02(\02\02\02)*+\02,-./0\02\021\02\02\022\02\02\02\02\02\02\02\023\02\024\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\025\026\027\02\02\02\02\02\02\02\028\029\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02:;<\02\02\02\02=\02\02>?@ABCDEF\02\02\02G\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02H\02\02\02\02\02\02\02\02\02\02\02I\02\02\02\02\02;\02\00\01\02\02\02\02\03\02\02\02\02\04\02\05\06\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\07\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02")
  (data (;2;) (i32.const 1058648) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
