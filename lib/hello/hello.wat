(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func (param i32 i32 i32) (result i32)))
  (type (;2;) (func (param i32)))
  (type (;3;) (func))
  (type (;4;) (func (param i32) (result i32)))
  (import "wasi_unstable" "fd_prestat_get" (func (;0;) (type 0)))
  (import "wasi_unstable" "fd_prestat_dir_name" (func (;1;) (type 1)))
  (import "wasi_unstable" "environ_sizes_get" (func (;2;) (type 0)))
  (import "wasi_unstable" "environ_get" (func (;3;) (type 0)))
  (import "wasi_unstable" "args_sizes_get" (func (;4;) (type 0)))
  (import "wasi_unstable" "args_get" (func (;5;) (type 0)))
  (import "wasi_unstable" "proc_exit" (func (;6;) (type 2)))
  (import "wasi_unstable" "fd_fdstat_get" (func (;7;) (type 0)))
  (func (;8;) (type 3))
  (func (;9;) (type 3)
    (local i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 0
    set_global 0
    call 19
    i32.const 3
    set_local 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              get_local 1
              get_local 0
              call 0
              tee_local 2
              i32.const 8
              i32.eq
              br_if 1 (;@4;)
              get_local 2
              br_if 3 (;@2;)
              block  ;; label = @6
                get_local 0
                i32.load8_u
                br_if 0 (;@6;)
                get_local 0
                i32.load offset=4
                i32.const 1
                i32.add
                call 12
                tee_local 2
                i32.eqz
                br_if 4 (;@2;)
                get_local 1
                get_local 2
                get_local 0
                i32.load offset=4
                call 1
                br_if 3 (;@3;)
                get_local 2
                get_local 0
                i32.load offset=4
                i32.add
                i32.const 0
                i32.store8
                get_local 1
                get_local 2
                call 20
                set_local 3
                get_local 2
                call 14
                get_local 3
                br_if 4 (;@2;)
              end
              get_local 1
              i32.const 1
              i32.add
              tee_local 1
              br_if 0 (;@5;)
            end
          end
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 0
                get_local 0
                i32.const 12
                i32.add
                call 2
                br_if 0 (;@6;)
                get_local 0
                i32.load
                tee_local 1
                i32.eqz
                br_if 1 (;@5;)
                i32.const 0
                get_local 1
                i32.const 2
                i32.shl
                i32.const 4
                i32.add
                call 12
                i32.store offset=1049080
                get_local 0
                i32.load offset=12
                call 12
                tee_local 1
                i32.eqz
                br_if 0 (;@6;)
                i32.const 0
                i32.load offset=1049080
                tee_local 2
                i32.eqz
                br_if 0 (;@6;)
                get_local 2
                get_local 0
                i32.load
                i32.const 2
                i32.shl
                i32.add
                i32.const 0
                i32.store
                i32.const 0
                i32.load offset=1049080
                get_local 1
                call 3
                i32.eqz
                br_if 2 (;@4;)
              end
              i32.const 71
              call 17
              unreachable
            end
            i32.const 0
            i32.const 0
            i32.store offset=1049080
          end
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 0
                i32.const 12
                i32.add
                get_local 0
                call 4
                br_if 0 (;@6;)
                get_local 0
                i32.load offset=12
                tee_local 1
                i32.eqz
                br_if 1 (;@5;)
                get_local 1
                i32.const 2
                i32.shl
                call 12
                set_local 1
                get_local 0
                i32.load
                call 12
                set_local 2
                get_local 1
                i32.eqz
                br_if 0 (;@6;)
                get_local 2
                i32.eqz
                br_if 0 (;@6;)
                get_local 1
                get_local 2
                call 5
                i32.eqz
                br_if 2 (;@4;)
              end
              i32.const 71
              call 17
              unreachable
            end
          end
          call 8
          get_local 0
          i32.load offset=12
          get_local 1
          call 11
          set_local 1
          call 24
          get_local 1
          br_if 2 (;@1;)
          get_local 0
          i32.const 16
          i32.add
          set_global 0
          return
        end
        get_local 2
        call 14
      end
      i32.const 71
      call 17
      unreachable
    end
    get_local 1
    call 17
    unreachable)
  (func (;10;) (type 4) (param i32) (result i32)
    get_local 0
    i32.const 1
    i32.add)
  (func (;11;) (type 0) (param i32 i32) (result i32)
    i32.const 0)
  (func (;12;) (type 4) (param i32) (result i32)
    get_local 0
    call 13)
  (func (;13;) (type 4) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 16
    i32.sub
    tee_local 1
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
                                                                              block  ;; label = @38
                                                                                get_local 0
                                                                                i32.const 244
                                                                                i32.gt_u
                                                                                br_if 0 (;@38;)
                                                                                i32.const 0
                                                                                i32.load offset=1048576
                                                                                tee_local 2
                                                                                i32.const 16
                                                                                get_local 0
                                                                                i32.const 11
                                                                                i32.add
                                                                                i32.const -8
                                                                                i32.and
                                                                                get_local 0
                                                                                i32.const 11
                                                                                i32.lt_u
                                                                                select
                                                                                tee_local 3
                                                                                i32.const 3
                                                                                i32.shr_u
                                                                                tee_local 4
                                                                                i32.shr_u
                                                                                tee_local 0
                                                                                i32.const 3
                                                                                i32.and
                                                                                i32.eqz
                                                                                br_if 1 (;@37;)
                                                                                get_local 0
                                                                                i32.const -1
                                                                                i32.xor
                                                                                i32.const 1
                                                                                i32.and
                                                                                get_local 4
                                                                                i32.add
                                                                                tee_local 5
                                                                                i32.const 3
                                                                                i32.shl
                                                                                tee_local 6
                                                                                i32.const 1048624
                                                                                i32.add
                                                                                i32.load
                                                                                tee_local 4
                                                                                i32.const 8
                                                                                i32.add
                                                                                set_local 0
                                                                                get_local 4
                                                                                i32.load offset=8
                                                                                tee_local 3
                                                                                get_local 6
                                                                                i32.const 1048616
                                                                                i32.add
                                                                                tee_local 6
                                                                                i32.eq
                                                                                br_if 2 (;@36;)
                                                                                get_local 3
                                                                                get_local 6
                                                                                i32.store offset=12
                                                                                get_local 6
                                                                                i32.const 8
                                                                                i32.add
                                                                                get_local 3
                                                                                i32.store
                                                                                br 3 (;@35;)
                                                                              end
                                                                              i32.const -1
                                                                              set_local 3
                                                                              get_local 0
                                                                              i32.const -65
                                                                              i32.gt_u
                                                                              br_if 14 (;@23;)
                                                                              get_local 0
                                                                              i32.const 11
                                                                              i32.add
                                                                              tee_local 0
                                                                              i32.const -8
                                                                              i32.and
                                                                              set_local 3
                                                                              i32.const 0
                                                                              i32.load offset=1048580
                                                                              tee_local 7
                                                                              i32.eqz
                                                                              br_if 14 (;@23;)
                                                                              i32.const 0
                                                                              set_local 8
                                                                              block  ;; label = @38
                                                                                get_local 0
                                                                                i32.const 8
                                                                                i32.shr_u
                                                                                tee_local 0
                                                                                i32.eqz
                                                                                br_if 0 (;@38;)
                                                                                i32.const 31
                                                                                set_local 8
                                                                                get_local 3
                                                                                i32.const 16777215
                                                                                i32.gt_u
                                                                                br_if 0 (;@38;)
                                                                                get_local 3
                                                                                i32.const 14
                                                                                get_local 0
                                                                                get_local 0
                                                                                i32.const 1048320
                                                                                i32.add
                                                                                i32.const 16
                                                                                i32.shr_u
                                                                                i32.const 8
                                                                                i32.and
                                                                                tee_local 4
                                                                                i32.shl
                                                                                tee_local 0
                                                                                i32.const 520192
                                                                                i32.add
                                                                                i32.const 16
                                                                                i32.shr_u
                                                                                i32.const 4
                                                                                i32.and
                                                                                tee_local 5
                                                                                get_local 4
                                                                                i32.or
                                                                                get_local 0
                                                                                get_local 5
                                                                                i32.shl
                                                                                tee_local 0
                                                                                i32.const 245760
                                                                                i32.add
                                                                                i32.const 16
                                                                                i32.shr_u
                                                                                i32.const 2
                                                                                i32.and
                                                                                tee_local 4
                                                                                i32.or
                                                                                i32.sub
                                                                                get_local 0
                                                                                get_local 4
                                                                                i32.shl
                                                                                i32.const 15
                                                                                i32.shr_u
                                                                                i32.add
                                                                                tee_local 0
                                                                                i32.const 7
                                                                                i32.add
                                                                                i32.shr_u
                                                                                i32.const 1
                                                                                i32.and
                                                                                get_local 0
                                                                                i32.const 1
                                                                                i32.shl
                                                                                i32.or
                                                                                set_local 8
                                                                              end
                                                                              i32.const 0
                                                                              get_local 3
                                                                              i32.sub
                                                                              set_local 5
                                                                              get_local 8
                                                                              i32.const 2
                                                                              i32.shl
                                                                              i32.const 1048880
                                                                              i32.add
                                                                              i32.load
                                                                              tee_local 4
                                                                              i32.eqz
                                                                              br_if 3 (;@34;)
                                                                              get_local 3
                                                                              i32.const 0
                                                                              i32.const 25
                                                                              get_local 8
                                                                              i32.const 1
                                                                              i32.shr_u
                                                                              i32.sub
                                                                              get_local 8
                                                                              i32.const 31
                                                                              i32.eq
                                                                              select
                                                                              i32.shl
                                                                              set_local 6
                                                                              i32.const 0
                                                                              set_local 0
                                                                              i32.const 0
                                                                              set_local 9
                                                                              loop  ;; label = @38
                                                                                block  ;; label = @39
                                                                                  get_local 4
                                                                                  i32.load offset=4
                                                                                  i32.const -8
                                                                                  i32.and
                                                                                  get_local 3
                                                                                  i32.sub
                                                                                  tee_local 2
                                                                                  get_local 5
                                                                                  i32.ge_u
                                                                                  br_if 0 (;@39;)
                                                                                  get_local 2
                                                                                  set_local 5
                                                                                  get_local 4
                                                                                  set_local 9
                                                                                  get_local 2
                                                                                  i32.eqz
                                                                                  br_if 8 (;@31;)
                                                                                end
                                                                                get_local 0
                                                                                get_local 4
                                                                                i32.const 20
                                                                                i32.add
                                                                                i32.load
                                                                                tee_local 2
                                                                                get_local 2
                                                                                get_local 4
                                                                                get_local 6
                                                                                i32.const 29
                                                                                i32.shr_u
                                                                                i32.const 4
                                                                                i32.and
                                                                                i32.add
                                                                                i32.const 16
                                                                                i32.add
                                                                                i32.load
                                                                                tee_local 4
                                                                                i32.eq
                                                                                select
                                                                                get_local 0
                                                                                get_local 2
                                                                                select
                                                                                set_local 0
                                                                                get_local 6
                                                                                get_local 4
                                                                                i32.const 0
                                                                                i32.ne
                                                                                i32.shl
                                                                                set_local 6
                                                                                get_local 4
                                                                                br_if 0 (;@38;)
                                                                              end
                                                                              get_local 0
                                                                              get_local 9
                                                                              i32.or
                                                                              i32.eqz
                                                                              br_if 4 (;@33;)
                                                                              br 11 (;@26;)
                                                                            end
                                                                            get_local 3
                                                                            i32.const 0
                                                                            i32.load offset=1048584
                                                                            tee_local 7
                                                                            i32.le_u
                                                                            br_if 13 (;@23;)
                                                                            get_local 0
                                                                            i32.eqz
                                                                            br_if 4 (;@32;)
                                                                            get_local 0
                                                                            get_local 4
                                                                            i32.shl
                                                                            i32.const 2
                                                                            get_local 4
                                                                            i32.shl
                                                                            tee_local 0
                                                                            i32.const 0
                                                                            get_local 0
                                                                            i32.sub
                                                                            i32.or
                                                                            i32.and
                                                                            tee_local 0
                                                                            i32.const 0
                                                                            get_local 0
                                                                            i32.sub
                                                                            i32.and
                                                                            i32.const -1
                                                                            i32.add
                                                                            tee_local 0
                                                                            get_local 0
                                                                            i32.const 12
                                                                            i32.shr_u
                                                                            i32.const 16
                                                                            i32.and
                                                                            tee_local 0
                                                                            i32.shr_u
                                                                            tee_local 4
                                                                            i32.const 5
                                                                            i32.shr_u
                                                                            i32.const 8
                                                                            i32.and
                                                                            tee_local 5
                                                                            get_local 0
                                                                            i32.or
                                                                            get_local 4
                                                                            get_local 5
                                                                            i32.shr_u
                                                                            tee_local 0
                                                                            i32.const 2
                                                                            i32.shr_u
                                                                            i32.const 4
                                                                            i32.and
                                                                            tee_local 4
                                                                            i32.or
                                                                            get_local 0
                                                                            get_local 4
                                                                            i32.shr_u
                                                                            tee_local 0
                                                                            i32.const 1
                                                                            i32.shr_u
                                                                            i32.const 2
                                                                            i32.and
                                                                            tee_local 4
                                                                            i32.or
                                                                            get_local 0
                                                                            get_local 4
                                                                            i32.shr_u
                                                                            tee_local 0
                                                                            i32.const 1
                                                                            i32.shr_u
                                                                            i32.const 1
                                                                            i32.and
                                                                            tee_local 4
                                                                            i32.or
                                                                            get_local 0
                                                                            get_local 4
                                                                            i32.shr_u
                                                                            i32.add
                                                                            tee_local 5
                                                                            i32.const 3
                                                                            i32.shl
                                                                            tee_local 6
                                                                            i32.const 1048624
                                                                            i32.add
                                                                            i32.load
                                                                            tee_local 4
                                                                            i32.load offset=8
                                                                            tee_local 0
                                                                            get_local 6
                                                                            i32.const 1048616
                                                                            i32.add
                                                                            tee_local 6
                                                                            i32.eq
                                                                            br_if 6 (;@30;)
                                                                            get_local 0
                                                                            get_local 6
                                                                            i32.store offset=12
                                                                            get_local 6
                                                                            i32.const 8
                                                                            i32.add
                                                                            get_local 0
                                                                            i32.store
                                                                            br 7 (;@29;)
                                                                          end
                                                                          i32.const 0
                                                                          get_local 2
                                                                          i32.const -2
                                                                          get_local 5
                                                                          i32.rotl
                                                                          i32.and
                                                                          i32.store offset=1048576
                                                                        end
                                                                        get_local 4
                                                                        get_local 5
                                                                        i32.const 3
                                                                        i32.shl
                                                                        tee_local 5
                                                                        i32.const 3
                                                                        i32.or
                                                                        i32.store offset=4
                                                                        get_local 4
                                                                        get_local 5
                                                                        i32.add
                                                                        tee_local 4
                                                                        get_local 4
                                                                        i32.load offset=4
                                                                        i32.const 1
                                                                        i32.or
                                                                        i32.store offset=4
                                                                        br 33 (;@1;)
                                                                      end
                                                                      i32.const 0
                                                                      set_local 0
                                                                      i32.const 0
                                                                      set_local 9
                                                                      i32.const 0
                                                                      i32.const 0
                                                                      i32.or
                                                                      br_if 7 (;@26;)
                                                                    end
                                                                    i32.const 2
                                                                    get_local 8
                                                                    i32.shl
                                                                    tee_local 0
                                                                    i32.const 0
                                                                    get_local 0
                                                                    i32.sub
                                                                    i32.or
                                                                    get_local 7
                                                                    i32.and
                                                                    tee_local 0
                                                                    i32.eqz
                                                                    br_if 9 (;@23;)
                                                                    get_local 0
                                                                    i32.const 0
                                                                    get_local 0
                                                                    i32.sub
                                                                    i32.and
                                                                    i32.const -1
                                                                    i32.add
                                                                    tee_local 0
                                                                    get_local 0
                                                                    i32.const 12
                                                                    i32.shr_u
                                                                    i32.const 16
                                                                    i32.and
                                                                    tee_local 0
                                                                    i32.shr_u
                                                                    tee_local 4
                                                                    i32.const 5
                                                                    i32.shr_u
                                                                    i32.const 8
                                                                    i32.and
                                                                    tee_local 6
                                                                    get_local 0
                                                                    i32.or
                                                                    get_local 4
                                                                    get_local 6
                                                                    i32.shr_u
                                                                    tee_local 0
                                                                    i32.const 2
                                                                    i32.shr_u
                                                                    i32.const 4
                                                                    i32.and
                                                                    tee_local 4
                                                                    i32.or
                                                                    get_local 0
                                                                    get_local 4
                                                                    i32.shr_u
                                                                    tee_local 0
                                                                    i32.const 1
                                                                    i32.shr_u
                                                                    i32.const 2
                                                                    i32.and
                                                                    tee_local 4
                                                                    i32.or
                                                                    get_local 0
                                                                    get_local 4
                                                                    i32.shr_u
                                                                    tee_local 0
                                                                    i32.const 1
                                                                    i32.shr_u
                                                                    i32.const 1
                                                                    i32.and
                                                                    tee_local 4
                                                                    i32.or
                                                                    get_local 0
                                                                    get_local 4
                                                                    i32.shr_u
                                                                    i32.add
                                                                    i32.const 2
                                                                    i32.shl
                                                                    i32.const 1048880
                                                                    i32.add
                                                                    i32.load
                                                                    tee_local 0
                                                                    br_if 7 (;@25;)
                                                                    br 8 (;@24;)
                                                                  end
                                                                  i32.const 0
                                                                  i32.load offset=1048580
                                                                  tee_local 10
                                                                  i32.eqz
                                                                  br_if 8 (;@23;)
                                                                  get_local 10
                                                                  i32.const 0
                                                                  get_local 10
                                                                  i32.sub
                                                                  i32.and
                                                                  i32.const -1
                                                                  i32.add
                                                                  tee_local 0
                                                                  get_local 0
                                                                  i32.const 12
                                                                  i32.shr_u
                                                                  i32.const 16
                                                                  i32.and
                                                                  tee_local 0
                                                                  i32.shr_u
                                                                  tee_local 4
                                                                  i32.const 5
                                                                  i32.shr_u
                                                                  i32.const 8
                                                                  i32.and
                                                                  tee_local 5
                                                                  get_local 0
                                                                  i32.or
                                                                  get_local 4
                                                                  get_local 5
                                                                  i32.shr_u
                                                                  tee_local 0
                                                                  i32.const 2
                                                                  i32.shr_u
                                                                  i32.const 4
                                                                  i32.and
                                                                  tee_local 4
                                                                  i32.or
                                                                  get_local 0
                                                                  get_local 4
                                                                  i32.shr_u
                                                                  tee_local 0
                                                                  i32.const 1
                                                                  i32.shr_u
                                                                  i32.const 2
                                                                  i32.and
                                                                  tee_local 4
                                                                  i32.or
                                                                  get_local 0
                                                                  get_local 4
                                                                  i32.shr_u
                                                                  tee_local 0
                                                                  i32.const 1
                                                                  i32.shr_u
                                                                  i32.const 1
                                                                  i32.and
                                                                  tee_local 4
                                                                  i32.or
                                                                  get_local 0
                                                                  get_local 4
                                                                  i32.shr_u
                                                                  i32.add
                                                                  i32.const 2
                                                                  i32.shl
                                                                  i32.const 1048880
                                                                  i32.add
                                                                  i32.load
                                                                  tee_local 6
                                                                  i32.load offset=4
                                                                  i32.const -8
                                                                  i32.and
                                                                  get_local 3
                                                                  i32.sub
                                                                  set_local 5
                                                                  get_local 6
                                                                  tee_local 9
                                                                  i32.load offset=16
                                                                  tee_local 0
                                                                  i32.eqz
                                                                  br_if 3 (;@28;)
                                                                  i32.const 1
                                                                  set_local 4
                                                                  br 4 (;@27;)
                                                                end
                                                                i32.const 0
                                                                set_local 5
                                                                get_local 4
                                                                set_local 9
                                                                get_local 4
                                                                set_local 0
                                                                br 5 (;@25;)
                                                              end
                                                              i32.const 0
                                                              get_local 2
                                                              i32.const -2
                                                              get_local 5
                                                              i32.rotl
                                                              i32.and
                                                              tee_local 2
                                                              i32.store offset=1048576
                                                            end
                                                            get_local 4
                                                            i32.const 8
                                                            i32.add
                                                            set_local 0
                                                            get_local 4
                                                            get_local 3
                                                            i32.const 3
                                                            i32.or
                                                            i32.store offset=4
                                                            get_local 4
                                                            get_local 5
                                                            i32.const 3
                                                            i32.shl
                                                            tee_local 5
                                                            i32.add
                                                            get_local 5
                                                            get_local 3
                                                            i32.sub
                                                            tee_local 5
                                                            i32.store
                                                            get_local 4
                                                            get_local 3
                                                            i32.add
                                                            tee_local 6
                                                            get_local 5
                                                            i32.const 1
                                                            i32.or
                                                            i32.store offset=4
                                                            block  ;; label = @29
                                                              get_local 7
                                                              i32.eqz
                                                              br_if 0 (;@29;)
                                                              get_local 7
                                                              i32.const 3
                                                              i32.shr_u
                                                              tee_local 9
                                                              i32.const 3
                                                              i32.shl
                                                              i32.const 1048616
                                                              i32.add
                                                              set_local 3
                                                              i32.const 0
                                                              i32.load offset=1048596
                                                              set_local 4
                                                              block  ;; label = @30
                                                                block  ;; label = @31
                                                                  get_local 2
                                                                  i32.const 1
                                                                  get_local 9
                                                                  i32.shl
                                                                  tee_local 9
                                                                  i32.and
                                                                  i32.eqz
                                                                  br_if 0 (;@31;)
                                                                  get_local 3
                                                                  i32.load offset=8
                                                                  set_local 9
                                                                  br 1 (;@30;)
                                                                end
                                                                i32.const 0
                                                                get_local 2
                                                                get_local 9
                                                                i32.or
                                                                i32.store offset=1048576
                                                                get_local 3
                                                                set_local 9
                                                              end
                                                              get_local 9
                                                              get_local 4
                                                              i32.store offset=12
                                                              get_local 3
                                                              get_local 4
                                                              i32.store offset=8
                                                              get_local 4
                                                              get_local 3
                                                              i32.store offset=12
                                                              get_local 4
                                                              get_local 9
                                                              i32.store offset=8
                                                            end
                                                            i32.const 0
                                                            get_local 6
                                                            i32.store offset=1048596
                                                            i32.const 0
                                                            get_local 5
                                                            i32.store offset=1048584
                                                            br 27 (;@1;)
                                                          end
                                                          i32.const 0
                                                          set_local 4
                                                        end
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            loop  ;; label = @29
                                                              block  ;; label = @30
                                                                block  ;; label = @31
                                                                  block  ;; label = @32
                                                                    block  ;; label = @33
                                                                      get_local 4
                                                                      br_table 1 (;@32;) 0 (;@33;) 0 (;@33;)
                                                                    end
                                                                    get_local 0
                                                                    i32.load offset=4
                                                                    i32.const -8
                                                                    i32.and
                                                                    get_local 3
                                                                    i32.sub
                                                                    tee_local 4
                                                                    get_local 5
                                                                    get_local 4
                                                                    get_local 5
                                                                    i32.lt_u
                                                                    tee_local 4
                                                                    select
                                                                    set_local 5
                                                                    get_local 0
                                                                    get_local 6
                                                                    get_local 4
                                                                    select
                                                                    set_local 6
                                                                    get_local 0
                                                                    tee_local 9
                                                                    i32.load offset=16
                                                                    tee_local 0
                                                                    br_if 1 (;@31;)
                                                                    i32.const 0
                                                                    set_local 4
                                                                    br 3 (;@29;)
                                                                  end
                                                                  get_local 9
                                                                  i32.const 20
                                                                  i32.add
                                                                  i32.load
                                                                  tee_local 0
                                                                  br_if 1 (;@30;)
                                                                  get_local 6
                                                                  get_local 3
                                                                  i32.add
                                                                  tee_local 11
                                                                  get_local 6
                                                                  i32.le_u
                                                                  br_if 8 (;@23;)
                                                                  get_local 6
                                                                  i32.load offset=24
                                                                  set_local 12
                                                                  block  ;; label = @32
                                                                    get_local 6
                                                                    i32.load offset=12
                                                                    tee_local 9
                                                                    get_local 6
                                                                    i32.eq
                                                                    br_if 0 (;@32;)
                                                                    get_local 6
                                                                    i32.load offset=8
                                                                    tee_local 0
                                                                    get_local 9
                                                                    i32.store offset=12
                                                                    get_local 9
                                                                    get_local 0
                                                                    i32.store offset=8
                                                                    get_local 12
                                                                    br_if 4 (;@28;)
                                                                    br 5 (;@27;)
                                                                  end
                                                                  block  ;; label = @32
                                                                    block  ;; label = @33
                                                                      get_local 6
                                                                      i32.const 20
                                                                      i32.add
                                                                      tee_local 4
                                                                      i32.load
                                                                      tee_local 0
                                                                      br_if 0 (;@33;)
                                                                      get_local 6
                                                                      i32.load offset=16
                                                                      tee_local 0
                                                                      i32.eqz
                                                                      br_if 1 (;@32;)
                                                                      get_local 6
                                                                      i32.const 16
                                                                      i32.add
                                                                      set_local 4
                                                                    end
                                                                    loop  ;; label = @33
                                                                      get_local 4
                                                                      set_local 8
                                                                      get_local 0
                                                                      tee_local 9
                                                                      i32.const 20
                                                                      i32.add
                                                                      tee_local 4
                                                                      i32.load
                                                                      tee_local 0
                                                                      br_if 0 (;@33;)
                                                                      get_local 9
                                                                      i32.const 16
                                                                      i32.add
                                                                      set_local 4
                                                                      get_local 9
                                                                      i32.load offset=16
                                                                      tee_local 0
                                                                      br_if 0 (;@33;)
                                                                    end
                                                                    get_local 8
                                                                    i32.const 0
                                                                    i32.store
                                                                    get_local 12
                                                                    i32.eqz
                                                                    br_if 5 (;@27;)
                                                                    br 4 (;@28;)
                                                                  end
                                                                  i32.const 0
                                                                  set_local 9
                                                                  get_local 12
                                                                  br_if 3 (;@28;)
                                                                  br 4 (;@27;)
                                                                end
                                                                i32.const 1
                                                                set_local 4
                                                                br 1 (;@29;)
                                                              end
                                                              i32.const 1
                                                              set_local 4
                                                              br 0 (;@29;)
                                                            end
                                                          end
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                get_local 6
                                                                get_local 6
                                                                i32.load offset=28
                                                                tee_local 4
                                                                i32.const 2
                                                                i32.shl
                                                                i32.const 1048880
                                                                i32.add
                                                                tee_local 0
                                                                i32.load
                                                                i32.eq
                                                                br_if 0 (;@30;)
                                                                get_local 12
                                                                i32.const 16
                                                                i32.const 20
                                                                get_local 12
                                                                i32.load offset=16
                                                                get_local 6
                                                                i32.eq
                                                                select
                                                                i32.add
                                                                get_local 9
                                                                i32.store
                                                                get_local 9
                                                                br_if 1 (;@29;)
                                                                br 3 (;@27;)
                                                              end
                                                              get_local 0
                                                              get_local 9
                                                              i32.store
                                                              get_local 9
                                                              i32.eqz
                                                              br_if 1 (;@28;)
                                                            end
                                                            get_local 9
                                                            get_local 12
                                                            i32.store offset=24
                                                            block  ;; label = @29
                                                              get_local 6
                                                              i32.load offset=16
                                                              tee_local 0
                                                              i32.eqz
                                                              br_if 0 (;@29;)
                                                              get_local 9
                                                              get_local 0
                                                              i32.store offset=16
                                                              get_local 0
                                                              get_local 9
                                                              i32.store offset=24
                                                            end
                                                            get_local 6
                                                            i32.const 20
                                                            i32.add
                                                            i32.load
                                                            tee_local 0
                                                            i32.eqz
                                                            br_if 1 (;@27;)
                                                            get_local 9
                                                            i32.const 20
                                                            i32.add
                                                            get_local 0
                                                            i32.store
                                                            get_local 0
                                                            get_local 9
                                                            i32.store offset=24
                                                            br 1 (;@27;)
                                                          end
                                                          i32.const 0
                                                          get_local 10
                                                          i32.const -2
                                                          get_local 4
                                                          i32.rotl
                                                          i32.and
                                                          i32.store offset=1048580
                                                        end
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            get_local 5
                                                            i32.const 15
                                                            i32.gt_u
                                                            br_if 0 (;@28;)
                                                            get_local 6
                                                            get_local 5
                                                            get_local 3
                                                            i32.add
                                                            tee_local 0
                                                            i32.const 3
                                                            i32.or
                                                            i32.store offset=4
                                                            get_local 6
                                                            get_local 0
                                                            i32.add
                                                            tee_local 0
                                                            get_local 0
                                                            i32.load offset=4
                                                            i32.const 1
                                                            i32.or
                                                            i32.store offset=4
                                                            br 1 (;@27;)
                                                          end
                                                          get_local 11
                                                          get_local 5
                                                          i32.const 1
                                                          i32.or
                                                          i32.store offset=4
                                                          get_local 6
                                                          get_local 3
                                                          i32.const 3
                                                          i32.or
                                                          i32.store offset=4
                                                          get_local 11
                                                          get_local 5
                                                          i32.add
                                                          get_local 5
                                                          i32.store
                                                          block  ;; label = @28
                                                            get_local 7
                                                            i32.eqz
                                                            br_if 0 (;@28;)
                                                            get_local 7
                                                            i32.const 3
                                                            i32.shr_u
                                                            tee_local 3
                                                            i32.const 3
                                                            i32.shl
                                                            i32.const 1048616
                                                            i32.add
                                                            set_local 4
                                                            i32.const 0
                                                            i32.load offset=1048596
                                                            set_local 0
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                i32.const 1
                                                                get_local 3
                                                                i32.shl
                                                                tee_local 3
                                                                get_local 2
                                                                i32.and
                                                                i32.eqz
                                                                br_if 0 (;@30;)
                                                                get_local 4
                                                                i32.load offset=8
                                                                set_local 3
                                                                br 1 (;@29;)
                                                              end
                                                              i32.const 0
                                                              get_local 3
                                                              get_local 2
                                                              i32.or
                                                              i32.store offset=1048576
                                                              get_local 4
                                                              set_local 3
                                                            end
                                                            get_local 3
                                                            get_local 0
                                                            i32.store offset=12
                                                            get_local 4
                                                            get_local 0
                                                            i32.store offset=8
                                                            get_local 0
                                                            get_local 4
                                                            i32.store offset=12
                                                            get_local 0
                                                            get_local 3
                                                            i32.store offset=8
                                                          end
                                                          i32.const 0
                                                          get_local 11
                                                          i32.store offset=1048596
                                                          i32.const 0
                                                          get_local 5
                                                          i32.store offset=1048584
                                                        end
                                                        get_local 6
                                                        i32.const 8
                                                        i32.add
                                                        set_local 0
                                                        br 25 (;@1;)
                                                      end
                                                      get_local 0
                                                      i32.eqz
                                                      br_if 1 (;@24;)
                                                    end
                                                    loop  ;; label = @25
                                                      get_local 0
                                                      i32.load offset=4
                                                      i32.const -8
                                                      i32.and
                                                      get_local 3
                                                      i32.sub
                                                      tee_local 2
                                                      get_local 5
                                                      i32.lt_u
                                                      set_local 6
                                                      block  ;; label = @26
                                                        get_local 0
                                                        i32.load offset=16
                                                        tee_local 4
                                                        br_if 0 (;@26;)
                                                        get_local 0
                                                        i32.const 20
                                                        i32.add
                                                        i32.load
                                                        set_local 4
                                                      end
                                                      get_local 2
                                                      get_local 5
                                                      get_local 6
                                                      select
                                                      set_local 5
                                                      get_local 0
                                                      get_local 9
                                                      get_local 6
                                                      select
                                                      set_local 9
                                                      get_local 4
                                                      set_local 0
                                                      get_local 4
                                                      br_if 0 (;@25;)
                                                    end
                                                  end
                                                  get_local 9
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  get_local 5
                                                  i32.const 0
                                                  i32.load offset=1048584
                                                  get_local 3
                                                  i32.sub
                                                  i32.ge_u
                                                  br_if 0 (;@23;)
                                                  get_local 9
                                                  get_local 3
                                                  i32.add
                                                  tee_local 8
                                                  get_local 9
                                                  i32.le_u
                                                  br_if 0 (;@23;)
                                                  get_local 9
                                                  i32.load offset=24
                                                  set_local 10
                                                  get_local 9
                                                  i32.load offset=12
                                                  tee_local 6
                                                  get_local 9
                                                  i32.eq
                                                  br_if 1 (;@22;)
                                                  get_local 9
                                                  i32.load offset=8
                                                  tee_local 0
                                                  get_local 6
                                                  i32.store offset=12
                                                  get_local 6
                                                  get_local 0
                                                  i32.store offset=8
                                                  get_local 10
                                                  br_if 20 (;@3;)
                                                  br 21 (;@2;)
                                                end
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            i32.const 0
                                                            i32.load offset=1048584
                                                            tee_local 0
                                                            get_local 3
                                                            i32.ge_u
                                                            br_if 0 (;@28;)
                                                            i32.const 0
                                                            i32.load offset=1048588
                                                            tee_local 6
                                                            get_local 3
                                                            i32.le_u
                                                            br_if 1 (;@27;)
                                                            i32.const 0
                                                            i32.load offset=1048600
                                                            tee_local 0
                                                            get_local 3
                                                            i32.add
                                                            tee_local 4
                                                            get_local 6
                                                            get_local 3
                                                            i32.sub
                                                            tee_local 5
                                                            i32.const 1
                                                            i32.or
                                                            i32.store offset=4
                                                            i32.const 0
                                                            get_local 5
                                                            i32.store offset=1048588
                                                            i32.const 0
                                                            get_local 4
                                                            i32.store offset=1048600
                                                            get_local 0
                                                            get_local 3
                                                            i32.const 3
                                                            i32.or
                                                            i32.store offset=4
                                                            get_local 0
                                                            i32.const 8
                                                            i32.add
                                                            set_local 0
                                                            br 27 (;@1;)
                                                          end
                                                          i32.const 0
                                                          i32.load offset=1048596
                                                          set_local 4
                                                          get_local 0
                                                          get_local 3
                                                          i32.sub
                                                          tee_local 5
                                                          i32.const 16
                                                          i32.lt_u
                                                          br_if 1 (;@26;)
                                                          get_local 4
                                                          get_local 3
                                                          i32.add
                                                          tee_local 6
                                                          get_local 5
                                                          i32.const 1
                                                          i32.or
                                                          i32.store offset=4
                                                          i32.const 0
                                                          get_local 5
                                                          i32.store offset=1048584
                                                          i32.const 0
                                                          get_local 6
                                                          i32.store offset=1048596
                                                          get_local 4
                                                          get_local 0
                                                          i32.add
                                                          get_local 5
                                                          i32.store
                                                          get_local 4
                                                          get_local 3
                                                          i32.const 3
                                                          i32.or
                                                          i32.store offset=4
                                                          br 2 (;@25;)
                                                        end
                                                        i32.const 0
                                                        i32.load offset=1049048
                                                        i32.eqz
                                                        br_if 2 (;@24;)
                                                        i32.const 0
                                                        i32.load offset=1049056
                                                        set_local 4
                                                        br 3 (;@23;)
                                                      end
                                                      get_local 4
                                                      get_local 0
                                                      i32.const 3
                                                      i32.or
                                                      i32.store offset=4
                                                      get_local 4
                                                      get_local 0
                                                      i32.add
                                                      tee_local 0
                                                      get_local 0
                                                      i32.load offset=4
                                                      i32.const 1
                                                      i32.or
                                                      i32.store offset=4
                                                      i32.const 0
                                                      i32.const 0
                                                      i32.store offset=1048596
                                                      i32.const 0
                                                      i32.const 0
                                                      i32.store offset=1048584
                                                    end
                                                    get_local 4
                                                    i32.const 8
                                                    i32.add
                                                    set_local 0
                                                    br 23 (;@1;)
                                                  end
                                                  i32.const 0
                                                  i64.const -1
                                                  i64.store offset=1049060 align=4
                                                  i32.const 0
                                                  i64.const 281474976776192
                                                  i64.store offset=1049052 align=4
                                                  i32.const 0
                                                  get_local 1
                                                  i32.const 12
                                                  i32.add
                                                  i32.const -16
                                                  i32.and
                                                  i32.const 1431655768
                                                  i32.xor
                                                  i32.store offset=1049048
                                                  i32.const 0
                                                  i32.const 0
                                                  i32.store offset=1049068
                                                  i32.const 0
                                                  i32.const 0
                                                  i32.store offset=1049020
                                                  i32.const 65536
                                                  set_local 4
                                                end
                                                i32.const 0
                                                set_local 0
                                                get_local 4
                                                get_local 3
                                                i32.const 47
                                                i32.add
                                                tee_local 7
                                                i32.add
                                                tee_local 2
                                                i32.const 0
                                                get_local 4
                                                i32.sub
                                                tee_local 8
                                                i32.and
                                                tee_local 9
                                                get_local 3
                                                i32.le_u
                                                br_if 21 (;@1;)
                                                i32.const 0
                                                set_local 0
                                                block  ;; label = @23
                                                  i32.const 0
                                                  i32.load offset=1049016
                                                  tee_local 4
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  i32.const 0
                                                  i32.load offset=1049008
                                                  tee_local 5
                                                  get_local 9
                                                  i32.add
                                                  tee_local 10
                                                  get_local 5
                                                  i32.le_u
                                                  br_if 22 (;@1;)
                                                  get_local 10
                                                  get_local 4
                                                  i32.gt_u
                                                  br_if 22 (;@1;)
                                                end
                                                i32.const 0
                                                i32.load8_u offset=1049020
                                                i32.const 4
                                                i32.and
                                                br_if 8 (;@14;)
                                                block  ;; label = @23
                                                  i32.const 0
                                                  i32.load offset=1048600
                                                  tee_local 4
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  i32.const 1049024
                                                  set_local 0
                                                  loop  ;; label = @24
                                                    block  ;; label = @25
                                                      get_local 0
                                                      i32.load
                                                      tee_local 5
                                                      get_local 4
                                                      i32.gt_u
                                                      br_if 0 (;@25;)
                                                      get_local 5
                                                      get_local 0
                                                      i32.load offset=4
                                                      i32.add
                                                      get_local 4
                                                      i32.gt_u
                                                      br_if 4 (;@21;)
                                                    end
                                                    get_local 0
                                                    i32.load offset=8
                                                    tee_local 0
                                                    br_if 0 (;@24;)
                                                  end
                                                end
                                                i32.const 0
                                                call 21
                                                tee_local 6
                                                i32.const -1
                                                i32.eq
                                                br_if 7 (;@15;)
                                                get_local 9
                                                set_local 2
                                                block  ;; label = @23
                                                  i32.const 0
                                                  i32.load offset=1049052
                                                  tee_local 0
                                                  i32.const -1
                                                  i32.add
                                                  tee_local 4
                                                  get_local 6
                                                  i32.and
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  get_local 9
                                                  get_local 6
                                                  i32.sub
                                                  get_local 4
                                                  get_local 6
                                                  i32.add
                                                  i32.const 0
                                                  get_local 0
                                                  i32.sub
                                                  i32.and
                                                  i32.add
                                                  set_local 2
                                                end
                                                get_local 2
                                                get_local 3
                                                i32.le_u
                                                br_if 7 (;@15;)
                                                get_local 2
                                                i32.const 2147483646
                                                i32.gt_u
                                                br_if 7 (;@15;)
                                                block  ;; label = @23
                                                  i32.const 0
                                                  i32.load offset=1049016
                                                  tee_local 0
                                                  i32.eqz
                                                  br_if 0 (;@23;)
                                                  i32.const 0
                                                  i32.load offset=1049008
                                                  tee_local 4
                                                  get_local 2
                                                  i32.add
                                                  tee_local 5
                                                  get_local 4
                                                  i32.le_u
                                                  br_if 8 (;@15;)
                                                  get_local 5
                                                  get_local 0
                                                  i32.gt_u
                                                  br_if 8 (;@15;)
                                                end
                                                get_local 2
                                                call 21
                                                tee_local 0
                                                get_local 6
                                                i32.ne
                                                br_if 2 (;@20;)
                                                br 9 (;@13;)
                                              end
                                              block  ;; label = @22
                                                get_local 9
                                                i32.const 20
                                                i32.add
                                                tee_local 4
                                                i32.load
                                                tee_local 0
                                                br_if 0 (;@22;)
                                                get_local 9
                                                i32.load offset=16
                                                tee_local 0
                                                i32.eqz
                                                br_if 3 (;@19;)
                                                get_local 9
                                                i32.const 16
                                                i32.add
                                                set_local 4
                                              end
                                              loop  ;; label = @22
                                                get_local 4
                                                set_local 2
                                                get_local 0
                                                tee_local 6
                                                i32.const 20
                                                i32.add
                                                tee_local 4
                                                i32.load
                                                tee_local 0
                                                br_if 0 (;@22;)
                                                get_local 6
                                                i32.const 16
                                                i32.add
                                                set_local 4
                                                get_local 6
                                                i32.load offset=16
                                                tee_local 0
                                                br_if 0 (;@22;)
                                              end
                                              get_local 2
                                              i32.const 0
                                              i32.store
                                              get_local 10
                                              i32.eqz
                                              br_if 19 (;@2;)
                                              br 18 (;@3;)
                                            end
                                            get_local 2
                                            get_local 6
                                            i32.sub
                                            get_local 8
                                            i32.and
                                            tee_local 2
                                            i32.const 2147483646
                                            i32.gt_u
                                            br_if 5 (;@15;)
                                            get_local 2
                                            call 21
                                            tee_local 6
                                            get_local 0
                                            i32.load
                                            get_local 0
                                            i32.load offset=4
                                            i32.add
                                            i32.eq
                                            br_if 3 (;@17;)
                                            get_local 6
                                            set_local 0
                                          end
                                          get_local 0
                                          set_local 6
                                          get_local 3
                                          i32.const 48
                                          i32.add
                                          get_local 2
                                          i32.le_u
                                          br_if 1 (;@18;)
                                          get_local 2
                                          i32.const 2147483646
                                          i32.gt_u
                                          br_if 1 (;@18;)
                                          get_local 6
                                          i32.const -1
                                          i32.eq
                                          br_if 1 (;@18;)
                                          get_local 7
                                          get_local 2
                                          i32.sub
                                          i32.const 0
                                          i32.load offset=1049056
                                          tee_local 0
                                          i32.add
                                          i32.const 0
                                          get_local 0
                                          i32.sub
                                          i32.and
                                          tee_local 0
                                          i32.const 2147483646
                                          i32.gt_u
                                          br_if 6 (;@13;)
                                          get_local 0
                                          call 21
                                          i32.const -1
                                          i32.eq
                                          br_if 3 (;@16;)
                                          get_local 0
                                          get_local 2
                                          i32.add
                                          set_local 2
                                          br 6 (;@13;)
                                        end
                                        i32.const 0
                                        set_local 6
                                        get_local 10
                                        br_if 15 (;@3;)
                                        br 16 (;@2;)
                                      end
                                      get_local 6
                                      i32.const -1
                                      i32.ne
                                      br_if 4 (;@13;)
                                      br 2 (;@15;)
                                    end
                                    get_local 6
                                    i32.const -1
                                    i32.ne
                                    br_if 3 (;@13;)
                                    br 1 (;@15;)
                                  end
                                  i32.const 0
                                  get_local 2
                                  i32.sub
                                  call 21
                                  drop
                                end
                                i32.const 0
                                i32.const 0
                                i32.load offset=1049020
                                i32.const 4
                                i32.or
                                i32.store offset=1049020
                              end
                              get_local 9
                              i32.const 2147483646
                              i32.gt_u
                              br_if 1 (;@12;)
                              get_local 9
                              call 21
                              tee_local 6
                              i32.const 0
                              call 21
                              tee_local 0
                              i32.ge_u
                              br_if 1 (;@12;)
                              get_local 6
                              i32.const -1
                              i32.eq
                              br_if 1 (;@12;)
                              get_local 0
                              i32.const -1
                              i32.eq
                              br_if 1 (;@12;)
                              get_local 0
                              get_local 6
                              i32.sub
                              tee_local 2
                              get_local 3
                              i32.const 40
                              i32.add
                              i32.le_u
                              br_if 1 (;@12;)
                            end
                            i32.const 0
                            i32.const 0
                            i32.load offset=1049008
                            get_local 2
                            i32.add
                            tee_local 0
                            i32.store offset=1049008
                            block  ;; label = @13
                              get_local 0
                              i32.const 0
                              i32.load offset=1049012
                              i32.le_u
                              br_if 0 (;@13;)
                              i32.const 0
                              get_local 0
                              i32.store offset=1049012
                            end
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    i32.const 0
                                    i32.load offset=1048600
                                    tee_local 4
                                    i32.eqz
                                    br_if 0 (;@16;)
                                    i32.const 1049024
                                    set_local 0
                                    loop  ;; label = @17
                                      get_local 6
                                      get_local 0
                                      i32.load
                                      tee_local 5
                                      get_local 0
                                      i32.load offset=4
                                      tee_local 9
                                      i32.add
                                      i32.eq
                                      br_if 2 (;@15;)
                                      get_local 0
                                      i32.load offset=8
                                      tee_local 0
                                      br_if 0 (;@17;)
                                      br 3 (;@14;)
                                    end
                                  end
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      i32.const 0
                                      i32.load offset=1048592
                                      tee_local 0
                                      i32.eqz
                                      br_if 0 (;@17;)
                                      get_local 6
                                      get_local 0
                                      i32.ge_u
                                      br_if 1 (;@16;)
                                    end
                                    i32.const 0
                                    get_local 6
                                    i32.store offset=1048592
                                  end
                                  i32.const 0
                                  set_local 0
                                  i32.const 0
                                  get_local 2
                                  i32.store offset=1049028
                                  i32.const 0
                                  get_local 6
                                  i32.store offset=1049024
                                  i32.const 0
                                  i32.const -1
                                  i32.store offset=1048608
                                  i32.const 0
                                  i32.const 0
                                  i32.load offset=1049048
                                  i32.store offset=1048612
                                  i32.const 0
                                  i32.const 0
                                  i32.store offset=1049036
                                  loop  ;; label = @16
                                    get_local 0
                                    i32.const 1048624
                                    i32.add
                                    get_local 0
                                    i32.const 1048616
                                    i32.add
                                    tee_local 4
                                    i32.store
                                    get_local 0
                                    i32.const 1048628
                                    i32.add
                                    get_local 4
                                    i32.store
                                    get_local 0
                                    i32.const 8
                                    i32.add
                                    tee_local 0
                                    i32.const 256
                                    i32.ne
                                    br_if 0 (;@16;)
                                  end
                                  get_local 6
                                  i32.const -8
                                  get_local 6
                                  i32.sub
                                  i32.const 7
                                  i32.and
                                  i32.const 0
                                  get_local 6
                                  i32.const 8
                                  i32.add
                                  i32.const 7
                                  i32.and
                                  select
                                  tee_local 0
                                  i32.add
                                  tee_local 4
                                  get_local 2
                                  i32.const -40
                                  i32.add
                                  tee_local 5
                                  get_local 0
                                  i32.sub
                                  tee_local 0
                                  i32.const 1
                                  i32.or
                                  i32.store offset=4
                                  i32.const 0
                                  i32.const 0
                                  i32.load offset=1049064
                                  i32.store offset=1048604
                                  i32.const 0
                                  get_local 0
                                  i32.store offset=1048588
                                  i32.const 0
                                  get_local 4
                                  i32.store offset=1048600
                                  get_local 6
                                  get_local 5
                                  i32.add
                                  i32.const 40
                                  i32.store offset=4
                                  br 2 (;@13;)
                                end
                                get_local 0
                                i32.load8_u offset=12
                                i32.const 8
                                i32.and
                                br_if 0 (;@14;)
                                get_local 6
                                get_local 4
                                i32.le_u
                                br_if 0 (;@14;)
                                get_local 5
                                get_local 4
                                i32.gt_u
                                br_if 0 (;@14;)
                                get_local 4
                                i32.const -8
                                get_local 4
                                i32.sub
                                i32.const 7
                                i32.and
                                i32.const 0
                                get_local 4
                                i32.const 8
                                i32.add
                                i32.const 7
                                i32.and
                                select
                                tee_local 5
                                i32.add
                                tee_local 6
                                i32.const 0
                                i32.load offset=1048588
                                get_local 2
                                i32.add
                                tee_local 8
                                get_local 5
                                i32.sub
                                tee_local 5
                                i32.const 1
                                i32.or
                                i32.store offset=4
                                get_local 0
                                i32.const 4
                                i32.add
                                get_local 9
                                get_local 2
                                i32.add
                                i32.store
                                i32.const 0
                                i32.const 0
                                i32.load offset=1049064
                                i32.store offset=1048604
                                i32.const 0
                                get_local 5
                                i32.store offset=1048588
                                i32.const 0
                                get_local 6
                                i32.store offset=1048600
                                get_local 4
                                get_local 8
                                i32.add
                                i32.const 40
                                i32.store offset=4
                                br 1 (;@13;)
                              end
                              block  ;; label = @14
                                get_local 6
                                i32.const 0
                                i32.load offset=1048592
                                i32.ge_u
                                br_if 0 (;@14;)
                                i32.const 0
                                get_local 6
                                i32.store offset=1048592
                              end
                              get_local 6
                              get_local 2
                              i32.add
                              set_local 5
                              i32.const 1049024
                              set_local 0
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              loop  ;; label = @22
                                                get_local 0
                                                i32.load
                                                get_local 5
                                                i32.eq
                                                br_if 1 (;@21;)
                                                get_local 0
                                                i32.load offset=8
                                                tee_local 0
                                                br_if 0 (;@22;)
                                                br 2 (;@20;)
                                              end
                                            end
                                            get_local 0
                                            i32.load8_u offset=12
                                            i32.const 8
                                            i32.and
                                            br_if 0 (;@20;)
                                            get_local 0
                                            get_local 6
                                            i32.store
                                            get_local 0
                                            get_local 0
                                            i32.load offset=4
                                            get_local 2
                                            i32.add
                                            i32.store offset=4
                                            get_local 6
                                            i32.const -8
                                            get_local 6
                                            i32.sub
                                            i32.const 7
                                            i32.and
                                            i32.const 0
                                            get_local 6
                                            i32.const 8
                                            i32.add
                                            i32.const 7
                                            i32.and
                                            select
                                            i32.add
                                            tee_local 2
                                            get_local 3
                                            i32.const 3
                                            i32.or
                                            i32.store offset=4
                                            get_local 5
                                            i32.const -8
                                            get_local 5
                                            i32.sub
                                            i32.const 7
                                            i32.and
                                            i32.const 0
                                            get_local 5
                                            i32.const 8
                                            i32.add
                                            i32.const 7
                                            i32.and
                                            select
                                            i32.add
                                            tee_local 6
                                            get_local 2
                                            i32.sub
                                            get_local 3
                                            i32.sub
                                            set_local 0
                                            get_local 2
                                            get_local 3
                                            i32.add
                                            set_local 5
                                            get_local 4
                                            get_local 6
                                            i32.eq
                                            br_if 1 (;@19;)
                                            i32.const 0
                                            i32.load offset=1048596
                                            get_local 6
                                            i32.eq
                                            br_if 9 (;@11;)
                                            get_local 6
                                            i32.load offset=4
                                            tee_local 4
                                            i32.const 3
                                            i32.and
                                            i32.const 1
                                            i32.ne
                                            br_if 15 (;@5;)
                                            get_local 4
                                            i32.const -8
                                            i32.and
                                            set_local 7
                                            get_local 4
                                            i32.const 255
                                            i32.gt_u
                                            br_if 10 (;@10;)
                                            get_local 6
                                            i32.load offset=12
                                            tee_local 3
                                            get_local 6
                                            i32.load offset=8
                                            tee_local 9
                                            i32.eq
                                            br_if 11 (;@9;)
                                            get_local 3
                                            get_local 9
                                            i32.store offset=8
                                            get_local 9
                                            get_local 3
                                            i32.store offset=12
                                            br 14 (;@6;)
                                          end
                                          i32.const 1049024
                                          set_local 0
                                          block  ;; label = @20
                                            loop  ;; label = @21
                                              block  ;; label = @22
                                                get_local 0
                                                i32.load
                                                tee_local 5
                                                get_local 4
                                                i32.gt_u
                                                br_if 0 (;@22;)
                                                get_local 5
                                                get_local 0
                                                i32.load offset=4
                                                i32.add
                                                tee_local 5
                                                get_local 4
                                                i32.gt_u
                                                br_if 2 (;@20;)
                                              end
                                              get_local 0
                                              i32.load offset=8
                                              set_local 0
                                              br 0 (;@21;)
                                            end
                                          end
                                          get_local 6
                                          i32.const -8
                                          get_local 6
                                          i32.sub
                                          i32.const 7
                                          i32.and
                                          i32.const 0
                                          get_local 6
                                          i32.const 8
                                          i32.add
                                          i32.const 7
                                          i32.and
                                          select
                                          tee_local 0
                                          i32.add
                                          tee_local 8
                                          get_local 2
                                          i32.const -40
                                          i32.add
                                          tee_local 9
                                          get_local 0
                                          i32.sub
                                          tee_local 0
                                          i32.const 1
                                          i32.or
                                          i32.store offset=4
                                          get_local 6
                                          get_local 9
                                          i32.add
                                          i32.const 40
                                          i32.store offset=4
                                          get_local 4
                                          get_local 5
                                          i32.const 39
                                          get_local 5
                                          i32.sub
                                          i32.const 7
                                          i32.and
                                          i32.const 0
                                          get_local 5
                                          i32.const -39
                                          i32.add
                                          i32.const 7
                                          i32.and
                                          select
                                          i32.add
                                          i32.const -47
                                          i32.add
                                          tee_local 9
                                          get_local 9
                                          get_local 4
                                          i32.const 16
                                          i32.add
                                          i32.lt_u
                                          select
                                          tee_local 9
                                          i32.const 27
                                          i32.store offset=4
                                          i32.const 0
                                          i32.const 0
                                          i32.load offset=1049064
                                          i32.store offset=1048604
                                          i32.const 0
                                          get_local 0
                                          i32.store offset=1048588
                                          i32.const 0
                                          get_local 8
                                          i32.store offset=1048600
                                          get_local 9
                                          i32.const 16
                                          i32.add
                                          i32.const 0
                                          i64.load offset=1049032 align=4
                                          i64.store align=4
                                          get_local 9
                                          i32.const 0
                                          i64.load offset=1049024 align=4
                                          i64.store offset=8 align=4
                                          i32.const 0
                                          get_local 2
                                          i32.store offset=1049028
                                          i32.const 0
                                          get_local 6
                                          i32.store offset=1049024
                                          i32.const 0
                                          get_local 9
                                          i32.const 8
                                          i32.add
                                          i32.store offset=1049032
                                          i32.const 0
                                          i32.const 0
                                          i32.store offset=1049036
                                          get_local 9
                                          i32.const 28
                                          i32.add
                                          set_local 0
                                          loop  ;; label = @20
                                            get_local 0
                                            i32.const 7
                                            i32.store
                                            get_local 0
                                            i32.const 4
                                            i32.add
                                            tee_local 0
                                            get_local 5
                                            i32.lt_u
                                            br_if 0 (;@20;)
                                          end
                                          get_local 9
                                          get_local 4
                                          i32.eq
                                          br_if 6 (;@13;)
                                          get_local 9
                                          i32.const 4
                                          i32.add
                                          tee_local 0
                                          get_local 0
                                          i32.load
                                          i32.const -2
                                          i32.and
                                          i32.store
                                          get_local 9
                                          get_local 9
                                          get_local 4
                                          i32.sub
                                          tee_local 2
                                          i32.store
                                          get_local 4
                                          get_local 2
                                          i32.const 1
                                          i32.or
                                          i32.store offset=4
                                          block  ;; label = @20
                                            get_local 2
                                            i32.const 255
                                            i32.gt_u
                                            br_if 0 (;@20;)
                                            get_local 2
                                            i32.const 3
                                            i32.shr_u
                                            tee_local 5
                                            i32.const 3
                                            i32.shl
                                            i32.const 1048616
                                            i32.add
                                            set_local 0
                                            i32.const 0
                                            i32.load offset=1048576
                                            tee_local 6
                                            i32.const 1
                                            get_local 5
                                            i32.shl
                                            tee_local 5
                                            i32.and
                                            i32.eqz
                                            br_if 2 (;@18;)
                                            get_local 0
                                            i32.load offset=8
                                            set_local 5
                                            br 3 (;@17;)
                                          end
                                          i32.const 0
                                          set_local 0
                                          block  ;; label = @20
                                            get_local 2
                                            i32.const 8
                                            i32.shr_u
                                            tee_local 5
                                            i32.eqz
                                            br_if 0 (;@20;)
                                            i32.const 31
                                            set_local 0
                                            get_local 2
                                            i32.const 16777215
                                            i32.gt_u
                                            br_if 0 (;@20;)
                                            get_local 2
                                            i32.const 14
                                            get_local 5
                                            get_local 5
                                            i32.const 1048320
                                            i32.add
                                            i32.const 16
                                            i32.shr_u
                                            i32.const 8
                                            i32.and
                                            tee_local 0
                                            i32.shl
                                            tee_local 5
                                            i32.const 520192
                                            i32.add
                                            i32.const 16
                                            i32.shr_u
                                            i32.const 4
                                            i32.and
                                            tee_local 6
                                            get_local 0
                                            i32.or
                                            get_local 5
                                            get_local 6
                                            i32.shl
                                            tee_local 0
                                            i32.const 245760
                                            i32.add
                                            i32.const 16
                                            i32.shr_u
                                            i32.const 2
                                            i32.and
                                            tee_local 5
                                            i32.or
                                            i32.sub
                                            get_local 0
                                            get_local 5
                                            i32.shl
                                            i32.const 15
                                            i32.shr_u
                                            i32.add
                                            tee_local 0
                                            i32.const 7
                                            i32.add
                                            i32.shr_u
                                            i32.const 1
                                            i32.and
                                            get_local 0
                                            i32.const 1
                                            i32.shl
                                            i32.or
                                            set_local 0
                                          end
                                          get_local 4
                                          i64.const 0
                                          i64.store offset=16 align=4
                                          get_local 4
                                          i32.const 28
                                          i32.add
                                          get_local 0
                                          i32.store
                                          get_local 0
                                          i32.const 2
                                          i32.shl
                                          i32.const 1048880
                                          i32.add
                                          set_local 5
                                          i32.const 0
                                          i32.load offset=1048580
                                          tee_local 6
                                          i32.const 1
                                          get_local 0
                                          i32.shl
                                          tee_local 9
                                          i32.and
                                          i32.eqz
                                          br_if 3 (;@16;)
                                          get_local 2
                                          i32.const 0
                                          i32.const 25
                                          get_local 0
                                          i32.const 1
                                          i32.shr_u
                                          i32.sub
                                          get_local 0
                                          i32.const 31
                                          i32.eq
                                          select
                                          i32.shl
                                          set_local 0
                                          get_local 5
                                          i32.load
                                          set_local 6
                                          loop  ;; label = @20
                                            get_local 6
                                            tee_local 5
                                            i32.load offset=4
                                            i32.const -8
                                            i32.and
                                            get_local 2
                                            i32.eq
                                            br_if 6 (;@14;)
                                            get_local 0
                                            i32.const 29
                                            i32.shr_u
                                            set_local 6
                                            get_local 0
                                            i32.const 1
                                            i32.shl
                                            set_local 0
                                            get_local 5
                                            get_local 6
                                            i32.const 4
                                            i32.and
                                            i32.add
                                            i32.const 16
                                            i32.add
                                            tee_local 9
                                            i32.load
                                            tee_local 6
                                            br_if 0 (;@20;)
                                          end
                                          get_local 9
                                          get_local 4
                                          i32.store
                                          get_local 4
                                          i32.const 24
                                          i32.add
                                          get_local 5
                                          i32.store
                                          br 4 (;@15;)
                                        end
                                        i32.const 0
                                        get_local 5
                                        i32.store offset=1048600
                                        i32.const 0
                                        i32.const 0
                                        i32.load offset=1048588
                                        get_local 0
                                        i32.add
                                        tee_local 0
                                        i32.store offset=1048588
                                        get_local 5
                                        get_local 0
                                        i32.const 1
                                        i32.or
                                        i32.store offset=4
                                        br 14 (;@4;)
                                      end
                                      i32.const 0
                                      get_local 6
                                      get_local 5
                                      i32.or
                                      i32.store offset=1048576
                                      get_local 0
                                      set_local 5
                                    end
                                    get_local 5
                                    get_local 4
                                    i32.store offset=12
                                    get_local 0
                                    get_local 4
                                    i32.store offset=8
                                    get_local 4
                                    get_local 0
                                    i32.store offset=12
                                    get_local 4
                                    get_local 5
                                    i32.store offset=8
                                    br 3 (;@13;)
                                  end
                                  get_local 5
                                  get_local 4
                                  i32.store
                                  i32.const 0
                                  get_local 6
                                  get_local 9
                                  i32.or
                                  i32.store offset=1048580
                                  get_local 4
                                  i32.const 24
                                  i32.add
                                  get_local 5
                                  i32.store
                                end
                                get_local 4
                                get_local 4
                                i32.store offset=12
                                get_local 4
                                get_local 4
                                i32.store offset=8
                                br 1 (;@13;)
                              end
                              get_local 5
                              i32.load offset=8
                              tee_local 0
                              get_local 4
                              i32.store offset=12
                              get_local 5
                              get_local 4
                              i32.store offset=8
                              get_local 4
                              i32.const 24
                              i32.add
                              i32.const 0
                              i32.store
                              get_local 4
                              get_local 5
                              i32.store offset=12
                              get_local 4
                              get_local 0
                              i32.store offset=8
                            end
                            i32.const 0
                            i32.load offset=1048588
                            tee_local 0
                            get_local 3
                            i32.le_u
                            br_if 0 (;@12;)
                            i32.const 0
                            i32.load offset=1048600
                            tee_local 4
                            get_local 3
                            i32.add
                            tee_local 5
                            get_local 0
                            get_local 3
                            i32.sub
                            tee_local 0
                            i32.const 1
                            i32.or
                            i32.store offset=4
                            i32.const 0
                            get_local 0
                            i32.store offset=1048588
                            i32.const 0
                            get_local 5
                            i32.store offset=1048600
                            get_local 4
                            get_local 3
                            i32.const 3
                            i32.or
                            i32.store offset=4
                            get_local 4
                            i32.const 8
                            i32.add
                            set_local 0
                            br 11 (;@1;)
                          end
                          i32.const 0
                          set_local 0
                          i32.const 0
                          i32.const 48
                          i32.store offset=1049072
                          br 10 (;@1;)
                        end
                        i32.const 0
                        get_local 5
                        i32.store offset=1048596
                        i32.const 0
                        i32.const 0
                        i32.load offset=1048584
                        get_local 0
                        i32.add
                        tee_local 0
                        i32.store offset=1048584
                        get_local 5
                        get_local 0
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        get_local 5
                        get_local 0
                        i32.add
                        get_local 0
                        i32.store
                        br 6 (;@4;)
                      end
                      get_local 6
                      i32.load offset=24
                      set_local 10
                      get_local 6
                      i32.load offset=12
                      tee_local 9
                      get_local 6
                      i32.eq
                      br_if 1 (;@8;)
                      get_local 6
                      i32.load offset=8
                      tee_local 4
                      get_local 9
                      i32.store offset=12
                      get_local 9
                      get_local 4
                      i32.store offset=8
                      get_local 10
                      br_if 2 (;@7;)
                      br 3 (;@6;)
                    end
                    i32.const 0
                    i32.const 0
                    i32.load offset=1048576
                    i32.const -2
                    get_local 4
                    i32.const 3
                    i32.shr_u
                    i32.rotl
                    i32.and
                    i32.store offset=1048576
                    br 2 (;@6;)
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 6
                      i32.const 20
                      i32.add
                      tee_local 4
                      i32.load
                      tee_local 3
                      br_if 0 (;@9;)
                      get_local 6
                      i32.const 16
                      i32.add
                      tee_local 4
                      i32.load
                      tee_local 3
                      i32.eqz
                      br_if 1 (;@8;)
                    end
                    loop  ;; label = @9
                      get_local 4
                      set_local 8
                      get_local 3
                      tee_local 9
                      i32.const 20
                      i32.add
                      tee_local 4
                      i32.load
                      tee_local 3
                      br_if 0 (;@9;)
                      get_local 9
                      i32.const 16
                      i32.add
                      set_local 4
                      get_local 9
                      i32.load offset=16
                      tee_local 3
                      br_if 0 (;@9;)
                    end
                    get_local 8
                    i32.const 0
                    i32.store
                    get_local 10
                    i32.eqz
                    br_if 2 (;@6;)
                    br 1 (;@7;)
                  end
                  i32.const 0
                  set_local 9
                  get_local 10
                  i32.eqz
                  br_if 1 (;@6;)
                end
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 6
                      i32.load offset=28
                      tee_local 3
                      i32.const 2
                      i32.shl
                      i32.const 1048880
                      i32.add
                      tee_local 4
                      i32.load
                      get_local 6
                      i32.eq
                      br_if 0 (;@9;)
                      get_local 10
                      i32.const 16
                      i32.const 20
                      get_local 10
                      i32.load offset=16
                      get_local 6
                      i32.eq
                      select
                      i32.add
                      get_local 9
                      i32.store
                      get_local 9
                      br_if 1 (;@8;)
                      br 3 (;@6;)
                    end
                    get_local 4
                    get_local 9
                    i32.store
                    get_local 9
                    i32.eqz
                    br_if 1 (;@7;)
                  end
                  get_local 9
                  get_local 10
                  i32.store offset=24
                  block  ;; label = @8
                    get_local 6
                    i32.load offset=16
                    tee_local 4
                    i32.eqz
                    br_if 0 (;@8;)
                    get_local 9
                    get_local 4
                    i32.store offset=16
                    get_local 4
                    get_local 9
                    i32.store offset=24
                  end
                  get_local 6
                  i32.const 20
                  i32.add
                  i32.load
                  tee_local 4
                  i32.eqz
                  br_if 1 (;@6;)
                  get_local 9
                  i32.const 20
                  i32.add
                  get_local 4
                  i32.store
                  get_local 4
                  get_local 9
                  i32.store offset=24
                  br 1 (;@6;)
                end
                i32.const 0
                i32.const 0
                i32.load offset=1048580
                i32.const -2
                get_local 3
                i32.rotl
                i32.and
                i32.store offset=1048580
              end
              get_local 7
              get_local 0
              i32.add
              set_local 0
              get_local 6
              get_local 7
              i32.add
              set_local 6
            end
            get_local 6
            get_local 6
            i32.load offset=4
            i32.const -2
            i32.and
            i32.store offset=4
            get_local 5
            get_local 0
            i32.add
            get_local 0
            i32.store
            get_local 5
            get_local 0
            i32.const 1
            i32.or
            i32.store offset=4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        get_local 0
                        i32.const 255
                        i32.gt_u
                        br_if 0 (;@10;)
                        get_local 0
                        i32.const 3
                        i32.shr_u
                        tee_local 4
                        i32.const 3
                        i32.shl
                        i32.const 1048616
                        i32.add
                        set_local 0
                        i32.const 0
                        i32.load offset=1048576
                        tee_local 3
                        i32.const 1
                        get_local 4
                        i32.shl
                        tee_local 4
                        i32.and
                        i32.eqz
                        br_if 1 (;@9;)
                        get_local 0
                        i32.load offset=8
                        set_local 4
                        br 2 (;@8;)
                      end
                      i32.const 0
                      set_local 4
                      block  ;; label = @10
                        get_local 0
                        i32.const 8
                        i32.shr_u
                        tee_local 3
                        i32.eqz
                        br_if 0 (;@10;)
                        i32.const 31
                        set_local 4
                        get_local 0
                        i32.const 16777215
                        i32.gt_u
                        br_if 0 (;@10;)
                        get_local 0
                        i32.const 14
                        get_local 3
                        get_local 3
                        i32.const 1048320
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 8
                        i32.and
                        tee_local 4
                        i32.shl
                        tee_local 3
                        i32.const 520192
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 4
                        i32.and
                        tee_local 6
                        get_local 4
                        i32.or
                        get_local 3
                        get_local 6
                        i32.shl
                        tee_local 4
                        i32.const 245760
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 2
                        i32.and
                        tee_local 3
                        i32.or
                        i32.sub
                        get_local 4
                        get_local 3
                        i32.shl
                        i32.const 15
                        i32.shr_u
                        i32.add
                        tee_local 4
                        i32.const 7
                        i32.add
                        i32.shr_u
                        i32.const 1
                        i32.and
                        get_local 4
                        i32.const 1
                        i32.shl
                        i32.or
                        set_local 4
                      end
                      get_local 5
                      get_local 4
                      i32.store offset=28
                      get_local 5
                      i64.const 0
                      i64.store offset=16 align=4
                      get_local 4
                      i32.const 2
                      i32.shl
                      i32.const 1048880
                      i32.add
                      set_local 3
                      i32.const 0
                      i32.load offset=1048580
                      tee_local 6
                      i32.const 1
                      get_local 4
                      i32.shl
                      tee_local 9
                      i32.and
                      i32.eqz
                      br_if 2 (;@7;)
                      get_local 0
                      i32.const 0
                      i32.const 25
                      get_local 4
                      i32.const 1
                      i32.shr_u
                      i32.sub
                      get_local 4
                      i32.const 31
                      i32.eq
                      select
                      i32.shl
                      set_local 4
                      get_local 3
                      i32.load
                      set_local 6
                      loop  ;; label = @10
                        get_local 6
                        tee_local 3
                        i32.load offset=4
                        i32.const -8
                        i32.and
                        get_local 0
                        i32.eq
                        br_if 5 (;@5;)
                        get_local 4
                        i32.const 29
                        i32.shr_u
                        set_local 6
                        get_local 4
                        i32.const 1
                        i32.shl
                        set_local 4
                        get_local 3
                        get_local 6
                        i32.const 4
                        i32.and
                        i32.add
                        i32.const 16
                        i32.add
                        tee_local 9
                        i32.load
                        tee_local 6
                        br_if 0 (;@10;)
                      end
                      get_local 9
                      get_local 5
                      i32.store
                      get_local 5
                      get_local 3
                      i32.store offset=24
                      br 3 (;@6;)
                    end
                    i32.const 0
                    get_local 3
                    get_local 4
                    i32.or
                    i32.store offset=1048576
                    get_local 0
                    set_local 4
                  end
                  get_local 4
                  get_local 5
                  i32.store offset=12
                  get_local 0
                  get_local 5
                  i32.store offset=8
                  get_local 5
                  get_local 0
                  i32.store offset=12
                  get_local 5
                  get_local 4
                  i32.store offset=8
                  br 3 (;@4;)
                end
                get_local 3
                get_local 5
                i32.store
                i32.const 0
                get_local 6
                get_local 9
                i32.or
                i32.store offset=1048580
                get_local 5
                get_local 3
                i32.store offset=24
              end
              get_local 5
              get_local 5
              i32.store offset=12
              get_local 5
              get_local 5
              i32.store offset=8
              br 1 (;@4;)
            end
            get_local 3
            i32.load offset=8
            tee_local 0
            get_local 5
            i32.store offset=12
            get_local 3
            get_local 5
            i32.store offset=8
            get_local 5
            i32.const 0
            i32.store offset=24
            get_local 5
            get_local 3
            i32.store offset=12
            get_local 5
            get_local 0
            i32.store offset=8
          end
          get_local 2
          i32.const 8
          i32.add
          set_local 0
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 9
              get_local 9
              i32.load offset=28
              tee_local 4
              i32.const 2
              i32.shl
              i32.const 1048880
              i32.add
              tee_local 0
              i32.load
              i32.eq
              br_if 0 (;@5;)
              get_local 10
              i32.const 16
              i32.const 20
              get_local 10
              i32.load offset=16
              get_local 9
              i32.eq
              select
              i32.add
              get_local 6
              i32.store
              get_local 6
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            get_local 0
            get_local 6
            i32.store
            get_local 6
            i32.eqz
            br_if 1 (;@3;)
          end
          get_local 6
          get_local 10
          i32.store offset=24
          block  ;; label = @4
            get_local 9
            i32.load offset=16
            tee_local 0
            i32.eqz
            br_if 0 (;@4;)
            get_local 6
            get_local 0
            i32.store offset=16
            get_local 0
            get_local 6
            i32.store offset=24
          end
          get_local 9
          i32.const 20
          i32.add
          i32.load
          tee_local 0
          i32.eqz
          br_if 1 (;@2;)
          get_local 6
          i32.const 20
          i32.add
          get_local 0
          i32.store
          get_local 0
          get_local 6
          i32.store offset=24
          br 1 (;@2;)
        end
        i32.const 0
        get_local 7
        i32.const -2
        get_local 4
        i32.rotl
        i32.and
        tee_local 7
        i32.store offset=1048580
      end
      block  ;; label = @2
        block  ;; label = @3
          get_local 5
          i32.const 15
          i32.gt_u
          br_if 0 (;@3;)
          get_local 9
          get_local 5
          get_local 3
          i32.add
          tee_local 0
          i32.const 3
          i32.or
          i32.store offset=4
          get_local 9
          get_local 0
          i32.add
          tee_local 0
          get_local 0
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          br 1 (;@2;)
        end
        get_local 8
        get_local 5
        i32.const 1
        i32.or
        i32.store offset=4
        get_local 9
        get_local 3
        i32.const 3
        i32.or
        i32.store offset=4
        get_local 8
        get_local 5
        i32.add
        get_local 5
        i32.store
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 5
                  i32.const 255
                  i32.gt_u
                  br_if 0 (;@7;)
                  get_local 5
                  i32.const 3
                  i32.shr_u
                  tee_local 4
                  i32.const 3
                  i32.shl
                  i32.const 1048616
                  i32.add
                  set_local 0
                  i32.const 0
                  i32.load offset=1048576
                  tee_local 5
                  i32.const 1
                  get_local 4
                  i32.shl
                  tee_local 4
                  i32.and
                  i32.eqz
                  br_if 1 (;@6;)
                  get_local 0
                  i32.load offset=8
                  set_local 4
                  br 2 (;@5;)
                end
                get_local 5
                i32.const 8
                i32.shr_u
                tee_local 4
                i32.eqz
                br_if 2 (;@4;)
                i32.const 31
                set_local 0
                get_local 5
                i32.const 16777215
                i32.gt_u
                br_if 3 (;@3;)
                get_local 5
                i32.const 14
                get_local 4
                get_local 4
                i32.const 1048320
                i32.add
                i32.const 16
                i32.shr_u
                i32.const 8
                i32.and
                tee_local 0
                i32.shl
                tee_local 4
                i32.const 520192
                i32.add
                i32.const 16
                i32.shr_u
                i32.const 4
                i32.and
                tee_local 3
                get_local 0
                i32.or
                get_local 4
                get_local 3
                i32.shl
                tee_local 0
                i32.const 245760
                i32.add
                i32.const 16
                i32.shr_u
                i32.const 2
                i32.and
                tee_local 4
                i32.or
                i32.sub
                get_local 0
                get_local 4
                i32.shl
                i32.const 15
                i32.shr_u
                i32.add
                tee_local 0
                i32.const 7
                i32.add
                i32.shr_u
                i32.const 1
                i32.and
                get_local 0
                i32.const 1
                i32.shl
                i32.or
                set_local 0
                br 3 (;@3;)
              end
              i32.const 0
              get_local 5
              get_local 4
              i32.or
              i32.store offset=1048576
              get_local 0
              set_local 4
            end
            get_local 4
            get_local 8
            i32.store offset=12
            get_local 0
            get_local 8
            i32.store offset=8
            get_local 8
            get_local 0
            i32.store offset=12
            get_local 8
            get_local 4
            i32.store offset=8
            br 2 (;@2;)
          end
          i32.const 0
          set_local 0
        end
        get_local 8
        get_local 0
        i32.store offset=28
        get_local 8
        i64.const 0
        i64.store offset=16 align=4
        get_local 0
        i32.const 2
        i32.shl
        i32.const 1048880
        i32.add
        set_local 4
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              get_local 7
              i32.const 1
              get_local 0
              i32.shl
              tee_local 3
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              get_local 5
              i32.const 0
              i32.const 25
              get_local 0
              i32.const 1
              i32.shr_u
              i32.sub
              get_local 0
              i32.const 31
              i32.eq
              select
              i32.shl
              set_local 0
              get_local 4
              i32.load
              set_local 3
              loop  ;; label = @6
                get_local 3
                tee_local 4
                i32.load offset=4
                i32.const -8
                i32.and
                get_local 5
                i32.eq
                br_if 3 (;@3;)
                get_local 0
                i32.const 29
                i32.shr_u
                set_local 3
                get_local 0
                i32.const 1
                i32.shl
                set_local 0
                get_local 4
                get_local 3
                i32.const 4
                i32.and
                i32.add
                i32.const 16
                i32.add
                tee_local 6
                i32.load
                tee_local 3
                br_if 0 (;@6;)
              end
              get_local 6
              get_local 8
              i32.store
              get_local 8
              get_local 4
              i32.store offset=24
              br 1 (;@4;)
            end
            get_local 4
            get_local 8
            i32.store
            i32.const 0
            get_local 7
            get_local 3
            i32.or
            i32.store offset=1048580
            get_local 8
            get_local 4
            i32.store offset=24
          end
          get_local 8
          get_local 8
          i32.store offset=12
          get_local 8
          get_local 8
          i32.store offset=8
          br 1 (;@2;)
        end
        get_local 4
        i32.load offset=8
        tee_local 0
        get_local 8
        i32.store offset=12
        get_local 4
        get_local 8
        i32.store offset=8
        get_local 8
        i32.const 0
        i32.store offset=24
        get_local 8
        get_local 4
        i32.store offset=12
        get_local 8
        get_local 0
        i32.store offset=8
      end
      get_local 9
      i32.const 8
      i32.add
      set_local 0
    end
    get_local 1
    i32.const 16
    i32.add
    set_global 0
    get_local 0)
  (func (;14;) (type 2) (param i32)
    get_local 0
    call 15)
  (func (;15;) (type 2) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.eqz
        br_if 0 (;@2;)
        get_local 0
        i32.const -8
        i32.add
        tee_local 1
        get_local 0
        i32.const -4
        i32.add
        i32.load
        tee_local 2
        i32.const -8
        i32.and
        tee_local 0
        i32.add
        set_local 3
        block  ;; label = @3
          block  ;; label = @4
            get_local 2
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            get_local 2
            i32.const 3
            i32.and
            i32.eqz
            br_if 2 (;@2;)
            get_local 1
            get_local 1
            i32.load
            tee_local 2
            i32.sub
            tee_local 1
            i32.const 0
            i32.load offset=1048592
            i32.lt_u
            br_if 2 (;@2;)
            get_local 2
            get_local 0
            i32.add
            set_local 0
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      i32.const 0
                      i32.load offset=1048596
                      get_local 1
                      i32.eq
                      br_if 0 (;@9;)
                      get_local 2
                      i32.const 255
                      i32.gt_u
                      br_if 1 (;@8;)
                      get_local 1
                      i32.load offset=12
                      tee_local 4
                      get_local 1
                      i32.load offset=8
                      tee_local 5
                      i32.eq
                      br_if 2 (;@7;)
                      get_local 4
                      get_local 5
                      i32.store offset=8
                      get_local 5
                      get_local 4
                      i32.store offset=12
                      get_local 1
                      get_local 3
                      i32.lt_u
                      br_if 6 (;@3;)
                      br 7 (;@2;)
                    end
                    get_local 3
                    i32.load offset=4
                    tee_local 2
                    i32.const 3
                    i32.and
                    i32.const 3
                    i32.ne
                    br_if 4 (;@4;)
                    get_local 3
                    i32.const 4
                    i32.add
                    get_local 2
                    i32.const -2
                    i32.and
                    i32.store
                    i32.const 0
                    get_local 0
                    i32.store offset=1048584
                    get_local 1
                    get_local 0
                    i32.add
                    get_local 0
                    i32.store
                    get_local 1
                    get_local 0
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    return
                  end
                  get_local 1
                  i32.load offset=24
                  set_local 6
                  get_local 1
                  i32.load offset=12
                  tee_local 5
                  get_local 1
                  i32.eq
                  br_if 1 (;@6;)
                  get_local 1
                  i32.load offset=8
                  tee_local 2
                  get_local 5
                  i32.store offset=12
                  get_local 5
                  get_local 2
                  i32.store offset=8
                  get_local 6
                  br_if 2 (;@5;)
                  br 3 (;@4;)
                end
                i32.const 0
                i32.const 0
                i32.load offset=1048576
                i32.const -2
                get_local 2
                i32.const 3
                i32.shr_u
                i32.rotl
                i32.and
                i32.store offset=1048576
                get_local 1
                get_local 3
                i32.lt_u
                br_if 3 (;@3;)
                br 4 (;@2;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.const 20
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  br_if 0 (;@7;)
                  get_local 1
                  i32.const 16
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  i32.eqz
                  br_if 1 (;@6;)
                end
                loop  ;; label = @7
                  get_local 2
                  set_local 7
                  get_local 4
                  tee_local 5
                  i32.const 20
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  br_if 0 (;@7;)
                  get_local 5
                  i32.const 16
                  i32.add
                  set_local 2
                  get_local 5
                  i32.load offset=16
                  tee_local 4
                  br_if 0 (;@7;)
                end
                get_local 7
                i32.const 0
                i32.store
                get_local 6
                i32.eqz
                br_if 2 (;@4;)
                br 1 (;@5;)
              end
              i32.const 0
              set_local 5
              get_local 6
              i32.eqz
              br_if 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 1
                  i32.load offset=28
                  tee_local 4
                  i32.const 2
                  i32.shl
                  i32.const 1048880
                  i32.add
                  tee_local 2
                  i32.load
                  get_local 1
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 6
                  i32.const 16
                  i32.const 20
                  get_local 6
                  i32.load offset=16
                  get_local 1
                  i32.eq
                  select
                  i32.add
                  get_local 5
                  i32.store
                  get_local 5
                  br_if 1 (;@6;)
                  br 3 (;@4;)
                end
                get_local 2
                get_local 5
                i32.store
                get_local 5
                i32.eqz
                br_if 1 (;@5;)
              end
              get_local 5
              get_local 6
              i32.store offset=24
              block  ;; label = @6
                get_local 1
                i32.load offset=16
                tee_local 2
                i32.eqz
                br_if 0 (;@6;)
                get_local 5
                get_local 2
                i32.store offset=16
                get_local 2
                get_local 5
                i32.store offset=24
              end
              get_local 1
              i32.const 20
              i32.add
              i32.load
              tee_local 2
              i32.eqz
              br_if 1 (;@4;)
              get_local 5
              i32.const 20
              i32.add
              get_local 2
              i32.store
              get_local 2
              get_local 5
              i32.store offset=24
              get_local 1
              get_local 3
              i32.lt_u
              br_if 2 (;@3;)
              br 3 (;@2;)
            end
            i32.const 0
            i32.const 0
            i32.load offset=1048580
            i32.const -2
            get_local 4
            i32.rotl
            i32.and
            i32.store offset=1048580
          end
          get_local 1
          get_local 3
          i32.ge_u
          br_if 1 (;@2;)
        end
        get_local 3
        i32.load offset=4
        tee_local 2
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          get_local 2
                          i32.const 2
                          i32.and
                          br_if 0 (;@11;)
                          i32.const 0
                          i32.load offset=1048600
                          get_local 3
                          i32.eq
                          br_if 1 (;@10;)
                          i32.const 0
                          i32.load offset=1048596
                          get_local 3
                          i32.eq
                          br_if 2 (;@9;)
                          get_local 2
                          i32.const -8
                          i32.and
                          get_local 0
                          i32.add
                          set_local 0
                          get_local 2
                          i32.const 255
                          i32.gt_u
                          br_if 3 (;@8;)
                          get_local 3
                          i32.load offset=12
                          tee_local 4
                          get_local 3
                          i32.load offset=8
                          tee_local 5
                          i32.eq
                          br_if 4 (;@7;)
                          get_local 4
                          get_local 5
                          i32.store offset=8
                          get_local 5
                          get_local 4
                          i32.store offset=12
                          br 7 (;@4;)
                        end
                        get_local 3
                        i32.const 4
                        i32.add
                        get_local 2
                        i32.const -2
                        i32.and
                        i32.store
                        get_local 1
                        get_local 0
                        i32.add
                        get_local 0
                        i32.store
                        get_local 1
                        get_local 0
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        br 7 (;@3;)
                      end
                      i32.const 0
                      get_local 1
                      i32.store offset=1048600
                      i32.const 0
                      i32.const 0
                      i32.load offset=1048588
                      get_local 0
                      i32.add
                      tee_local 0
                      i32.store offset=1048588
                      get_local 1
                      get_local 0
                      i32.const 1
                      i32.or
                      i32.store offset=4
                      get_local 1
                      i32.const 0
                      i32.load offset=1048596
                      i32.ne
                      br_if 7 (;@2;)
                      i32.const 0
                      i32.const 0
                      i32.store offset=1048584
                      i32.const 0
                      i32.const 0
                      i32.store offset=1048596
                      return
                    end
                    i32.const 0
                    get_local 1
                    i32.store offset=1048596
                    i32.const 0
                    i32.const 0
                    i32.load offset=1048584
                    get_local 0
                    i32.add
                    tee_local 0
                    i32.store offset=1048584
                    get_local 1
                    get_local 0
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    get_local 1
                    get_local 0
                    i32.add
                    get_local 0
                    i32.store
                    return
                  end
                  get_local 3
                  i32.load offset=24
                  set_local 6
                  get_local 3
                  i32.load offset=12
                  tee_local 5
                  get_local 3
                  i32.eq
                  br_if 1 (;@6;)
                  get_local 3
                  i32.load offset=8
                  tee_local 2
                  get_local 5
                  i32.store offset=12
                  get_local 5
                  get_local 2
                  i32.store offset=8
                  get_local 6
                  br_if 2 (;@5;)
                  br 3 (;@4;)
                end
                i32.const 0
                i32.const 0
                i32.load offset=1048576
                i32.const -2
                get_local 2
                i32.const 3
                i32.shr_u
                i32.rotl
                i32.and
                i32.store offset=1048576
                br 2 (;@4;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  get_local 3
                  i32.const 20
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  br_if 0 (;@7;)
                  get_local 3
                  i32.const 16
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  i32.eqz
                  br_if 1 (;@6;)
                end
                loop  ;; label = @7
                  get_local 2
                  set_local 7
                  get_local 4
                  tee_local 5
                  i32.const 20
                  i32.add
                  tee_local 2
                  i32.load
                  tee_local 4
                  br_if 0 (;@7;)
                  get_local 5
                  i32.const 16
                  i32.add
                  set_local 2
                  get_local 5
                  i32.load offset=16
                  tee_local 4
                  br_if 0 (;@7;)
                end
                get_local 7
                i32.const 0
                i32.store
                get_local 6
                i32.eqz
                br_if 2 (;@4;)
                br 1 (;@5;)
              end
              i32.const 0
              set_local 5
              get_local 6
              i32.eqz
              br_if 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 3
                  i32.load offset=28
                  tee_local 4
                  i32.const 2
                  i32.shl
                  i32.const 1048880
                  i32.add
                  tee_local 2
                  i32.load
                  get_local 3
                  i32.eq
                  br_if 0 (;@7;)
                  get_local 6
                  i32.const 16
                  i32.const 20
                  get_local 6
                  i32.load offset=16
                  get_local 3
                  i32.eq
                  select
                  i32.add
                  get_local 5
                  i32.store
                  get_local 5
                  br_if 1 (;@6;)
                  br 3 (;@4;)
                end
                get_local 2
                get_local 5
                i32.store
                get_local 5
                i32.eqz
                br_if 1 (;@5;)
              end
              get_local 5
              get_local 6
              i32.store offset=24
              block  ;; label = @6
                get_local 3
                i32.load offset=16
                tee_local 2
                i32.eqz
                br_if 0 (;@6;)
                get_local 5
                get_local 2
                i32.store offset=16
                get_local 2
                get_local 5
                i32.store offset=24
              end
              get_local 3
              i32.const 20
              i32.add
              i32.load
              tee_local 2
              i32.eqz
              br_if 1 (;@4;)
              get_local 5
              i32.const 20
              i32.add
              get_local 2
              i32.store
              get_local 2
              get_local 5
              i32.store offset=24
              br 1 (;@4;)
            end
            i32.const 0
            i32.const 0
            i32.load offset=1048580
            i32.const -2
            get_local 4
            i32.rotl
            i32.and
            i32.store offset=1048580
          end
          get_local 1
          get_local 0
          i32.add
          get_local 0
          i32.store
          get_local 1
          get_local 0
          i32.const 1
          i32.or
          i32.store offset=4
          get_local 1
          i32.const 0
          i32.load offset=1048596
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          get_local 0
          i32.store offset=1048584
          return
        end
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      get_local 0
                      i32.const 255
                      i32.gt_u
                      br_if 0 (;@9;)
                      get_local 0
                      i32.const 3
                      i32.shr_u
                      tee_local 2
                      i32.const 3
                      i32.shl
                      i32.const 1048616
                      i32.add
                      set_local 0
                      i32.const 0
                      i32.load offset=1048576
                      tee_local 4
                      i32.const 1
                      get_local 2
                      i32.shl
                      tee_local 2
                      i32.and
                      i32.eqz
                      br_if 1 (;@8;)
                      get_local 0
                      i32.load offset=8
                      set_local 2
                      br 2 (;@7;)
                    end
                    i32.const 0
                    set_local 2
                    block  ;; label = @9
                      get_local 0
                      i32.const 8
                      i32.shr_u
                      tee_local 4
                      i32.eqz
                      br_if 0 (;@9;)
                      i32.const 31
                      set_local 2
                      get_local 0
                      i32.const 16777215
                      i32.gt_u
                      br_if 0 (;@9;)
                      get_local 0
                      i32.const 14
                      get_local 4
                      get_local 4
                      i32.const 1048320
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 8
                      i32.and
                      tee_local 2
                      i32.shl
                      tee_local 4
                      i32.const 520192
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 4
                      i32.and
                      tee_local 5
                      get_local 2
                      i32.or
                      get_local 4
                      get_local 5
                      i32.shl
                      tee_local 2
                      i32.const 245760
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 2
                      i32.and
                      tee_local 4
                      i32.or
                      i32.sub
                      get_local 2
                      get_local 4
                      i32.shl
                      i32.const 15
                      i32.shr_u
                      i32.add
                      tee_local 2
                      i32.const 7
                      i32.add
                      i32.shr_u
                      i32.const 1
                      i32.and
                      get_local 2
                      i32.const 1
                      i32.shl
                      i32.or
                      set_local 2
                    end
                    get_local 1
                    i64.const 0
                    i64.store offset=16 align=4
                    get_local 1
                    i32.const 28
                    i32.add
                    get_local 2
                    i32.store
                    get_local 2
                    i32.const 2
                    i32.shl
                    i32.const 1048880
                    i32.add
                    set_local 4
                    i32.const 0
                    i32.load offset=1048580
                    tee_local 5
                    i32.const 1
                    get_local 2
                    i32.shl
                    tee_local 3
                    i32.and
                    i32.eqz
                    br_if 2 (;@6;)
                    get_local 0
                    i32.const 0
                    i32.const 25
                    get_local 2
                    i32.const 1
                    i32.shr_u
                    i32.sub
                    get_local 2
                    i32.const 31
                    i32.eq
                    select
                    i32.shl
                    set_local 2
                    get_local 4
                    i32.load
                    set_local 5
                    loop  ;; label = @9
                      get_local 5
                      tee_local 4
                      i32.load offset=4
                      i32.const -8
                      i32.and
                      get_local 0
                      i32.eq
                      br_if 5 (;@4;)
                      get_local 2
                      i32.const 29
                      i32.shr_u
                      set_local 5
                      get_local 2
                      i32.const 1
                      i32.shl
                      set_local 2
                      get_local 4
                      get_local 5
                      i32.const 4
                      i32.and
                      i32.add
                      i32.const 16
                      i32.add
                      tee_local 3
                      i32.load
                      tee_local 5
                      br_if 0 (;@9;)
                    end
                    get_local 3
                    get_local 1
                    i32.store
                    get_local 1
                    i32.const 24
                    i32.add
                    get_local 4
                    i32.store
                    br 3 (;@5;)
                  end
                  i32.const 0
                  get_local 4
                  get_local 2
                  i32.or
                  i32.store offset=1048576
                  get_local 0
                  set_local 2
                end
                get_local 2
                get_local 1
                i32.store offset=12
                get_local 0
                get_local 1
                i32.store offset=8
                get_local 1
                get_local 0
                i32.store offset=12
                get_local 1
                get_local 2
                i32.store offset=8
                return
              end
              get_local 4
              get_local 1
              i32.store
              i32.const 0
              get_local 5
              get_local 3
              i32.or
              i32.store offset=1048580
              get_local 1
              i32.const 24
              i32.add
              get_local 4
              i32.store
            end
            get_local 1
            get_local 1
            i32.store offset=12
            get_local 1
            get_local 1
            i32.store offset=8
            br 1 (;@3;)
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
          i32.const 24
          i32.add
          i32.const 0
          i32.store
          get_local 1
          get_local 4
          i32.store offset=12
          get_local 1
          get_local 0
          i32.store offset=8
        end
        i32.const 0
        i32.const 0
        i32.load offset=1048608
        i32.const -1
        i32.add
        tee_local 1
        i32.store offset=1048608
        get_local 1
        i32.eqz
        br_if 1 (;@1;)
      end
      return
    end
    i32.const 1049032
    set_local 1
    loop  ;; label = @1
      get_local 1
      i32.load
      tee_local 0
      i32.const 8
      i32.add
      set_local 1
      get_local 0
      br_if 0 (;@1;)
    end
    i32.const 0
    i32.const -1
    i32.store offset=1048608)
  (func (;16;) (type 0) (param i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 0
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          get_local 0
          i32.mul
          set_local 2
          block  ;; label = @4
            get_local 1
            get_local 0
            i32.or
            i32.const 65536
            i32.lt_u
            br_if 0 (;@4;)
            get_local 2
            i32.const -1
            get_local 2
            get_local 0
            i32.div_u
            get_local 1
            i32.eq
            select
            set_local 2
          end
          get_local 2
          call 13
          tee_local 0
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        i32.const 0
        set_local 2
        i32.const 0
        call 13
        tee_local 0
        i32.eqz
        br_if 1 (;@1;)
      end
      get_local 0
      i32.const -4
      i32.add
      i32.load8_u
      i32.const 3
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.const 0
      get_local 2
      call 27
      drop
    end
    get_local 0)
  (func (;17;) (type 2) (param i32)
    get_local 0
    call 6
    unreachable)
  (func (;18;) (type 2) (param i32)
    (local i32 i32)
    block  ;; label = @1
      get_local 0
      i32.load
      i32.const 0
      i32.le_s
      br_if 0 (;@1;)
      get_local 0
      i32.load offset=12
      tee_local 1
      get_local 0
      i32.load offset=8
      tee_local 2
      i32.gt_u
      br_if 0 (;@1;)
      get_local 0
      i32.load offset=4
      set_local 0
      block  ;; label = @2
        get_local 2
        i32.eqz
        br_if 0 (;@2;)
        get_local 0
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        get_local 1
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        set_local 2
        loop  ;; label = @3
          get_local 0
          i32.load
          i32.eqz
          br_if 2 (;@1;)
          get_local 0
          i32.const 4
          i32.add
          i32.load
          i32.const -1
          i32.le_s
          br_if 2 (;@1;)
          get_local 0
          i32.const 24
          i32.add
          set_local 0
          get_local 2
          i32.const 1
          i32.add
          tee_local 2
          get_local 1
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      return
    end
    call 22
    unreachable)
  (func (;19;) (type 3)
    (local i32 i32)
    block  ;; label = @1
      i32.const 16
      call 12
      tee_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      i32.const 24
      i32.const 4
      call 16
      tee_local 1
      i32.store offset=4
      block  ;; label = @2
        get_local 1
        i32.eqz
        br_if 0 (;@2;)
        get_local 0
        i64.const 4
        i64.store offset=8 align=4
        get_local 0
        i32.const 1
        i32.store
        get_local 0
        call 18
        i32.const 0
        get_local 0
        i32.store offset=1049076
        get_local 0
        call 18
        return
      end
      get_local 0
      call 14
    end
    i32.const 0
    i32.const 0
    i32.store offset=1049076
    unreachable
    unreachable)
  (func (;20;) (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    get_global 0
    i32.const 32
    i32.sub
    tee_local 2
    set_global 0
    i32.const 0
    i32.load offset=1049076
    call 18
    i32.const -1
    set_local 3
    block  ;; label = @1
      get_local 1
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      i32.load offset=1049076
      tee_local 4
      call 18
      get_local 0
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          get_local 4
          i32.load offset=12
          tee_local 5
          get_local 4
          i32.load offset=8
          i32.ne
          br_if 0 (;@3;)
          i32.const 24
          get_local 5
          i32.const 1
          i32.shl
          call 16
          tee_local 6
          i32.eqz
          br_if 2 (;@1;)
          get_local 6
          get_local 4
          i32.load offset=4
          get_local 4
          i32.const 12
          i32.add
          tee_local 5
          i32.load
          i32.const 24
          i32.mul
          call 26
          drop
          get_local 4
          i32.load offset=4
          call 14
          get_local 4
          get_local 6
          i32.store offset=4
          get_local 4
          i32.const 8
          i32.add
          tee_local 7
          get_local 7
          i32.load
          i32.const 1
          i32.shl
          i32.store
          get_local 5
          i32.load
          set_local 5
          br 1 (;@2;)
        end
        get_local 4
        i32.load offset=4
        set_local 6
      end
      get_local 4
      i32.const 12
      i32.add
      get_local 5
      i32.const 1
      i32.add
      i32.store
      get_local 1
      call 25
      set_local 7
      get_local 6
      get_local 5
      i32.const 24
      i32.mul
      i32.add
      tee_local 1
      get_local 0
      i32.store offset=4
      get_local 1
      get_local 7
      i32.store
      block  ;; label = @2
        get_local 0
        get_local 2
        i32.const 8
        i32.add
        call 7
        tee_local 0
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        get_local 0
        i32.store offset=1049072
        br 1 (;@1;)
      end
      get_local 1
      get_local 2
      i64.load offset=16
      i64.store offset=8
      get_local 1
      get_local 2
      i64.load offset=24
      i64.store offset=16
      get_local 4
      call 18
      get_local 4
      call 18
      i32.const 0
      set_local 3
      i32.const 0
      get_local 4
      i32.store offset=1049076
    end
    get_local 2
    i32.const 32
    i32.add
    set_global 0
    get_local 3)
  (func (;21;) (type 4) (param i32) (result i32)
    block  ;; label = @1
      get_local 0
      i32.const 65535
      i32.and
      br_if 0 (;@1;)
      get_local 0
      i32.const -1
      i32.le_s
      br_if 0 (;@1;)
      block  ;; label = @2
        get_local 0
        i32.const 16
        i32.shr_u
        memory.grow
        tee_local 0
        i32.const -1
        i32.eq
        br_if 0 (;@2;)
        get_local 0
        i32.const 16
        i32.shl
        return
      end
      i32.const 0
      i32.const 48
      i32.store offset=1049072
      i32.const -1
      return
    end
    call 22
    unreachable)
  (func (;22;) (type 3)
    unreachable
    unreachable)
  (func (;23;) (type 3))
  (func (;24;) (type 3)
    call 23
    call 23)
  (func (;25;) (type 4) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      get_local 0
      call 28
      i32.const 1
      i32.add
      tee_local 1
      call 12
      tee_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 2
      get_local 0
      get_local 1
      call 26
      return
    end
    i32.const 0)
  (func (;26;) (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 2
            i32.eqz
            br_if 0 (;@4;)
            get_local 1
            i32.const 3
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            get_local 0
            set_local 3
            block  ;; label = @5
              loop  ;; label = @6
                get_local 3
                get_local 1
                i32.load8_u
                i32.store8
                get_local 2
                i32.const -1
                i32.add
                set_local 4
                get_local 3
                i32.const 1
                i32.add
                set_local 3
                get_local 1
                i32.const 1
                i32.add
                set_local 1
                get_local 2
                i32.const 1
                i32.eq
                br_if 1 (;@5;)
                get_local 4
                set_local 2
                get_local 1
                i32.const 3
                i32.and
                br_if 0 (;@6;)
              end
            end
            get_local 3
            i32.const 3
            i32.and
            tee_local 2
            i32.eqz
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          get_local 2
          set_local 4
          get_local 0
          tee_local 3
          i32.const 3
          i32.and
          tee_local 2
          br_if 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            get_local 4
            i32.const 16
            i32.lt_u
            br_if 0 (;@4;)
            get_local 4
            i32.const -16
            i32.add
            set_local 2
            loop  ;; label = @5
              get_local 3
              get_local 1
              i32.load
              i32.store
              get_local 3
              i32.const 4
              i32.add
              get_local 1
              i32.const 4
              i32.add
              i32.load
              i32.store
              get_local 3
              i32.const 8
              i32.add
              get_local 1
              i32.const 8
              i32.add
              i32.load
              i32.store
              get_local 3
              i32.const 12
              i32.add
              get_local 1
              i32.const 12
              i32.add
              i32.load
              i32.store
              get_local 3
              i32.const 16
              i32.add
              set_local 3
              get_local 1
              i32.const 16
              i32.add
              set_local 1
              get_local 4
              i32.const -16
              i32.add
              tee_local 4
              i32.const 15
              i32.gt_u
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          get_local 4
          set_local 2
        end
        block  ;; label = @3
          get_local 2
          i32.const 8
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          get_local 3
          get_local 1
          i64.load align=4
          i64.store align=4
          get_local 1
          i32.const 8
          i32.add
          set_local 1
          get_local 3
          i32.const 8
          i32.add
          set_local 3
        end
        block  ;; label = @3
          get_local 2
          i32.const 4
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          get_local 3
          get_local 1
          i32.load
          i32.store
          get_local 1
          i32.const 4
          i32.add
          set_local 1
          get_local 3
          i32.const 4
          i32.add
          set_local 3
        end
        block  ;; label = @3
          get_local 2
          i32.const 2
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          get_local 3
          get_local 1
          i32.load8_u
          i32.store8
          get_local 3
          get_local 1
          i32.load8_u offset=1
          i32.store8 offset=1
          get_local 3
          i32.const 2
          i32.add
          set_local 3
          get_local 1
          i32.const 2
          i32.add
          set_local 1
        end
        get_local 2
        i32.const 1
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        get_local 3
        get_local 1
        i32.load8_u
        i32.store8
        get_local 0
        return
      end
      block  ;; label = @2
        get_local 4
        i32.const 32
        i32.lt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            get_local 2
            i32.const 3
            i32.eq
            br_if 0 (;@4;)
            get_local 2
            i32.const 2
            i32.eq
            br_if 1 (;@3;)
            get_local 2
            i32.const 1
            i32.ne
            br_if 2 (;@2;)
            get_local 3
            get_local 1
            i32.load8_u offset=1
            i32.store8 offset=1
            get_local 3
            get_local 1
            i32.load
            tee_local 5
            i32.store8
            get_local 3
            get_local 1
            i32.load8_u offset=2
            i32.store8 offset=2
            get_local 4
            i32.const -3
            i32.add
            set_local 6
            get_local 3
            i32.const 3
            i32.add
            set_local 7
            get_local 4
            i32.const -20
            i32.add
            i32.const -16
            i32.and
            set_local 8
            i32.const 0
            set_local 2
            loop  ;; label = @5
              get_local 7
              get_local 2
              i32.add
              tee_local 3
              get_local 1
              get_local 2
              i32.add
              tee_local 9
              i32.const 4
              i32.add
              i32.load
              tee_local 10
              i32.const 8
              i32.shl
              get_local 5
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              get_local 3
              i32.const 4
              i32.add
              get_local 9
              i32.const 8
              i32.add
              i32.load
              tee_local 5
              i32.const 8
              i32.shl
              get_local 10
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              get_local 3
              i32.const 8
              i32.add
              get_local 9
              i32.const 12
              i32.add
              i32.load
              tee_local 10
              i32.const 8
              i32.shl
              get_local 5
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              get_local 3
              i32.const 12
              i32.add
              get_local 9
              i32.const 16
              i32.add
              i32.load
              tee_local 5
              i32.const 8
              i32.shl
              get_local 10
              i32.const 24
              i32.shr_u
              i32.or
              i32.store
              get_local 2
              i32.const 16
              i32.add
              set_local 2
              get_local 6
              i32.const -16
              i32.add
              tee_local 6
              i32.const 16
              i32.gt_u
              br_if 0 (;@5;)
            end
            get_local 7
            get_local 2
            i32.add
            set_local 3
            get_local 1
            get_local 2
            i32.add
            i32.const 3
            i32.add
            set_local 1
            get_local 4
            i32.const -19
            i32.add
            get_local 8
            i32.sub
            set_local 4
            br 2 (;@2;)
          end
          get_local 3
          get_local 1
          i32.load
          tee_local 5
          i32.store8
          get_local 4
          i32.const -1
          i32.add
          set_local 6
          get_local 3
          i32.const 1
          i32.add
          set_local 7
          get_local 4
          i32.const -20
          i32.add
          i32.const -16
          i32.and
          set_local 8
          i32.const 0
          set_local 2
          loop  ;; label = @4
            get_local 7
            get_local 2
            i32.add
            tee_local 3
            get_local 1
            get_local 2
            i32.add
            tee_local 9
            i32.const 4
            i32.add
            i32.load
            tee_local 10
            i32.const 24
            i32.shl
            get_local 5
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            get_local 3
            i32.const 4
            i32.add
            get_local 9
            i32.const 8
            i32.add
            i32.load
            tee_local 5
            i32.const 24
            i32.shl
            get_local 10
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            get_local 3
            i32.const 8
            i32.add
            get_local 9
            i32.const 12
            i32.add
            i32.load
            tee_local 10
            i32.const 24
            i32.shl
            get_local 5
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            get_local 3
            i32.const 12
            i32.add
            get_local 9
            i32.const 16
            i32.add
            i32.load
            tee_local 5
            i32.const 24
            i32.shl
            get_local 10
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            get_local 2
            i32.const 16
            i32.add
            set_local 2
            get_local 6
            i32.const -16
            i32.add
            tee_local 6
            i32.const 18
            i32.gt_u
            br_if 0 (;@4;)
          end
          get_local 7
          get_local 2
          i32.add
          set_local 3
          get_local 1
          get_local 2
          i32.add
          i32.const 1
          i32.add
          set_local 1
          get_local 4
          i32.const -17
          i32.add
          get_local 8
          i32.sub
          set_local 4
          br 1 (;@2;)
        end
        get_local 3
        get_local 1
        i32.load
        tee_local 5
        i32.store8
        get_local 3
        get_local 1
        i32.load8_u offset=1
        i32.store8 offset=1
        get_local 4
        i32.const -2
        i32.add
        set_local 6
        get_local 3
        i32.const 2
        i32.add
        set_local 7
        get_local 4
        i32.const -20
        i32.add
        i32.const -16
        i32.and
        set_local 8
        i32.const 0
        set_local 2
        loop  ;; label = @3
          get_local 7
          get_local 2
          i32.add
          tee_local 3
          get_local 1
          get_local 2
          i32.add
          tee_local 9
          i32.const 4
          i32.add
          i32.load
          tee_local 10
          i32.const 16
          i32.shl
          get_local 5
          i32.const 16
          i32.shr_u
          i32.or
          i32.store
          get_local 3
          i32.const 4
          i32.add
          get_local 9
          i32.const 8
          i32.add
          i32.load
          tee_local 5
          i32.const 16
          i32.shl
          get_local 10
          i32.const 16
          i32.shr_u
          i32.or
          i32.store
          get_local 3
          i32.const 8
          i32.add
          get_local 9
          i32.const 12
          i32.add
          i32.load
          tee_local 10
          i32.const 16
          i32.shl
          get_local 5
          i32.const 16
          i32.shr_u
          i32.or
          i32.store
          get_local 3
          i32.const 12
          i32.add
          get_local 9
          i32.const 16
          i32.add
          i32.load
          tee_local 5
          i32.const 16
          i32.shl
          get_local 10
          i32.const 16
          i32.shr_u
          i32.or
          i32.store
          get_local 2
          i32.const 16
          i32.add
          set_local 2
          get_local 6
          i32.const -16
          i32.add
          tee_local 6
          i32.const 17
          i32.gt_u
          br_if 0 (;@3;)
        end
        get_local 7
        get_local 2
        i32.add
        set_local 3
        get_local 1
        get_local 2
        i32.add
        i32.const 2
        i32.add
        set_local 1
        get_local 4
        i32.const -18
        i32.add
        get_local 8
        i32.sub
        set_local 4
      end
      block  ;; label = @2
        get_local 4
        i32.const 16
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        get_local 1
        i32.load16_u align=1
        i32.store16 align=1
        get_local 3
        get_local 1
        i32.load8_u offset=2
        i32.store8 offset=2
        get_local 3
        get_local 1
        i32.load8_u offset=3
        i32.store8 offset=3
        get_local 3
        get_local 1
        i32.load8_u offset=4
        i32.store8 offset=4
        get_local 3
        get_local 1
        i32.load8_u offset=5
        i32.store8 offset=5
        get_local 3
        get_local 1
        i32.load8_u offset=6
        i32.store8 offset=6
        get_local 3
        get_local 1
        i32.load8_u offset=7
        i32.store8 offset=7
        get_local 3
        get_local 1
        i32.load8_u offset=8
        i32.store8 offset=8
        get_local 3
        get_local 1
        i32.load8_u offset=9
        i32.store8 offset=9
        get_local 3
        get_local 1
        i32.load8_u offset=10
        i32.store8 offset=10
        get_local 3
        get_local 1
        i32.load8_u offset=11
        i32.store8 offset=11
        get_local 3
        get_local 1
        i32.load8_u offset=12
        i32.store8 offset=12
        get_local 3
        get_local 1
        i32.load8_u offset=13
        i32.store8 offset=13
        get_local 3
        get_local 1
        i32.load8_u offset=14
        i32.store8 offset=14
        get_local 3
        get_local 1
        i32.load8_u offset=15
        i32.store8 offset=15
        get_local 3
        i32.const 16
        i32.add
        set_local 3
        get_local 1
        i32.const 16
        i32.add
        set_local 1
      end
      block  ;; label = @2
        get_local 4
        i32.const 8
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        get_local 1
        i32.load8_u
        i32.store8
        get_local 3
        get_local 1
        i32.load8_u offset=1
        i32.store8 offset=1
        get_local 3
        get_local 1
        i32.load8_u offset=2
        i32.store8 offset=2
        get_local 3
        get_local 1
        i32.load8_u offset=3
        i32.store8 offset=3
        get_local 3
        get_local 1
        i32.load8_u offset=4
        i32.store8 offset=4
        get_local 3
        get_local 1
        i32.load8_u offset=5
        i32.store8 offset=5
        get_local 3
        get_local 1
        i32.load8_u offset=6
        i32.store8 offset=6
        get_local 3
        get_local 1
        i32.load8_u offset=7
        i32.store8 offset=7
        get_local 3
        i32.const 8
        i32.add
        set_local 3
        get_local 1
        i32.const 8
        i32.add
        set_local 1
      end
      block  ;; label = @2
        get_local 4
        i32.const 4
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        get_local 1
        i32.load8_u
        i32.store8
        get_local 3
        get_local 1
        i32.load8_u offset=1
        i32.store8 offset=1
        get_local 3
        get_local 1
        i32.load8_u offset=2
        i32.store8 offset=2
        get_local 3
        get_local 1
        i32.load8_u offset=3
        i32.store8 offset=3
        get_local 3
        i32.const 4
        i32.add
        set_local 3
        get_local 1
        i32.const 4
        i32.add
        set_local 1
      end
      block  ;; label = @2
        get_local 4
        i32.const 2
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        get_local 3
        get_local 1
        i32.load8_u
        i32.store8
        get_local 3
        get_local 1
        i32.load8_u offset=1
        i32.store8 offset=1
        get_local 3
        i32.const 2
        i32.add
        set_local 3
        get_local 1
        i32.const 2
        i32.add
        set_local 1
      end
      get_local 4
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      get_local 3
      get_local 1
      i32.load8_u
      i32.store8
    end
    get_local 0)
  (func (;27;) (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64)
    block  ;; label = @1
      get_local 2
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      i32.store8
      get_local 0
      get_local 2
      i32.add
      tee_local 3
      i32.const -1
      i32.add
      get_local 1
      i32.store8
      get_local 2
      i32.const 3
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      i32.store8 offset=2
      get_local 0
      get_local 1
      i32.store8 offset=1
      get_local 3
      i32.const -3
      i32.add
      get_local 1
      i32.store8
      get_local 3
      i32.const -2
      i32.add
      get_local 1
      i32.store8
      get_local 2
      i32.const 7
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      get_local 1
      i32.store8 offset=3
      get_local 3
      i32.const -4
      i32.add
      get_local 1
      i32.store8
      get_local 2
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 0
      get_local 0
      i32.sub
      i32.const 3
      i32.and
      tee_local 4
      i32.add
      tee_local 3
      get_local 1
      i32.const 255
      i32.and
      i32.const 16843009
      i32.mul
      tee_local 1
      i32.store
      get_local 3
      get_local 2
      get_local 4
      i32.sub
      i32.const -4
      i32.and
      tee_local 4
      i32.add
      tee_local 2
      i32.const -4
      i32.add
      get_local 1
      i32.store
      get_local 4
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      get_local 3
      get_local 1
      i32.store offset=8
      get_local 3
      get_local 1
      i32.store offset=4
      get_local 2
      i32.const -8
      i32.add
      get_local 1
      i32.store
      get_local 2
      i32.const -12
      i32.add
      get_local 1
      i32.store
      get_local 4
      i32.const 25
      i32.lt_u
      br_if 0 (;@1;)
      get_local 3
      get_local 1
      i32.store offset=24
      get_local 3
      get_local 1
      i32.store offset=20
      get_local 3
      get_local 1
      i32.store offset=16
      get_local 3
      get_local 1
      i32.store offset=12
      get_local 2
      i32.const -16
      i32.add
      get_local 1
      i32.store
      get_local 2
      i32.const -20
      i32.add
      get_local 1
      i32.store
      get_local 2
      i32.const -24
      i32.add
      get_local 1
      i32.store
      get_local 2
      i32.const -28
      i32.add
      get_local 1
      i32.store
      get_local 4
      get_local 3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      tee_local 5
      i32.sub
      tee_local 2
      i32.const 32
      i32.lt_u
      br_if 0 (;@1;)
      get_local 1
      i64.extend_u/i32
      tee_local 6
      i64.const 32
      i64.shl
      get_local 6
      i64.or
      set_local 6
      get_local 3
      get_local 5
      i32.add
      set_local 1
      loop  ;; label = @2
        get_local 1
        get_local 6
        i64.store
        get_local 1
        i32.const 24
        i32.add
        get_local 6
        i64.store
        get_local 1
        i32.const 16
        i32.add
        get_local 6
        i64.store
        get_local 1
        i32.const 8
        i32.add
        get_local 6
        i64.store
        get_local 1
        i32.const 32
        i32.add
        set_local 1
        get_local 2
        i32.const -32
        i32.add
        tee_local 2
        i32.const 31
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    get_local 0)
  (func (;28;) (type 4) (param i32) (result i32)
    (local i32 i32 i32)
    get_local 0
    set_local 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          get_local 0
          i32.const 3
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          get_local 0
          i32.load8_u
          i32.eqz
          br_if 1 (;@2;)
          get_local 0
          i32.const 1
          i32.add
          set_local 1
          loop  ;; label = @4
            get_local 1
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            get_local 1
            i32.load8_u
            set_local 2
            get_local 1
            i32.const 1
            i32.add
            tee_local 3
            set_local 1
            get_local 2
            br_if 0 (;@4;)
          end
          get_local 3
          i32.const -1
          i32.add
          get_local 0
          i32.sub
          return
        end
        get_local 1
        i32.const -4
        i32.add
        set_local 1
        loop  ;; label = @3
          get_local 1
          i32.const 4
          i32.add
          tee_local 1
          i32.load
          tee_local 2
          i32.const -1
          i32.xor
          get_local 2
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          i32.eqz
          br_if 0 (;@3;)
        end
        get_local 2
        i32.const 255
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        loop  ;; label = @3
          get_local 1
          i32.load8_u offset=1
          set_local 2
          get_local 1
          i32.const 1
          i32.add
          tee_local 3
          set_local 1
          get_local 2
          br_if 0 (;@3;)
        end
        get_local 3
        get_local 0
        i32.sub
        return
      end
      get_local 0
      get_local 0
      i32.sub
      return
    end
    get_local 1
    get_local 0
    i32.sub)
  (table (;0;) 1 1 anyfunc)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1049084))
  (global (;2;) i32 (i32.const 1049084))
  (export "memory" (memory 0))
  (export "__heap_base" (global 1))
  (export "__data_end" (global 2))
  (export "_start" (func 9))
  (export "main" (func 11))
  (export "add_one" (func 10))
  (data (;0;) (i32.const 1048576) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
