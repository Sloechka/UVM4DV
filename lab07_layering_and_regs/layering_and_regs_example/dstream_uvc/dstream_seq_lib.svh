/**
 * @author radigast
 */

class dstream_seq extends uvm_sequence#(dstream_item);
  `uvm_object_utils(dstream_seq)

  rand logic [31:0] m_master_data;
       logic [31:0] m_slave_data;

   // Constructor
  function new(string name = "dstream_seq");
    super.new(name);
  endfunction: new

  // Sequence Body
  task body();

    req = REQ::type_id::create("req", null, get_full_name());
  
    start_item(req);
  
    if (!req.randomize() with {
      m_master_data == local::m_master_data;
    }) begin
      `uvm_fatal(get_name(), "randomize failed")
    end
  
    finish_item(req);
  
    get_response(rsp);

    m_slave_data = rsp.m_slave_data;

  endtask: body
  
endclass: dstream_seq