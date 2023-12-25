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
        axis_sequence axis_seq1;
        axis_sequence axis_seq2;

        axis_seq1 = axis_sequence::type_id::create("axis_seq1");
        axis_seq2 = axis_sequence::type_id::create("axis_seq2");

        assert(axis_seq1.randomize());
        assert(axis_seq2.randomize());

        // env.axis_ag.sequencer.set_arbitration(SEQ_ARB_FIFO); // default
        // env.axis_ag.sequencer.set_arbitration(SEQ_ARB_RANDOM);
        // env.axis_ag.sequencer.set_arbitration(SEQ_ARB_STRICT_FIFO);
        // env.axis_ag.sequencer.set_arbitration(SEQ_ARB_STRICT_RANDOM);
        // env.axis_ag.sequencer.set_arbitration(SEQ_ARB_WEIGHTED);

        phase.raise_objection(this);
        fork
            axis_seq1.start(env.axis_ag.sequencer, .this_priority(100));
            axis_seq2.start(env.axis_ag.sequencer, .this_priority(200));
        join
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