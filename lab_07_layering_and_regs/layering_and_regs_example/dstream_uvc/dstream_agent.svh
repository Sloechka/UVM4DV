/**
 * @author radigast
 */

class dstream_agent extends uvm_agent;
  `uvm_component_utils(dstream_agent)

  dstream_config m_config;

  // Child Components
  dstream_sequencer m_sequencer;
  dstream_driver    m_driver;
  dstream_monitor   m_monitor;

  // Constructor
  function new(string name = "dstream_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass: dstream_agent

function void dstream_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_config = dstream_config::get_config(this);

  m_sequencer = dstream_sequencer::type_id::create("m_sequencer", this);
  m_driver = dstream_driver::type_id::create("m_driver", this);

  m_monitor = dstream_monitor::type_id::create("m_monitor", this);


endfunction: build_phase


function void dstream_agent::connect_phase(input uvm_phase phase);
  super.connect_phase(phase);

  // Connect
  m_driver.seq_item_port.connect(m_sequencer.seq_item_export);

endfunction: connect_phase
