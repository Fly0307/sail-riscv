/* address ranges */
/* [min, max) of the matching range. */
type spmp_addr_range = option((xlenbits, xlenbits))

function spmpAddrRange(cfg: Spmpcfg_ent, spmpaddr: xlenbits, prev_spmpaddr: xlenbits) -> spmp_addr_range = {
  match spmpAddrMatchType_of_bits(cfg.A()) {
    OFF   => None(),
    TOR   => { Some ((prev_spmpaddr << 2, spmpaddr << 2)) },
    NA4   => { let lo = spmpaddr << 2;
               Some((lo, lo + 4))
             },
    NAPOT => { let mask = spmpaddr ^ (spmpaddr + 1);  // generate 1s in signifying bits
               let lo   = spmpaddr & (~ (mask));
               let len  = mask + 1;
               Some((lo << 2, (lo + len) << 2))
             }
  }
}

/* permission checks */
val CheckRWX: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool
function CheckRWX(ent, acc, priv) = {
  match acc {
    Read(_)      => ent.R() == 0b1,
    Write(_)     => ent.W() == 0b1,
    ReadWrite(_) => ent.R() == 0b1 & ent.W() == 0b1,
    Execute()    => ent.X() == 0b1
  }
}

val spmpCheckRWX: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function spmpCheckRWX(ent, acc, priv) = {
  let do_sum : bool = mstatus.SUM() == 0b1;

  match (ent.S(), ent.R(), ent.W(), ent.X()) {
    (0b0, 0b0, 0b0, 0b0) => false,
    (0b0, 0b0, 0b0, 0b1) => priv == User & CheckRWX(ent, acc, priv),
    (0b0, 0b0, 0b1, 0b0) => (priv == User & acc == Read()) | (priv == Supervisor & acc != Execute()),
    (0b0, 0b0, 0b1, 0b1) => acc != Execute(),
    (0b0, 0b1, 0b0, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b0, 0b1) => (priv == User | (priv == Supervisor & do_sum & acc != Execute())) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b0) => (priv == User | (priv == Supervisor & do_sum)) & CheckRWX(ent, acc, priv),
    (0b0, 0b1, 0b1, 0b1) => (priv == User | (priv == Supervisor & do_sum & acc != Execute())) & CheckRWX(ent, acc, priv),
    (0b1, 0b0, 0b0, 0b0) => false,
    (0b1, 0b0, 0b0, 0b1) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b0, 0b1, 0b0) => acc == Execute(),
    (0b1, 0b0, 0b1, 0b1) => (priv == User & acc == Execute()) | (priv == Supervisor & acc != Write()),
    (0b1, 0b1, 0b0, 0b0) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b0, 0b1) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b0) => priv == Supervisor & CheckRWX(ent, acc, priv),
    (0b1, 0b1, 0b1, 0b1) => acc == Read()
  }
}

// this needs to be called with the effective current privilege.
val spmpCheckPerms: (Spmpcfg_ent, AccessType(ext_access_type), Privilege) -> bool effect {rreg}
function spmpCheckPerms(ent, acc, priv) = {
  match priv {
    Machine => true,
    _       => spmpCheckRWX(ent, acc, priv)
  }
}

/* matching logic */

enum spmpAddrMatch = {SPMP_NoMatch, SPMP_PartialMatch, SPMP_Match}

function spmpMatchAddr(addr: xlenbits, width: xlenbits, rng: spmp_addr_range) -> spmpAddrMatch = {
  match rng {
    None()         => SPMP_NoMatch,
    Some((lo, hi)) => if   hi <_u lo   /* to handle mis-configuration */
                      then SPMP_NoMatch
                      else {
                        if      (addr + width <=_u lo) | (hi <=_u addr)
                        then    SPMP_NoMatch
                        else if (lo <=_u addr) & (addr + width <=_u hi)
                        then    SPMP_Match
                        else    SPMP_PartialMatch
                      }
  }
}

enum spmpMatch = {SPMP_Success, SPMP_Continue, SPMP_Fail}

