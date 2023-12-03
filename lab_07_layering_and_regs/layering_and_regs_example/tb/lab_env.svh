/*!
 * @author radigast
 */

// (step 3) -->  изучить
class lab_env extends uvm_env;
    `uvm_component_utils(lab_env)

    lab_env_config m_config;
    dstream_agent  m_dstream_agent;
    a_layer_agent  m_a_layer_agent;
    cam_reg_env    m_reg_env;

    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(input uvm_phase phase);
    
endclass


function void lab_env::build_phase(uvm_phase phase);
    if (uvm_report_enabled(UVM_DEBUG))  uvm_resource_db#()::dump();

    ///-----------------------------------------------------------------------------
    /// get external configuration
    ///-----------------------------------------------------------------------------
    m_config = lab_env_config::get_config(this);
    `uvm_info(get_full_name(),"configuration::", UVM_NONE);
    m_config.print();

    ///-----------------------------------------------------------------------------
    /// config components
    ///-----------------------------------------------------------------------------
    uvm_config_db #(dstream_config)::set(this, "m_dstream_agent*", "dstream_config", m_config.m_dstream_agent_config);    

    ///-----------------------------------------------------------------------------
    /// create  components
    ///-----------------------------------------------------------------------------
    m_dstream_agent = dstream_agent::type_id::create("m_dstream_agent", this);
    // (step 3) --> uncomment
    //m_a_layer_agent = a_layer_agent::type_id::create("m_a_layer_agent", this);
    // (step 4) --> uncomment
    //m_reg_env = cam_reg_env::type_id::create ("m_reg_env", this);

endfunction

function void lab_env::connect_phase(input uvm_phase phase);
    //layering    
    // (step 3) --> uncomment
    //m_a_layer_agent.m_driver.connect_sequencer(m_dstream_agent.m_sequencer);
    //m_dstream_agent.m_monitor.m_analysis_port.connect(m_a_layer_agent.m_monitor.analysis_export);

    //reg model
    // (step 4) --> uncomment
    //m_a_layer_agent.m_monitor.m_analysis_port.connect (m_reg_env.m_a_layer2reg_predictor.bus_in);
    //m_reg_env.m_ral_model.default_map.set_sequencer(m_a_layer_agent.m_sequencer, m_reg_env.m_reg2a_layer);
 
endfunction: connect_phase

