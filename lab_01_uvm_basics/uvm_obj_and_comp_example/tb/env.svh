/*!
 * @author radigast
 */


class env extends uvm_env;
    `uvm_component_utils(env)
    
    my_top_comp m_my_top_comp_0;
    // insert component declaration here --> (step 1)

   
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    extern function void build_phase(uvm_phase phase);    

endclass


function void env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_my_top_comp_0 = my_top_comp::type_id::create("m_my_top_comp_0", this);
    // insert component creation here --> (step 1)

endfunction
