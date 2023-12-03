/**
 * @author radigast
 */

class dstream_driver extends uvm_driver#(dstream_item);
  `uvm_component_utils(dstream_driver)

  // Config
  dstream_config  m_config;

  // Interface
    // Interface
  virtual dstream_if.drv_mp m_vif;

  // Constructor
  function new (string name = "dstream_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  // Helper Methods
  extern virtual task drv_init();
  extern virtual task drv_interface();

endclass: dstream_driver

function void dstream_driver::build_phase(input uvm_phase phase);
  super.build_phase(phase);

  // Grab the Config
  m_config = dstream_config::get_config(this);
  m_vif = m_config.m_dstream_vif.drv_mp;

endfunction: build_phase


function void dstream_driver::connect_phase(input uvm_phase phase);

endfunction: connect_phase

task dstream_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  drv_init();

  fork
    drv_interface();
  join

endtask: run_phase

task dstream_driver::drv_init();
  `uvm_info( "DSTREAM_AGENT" ,  $sformatf("start of reset phase"), UVM_DEBUG);
  m_vif.d_master    <= 0;
  m_vif.d_valid       <= 0;
  @(posedge m_vif.rst_n);
  @(m_vif.drv_cb);
 `uvm_info( "DSTREAM_AGENT" ,  $sformatf("end of reset phase"), UVM_DEBUG);
endtask: drv_init


task dstream_driver::drv_interface();

  forever begin
    // Get and item from the seq item port
    seq_item_port.get(req);

    // Construct Response
    rsp = RSP::type_id::create("rsp", this);

    // Copy Req ID to Rsp ID
    rsp.copy(req); // copy contents
    rsp.set_id_info(req); // copy sequence item id

    m_vif.d_master   <= req.m_master_data;
    m_vif.d_valid      <= 1;
    @(m_vif.drv_cb);
    rsp.m_slave_data = m_vif.d_slave;
    m_vif.d_valid      <= 0;
    
    `uvm_info( "DSTREAM_AGENT", $sformatf("finish transaction:: %s", rsp.convert2string()), UVM_DEBUG);

    // Return Response to Sequence
    seq_item_port.put(rsp);

  end
endtask: drv_interface

