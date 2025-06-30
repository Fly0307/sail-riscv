/* SPMP configuration entries */

/* Reuse PmpAddrMatchType */
// enum PmpAddrMatchType = {OFF, TOR, NA4, NAPOT}

val spmpAddrMatchType_of_bits : bits(2) -> PmpAddrMatchType
function spmpAddrMatchType_of_bits(bs) = {
  match bs {
    0b00 => OFF,
    0b01 => TOR,
    0b10 => NA4,
    0b11 => NAPOT
  }
}

val spmpAddrMatchType_to_bits : PmpAddrMatchType -> bits(2)
function spmpAddrMatchType_to_bits(bs) = {
  match bs {
    OFF   => 0b00,
    TOR   => 0b01,
    NA4   => 0b10,
    NAPOT => 0b11
  }
}

bitfield Spmpcfg_ent : bits(8) = {
  S : 7,        /* S-mode */
  A : 4 .. 3,   /* address match type, encoded as above */

  /* permissions */
  X : 2,        /* execute */
  W : 1,        /* write */
  R : 0         /* read */
}

register spmp0cfg  : Spmpcfg_ent
register spmp1cfg  : Spmpcfg_ent
register spmp2cfg  : Spmpcfg_ent
register spmp3cfg  : Spmpcfg_ent
register spmp4cfg  : Spmpcfg_ent
register spmp5cfg  : Spmpcfg_ent
register spmp6cfg  : Spmpcfg_ent
register spmp7cfg  : Spmpcfg_ent
register spmp8cfg  : Spmpcfg_ent
register spmp9cfg  : Spmpcfg_ent
register spmp10cfg : Spmpcfg_ent
register spmp11cfg : Spmpcfg_ent
register spmp12cfg : Spmpcfg_ent
register spmp13cfg : Spmpcfg_ent
register spmp14cfg : Spmpcfg_ent
register spmp15cfg : Spmpcfg_ent
register spmp16cfg : Spmpcfg_ent
register spmp17cfg : Spmpcfg_ent
register spmp18cfg : Spmpcfg_ent
register spmp19cfg : Spmpcfg_ent
register spmp20cfg : Spmpcfg_ent
register spmp21cfg : Spmpcfg_ent
register spmp22cfg : Spmpcfg_ent
register spmp23cfg : Spmpcfg_ent
register spmp24cfg : Spmpcfg_ent
register spmp25cfg : Spmpcfg_ent
register spmp26cfg : Spmpcfg_ent
register spmp27cfg : Spmpcfg_ent
register spmp28cfg : Spmpcfg_ent
register spmp29cfg : Spmpcfg_ent
register spmp30cfg : Spmpcfg_ent
register spmp31cfg : Spmpcfg_ent
register spmp32cfg : Spmpcfg_ent
register spmp33cfg : Spmpcfg_ent
register spmp34cfg : Spmpcfg_ent
register spmp35cfg : Spmpcfg_ent
register spmp36cfg : Spmpcfg_ent
register spmp37cfg : Spmpcfg_ent
register spmp38cfg : Spmpcfg_ent
register spmp39cfg : Spmpcfg_ent
register spmp40cfg : Spmpcfg_ent
register spmp41cfg : Spmpcfg_ent
register spmp42cfg : Spmpcfg_ent
register spmp43cfg : Spmpcfg_ent
register spmp44cfg : Spmpcfg_ent
register spmp45cfg : Spmpcfg_ent
register spmp46cfg : Spmpcfg_ent
register spmp47cfg : Spmpcfg_ent
register spmp48cfg : Spmpcfg_ent
register spmp49cfg : Spmpcfg_ent
register spmp50cfg : Spmpcfg_ent
register spmp51cfg : Spmpcfg_ent
register spmp52cfg : Spmpcfg_ent
register spmp53cfg : Spmpcfg_ent
register spmp54cfg : Spmpcfg_ent
register spmp55cfg : Spmpcfg_ent
register spmp56cfg : Spmpcfg_ent
register spmp57cfg : Spmpcfg_ent
register spmp58cfg : Spmpcfg_ent
register spmp59cfg : Spmpcfg_ent
register spmp60cfg : Spmpcfg_ent
register spmp61cfg : Spmpcfg_ent
register spmp62cfg : Spmpcfg_ent
register spmp63cfg : Spmpcfg_ent

