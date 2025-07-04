/*=======================================================================================*/
/*  SPMP (Supervisor Mode Physical Memory Protection) Register Definitions              */
/*                                                                                       */
/*  This module implements the SPMP CSR interface as specified in .    */
/*  SPMP provides 64 protection entries with configuration and address registers.       */
/*                                                                                       */
/*  CSR Address Space ( Section 2.1):                                   */
/*    0x1A0-0x1AF: spmpcfg0-spmpcfg15   (Configuration registers)                       */
/*    0x1B0-0x1EF: spmpaddr0-spmpaddr63 (Address registers)                             */
/*                                                                                       */
/*  Privilege Level: Supervisor (0x1XX address space)                                   */
/*                                                                                       */
/*  Lock Bit (L) Access Control Rules:                                                  */
/*    - L bit is only accessible to M-mode for writes                                   */
/*    - M-mode: Can read/write L bit and modify locked entries                          */
/*    - S-mode: Cannot modify locked entries (writes ignored when L=1)                 */
/*    - L bit is not sticky - can only be reset by M-mode                              */
/*    - Setting L=1 locks entry even when A=OFF                                        */
/*    - For locked TOR entries, S-mode writes to previous addr register ignored        */
/*=======================================================================================*/

/* SPMP platform configuration parameters.
 * These values are typically set at build time based on platform capabilities. */
let sys_spmp_enabled : bool = config memory.spmp.enabled  // Platform SPMP support
let sys_spmp_count : nat = config memory.spmp.count       // Number of SPMP entries

/*=======================================================================================*/
/*  SPMP Configuration Register CSR Name Mappings (0x1A0-0x1AF)                        */
/*                                                                                       */
/*  Each spmpcfg register contains configuration for multiple SPMP entries:             */
/*    - RV32: 4 entries per register (8 bits each)                                      */
/*    - RV64: 8 entries per register (8 bits each)                                      */
/*                                                                                       */
/*  Configuration bits per entry ( Section 2.2):                       */
/*    [7]: L - Lock bit (prevents further modifications when set)                       */
/*    [6]: S - Supervisor/User mode shared permission management (Section 2.3)         */
/*    [5]: Reserved (WPRI - Write Preserve, Read Ignore)                               */
/*    [4:3]: A - Address matching mode (OFF/TOR/NA4/NAPOT)                             */
/*    [2]: X - Execute permission                                                       */
/*    [1]: W - Write permission                                                         */
/*    [0]: R - Read permission                                                          */
/*=======================================================================================*/

mapping clause csr_name_map = 0x1A0  <-> "spmpcfg0"   // SPMP config entries 0-7 (RV64) or 0-3 (RV32)
mapping clause csr_name_map = 0x1A1  <-> "spmpcfg1"   // SPMP config entries 4-7 (RV32 only)
mapping clause csr_name_map = 0x1A2  <-> "spmpcfg2"   // SPMP config entries 8-15 (RV64) or 8-11 (RV32)
mapping clause csr_name_map = 0x1A3  <-> "spmpcfg3"   // SPMP config entries 12-15 (RV32 only)
mapping clause csr_name_map = 0x1A4  <-> "spmpcfg4"   // SPMP config entries 16-23 (RV64) or 16-19 (RV32)
mapping clause csr_name_map = 0x1A5  <-> "spmpcfg5"   // SPMP config entries 20-23 (RV32 only)
mapping clause csr_name_map = 0x1A6  <-> "spmpcfg6"   // SPMP config entries 24-31 (RV64) or 24-27 (RV32)
mapping clause csr_name_map = 0x1A7  <-> "spmpcfg7"   // SPMP config entries 28-31 (RV32 only)
mapping clause csr_name_map = 0x1A8  <-> "spmpcfg8"   // SPMP config entries 32-39 (RV64) or 32-35 (RV32)
mapping clause csr_name_map = 0x1A9  <-> "spmpcfg9"   // SPMP config entries 36-39 (RV32 only)
mapping clause csr_name_map = 0x1AA  <-> "spmpcfg10"  // SPMP config entries 40-47 (RV64) or 40-43 (RV32)
mapping clause csr_name_map = 0x1AB  <-> "spmpcfg11"  // SPMP config entries 44-47 (RV32 only)
mapping clause csr_name_map = 0x1AC  <-> "spmpcfg12"  // SPMP config entries 48-55 (RV64) or 48-51 (RV32)
mapping clause csr_name_map = 0x1AD  <-> "spmpcfg13"  // SPMP config entries 52-55 (RV32 only)
mapping clause csr_name_map = 0x1AE  <-> "spmpcfg14"  // SPMP config entries 56-63 (RV64) or 56-59 (RV32)
mapping clause csr_name_map = 0x1AF  <-> "spmpcfg15"  // SPMP config entries 60-63 (RV32 only)

