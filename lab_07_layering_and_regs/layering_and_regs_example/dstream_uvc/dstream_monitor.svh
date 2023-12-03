/**
 * @author radigast
 */

class dstream_monitor extends uvm_monitor;
  `uvm_component_utils(dstream_monitor)

  // Config
  dstream_config  m_config;

  // Interface
  virtual dstream_if.mon_mp m_vif;

  // Analysis Port
  uvm_analysis_port#(dstream_item) m_analysis_port;

  // Constructor
  function new (string name = "dstream_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  // Helper Methods
  extern virtual task mon_interface();

endclass: dstream_monitor


function void dstream_monitor::build_phase(input uvm_phase phase);
  super.build_phase(phase);

  // Grab the Config
  m_config = dstream_config::get_config(this);
  m_vif = m_config.m_dstream_vif.mon_mp;

  // Build the Analysis Ports
  m_analysis_port = new("m_analysis_port", this);

endfunction: build_phase


function void dstream_monitor::connect_phase(input uvm_phase phase);


endfunction: connect_phase

task dstream_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);

  fork
    mon_interface();
  join

endtask: run_phase

task dstream_monitor::mon_interface();
  dstream_item mon_item;

  forever begin

    `uvm_info( "DSTREAM_AGENT", $sformatf("wait for transaction"), UVM_DEBUG);

    mon_item = dstream_item::type_id::create("mon_item", this);
    void'(this.begin_tr(mon_item));

    // Wait for a d_valid access
    do begin
      @(m_vif.mon_cb);
    end while ((m_vif.mon_cb.d_valid)!==1'b1);

    // Collectr Monitored Item    
    mon_item.m_master_data = m_vif.d_master;
    mon_item.m_slave_data = m_vif.d_slave;

    this.end_tr(mon_item);

    `uvm_info( "DSTREAM_AGENT", $sformatf("transaction collected:: %s", mon_item.convert2string()), UVM_DEBUG);

    // Write the Item out
    m_analysis_port.write(mon_item);

  end

endtask: mon_interface
