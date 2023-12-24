/**
  * @author radigast
 */

class dstream_item extends uvm_sequence_item;

  rand logic [31:0] m_master_data;  // data from master
       logic [31:0] m_slave_data;   // data from slave
  
   // Constructor
  function new (string name = "dstream_item");
    super.new(name);
  endfunction: new

  virtual function string convert2string();
    string contets="";                              
    $sformat(contets, "%s DSTREAM_TRAN: ", contets);
    $sformat(contets, "%s master_data:      %8x", contets, m_master_data);
    $sformat(contets, "%s slave_data:       %8x", contets, m_slave_data);
    return contets;
  endfunction


  // Field Macros
  `uvm_object_utils_begin(dstream_item)
    `uvm_field_int(m_master_data, UVM_ALL_ON)
    `uvm_field_int(m_slave_data, UVM_ALL_ON)
  `uvm_object_utils_end


endclass: dstream_item

