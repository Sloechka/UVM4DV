module uvm_example_1;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class Producer extends uvm_component;
        `uvm_component_utils(Producer)

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

    class Wrapper2 extends uvm_component;
        `uvm_component_utils(Wrapper2)

        Producer prod;

        uvm_blocking_put_export#(int) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            prod = Producer::type_id::create("prod", this);
            p_export = new("p_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            prod.p_port.connect(p_export);
        endfunction

    endclass

    class Consumer extends uvm_component;
        `uvm_component_utils(Consumer)

        uvm_blocking_put_imp#(int, Consumer) p_imp;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            p_imp = new("p_imp", this);
        endfunction

        virtual task put(int t);
            `uvm_info(get_name(),
                $sformatf("Got %0d", t), UVM_LOW);
        endtask

    endclass

    class Wrapper3 extends uvm_component;
        `uvm_component_utils(Wrapper3)

        Consumer cons;

        uvm_blocking_put_export#(int) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            cons = Consumer::type_id::create("cons", this);
            p_export = new("p_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            p_export.connect(cons.p_imp);
        endfunction

    endclass

    class Wrapper1 extends uvm_test;
        `uvm_component_utils(Wrapper1)

        Wrapper2 wr2;
        Wrapper3 wr3;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            wr2 = Wrapper2::type_id::create("wr2", this);
            wr3 = Wrapper3::type_id::create("wr3", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            wr2.p_export.connect(wr3.p_export);
        endfunction

    endclass


    initial begin
        run_test("my_test");
    end


endmodule