/*=======================================================================================*/
/*  SPMP Address Register CSR Name Mappings (0x1B0-0x1EF)                              */
/*                                                                                       */
/*  Each spmpaddr register contains one address value ( Section 2.2):  */
/*    - Contains bits [XLEN-1:2] of the address (word-aligned)                          */
/*    - Interpretation depends on address matching mode in corresponding spmpcfg        */
/*    - TOR: Top address of range [prev_addr*4, addr*4)                                 */
/*    - NA4/NAPOT: Base address with mode-specific encoding                             */
/*=======================================================================================*/

mapping clause csr_name_map = 0x1B0  <-> "spmpaddr0"   // SPMP address register 0
mapping clause csr_name_map = 0x1B1  <-> "spmpaddr1"   // SPMP address register 1
mapping clause csr_name_map = 0x1B2  <-> "spmpaddr2"   // SPMP address register 2
mapping clause csr_name_map = 0x1B3  <-> "spmpaddr3"   // SPMP address register 3
mapping clause csr_name_map = 0x1B4  <-> "spmpaddr4"   // SPMP address register 4
mapping clause csr_name_map = 0x1B5  <-> "spmpaddr5"   // SPMP address register 5
mapping clause csr_name_map = 0x1B6  <-> "spmpaddr6"   // SPMP address register 6
mapping clause csr_name_map = 0x1B7  <-> "spmpaddr7"   // SPMP address register 7
mapping clause csr_name_map = 0x1B8  <-> "spmpaddr8"   // SPMP address register 8
mapping clause csr_name_map = 0x1B9  <-> "spmpaddr9"   // SPMP address register 9
mapping clause csr_name_map = 0x1BA  <-> "spmpaddr10"  // SPMP address register 10
mapping clause csr_name_map = 0x1BB  <-> "spmpaddr11"  // SPMP address register 11
mapping clause csr_name_map = 0x1BC  <-> "spmpaddr12"  // SPMP address register 12
mapping clause csr_name_map = 0x1BD  <-> "spmpaddr13"  // SPMP address register 13
mapping clause csr_name_map = 0x1BE  <-> "spmpaddr14"  // SPMP address register 14
mapping clause csr_name_map = 0x1BF  <-> "spmpaddr15"  // SPMP address register 15
mapping clause csr_name_map = 0x1C0  <-> "spmpaddr16"  // SPMP address register 16
mapping clause csr_name_map = 0x1C1  <-> "spmpaddr17"  // SPMP address register 17
mapping clause csr_name_map = 0x1C2  <-> "spmpaddr18"  // SPMP address register 18
mapping clause csr_name_map = 0x1C3  <-> "spmpaddr19"  // SPMP address register 19
mapping clause csr_name_map = 0x1C4  <-> "spmpaddr20"  // SPMP address register 20
mapping clause csr_name_map = 0x1C5  <-> "spmpaddr21"  // SPMP address register 21
mapping clause csr_name_map = 0x1C6  <-> "spmpaddr22"  // SPMP address register 22
mapping clause csr_name_map = 0x1C7  <-> "spmpaddr23"  // SPMP address register 23
mapping clause csr_name_map = 0x1C8  <-> "spmpaddr24"  // SPMP address register 24
mapping clause csr_name_map = 0x1C9  <-> "spmpaddr25"  // SPMP address register 25
mapping clause csr_name_map = 0x1CA  <-> "spmpaddr26"  // SPMP address register 26
mapping clause csr_name_map = 0x1CB  <-> "spmpaddr27"
mapping clause csr_name_map = 0x1CC  <-> "spmpaddr28"
mapping clause csr_name_map = 0x1CD  <-> "spmpaddr29"
mapping clause csr_name_map = 0x1CE  <-> "spmpaddr30"
mapping clause csr_name_map = 0x1CF  <-> "spmpaddr31"
mapping clause csr_name_map = 0x1D0  <-> "spmpaddr32"
mapping clause csr_name_map = 0x1D1  <-> "spmpaddr33"
mapping clause csr_name_map = 0x1D2  <-> "spmpaddr34"
mapping clause csr_name_map = 0x1D3  <-> "spmpaddr35"
mapping clause csr_name_map = 0x1D4  <-> "spmpaddr36"
mapping clause csr_name_map = 0x1D5  <-> "spmpaddr37"
mapping clause csr_name_map = 0x1D6  <-> "spmpaddr38"
mapping clause csr_name_map = 0x1D7  <-> "spmpaddr39"
mapping clause csr_name_map = 0x1D8  <-> "spmpaddr40"
mapping clause csr_name_map = 0x1D9  <-> "spmpaddr41"
mapping clause csr_name_map = 0x1DA  <-> "spmpaddr42"
mapping clause csr_name_map = 0x1DB  <-> "spmpaddr43"
mapping clause csr_name_map = 0x1DC  <-> "spmpaddr44"
mapping clause csr_name_map = 0x1DD  <-> "spmpaddr45"
mapping clause csr_name_map = 0x1DE  <-> "spmpaddr46"
mapping clause csr_name_map = 0x1DF  <-> "spmpaddr47"
mapping clause csr_name_map = 0x1E0  <-> "spmpaddr48"
mapping clause csr_name_map = 0x1E1  <-> "spmpaddr49"
mapping clause csr_name_map = 0x1E2  <-> "spmpaddr50"
mapping clause csr_name_map = 0x1E3  <-> "spmpaddr51"
mapping clause csr_name_map = 0x1E4  <-> "spmpaddr52"
mapping clause csr_name_map = 0x1E5  <-> "spmpaddr53"
mapping clause csr_name_map = 0x1E6  <-> "spmpaddr54"
mapping clause csr_name_map = 0x1E7  <-> "spmpaddr55"
mapping clause csr_name_map = 0x1E8  <-> "spmpaddr56"
mapping clause csr_name_map = 0x1E9  <-> "spmpaddr57"
mapping clause csr_name_map = 0x1EA  <-> "spmpaddr58"
mapping clause csr_name_map = 0x1EB  <-> "spmpaddr59"
mapping clause csr_name_map = 0x1EC  <-> "spmpaddr60"
mapping clause csr_name_map = 0x1ED  <-> "spmpaddr61"
mapping clause csr_name_map = 0x1EE  <-> "spmpaddr62"
mapping clause csr_name_map = 0x1EF  <-> "spmpaddr63"

