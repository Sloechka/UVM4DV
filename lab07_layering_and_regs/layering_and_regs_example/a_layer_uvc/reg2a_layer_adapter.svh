
class reg2a_layer_adapter extends uvm_reg_adapter;
    `uvm_object_utils (reg2a_layer_adapter)
 
    function new (string name = "reg2a_layer_adapter");
       super.new (name);
       // (step 4) --> должен ли переходник ждать response?
      
    endfunction
 
    virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
      // (step 4) --> реализовать функцию переходника
      
    endfunction
 
    virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      // (step 4) --> реализовать функцию переходника
       
    endfunction
 endclass