/* SPMP address configuration */

register spmpaddr0  : xlenbits
register spmpaddr1  : xlenbits
register spmpaddr2  : xlenbits
register spmpaddr3  : xlenbits
register spmpaddr4  : xlenbits
register spmpaddr5  : xlenbits
register spmpaddr6  : xlenbits
register spmpaddr7  : xlenbits
register spmpaddr8  : xlenbits
register spmpaddr9  : xlenbits
register spmpaddr10 : xlenbits
register spmpaddr11 : xlenbits
register spmpaddr12 : xlenbits
register spmpaddr13 : xlenbits
register spmpaddr14 : xlenbits
register spmpaddr15 : xlenbits
register spmpaddr16 : xlenbits
register spmpaddr17 : xlenbits
register spmpaddr18 : xlenbits
register spmpaddr19 : xlenbits
register spmpaddr20 : xlenbits
register spmpaddr21 : xlenbits
register spmpaddr22 : xlenbits
register spmpaddr23 : xlenbits
register spmpaddr24 : xlenbits
register spmpaddr25 : xlenbits
register spmpaddr26 : xlenbits
register spmpaddr27 : xlenbits
register spmpaddr28 : xlenbits
register spmpaddr29 : xlenbits
register spmpaddr30 : xlenbits
register spmpaddr31 : xlenbits
register spmpaddr32 : xlenbits
register spmpaddr33 : xlenbits
register spmpaddr34 : xlenbits
register spmpaddr35 : xlenbits
register spmpaddr36 : xlenbits
register spmpaddr37 : xlenbits
register spmpaddr38 : xlenbits
register spmpaddr39 : xlenbits
register spmpaddr40 : xlenbits
register spmpaddr41 : xlenbits
register spmpaddr42 : xlenbits
register spmpaddr43 : xlenbits
register spmpaddr44 : xlenbits
register spmpaddr45 : xlenbits
register spmpaddr46 : xlenbits
register spmpaddr47 : xlenbits
register spmpaddr48 : xlenbits
register spmpaddr49 : xlenbits
register spmpaddr50 : xlenbits
register spmpaddr51 : xlenbits
register spmpaddr52 : xlenbits
register spmpaddr53 : xlenbits
register spmpaddr54 : xlenbits
register spmpaddr55 : xlenbits
register spmpaddr56 : xlenbits
register spmpaddr57 : xlenbits
register spmpaddr58 : xlenbits
register spmpaddr59 : xlenbits
register spmpaddr60 : xlenbits
register spmpaddr61 : xlenbits
register spmpaddr62 : xlenbits
register spmpaddr63 : xlenbits

/* Packing and unpacking spmpcfg regs for xlen-width accesses */

