/**
 * @author radigast
 */

 class a_layer_agent extends uvm_agent;
    `uvm_component_utils(a_layer_agent)
  
    // Child Components
    a_layer_sequencer       m_sequencer;
    dstream2a_layer_monitor m_monitor;
    a_layer2dstream_driver  m_driver;

    // Constructor
    function new(string name = "a_layer_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction: new
  
    // Phase Methods
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
  
  endclass: a_layer_agent
  
  function void a_layer_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_driver = a_layer2dstream_driver::type_id::create("m_driver", this);

    // (step 3) --> создать копмоненты агента  

  endfunction: build_phase
  
  
  function void a_layer_agent::connect_phase(input uvm_phase phase);
    super.connect_phase(phase);
  
    // Connect
    // (step 3) --> подключит секвенсер к драйверу
  
  endfunction: connect_phase
  