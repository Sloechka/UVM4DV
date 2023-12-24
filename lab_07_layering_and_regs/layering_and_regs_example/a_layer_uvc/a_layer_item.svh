/**
  * @author radigast
 */

 // (step 3) -->  изучить
 class a_layer_item extends uvm_sequence_item;
    rand logic        [31:0] m_addr;      // addr
    rand logic        [31:0] m_data;      // data 
    rand a_layer_tran_type_e m_tran_type; // read or write
     // Constructor
    function new (string name = "a_layer_item");
      super.new(name);
    endfunction: new
  
    virtual function string convert2string();
      string contets="";                              
      $sformat(contets, "%s A_LAYER_TRAN: ", contets);
      $sformat(contets, "%s type:      %s", contets, m_tran_type.name);
      $sformat(contets, "%s addr:      %8x", contets, m_addr);
      $sformat(contets, "%s data:      %8x", contets, m_data);
      return contets;
    endfunction
  
  
    // Field Macros
    `uvm_object_utils_begin(a_layer_item)
      `uvm_field_int(m_addr, UVM_ALL_ON)
      `uvm_field_int(m_data, UVM_ALL_ON)
      `uvm_field_enum(a_layer_tran_type_e, m_tran_type, UVM_ALL_ON)
    `uvm_object_utils_end
  
  
  endclass: a_layer_item
  
  