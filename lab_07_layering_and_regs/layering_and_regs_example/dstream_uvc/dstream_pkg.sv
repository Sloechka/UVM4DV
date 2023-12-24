/**
 * @author radigast
 */

`ifndef DSTREAM_PKG__SV
`define DSTREAM_PKG__SV

`include "dstream_if.sv"

package dstream_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Include the Agent files
  `include "dstream_item.svh"
  `include "dstream_config.svh"
  `include "dstream_sequencer.svh"
  `include "dstream_driver.svh"
  `include "dstream_monitor.svh"
  `include "dstream_agent.svh"
  `include "dstream_seq_lib.svh"

endpackage: dstream_pkg

`endif // DSTREAM_PKG__SV