/**
 * @author radigast
 */

 // (step 3) -->  изучить
class a_layer_sequencer extends uvm_sequencer#(a_layer_item);
    `uvm_component_utils(a_layer_sequencer)
  
    // Constructor
    function new (string name = "a_layer_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
  
endclass: a_layer_sequencer