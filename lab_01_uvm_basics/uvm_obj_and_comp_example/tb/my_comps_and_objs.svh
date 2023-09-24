/*!
 * @author radigast
 */

class my_obj_a extends uvm_object;
    `uvm_object_utils(my_obj_a)

    function new();
      `uvm_info("MY_COMPS", "print from my_obj_a new", UVM_NONE);
    endfunction
    
endclass
 
// Insert your component implementation here --> (step 1)
class my_comp_a extends uvm_component;
    `uvm_component_utils(my_comp_a)
    
    my_obj_a m_my_obj_a;
    
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction
    
    function void build_phase(uvm_phase phase);
       `uvm_info("MY_COMPS", "print from my_comp_a build_phase (start)", UVM_NONE);

	m_my_obj_a = my_obj_a::type_id::create("m_my_obj_a");
       
       `uvm_info("MY_COMPS", "print from my_comp_a build_phase (end)", UVM_MEDIUM);
    endfunction
endclass

class my_comp_b extends uvm_component;
    `uvm_component_utils(my_comp_b)
    
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction
    
    function void build_phase(uvm_phase phase);
       `uvm_info("MY_COMPS", "print from my_comp_b build_phase (start)", UVM_NONE);

       `uvm_info("MY_COMPS", "print from my_comp_b build_phase (end)", UVM_MEDIUM);
    endfunction
endclass

 
class my_top_comp extends uvm_component;
    `uvm_component_utils(my_top_comp)

    
    // Insert your component declaration here --> (step 1)
    my_comp_a m_my_comp_a;
    my_comp_b m_my_comp_b;

   
    function new( string name , uvm_component parent );
        super.new( name , parent );
    endfunction

    function void build_phase(uvm_phase phase);
       `uvm_info("MY_COMPS", "print from my_top_comp build_phase (start)", UVM_NONE);
        
        // Insert your component creation here --> (step 1)
        m_my_comp_a = my_comp_a::type_id::create("m_my_comp_a", this);
        m_my_comp_b = my_comp_b::type_id::create("m_my_comp_b", this);

       `uvm_info("MY_COMPS", "print from my_top_comp build_phase (end)", UVM_MEDIUM);
    endfunction

endclass