mapping clause csr_name_map = 0x1F0  <-> "spmpswitch" // SPMP domain switch register
mapping clause csr_name_map = 0x1F1  <-> "spmpswitchh" // SPMP domain switch register high (RV32 only)
// mapping clause csr_name_map = 0x1F2  <-> "mpmpdeleg"  // allows an implementation to hardwire the PMP/SPMP split if desired

/*=======================================================================================*/
/*  SPMP Context Switching Optimization (Section 2.8)                                  */
/*                                                                                       */
/*  The spmpswitch registers provide context switching optimization by allowing         */
/*  software to activate/deactivate SPMP entries without modifying configuration.      */
/*                                                                                       */
/*  Register Layout:                                                                     */
/*    - RV32: spmpswitch (entries 0-31) + spmpswitchh (entries 32-63)                  */
/*    - RV64: spmpswitch (entries 0-63)                                                 */
/*                                                                                       */
/*  Activation Rule:                                                                     */
/*    An entry is active only when: spmpswitch[i] & (spmp[i]cfg.A != OFF)              */
/*                                                                                       */
/*  Special Cases:                                                                       */
/*    - When spmpswitch[i] == 0 and spmp[i]cfg.L == 1, entry i remains enabled        */
/*    - TOR entries match regardless of spmpswitch[i-1] value                          */
/*    - spmpswitch registers must be cleared on reset                                   */
/*=======================================================================================*/

/* SPMP switch registers - control activation of SPMP entries */
register spmpswitch : xlenbits
register spmpswitchh : bits(32)  // Only used in RV32

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
  L : 7,        /* Lock bit - prevents further modifications when set ( Section 2.2) */
  S : 6,        /* S-mode/U-mode shared permission management ( Section 2.3) */
              /* bit[5]: Reserved (WPRI - Write Preserve, Read Ignore) */
  A : 4 .. 3,   /* Address matching mode (OFF/TOR/NA4/NAPOT) ( Section 2.2) */

  /* Memory access permissions ( Section 2.2) */
  X : 2,        /* Execute permission */
  W : 1,        /* Write permission */
  R : 0         /* Read permission */
}

