class reset_agent extends uvm_agent;

    `uvm_component_utils(reset_agent)

    reset_driver driver;

    reset_agent_cfg cfg;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        assert(uvm_resource_db#(reset_agent_cfg)::read_by_type(get_full_name(), cfg, this))
        else $fatal(-1, "Can't access reset_agent_cfg by %s", get_full_name());

        driver = reset_driver::type_id::create("driver", this);
        driver.reset_time_ps = cfg.reset_time_ps;
    endfunction: build_phase

endclass: reset_agent
