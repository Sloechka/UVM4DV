class dummy_test extends uvm_test;

    `uvm_component_utils(dummy_test)

    dummy_env env;

    axis_agent_cfg axis_cfg;
    reset_agent_cfg reset_cfg;

    int run_count;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        axis_cfg = axis_agent_cfg::type_id::create("axis_cfg", this);
        axis_cfg.is_active = UVM_ACTIVE;
        uvm_resource_db#(axis_agent_cfg)::set("*axis_ag", "cfg", axis_cfg);

        reset_cfg = reset_agent_cfg::type_id::create("reset_cfg");
        assert(reset_cfg.randomize());
        uvm_resource_db#(reset_agent_cfg)::set("*reset_ag", "cfg", reset_cfg);

        env = dummy_env::type_id::create("env", this);
    endfunction: build_phase

    virtual task main_phase(uvm_phase phase);
        dummy_sequence seq;
        seq = dummy_sequence::type_id::create("seq");

        phase.raise_objection(this);
        seq.start(env.axis_ag.sequencer);
        phase.drop_objection(this);
    endtask: main_phase

    // Rerun test
    virtual function void phase_ready_to_end(uvm_phase phase);
        super.phase_ready_to_end(phase);
        if(phase.get_imp() == uvm_shutdown_phase::get()) begin
            if(run_count == 0) begin
                phase.jump(uvm_pre_reset_phase::get());
                run_count++;
            end
        end
    endfunction: phase_ready_to_end

endclass: dummy_test