register spmpcfg_n : vector(64, Spmpcfg_ent)
register spmpaddr_n : vector(64, xlenbits)


/* Packing and unpacking spmpcfg regs for xlen-width accesses */

function spmpReadCfgReg(n : range(0, 15)) -> xlenbits = {
  if xlen == 32
  then {
    spmpcfg_n[n*4 + 3].bits @
    spmpcfg_n[n*4 + 2].bits @
    spmpcfg_n[n*4 + 1].bits @
    spmpcfg_n[n*4 + 0].bits
  }
  else {
    assert(n % 2 == 0, "Unexpected spmp config reg read");
    spmpcfg_n[n*4 + 7].bits @
    spmpcfg_n[n*4 + 6].bits @
    spmpcfg_n[n*4 + 5].bits @
    spmpcfg_n[n*4 + 4].bits @
    spmpcfg_n[n*4 + 3].bits @
    spmpcfg_n[n*4 + 2].bits @
    spmpcfg_n[n*4 + 1].bits @
    spmpcfg_n[n*4 + 0].bits
  }
}

/* Helpers to handle locked entries */
function spmpLocked(cfg: Spmpcfg_ent) -> bool =
   cfg[L] == 0b1

function spmpTORLocked(cfg: Spmpcfg_ent) -> bool =
   (cfg[L] == 0b1) & (spmpAddrMatchType_of_bits(cfg[A]) == TOR)

/* Check if SPMP entry write is allowed based on privilege level and lock status.
 * 
 * L bit access control rules:
 * - M-mode: Can always read/write L bit and modify locked entries
 * - S-mode: Cannot modify locked entries (writes are ignored when L=1)
 * - The L bit is only accessible to M-mode for writes
 */
function spmpWriteCfg(n: range(0, 63), cfg: Spmpcfg_ent, v: bits(8), priv: Privilege) -> Spmpcfg_ent = {
  // Check if entry is locked and current privilege
  let is_locked = spmpLocked(cfg);
  let is_machine_mode = (priv == Machine);
  
  // If locked and not in M-mode, ignore write completely
  if is_locked & not(is_machine_mode) then cfg
  else {
    // Create new configuration from input value
    // Preserve reserved bit[5] (WPRI) and allow modification of other fields  
    let new_cfg = Mk_Spmpcfg_ent((v & 0xDF) | (cfg.bits & 0x20));
    
    // L bit access control: Only M-mode can modify L bit
    let new_cfg = if not(is_machine_mode) then [new_cfg with L = cfg[L]] else new_cfg;

    // "The R, W, and X fields form a collective WARL field for which the combinations with R=0 and W=1 are reserved."
    // In this implementation if R=0 and W=1 then R, W and X are all set to 0.
    // This is the least risky option from a security perspective.
    let new_cfg = if new_cfg[W] == 0b1 & new_cfg[R] == 0b0 then [new_cfg with X = 0b0, W = 0b0, R = 0b0] else new_cfg;

    new_cfg
  }
}

function spmpWriteCfgReg(n : range(0, 15), v : xlenbits) -> unit = {
  if xlen == 32
  then {
    foreach (i from 0 to 3) {
      let idx = n*4 + i;
      spmpcfg_n[idx] = spmpWriteCfg(idx, spmpcfg_n[idx], v[8*i+7 .. 8*i], cur_privilege);
    }
  }
  else {
    assert(n % 2 == 0, "Unexpected spmp config reg write");
    foreach (i from 0 to 7) {
      let idx = n*4 + i;
      spmpcfg_n[idx] = spmpWriteCfg(idx, spmpcfg_n[idx], v[8*i+7 .. 8*i], cur_privilege);
    }
  }
}

/* SPMP address register write with privilege-aware locking.
 * 
 * Address register write rules:
 * - M-mode: Can always write to address registers, even for locked entries
 * - S-mode: Cannot write to address registers of locked entries
 * - S-mode: Cannot write to spmpaddr[i-1] if spmp[i]cfg is locked and A=TOR
 */
function spmpWriteAddr(locked: bool, tor_locked: bool, reg: xlenbits, v: xlenbits, priv: Privilege) -> xlenbits = {
  let is_machine_mode = (priv == Machine);
  
  if xlen == 32
  then { 
    if (locked | tor_locked) & not(is_machine_mode) then reg else v 
  }
  else { 
    if (locked | tor_locked) & not(is_machine_mode) then reg else zero_extend(v[53..0]) 
  }
}