function spmpMatchEntry(addr: xlenbits, width: xlenbits, acc: AccessType(ext_access_type), priv: Privilege,
                       ent: Spmpcfg_ent, spmpaddr: xlenbits, prev_spmpaddr: xlenbits) -> spmpMatch = {
  let rng = spmpAddrRange(ent, spmpaddr, prev_spmpaddr);
  match spmpMatchAddr(addr, width, rng) {
    SPMP_NoMatch      => SPMP_Continue,
    SPMP_PartialMatch => SPMP_Fail,
    SPMP_Match        => if   spmpCheckPerms(ent, acc, priv)
                        then SPMP_Success
                        else SPMP_Fail
  }
}

/* priority checks */

function spmpCheck forall 'n, 'n > 0. (addr: xlenbits, width: atom('n), acc: AccessType(ext_access_type), priv: Privilege)
                  -> option(ExceptionType) = {
  let width : xlenbits = to_bits(sizeof(xlen), width);
  let check : bool =
  match spmpMatchEntry(addr, width, acc, priv, spmp0cfg, spmpaddr0, zeros()) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp1cfg, spmpaddr1, spmpaddr0) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp2cfg, spmpaddr2, spmpaddr1) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp3cfg, spmpaddr3, spmpaddr2) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp4cfg, spmpaddr4, spmpaddr3) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp5cfg, spmpaddr5, spmpaddr4) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp6cfg, spmpaddr6, spmpaddr5) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp7cfg, spmpaddr7, spmpaddr6) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp8cfg, spmpaddr8, spmpaddr7) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp9cfg, spmpaddr9, spmpaddr8) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp10cfg, spmpaddr10, spmpaddr9) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp11cfg, spmpaddr11, spmpaddr10) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp12cfg, spmpaddr12, spmpaddr11) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp13cfg, spmpaddr13, spmpaddr12) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp14cfg, spmpaddr14, spmpaddr13) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp15cfg, spmpaddr15, spmpaddr14) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue => 
  match spmpMatchEntry(addr, width, acc, priv, spmp16cfg, spmpaddr16, spmpaddr15) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp17cfg, spmpaddr17, spmpaddr16) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp18cfg, spmpaddr18, spmpaddr17) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp19cfg, spmpaddr19, spmpaddr18) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp20cfg, spmpaddr20, spmpaddr19) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp21cfg, spmpaddr21, spmpaddr20) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp22cfg, spmpaddr22, spmpaddr21) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp23cfg, spmpaddr23, spmpaddr22) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp24cfg, spmpaddr24, spmpaddr23) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp25cfg, spmpaddr25, spmpaddr24) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp26cfg, spmpaddr26, spmpaddr25) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp27cfg, spmpaddr27, spmpaddr26) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp28cfg, spmpaddr28, spmpaddr27) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp29cfg, spmpaddr29, spmpaddr28) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp30cfg, spmpaddr30, spmpaddr29) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp31cfg, spmpaddr31, spmpaddr30) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue => 
  match spmpMatchEntry(addr, width, acc, priv, spmp32cfg, spmpaddr32, spmpaddr31) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp33cfg, spmpaddr33, spmpaddr32) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp34cfg, spmpaddr34, spmpaddr33) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp35cfg, spmpaddr35, spmpaddr34) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp36cfg, spmpaddr36, spmpaddr35) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp37cfg, spmpaddr37, spmpaddr36) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp38cfg, spmpaddr38, spmpaddr37) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp39cfg, spmpaddr39, spmpaddr38) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp40cfg, spmpaddr40, spmpaddr39) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp41cfg, spmpaddr41, spmpaddr40) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp42cfg, spmpaddr42, spmpaddr41) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp43cfg, spmpaddr43, spmpaddr42) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp44cfg, spmpaddr44, spmpaddr43) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp45cfg, spmpaddr45, spmpaddr44) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp46cfg, spmpaddr46, spmpaddr45) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp47cfg, spmpaddr47, spmpaddr46) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue => 
  match spmpMatchEntry(addr, width, acc, priv, spmp48cfg, spmpaddr48, spmpaddr47) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp49cfg, spmpaddr49, spmpaddr48) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp50cfg, spmpaddr50, spmpaddr49) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp51cfg, spmpaddr51, spmpaddr50) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp52cfg, spmpaddr52, spmpaddr51) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp53cfg, spmpaddr53, spmpaddr52) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp54cfg, spmpaddr54, spmpaddr53) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp55cfg, spmpaddr55, spmpaddr54) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp56cfg, spmpaddr56, spmpaddr55) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp57cfg, spmpaddr57, spmpaddr56) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp58cfg, spmpaddr58, spmpaddr57) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp59cfg, spmpaddr59, spmpaddr58) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp60cfg, spmpaddr60, spmpaddr59) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp61cfg, spmpaddr61, spmpaddr60) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp62cfg, spmpaddr62, spmpaddr61) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue =>
  match spmpMatchEntry(addr, width, acc, priv, spmp63cfg, spmpaddr63, spmpaddr62) {
    SPMP_Success  => true,
    SPMP_Fail     => false,
    SPMP_Continue => match priv {
                      User => false,
                      _    => true
                    }
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}};

