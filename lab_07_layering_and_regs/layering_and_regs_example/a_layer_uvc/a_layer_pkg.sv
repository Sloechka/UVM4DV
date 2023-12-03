/**
 * @author radigast
 */

`ifndef A_LAYER_PKG__SV
`define A_LAYER_PKG__SV

package a_layer_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;


  typedef enum { 
    A_LAYER_READ,
    A_LAYER_WRITE
  } a_layer_tran_type_e;

  typedef enum { 
    A_LAYER_PHASE_ADDR,
    A_LAYER_PHASE_DATA
  } a_layer_phase_e;

  // Include the Agent files
  `include "a_layer_item.svh"
  `include "a_layer_sequencer.svh"
  `include "dstream2a_layer_monitor.svh"
  `include "a_layer2dstream_driver.svh"
  `include "a_layer_agent.svh"
  `include "a_layer_seq_lib.svh"
  `include "reg2a_layer_adapter.svh"

endpackage: a_layer_pkg

`endif // A_LAYER_PKG__SV