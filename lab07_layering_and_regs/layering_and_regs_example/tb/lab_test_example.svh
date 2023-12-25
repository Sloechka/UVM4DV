/*!
 * @author radigast
 */

class lab_virtual_sequence_example extends uvm_sequence;

    `uvm_object_utils(lab_virtual_sequence_example)

    // (step 3) --> изучить
    dstream_sequencer m_dstream_sequencer;
    a_layer_sequencer m_a_layer_sequencer;
    ral_sys_cam       m_ral_model;

    function new (string name = "virtual_sequence_base");
        super.new(name);
    endfunction: new

    task test_access_using_dstream_sequencer();
        dstream_seq my_seq;
        `uvm_info("TEST_LOG", "example of direct sequence usage. Write and read ctrl reg", UVM_NONE);
        // (step 2) --> выполните проверку корректности записи и чтения в регистра ctrl, 
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'hff001000;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'h0001;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'h00001000;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'h0;});
        // (step 2) --> проверьте корректность установки бита valid при записи в память
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'hff002000;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'hbeef;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'h00001004;});
        `uvm_do_on_with(my_seq, m_dstream_sequencer, {m_master_data==32'h0;});  
      
    endtask


    task test_access_using_a_layer_sequencer();
        a_layer_seq my_layer_seq;
        `uvm_info("TEST_LOG", "example of layered sequence usage ", UVM_NONE);
        // (step 3) --> выполните проверку корректности записи и чтения в регистра ctrl
        // (step 3) --> проверьте корректность установки бита valid при записи в память
        // пример записи в регистр ctrl
        `uvm_do_on_with(my_layer_seq, m_a_layer_sequencer, {m_addr==32'h1000; m_data==32'h1; m_tran_type==A_LAYER_WRITE;});

    endtask

    task test_access_using_reg_model();
        uvm_status_e      status;
        bit               predict_status;
        int               rdata;
        uvm_reg_data_t    write_data[];
        `uvm_info("TEST_LOG", "example of register layer usage ", UVM_NONE);
        
        // (step 4) --> проверьте корректность установки бита valid при записи в память
        // (step 4) --> проверьте корректность поиска при mode=1 
        // (step 4) --> проверьте корректность поиска при mode=2
        // (step 4) --> проверьте стабильность регистра result_reg при mode=0
        // пример тестирования регистра ctrl
        `uvm_info("TEST_LOG", "check ctrl reset state ", UVM_NONE);
        m_ral_model.regs.ctrl.mirror(status, .check(UVM_CHECK) );

        `uvm_info("TEST_LOG", "check ctrl write operation ", UVM_NONE);
        m_ral_model.regs.ctrl.mode.set(1);
        m_ral_model.regs.ctrl.update(status);
        m_ral_model.regs.ctrl.mirror(status, .check(UVM_CHECK) );

     

    endtask

    task body();
        // (step 2) --> используйте функцию test_access_using_dstream_sequencer
        test_access_using_dstream_sequencer();
        // (step 3) --> используйте функцию test_access_using_a_layer_sequencer
        test_access_using_a_layer_sequencer();
        // (step 4) --> используйте функцию test_access_using_reg_model
        //test_access_using_reg_model();
    endtask: body

  endclass
  


class lab_test_example extends uvm_test;

    `uvm_component_utils(lab_test_example)
    
    lab_env_config env_config;
    lab_env m_env;

    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

// (step 3) --> изучить
function void lab_test_example::build_phase(uvm_phase phase);
    virtual dstream_if dstream_vif;

    env_config = new("lab_env_cfg");    
    void'(uvm_pkg::uvm_config_db #(virtual dstream_if)::get(null, "tb_top.dstream_if0", "dstream_vif", dstream_vif));
    env_config.m_dstream_agent_config.m_dstream_vif = dstream_vif;
    uvm_pkg::uvm_config_db #(lab_env_config)::set(null, "uvm_test_top.m_env", "lab_env_config", env_config);
    
    m_env = lab_env::type_id::create("m_env" , this);

    uvm_pkg::uvm_config_db #(int)::set(this, "*", "recording_detail", UVM_FULL);    

endfunction

// (step 3) --> изучить
function void lab_test_example::end_of_elaboration_phase(uvm_phase phase);
    if (uvm_report_enabled(UVM_DEBUG)) begin
        factory.print();
        uvm_top.print_topology();
        m_env.m_reg_env.m_ral_model.print();
    end
endfunction

// (step 3) --> изучить
task lab_test_example::run_phase(uvm_phase phase);
    lab_virtual_sequence_example test_seq;

    phase.raise_objection(this, "Starting sequences");
    test_seq = lab_virtual_sequence_example::type_id::create("test_seq");
    test_seq.m_dstream_sequencer = m_env.m_dstream_agent.m_sequencer;
    // (step 3) --> uncomment
    test_seq.m_a_layer_sequencer = m_env.m_a_layer_agent.m_sequencer;
    // (step 4) --> uncomment
    //test_seq.m_ral_model         = m_env.m_reg_env.m_ral_model;
    
    test_seq.start(null);
    phase.drop_objection(this, "Complete sequences");

endtask

