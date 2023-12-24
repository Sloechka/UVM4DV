class reset_driver extends uvm_driver;

    `uvm_component_utils(reset_driver)

    virtual reset_if rst_vi;

    int reset_time_ps;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        assert(uvm_resource_db#(virtual reset_if)::read_by_type(get_full_name(), rst_vi, this))
        else $fatal(-1, "Can't access axis_if by %s", get_full_name());

        // `uvm_info(get_full_name(), $sformatf("reset time in ps = %d", reset_time_ps), UVM_NONE)
    endfunction: build_phase

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info(get_full_name(), "driving reset", UVM_NONE)

        rst_vi.rst_n <= 0;
        #(reset_time_ps * 1ps);
        rst_vi.rst_n <= 1'b1;

        `uvm_info(get_full_name(), "reset done", UVM_NONE)

        phase.drop_objection(this);
    endtask: reset_phase

endclass: reset_driver