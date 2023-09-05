/*!
 * @author radigast
 */

// Insert your component implementation here --> (step 1)

 
class my_top_comp extends uvm_component;
    `uvm_component_utils(my_top_comp)
    
    
    // Insert your component declaration here --> (step 1)
    //my_comp_a m_my_comp_a;

   
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    function void build_phase(uvm_phase phase);
       `uvm_info("MY_COMPS", "print from my_top_comp build_phase (start)", UVM_NONE);
        
        // Insert your component creation here --> (step 1)
        //m_my_comp_a = my_comp_a::type_id::create("m_my_comp_a", this);

       `uvm_info("MY_COMPS", "print from my_top_comp build_phase (end)", UVM_MEDIUM);
    endfunction

endclass