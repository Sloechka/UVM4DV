class axis_agent_cfg extends uvm_object;

    `uvm_object_utils(axis_agent_cfg)
  
    uvm_active_passive_enum is_active;
  
    function new(string name = "");
        super.new(name);
    endfunction
  
endclass: axis_agent_cfg