/*!
 * @author radigast
 */

// --> define derrived objects and components here (step 3)
class my_new_comp_a extends my_comp_a;
    `uvm_component_utils(my_new_comp_a)
     
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction
endclass

class my_new_comp_b extends my_comp_b;
    `uvm_component_utils(my_new_comp_b)

    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction
endclass


class test_example extends uvm_test;

    `uvm_component_utils(test_example)

    env m_env;

    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);  
    extern task run_phase(uvm_phase phase);

endclass


function void test_example::build_phase(uvm_phase phase);

  `uvm_info("LAB01", "FACTORY OVERRIDE STUFF", UVM_NONE) 

   // insert factory overrides here ->> (step 3)
   factory.set_inst_override_by_name("my_comp_a", "my_new_comp_a", {get_full_name(), ".m_env.m_my_top_comp_1*"});
   factory.set_type_override_by_name("my_comp_b", "my_new_comp_b");

   `uvm_info("LAB01", "FACTORY INFO", UVM_NONE) 
   factory.print();

   `uvm_info("LAB01", "BUILDING ENV", UVM_NONE) 
    m_env = env::type_id::create("m_env" , this);
endfunction

 function void test_example::end_of_elaboration_phase(uvm_phase phase);        
    uvm_top.print_topology();
 endfunction

task test_example::run_phase(uvm_phase phase);
    
    `uvm_info("LAB01", "RUN PHASE EMPTY IN THIS LAB", UVM_NONE) 

endtask
