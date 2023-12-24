class reset_agent_cfg extends uvm_object;

    `uvm_object_utils(reset_agent_cfg)
  
    rand int reset_time_ps;

    constraint rst_cnstr {
        reset_time_ps inside {[1:1000]};
    }
  
    function new(string name = "");
        super.new(name);
    endfunction
  
endclass: reset_agent_cfg