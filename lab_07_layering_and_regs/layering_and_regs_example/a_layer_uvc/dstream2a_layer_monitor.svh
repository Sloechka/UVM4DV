/**
  * @author radigast
 */

class dstream2a_layer_monitor extends uvm_subscriber #(dstream_pkg::dstream_item);
  `uvm_component_utils(dstream2a_layer_monitor)

  // Analysis Port
  uvm_analysis_port#(a_layer_item) m_analysis_port; 


  a_layer_item    m_a_layer_mon_tran;

   // Constructor
  function new (string name = "dstream2a_layer_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
  
    // Build the Analysis Ports
    m_analysis_port = new("m_analysis_port", this);
  
  endfunction: build_phase

  function void write(dstream_pkg::dstream_item t);  
    `uvm_info( "A_LAYER_AGENT", $sformatf("down layer transaction recieved:: %s", t.convert2string()), UVM_DEBUG);
    // (step 3) --> реализуйте логику перевода потока транзакций DSTREAM с монитора ap нижнего уровня 
    // на ap верхнего уровня (a_layer m_analysis_port)
    // если потребуется модифицировать можно код монитора и за пределами данной функции
   
  endfunction

endclass