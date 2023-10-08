module uvm_example_2;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class my_comp_1 extends uvm_component;
        `uvm_component_utils(my_comp_1)

        uvm_blocking_put_port#(int) p_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            p_port = new("p_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            repeat(10) begin
                p_port.put($urandom_range(1, 10));
            end
            phase.drop_objection(this);
        endtask

    endclass

    class my_comp_2 extends uvm_component;
        `uvm_component_utils(my_comp_2)

        my_comp_1 comp_1;

        uvm_blocking_put_export#(int) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            comp_1 = my_comp_1::type_id::create("comp_1", this);
            p_export = new("p_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            comp_1.p_port.connect(p_export);
        endfunction

    endclass

    class my_comp_3 extends uvm_component;
        `uvm_component_utils(my_comp_3)

        uvm_put_imp#(int, my_comp_3) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            p_export = new("p_export", this);
        endfunction

        virtual task put(int t);
            `uvm_info(get_name(),
                $sformatf("Got %0d", t), UVM_LOW);
        endtask

        virtual function bit try_put(int t);
            `uvm_info(get_name(),
                $sformatf("Got %0d", t), UVM_LOW);
            return 1;
        endfunction

        virtual function bit can_put();
            return 1;
        endfunction

    endclass

    class my_comp_4 extends uvm_component;
        `uvm_component_utils(my_comp_4)

        my_comp_3 comp_3;

        uvm_blocking_put_export#(int) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            comp_3 = my_comp_3::type_id::create("comp_3", this);
            p_export = new("p_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            p_export.connect(comp_3.p_export);
        endfunction

    endclass

    class my_test extends uvm_test;
        `uvm_component_utils(my_test)

        my_comp_2 comp_2;
        my_comp_4 comp_4;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            comp_2 = my_comp_2::type_id::create("comp_2", this);
            comp_4 = my_comp_4::type_id::create("comp_4", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            comp_2.p_export.connect(comp_4.p_export);
        endfunction

    endclass


    initial begin
        run_test("my_test");
    end


endmodule