module uvm_example_5;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class Transaction extends uvm_object;
        `uvm_object_utils(Transaction)

        rand bit        req;
        rand bit        ack;
        rand bit [31:0] data;

        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string str;
            str = {str, $sformatf("\nreq : %1b",   req )};
            str = {str, $sformatf("\nack : %1b",   ack )};
            str = {str, $sformatf("\ndata: 0x%8h", data)};
            return str;
        endfunction

    endclass

    class Producer extends uvm_component;
        `uvm_component_utils(Producer)

        // Transaction handle
        Transaction tr;

        uvm_analysis_port#(Transaction) p_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            p_port = new("p_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            repeat(5) begin
                tr = new("tr");
                void'(tr.randomize());
                p_port.write(tr);
            end
            phase.drop_objection(this);
        endtask

    endclass

    class Wrapper2 extends uvm_component;
        `uvm_component_utils(Wrapper2)

        Producer prod;

        uvm_analysis_export#(Transaction) p_export;

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

    `uvm_analysis_imp_decl(_0)
    `uvm_analysis_imp_decl(_1)
    `uvm_analysis_imp_decl(_2)

    class Consumer extends uvm_component;
        `uvm_component_utils(Consumer)

        uvm_analysis_imp_0#(Transaction, Consumer) p_imp_0;
        uvm_analysis_imp_1#(Transaction, Consumer) p_imp_1;
        uvm_analysis_imp_2#(Transaction, Consumer) p_imp_2;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            p_imp_0 = new("p_imp_0", this);
            p_imp_1 = new("p_imp_1", this);
            p_imp_2 = new("p_imp_2", this);
        endfunction

        virtual function void write_0(Transaction t);
            Transaction t_ = new("tr");
            t_.copy(t);
            `uvm_info(get_name(),
                $sformatf("Got 0: %s", t.convert2string()), UVM_LOW);
        endfunction

        virtual function void write_1(Transaction t);
            Transaction t_ = new("tr");;
            t_.copy(t);
            `uvm_info(get_name(),
                $sformatf("Got 1: %s", t.convert2string()), UVM_LOW);
        endfunction

        virtual function void write_2(Transaction t);
            Transaction t_ = new("tr");;
            t_.copy(t);
            `uvm_info(get_name(),
                $sformatf("Got 2: %s", t.convert2string()), UVM_LOW);
        endfunction

    endclass

    class Wrapper3 extends uvm_component;
        `uvm_component_utils(Wrapper3)

        Consumer cons;

        uvm_analysis_export#(Transaction) p_export;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            cons = Consumer::type_id::create("cons", this);
            p_export = new("p_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            p_export.connect(cons.p_imp_0);
            p_export.connect(cons.p_imp_1);
            p_export.connect(cons.p_imp_2);
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