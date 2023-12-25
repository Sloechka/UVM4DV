/**
 * @author radigast
 */

class dstream_sequencer extends uvm_sequencer#(dstream_item);
  `uvm_component_utils(dstream_sequencer)

  // Constructor
  function new (string name = "dstream_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

endclass: dstream_sequencer
