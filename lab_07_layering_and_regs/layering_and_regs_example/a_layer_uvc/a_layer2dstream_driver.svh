/**
 * @author radigast
 */

 class a_layer2dstream_driver extends uvm_driver#(a_layer_item);
    `uvm_component_utils(a_layer2dstream_driver)

    dstream_pkg::dstream_sequencer m_dstream_sequencer;
  
    // Constructor
    function new (string name = "a_layer2dstream_driver", uvm_component parent = null);
      super.new(name, parent);
      m_dstream_sequencer = null;
    endfunction: new

    function void connect_sequencer (dstream_pkg::dstream_sequencer s);
        m_dstream_sequencer = s;
    endfunction

    // Phase Methods
    extern task run_phase(uvm_phase phase);

  endclass: a_layer2dstream_driver
  


  task a_layer2dstream_driver::run_phase(uvm_phase phase);
    dstream_pkg::dstream_seq d_seq;
    super.run_phase(phase);
    
    if (m_dstream_sequencer == null) `uvm_fatal("A_LAYER_AGENT", "m_dstream_sequencer is null use connect_sequencer...")

    forever begin
        // Get and item from the seq item port
        seq_item_port.get(req);
        `uvm_info( "A_LAYER_AGENT", $sformatf("start transaction:: %s", req.convert2string()), UVM_DEBUG);

        //  (step 4) --> реализовать логику перехода последовательности с уровня A_LAYER на 
        // уровень DSTREAM с использованием ссылки m_dstream_sequencer
        

        // Return Response to Sequence
        seq_item_port.put(rsp);
    
      end
  endtask: run_phase
  
  
  