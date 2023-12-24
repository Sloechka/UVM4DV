class dummy_env extends uvm_env;

    `uvm_component_utils(dummy_env)
    
    reset_agent reset_ag;
    axis_agent axis_ag;
  
    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
        reset_ag = reset_agent::type_id::create("reset_ag", this);
        axis_ag = axis_agent::type_id::create("axis_ag", this);
    endfunction
  
endclass: dummy_env
