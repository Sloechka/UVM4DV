class axis_agent extends uvm_agent;

    `uvm_component_utils(axis_agent)

    uvm_analysis_port#(axis_transaction) an_port;

    axis_sequencer sequencer;
    axis_driver driver;
    axis_monitor monitor;

    axis_agent_cfg cfg;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        assert(uvm_resource_db#(axis_agent_cfg)::read_by_type(get_full_name(), cfg, this))
        else $fatal(-1, "Can't access axis_agent_cfg by %s", get_full_name());
        is_active = cfg.is_active;

        `uvm_info(get_full_name(), $sformatf("active == %b", is_active), UVM_NONE)

        an_port = new("an_port", this);
        monitor = axis_monitor::type_id::create("monitor", this);

        if(get_is_active) begin
            sequencer = axis_sequencer::type_id::create("sequencer", this);
            driver = axis_driver::type_id::create("driver", this);
        end
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        monitor.port.connect(an_port);

        if(get_is_active) begin
          driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction: connect_phase

    task pre_reset_phase(uvm_phase phase);
        if(get_is_active) begin
            `uvm_info(get_full_name(), "disabling sequencer & driver", UVM_NONE)
            sequencer.stop_sequences();
            ->driver.reset_driver;
        end
    endtask: pre_reset_phase

endclass: axis_agent