/* 
 * The SPMP is proposing to rename page fault to SPMP/Sv fault for clarity.
 * Since SPMP is not merged into spec, so it remains page fault here.
 */    
  if   check
  then None()
  else match acc {
    Read(_)      => Some(E_Load_Page_Fault()),
    Write(_)     => Some(E_SAMO_Page_Fault()),
    ReadWrite(_) => Some(E_SAMO_Page_Fault()),
    Execute()    => Some(E_Fetch_Page_Fault())
  }
}

function init_spmp() -> unit = {
  spmp0cfg  = update_A(spmp0cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp1cfg  = update_A(spmp1cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp2cfg  = update_A(spmp2cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp3cfg  = update_A(spmp3cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp4cfg  = update_A(spmp4cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp5cfg  = update_A(spmp5cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp6cfg  = update_A(spmp6cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp7cfg  = update_A(spmp7cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp8cfg  = update_A(spmp8cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp9cfg  = update_A(spmp9cfg,  spmpAddrMatchType_to_bits(OFF));
  spmp10cfg = update_A(spmp10cfg, spmpAddrMatchType_to_bits(OFF));
  spmp11cfg = update_A(spmp11cfg, spmpAddrMatchType_to_bits(OFF));
  spmp12cfg = update_A(spmp12cfg, spmpAddrMatchType_to_bits(OFF));
  spmp13cfg = update_A(spmp13cfg, spmpAddrMatchType_to_bits(OFF));
  spmp14cfg = update_A(spmp14cfg, spmpAddrMatchType_to_bits(OFF));
  spmp15cfg = update_A(spmp15cfg, spmpAddrMatchType_to_bits(OFF));
  spmp16cfg = update_A(spmp16cfg, spmpAddrMatchType_to_bits(OFF));
  spmp17cfg = update_A(spmp17cfg, spmpAddrMatchType_to_bits(OFF));
  spmp18cfg = update_A(spmp18cfg, spmpAddrMatchType_to_bits(OFF));
  spmp19cfg = update_A(spmp19cfg, spmpAddrMatchType_to_bits(OFF));
  spmp20cfg = update_A(spmp20cfg, spmpAddrMatchType_to_bits(OFF));
  spmp21cfg = update_A(spmp21cfg, spmpAddrMatchType_to_bits(OFF));
  spmp22cfg = update_A(spmp22cfg, spmpAddrMatchType_to_bits(OFF));
  spmp23cfg = update_A(spmp23cfg, spmpAddrMatchType_to_bits(OFF));
  spmp24cfg = update_A(spmp24cfg, spmpAddrMatchType_to_bits(OFF));
  spmp25cfg = update_A(spmp25cfg, spmpAddrMatchType_to_bits(OFF));
  spmp26cfg = update_A(spmp26cfg, spmpAddrMatchType_to_bits(OFF));
  spmp27cfg = update_A(spmp27cfg, spmpAddrMatchType_to_bits(OFF));
  spmp28cfg = update_A(spmp28cfg, spmpAddrMatchType_to_bits(OFF));
  spmp29cfg = update_A(spmp29cfg, spmpAddrMatchType_to_bits(OFF));
  spmp30cfg = update_A(spmp30cfg, spmpAddrMatchType_to_bits(OFF));
  spmp31cfg = update_A(spmp31cfg, spmpAddrMatchType_to_bits(OFF));
  spmp32cfg = update_A(spmp32cfg, spmpAddrMatchType_to_bits(OFF));
  spmp33cfg = update_A(spmp33cfg, spmpAddrMatchType_to_bits(OFF));
  spmp34cfg = update_A(spmp34cfg, spmpAddrMatchType_to_bits(OFF));
  spmp35cfg = update_A(spmp35cfg, spmpAddrMatchType_to_bits(OFF));
  spmp36cfg = update_A(spmp36cfg, spmpAddrMatchType_to_bits(OFF));
  spmp37cfg = update_A(spmp37cfg, spmpAddrMatchType_to_bits(OFF));
  spmp38cfg = update_A(spmp38cfg, spmpAddrMatchType_to_bits(OFF));
  spmp39cfg = update_A(spmp39cfg, spmpAddrMatchType_to_bits(OFF));
  spmp40cfg = update_A(spmp40cfg, spmpAddrMatchType_to_bits(OFF));
  spmp41cfg = update_A(spmp41cfg, spmpAddrMatchType_to_bits(OFF));
  spmp42cfg = update_A(spmp42cfg, spmpAddrMatchType_to_bits(OFF));
  spmp43cfg = update_A(spmp43cfg, spmpAddrMatchType_to_bits(OFF));
  spmp44cfg = update_A(spmp44cfg, spmpAddrMatchType_to_bits(OFF));
  spmp45cfg = update_A(spmp45cfg, spmpAddrMatchType_to_bits(OFF));
  spmp46cfg = update_A(spmp46cfg, spmpAddrMatchType_to_bits(OFF));
  spmp47cfg = update_A(spmp47cfg, spmpAddrMatchType_to_bits(OFF));
  spmp48cfg = update_A(spmp48cfg, spmpAddrMatchType_to_bits(OFF));
  spmp49cfg = update_A(spmp49cfg, spmpAddrMatchType_to_bits(OFF));
  spmp50cfg = update_A(spmp50cfg, spmpAddrMatchType_to_bits(OFF));
  spmp51cfg = update_A(spmp51cfg, spmpAddrMatchType_to_bits(OFF));
  spmp52cfg = update_A(spmp52cfg, spmpAddrMatchType_to_bits(OFF));
  spmp53cfg = update_A(spmp53cfg, spmpAddrMatchType_to_bits(OFF));
  spmp54cfg = update_A(spmp54cfg, spmpAddrMatchType_to_bits(OFF));
  spmp55cfg = update_A(spmp55cfg, spmpAddrMatchType_to_bits(OFF));
  spmp56cfg = update_A(spmp56cfg, spmpAddrMatchType_to_bits(OFF));
  spmp57cfg = update_A(spmp57cfg, spmpAddrMatchType_to_bits(OFF));
  spmp58cfg = update_A(spmp58cfg, spmpAddrMatchType_to_bits(OFF));
  spmp59cfg = update_A(spmp59cfg, spmpAddrMatchType_to_bits(OFF));
  spmp60cfg = update_A(spmp60cfg, spmpAddrMatchType_to_bits(OFF));
  spmp61cfg = update_A(spmp61cfg, spmpAddrMatchType_to_bits(OFF));
  spmp62cfg = update_A(spmp62cfg, spmpAddrMatchType_to_bits(OFF));
  spmp63cfg = update_A(spmp63cfg, spmpAddrMatchType_to_bits(OFF));

  /* For backwards compatibility with software that is unaware of SPMP,
    initialize SPMP to permit unprivileged access to all of memory. */
  // spmpWriteCfgReg(2, 0b1000100000000000000000000000000000000000000000000000000000000000);
  // spmpaddr63 = spmpWriteAddr(spmpaddr63, 0b1111111111111111111111111111111111111111111111111111111111111111)
}