function spmpWriteAddrReg(n : range(0, 63), v : xlenbits) -> unit = {
  // Get current privilege for L bit access control
  let priv = cur_privilege;
  
  spmpaddr_n[n] = spmpWriteAddr(
    spmpLocked(spmpcfg_n[n]),
    if n + 1 < 64 then spmpTORLocked(spmpcfg_n[n + 1]) else false,
    spmpaddr_n[n],
    v,
    priv
  );
}


/*=======================================================================================*/
// spmpswitch - SPMP domain switch register (RV64 and RV32)
function clause is_CSR_defined(0x1F0) = sys_spmp_enabled
function clause read_CSR(0x1F0) = spmpswitch
function clause write_CSR(0x1F0, value) = {
  // spmpswitch register can be written by both M-mode and S-mode
  spmpswitch = value;
  spmpswitch
}

// spmpswitchh - SPMP domain switch register high (RV32 only)
function clause is_CSR_defined(0x1F1) = sys_spmp_enabled & (xlen == 32)
function clause read_CSR(0x1F1) = {
  if xlen == 32
  then zero_extend(spmpswitchh)
  else zero_extend(0x0)
}
function clause write_CSR(0x1F1, value) = {
  if xlen == 32
  then {
    spmpswitchh = value[31..0];
    zero_extend(spmpswitchh)
  }
  else zero_extend(0x0)
}

/* Get the effective switch register value for 64-bit view */
function spmpGetFullSwitchReg() -> bits(64) = {
  if xlen == 32
  then spmpswitchh @ spmpswitch[31..0]
  else zero_extend(spmpswitch)
}

/* Initialize SPMP switch registers on reset */
function spmpSwitchReset() -> unit = {
  spmpswitch = zero_extend(0x0);
  spmpswitchh = 0x00000000;
}

/* SPMP CSRs */

// spmpcfgN
function clause is_CSR_defined(0x1A) @ idx : bits(4) = sys_spmp_enabled & (idx[0] == bitzero | xlen == 32)
function clause read_CSR(0x1A @ idx : bits(4) if idx[0] == bitzero | xlen == 32) = spmpReadCfgReg(unsigned(idx))
function clause write_CSR((0x1A @ idx : bits(4), value) if idx[0] == bitzero | xlen == 32) = {
  let idx = unsigned(idx);
  spmpWriteCfgReg(idx, value);
  spmpReadCfgReg(idx)
}

// spmpaddrN. Unfortunately the SPMP index does not nicely align with the CSR index bits.
// TODO: It needs to be modified to indirect access
function clause is_CSR_defined(0x1B) @ idx : bits(4) = sys_spmp_enabled
function clause is_CSR_defined(0x1C) @ idx : bits(4) = sys_spmp_enabled
function clause is_CSR_defined(0x1D) @ idx : bits(4) = sys_spmp_enabled
function clause is_CSR_defined(0x1E) @ idx : bits(4) = sys_spmp_enabled

function clause read_CSR(0x1B @ idx : bits(4)) = spmpaddr_n[unsigned(0b00 @ idx)]
function clause read_CSR(0x1C @ idx : bits(4)) = spmpaddr_n[unsigned(0b01 @ idx)]
function clause read_CSR(0x1D @ idx : bits(4)) = spmpaddr_n[unsigned(0b10 @ idx)]
function clause read_CSR(0x1E @ idx : bits(4)) = spmpaddr_n[unsigned(0b11 @ idx)]

function clause write_CSR(0x1B @ idx : bits(4), value) = { let idx = unsigned(0b00 @ idx); spmpWriteAddrReg(idx, value); spmpaddr_n[idx] }
function clause write_CSR(0x1C @ idx : bits(4), value) = { let idx = unsigned(0b01 @ idx); spmpWriteAddrReg(idx, value); spmpaddr_n[idx] }
function clause write_CSR(0x1D @ idx : bits(4), value) = { let idx = unsigned(0b10 @ idx); spmpWriteAddrReg(idx, value); spmpaddr_n[idx] }
function clause write_CSR(0x1E @ idx : bits(4), value) = { let idx = unsigned(0b11 @ idx); spmpWriteAddrReg(idx, value); spmpaddr_n[idx] }
