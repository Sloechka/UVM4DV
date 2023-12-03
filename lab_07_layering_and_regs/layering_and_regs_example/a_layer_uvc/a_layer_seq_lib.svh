/**
 * @author radigast
 */
 
// (step 3) -->  изучить
 class a_layer_seq extends uvm_sequence#(a_layer_item);
    `uvm_object_utils(a_layer_seq)
  
    rand logic [31:0] m_addr;
    rand logic [31:0] m_data;
    rand a_layer_tran_type_e m_tran_type;
  
     // Constructor
    function new(string name = "a_layer_seq");
      super.new(name);
    endfunction: new
  
    // Sequence Body
    task body();
  
      req = REQ::type_id::create("req", null, get_full_name());
    
      start_item(req);
    
      if (!req.randomize() with {
        m_addr == local::m_addr;
        m_data == local::m_data;
        m_tran_type == local::m_tran_type;
      }) begin
        `uvm_fatal(get_name(), "randomize failed")
      end
    
      finish_item(req);
    
      get_response(rsp);
  
      if (m_tran_type == A_LAYER_READ) m_data = rsp.m_data;
  
    endtask: body
    
  endclass: a_layer_seq