val spmpReadCfgReg : forall 'n, 0 <= 'n < 16 . (atom('n)) -> xlenbits effect {rreg}
function spmpReadCfgReg(n) = {
  if   sizeof(xlen) == 32
  then match n {
         0  => append(spmp3cfg.bits(),  append(spmp2cfg.bits(),  append(spmp1cfg.bits(),  spmp0cfg.bits()))),
         1  => append(spmp7cfg.bits(),  append(spmp6cfg.bits(),  append(spmp5cfg.bits(),  spmp4cfg.bits()))),
         2  => append(spmp11cfg.bits(), append(spmp10cfg.bits(), append(spmp9cfg.bits(),  spmp8cfg.bits()))),
         3  => append(spmp15cfg.bits(), append(spmp14cfg.bits(), append(spmp13cfg.bits(), spmp12cfg.bits()))),
         4  => append(spmp19cfg.bits(), append(spmp18cfg.bits(), append(spmp17cfg.bits(), spmp16cfg.bits()))),
         5  => append(spmp23cfg.bits(), append(spmp22cfg.bits(), append(spmp21cfg.bits(), spmp20cfg.bits()))),
         6  => append(spmp27cfg.bits(), append(spmp26cfg.bits(), append(spmp25cfg.bits(), spmp24cfg.bits()))),
         7  => append(spmp31cfg.bits(), append(spmp30cfg.bits(), append(spmp29cfg.bits(), spmp28cfg.bits()))),
         8  => append(spmp35cfg.bits(), append(spmp34cfg.bits(), append(spmp33cfg.bits(), spmp32cfg.bits()))),
         9  => append(spmp39cfg.bits(), append(spmp38cfg.bits(), append(spmp37cfg.bits(), spmp36cfg.bits()))),
         10 => append(spmp43cfg.bits(), append(spmp42cfg.bits(), append(spmp41cfg.bits(), spmp40cfg.bits()))),
         11 => append(spmp47cfg.bits(), append(spmp46cfg.bits(), append(spmp45cfg.bits(), spmp44cfg.bits()))),
         12 => append(spmp51cfg.bits(), append(spmp50cfg.bits(), append(spmp49cfg.bits(), spmp48cfg.bits()))),
         13 => append(spmp55cfg.bits(), append(spmp54cfg.bits(), append(spmp53cfg.bits(), spmp52cfg.bits()))),
         14 => append(spmp59cfg.bits(), append(spmp58cfg.bits(), append(spmp57cfg.bits(), spmp56cfg.bits()))),
         15 => append(spmp63cfg.bits(), append(spmp62cfg.bits(), append(spmp61cfg.bits(), spmp60cfg.bits())))
       }
  else match n { //  sizeof(xlen) == 64
         0  => append(spmp7cfg.bits(),  append(spmp6cfg.bits(),  append(spmp5cfg.bits(),  append(spmp4cfg.bits(),  append(spmp3cfg.bits(),  append(spmp2cfg.bits(),  append(spmp1cfg.bits(),  spmp0cfg.bits()))))))),
         2  => append(spmp15cfg.bits(), append(spmp14cfg.bits(), append(spmp13cfg.bits(), append(spmp12cfg.bits(), append(spmp11cfg.bits(), append(spmp10cfg.bits(), append(spmp9cfg.bits(),  spmp8cfg.bits()))))))),
         4  => append(spmp23cfg.bits(), append(spmp22cfg.bits(), append(spmp21cfg.bits(), append(spmp20cfg.bits(), append(spmp19cfg.bits(), append(spmp18cfg.bits(), append(spmp17cfg.bits(), spmp16cfg.bits()))))))),
         6  => append(spmp31cfg.bits(), append(spmp30cfg.bits(), append(spmp29cfg.bits(), append(spmp28cfg.bits(), append(spmp27cfg.bits(), append(spmp26cfg.bits(), append(spmp25cfg.bits(), spmp24cfg.bits()))))))),
         8  => append(spmp39cfg.bits(), append(spmp38cfg.bits(), append(spmp37cfg.bits(), append(spmp36cfg.bits(), append(spmp35cfg.bits(), append(spmp34cfg.bits(), append(spmp33cfg.bits(), spmp32cfg.bits()))))))),
         10 => append(spmp47cfg.bits(), append(spmp46cfg.bits(), append(spmp45cfg.bits(), append(spmp44cfg.bits(), append(spmp43cfg.bits(), append(spmp42cfg.bits(), append(spmp41cfg.bits(), spmp40cfg.bits()))))))),
         12 => append(spmp55cfg.bits(), append(spmp54cfg.bits(), append(spmp53cfg.bits(), append(spmp52cfg.bits(), append(spmp51cfg.bits(), append(spmp50cfg.bits(), append(spmp49cfg.bits(), spmp48cfg.bits()))))))),
         14 => append(spmp63cfg.bits(), append(spmp62cfg.bits(), append(spmp61cfg.bits(), append(spmp60cfg.bits(), append(spmp59cfg.bits(), append(spmp58cfg.bits(), append(spmp57cfg.bits(), spmp56cfg.bits())))))))
       }
}

/* Helpers to handle S mode regions */
// function mpuSmodeRegion(cfg: Spmpcfg_ent) -> bool =
//    cfg.S() == 0b1

function spmpWriteCfg(cfg: Spmpcfg_ent, v: bits(8)) -> Spmpcfg_ent =
  Mk_Spmpcfg_ent(v & 0x9f)  // Bits 5 and 6 are zero.

val spmpWriteCfgReg : forall 'n, 0 <= 'n < 16 . (atom('n), xlenbits) -> unit effect {rreg, wreg}
function spmpWriteCfgReg(n, v) = {
  if   sizeof(xlen) == 32
  then match n {
         0 => { spmp0cfg   = spmpWriteCfg(spmp0cfg,  v[7 ..0]);
                spmp1cfg   = spmpWriteCfg(spmp1cfg,  v[15..8]);
                spmp2cfg   = spmpWriteCfg(spmp2cfg,  v[23..16]);
                spmp3cfg   = spmpWriteCfg(spmp3cfg,  v[31..24]);
              },
         1 => { spmp4cfg   = spmpWriteCfg(spmp4cfg,  v[7 ..0]);
                spmp5cfg   = spmpWriteCfg(spmp5cfg,  v[15..8]);
                spmp6cfg   = spmpWriteCfg(spmp6cfg,  v[23..16]);
                spmp7cfg   = spmpWriteCfg(spmp7cfg,  v[31..24]);
              },
         2 => { spmp8cfg   = spmpWriteCfg(spmp8cfg,  v[7 ..0]);
                spmp9cfg   = spmpWriteCfg(spmp9cfg,  v[15..8]);
                spmp10cfg  = spmpWriteCfg(spmp10cfg, v[23..16]);
                spmp11cfg  = spmpWriteCfg(spmp11cfg, v[31..24]);
              },
         3 => { spmp12cfg  = spmpWriteCfg(spmp12cfg, v[7 ..0]);
                spmp13cfg  = spmpWriteCfg(spmp13cfg, v[15..8]);
                spmp14cfg  = spmpWriteCfg(spmp14cfg, v[23..16]);
                spmp15cfg  = spmpWriteCfg(spmp15cfg, v[31..24]);
              },
         4 => { spmp16cfg  = spmpWriteCfg(spmp16cfg, v[7 ..0]);
                spmp17cfg  = spmpWriteCfg(spmp17cfg, v[15..8]);
                spmp18cfg  = spmpWriteCfg(spmp18cfg, v[23..16]);
                spmp19cfg  = spmpWriteCfg(spmp19cfg, v[31..24]);
              },
         5 => { spmp20cfg  = spmpWriteCfg(spmp20cfg, v[7 ..0]);
                spmp21cfg  = spmpWriteCfg(spmp21cfg, v[15..8]);
                spmp22cfg  = spmpWriteCfg(spmp22cfg, v[23..16]);
                spmp23cfg  = spmpWriteCfg(spmp23cfg, v[31..24]);
              },
         6 => { spmp24cfg  = spmpWriteCfg(spmp24cfg, v[7 ..0]);
                spmp25cfg  = spmpWriteCfg(spmp25cfg, v[15..8]);
                spmp26cfg  = spmpWriteCfg(spmp26cfg, v[23..16]);
                spmp27cfg  = spmpWriteCfg(spmp27cfg, v[31..24]);
              },
         7 => { spmp28cfg  = spmpWriteCfg(spmp28cfg, v[7 ..0]);
                spmp29cfg  = spmpWriteCfg(spmp29cfg, v[15..8]);
                spmp30cfg  = spmpWriteCfg(spmp30cfg, v[23..16]);
                spmp31cfg  = spmpWriteCfg(spmp31cfg, v[31..24]);
              },
         8 => { spmp32cfg  = spmpWriteCfg(spmp32cfg, v[7 ..0]);
                spmp33cfg  = spmpWriteCfg(spmp33cfg, v[15..8]);
                spmp34cfg  = spmpWriteCfg(spmp34cfg, v[23..16]);
                spmp35cfg  = spmpWriteCfg(spmp35cfg, v[31..24]);
              },
         9 => { spmp36cfg  = spmpWriteCfg(spmp36cfg, v[7 ..0]);
                spmp37cfg  = spmpWriteCfg(spmp37cfg, v[15..8]);
                spmp38cfg  = spmpWriteCfg(spmp38cfg, v[23..16]);
                spmp39cfg  = spmpWriteCfg(spmp39cfg, v[31..24]);
              },
         10 => { spmp40cfg = spmpWriteCfg(spmp40cfg, v[7 ..0]);
                 spmp41cfg = spmpWriteCfg(spmp41cfg, v[15..8]);
                 spmp42cfg = spmpWriteCfg(spmp42cfg, v[23..16]);
                 spmp43cfg = spmpWriteCfg(spmp43cfg, v[31..24]);
              },
         11 => { spmp44cfg = spmpWriteCfg(spmp44cfg, v[7 ..0]);
                 spmp45cfg = spmpWriteCfg(spmp45cfg, v[15..8]);
                 spmp46cfg = spmpWriteCfg(spmp46cfg, v[23..16]);
                 spmp47cfg = spmpWriteCfg(spmp47cfg, v[31..24]);
              },
         12 => { spmp48cfg = spmpWriteCfg(spmp48cfg, v[7 ..0]);
                 spmp49cfg = spmpWriteCfg(spmp49cfg, v[15..8]);
                 spmp50cfg = spmpWriteCfg(spmp50cfg, v[23..16]);
                 spmp51cfg = spmpWriteCfg(spmp51cfg, v[31..24]);
              },
         13 => { spmp52cfg = spmpWriteCfg(spmp52cfg, v[7 ..0]);
                 spmp53cfg = spmpWriteCfg(spmp53cfg, v[15..8]);
                 spmp54cfg = spmpWriteCfg(spmp54cfg, v[23..16]);
                 spmp55cfg = spmpWriteCfg(spmp55cfg, v[31..24]);
              },
         14 => { spmp56cfg = spmpWriteCfg(spmp56cfg, v[7 ..0]);
                 spmp57cfg = spmpWriteCfg(spmp57cfg, v[15..8]);
                 spmp58cfg = spmpWriteCfg(spmp58cfg, v[23..16]);
                 spmp59cfg = spmpWriteCfg(spmp59cfg, v[31..24]);
              },
         15 => { spmp60cfg = spmpWriteCfg(spmp60cfg, v[7 ..0]);
                 spmp61cfg = spmpWriteCfg(spmp61cfg, v[15..8]);
                 spmp62cfg = spmpWriteCfg(spmp62cfg, v[23..16]);
                 spmp63cfg = spmpWriteCfg(spmp63cfg, v[31..24]);
              }
       }
  else if sizeof(xlen) == 64
  then match n {
         0 => { spmp0cfg  = spmpWriteCfg(spmp0cfg,  v[7 ..0]);
                spmp1cfg  = spmpWriteCfg(spmp1cfg,  v[15..8]);
                spmp2cfg  = spmpWriteCfg(spmp2cfg,  v[23..16]);
                spmp3cfg  = spmpWriteCfg(spmp3cfg,  v[31..24]);
                spmp4cfg  = spmpWriteCfg(spmp4cfg,  v[39..32]);
                spmp5cfg  = spmpWriteCfg(spmp5cfg,  v[47..40]);
                spmp6cfg  = spmpWriteCfg(spmp6cfg,  v[55..48]);
                spmp7cfg  = spmpWriteCfg(spmp7cfg,  v[63..56])
              },
         2 => { spmp8cfg  = spmpWriteCfg(spmp8cfg,  v[7 ..0]);
                spmp9cfg  = spmpWriteCfg(spmp9cfg,  v[15..8]);
                spmp10cfg = spmpWriteCfg(spmp10cfg, v[23..16]);
                spmp11cfg = spmpWriteCfg(spmp11cfg, v[31..24]);
                spmp12cfg = spmpWriteCfg(spmp12cfg, v[39..32]);
                spmp13cfg = spmpWriteCfg(spmp13cfg, v[47..40]);
                spmp14cfg = spmpWriteCfg(spmp14cfg, v[55..48]);
                spmp15cfg = spmpWriteCfg(spmp15cfg, v[63..56])
              },
         4 => { spmp16cfg = spmpWriteCfg(spmp16cfg, v[7 ..0]);
                spmp17cfg = spmpWriteCfg(spmp17cfg, v[15..8]);
                spmp18cfg = spmpWriteCfg(spmp18cfg, v[23..16]);
                spmp19cfg = spmpWriteCfg(spmp19cfg, v[31..24]);
                spmp20cfg = spmpWriteCfg(spmp20cfg, v[39..32]);
                spmp21cfg = spmpWriteCfg(spmp21cfg, v[47..40]);
                spmp22cfg = spmpWriteCfg(spmp22cfg, v[55..48]);
                spmp23cfg = spmpWriteCfg(spmp23cfg, v[63..56])
              },
         6 => { spmp24cfg = spmpWriteCfg(spmp24cfg, v[7 ..0]);
                spmp25cfg = spmpWriteCfg(spmp25cfg, v[15..8]);
                spmp26cfg = spmpWriteCfg(spmp26cfg, v[23..16]);
                spmp27cfg = spmpWriteCfg(spmp27cfg, v[31..24]);
                spmp28cfg = spmpWriteCfg(spmp28cfg, v[39..32]);
                spmp29cfg = spmpWriteCfg(spmp29cfg, v[47..40]);
                spmp30cfg = spmpWriteCfg(spmp30cfg, v[55..48]);
                spmp31cfg = spmpWriteCfg(spmp31cfg, v[63..56])
              },
         8 => { spmp32cfg = spmpWriteCfg(spmp32cfg, v[7 ..0]);
                spmp33cfg = spmpWriteCfg(spmp33cfg, v[15..8]);
                spmp34cfg = spmpWriteCfg(spmp34cfg, v[23..16]);
                spmp35cfg = spmpWriteCfg(spmp35cfg, v[31..24]);
                spmp36cfg = spmpWriteCfg(spmp36cfg, v[39..32]);
                spmp37cfg = spmpWriteCfg(spmp37cfg, v[47..40]);
                spmp38cfg = spmpWriteCfg(spmp38cfg, v[55..48]);
                spmp39cfg = spmpWriteCfg(spmp39cfg, v[63..56])
              },
         10 => { spmp40cfg = spmpWriteCfg(spmp40cfg, v[7 ..0]);
                spmp41cfg  = spmpWriteCfg(spmp41cfg, v[15..8]);
                spmp42cfg  = spmpWriteCfg(spmp42cfg, v[23..16]);
                spmp43cfg  = spmpWriteCfg(spmp43cfg, v[31..24]);
                spmp44cfg  = spmpWriteCfg(spmp44cfg, v[39..32]);
                spmp45cfg  = spmpWriteCfg(spmp45cfg, v[47..40]);
                spmp46cfg  = spmpWriteCfg(spmp46cfg, v[55..48]);
                spmp47cfg  = spmpWriteCfg(spmp47cfg, v[63..56])
              },
         12 => { spmp48cfg = spmpWriteCfg(spmp48cfg, v[7 ..0]);
                 spmp49cfg = spmpWriteCfg(spmp49cfg, v[15..8]);
                 spmp50cfg = spmpWriteCfg(spmp50cfg, v[23..16]);
                 spmp51cfg = spmpWriteCfg(spmp51cfg, v[31..24]);
                 spmp52cfg = spmpWriteCfg(spmp52cfg, v[39..32]);
                 spmp53cfg = spmpWriteCfg(spmp53cfg, v[47..40]);
                 spmp54cfg = spmpWriteCfg(spmp54cfg, v[55..48]);
                 spmp55cfg = spmpWriteCfg(spmp55cfg, v[63..56])
              },
         14 => { spmp56cfg = spmpWriteCfg(spmp56cfg, v[7 ..0]);
                 spmp57cfg = spmpWriteCfg(spmp57cfg, v[15..8]);
                 spmp58cfg = spmpWriteCfg(spmp58cfg, v[23..16]);
                 spmp59cfg = spmpWriteCfg(spmp59cfg, v[31..24]);
                 spmp60cfg = spmpWriteCfg(spmp60cfg, v[39..32]);
                 spmp61cfg = spmpWriteCfg(spmp61cfg, v[47..40]);
                 spmp62cfg = spmpWriteCfg(spmp62cfg, v[55..48]);
                 spmp63cfg = spmpWriteCfg(spmp63cfg, v[63..56])
              }
       }
}

function spmpWriteAddr(reg: xlenbits, v: xlenbits) -> xlenbits =
  if   sizeof(xlen) == 32
  then { v }
  else { EXTZ(v[53..0]) }
