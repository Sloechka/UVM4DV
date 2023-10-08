//-----------------------------------------------
// Module: lab_02
//-----------------------------------------------

// Template for hierarchy

module lab_02;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    // Trasnaction class

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

    //  ___________
    // |           |_
    // | Producer1 |_| port
    // |___________|
    // 

    class Producer1 extends uvm_component;
        `uvm_component_utils(Producer1)

        uvm_analysis_port#(Transaction) a_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            a_port = new("a_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            repeat(5) begin
                t = new("tr");
                void'(t.randomize());
                a_port.write(t);
            end
        endtask

    endclass

    //  ___________
    // |           |_
    // | Producer2 |_| port
    // |___________|
    // 

    class Producer2 extends uvm_component;
        `uvm_component_utils(Producer2)

        uvm_nonblocking_put_port#(Transaction) nbp_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            nbp_port = new("nbp_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            repeat(5) begin
                wait(nbp_port.can_put());
                t = new("tr");
                void'(t.randomize());
                void'(nbp_port.try_put(t));
            end
        endtask

    endclass

    //  ___________
    // |           |
    // | Producer3 |<> imp
    // |___________|
    // 

    class Producer3 extends uvm_component;
        `uvm_component_utils(Producer3)

        uvm_blocking_get_imp#(Transaction, Producer3) bg_imp;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            bg_imp = new("bg_imp", this);
        endfunction

        virtual task get(output Transaction t);
            t = new("tr");
            void'(t.randomize());
        endtask

    endclass

    //  ___________
    // |           |_
    // | Producer4 |_| port
    // |___________|
    // 

    class Producer4 extends Producer1;
        `uvm_component_utils(Producer4)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

    endclass

    //  ___________
    // |           |_
    // | Producer5 |_| port
    // |___________|
    // 

    class Producer5 extends Producer3;
        `uvm_component_utils(Producer5)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

    endclass

    //  ________________________
    // |  Wrapper1              |
    // |   ___________          |
    // |  |           |_        |_
    // |  | Producer1 |_|port-->|_|port
    // |  |___________|         |
    // |____________________ ___|  
    //  

    class Wrapper1 extends uvm_component;
        `uvm_component_utils(Wrapper1)

        Producer1 prod;

        uvm_analysis_port#(Transaction) a_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            prod = Producer1::type_id::create("prod", this);
            a_port = new("a_port", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            prod.a_port.connect(a_port);
        endfunction

    endclass

    //  ________________________
    // |  Wrapper3              |
    // |   ___________          |
    // |  |           |_        |_
    // |  | Producer2 |_|port-->|_|export
    // |  |___________|         |
    // |____________________ ___|  
    //  

    class Wrapper3 extends uvm_component;
        `uvm_component_utils(Wrapper3)

        Producer2 prod;

        uvm_nonblocking_put_export#(Transaction) nbp_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            prod = Producer2::type_id::create("prod", this);
            nbp_export = new("nbp_port", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            prod.nbp_port.connect(nbp_export);
        endfunction

    endclass

    //  ________________________
    // |  Wrapper4              |
    // |   ___________          |
    // |  |           |         |
    // |  | Producer3 |<>imp--->|<>export
    // |  |___________|         |
    // |____________________ ___|  
    //  

    class Wrapper4 extends uvm_component;
        `uvm_component_utils(Wrapper4)

        Producer3 prod;

        uvm_blocking_get_export#(Transaction) bg_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            prod = Producer3::type_id::create("prod", this);
            bg_export = new("bg_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            bg_export.connect(prod.bg_imp);
        endfunction

    endclass

    //  _______________________
    // |  Wrapper5             |
    // |   ___________         |
    // |  |           |        |_
    // |  | Producer5 |<>imp-->|_|export
    // |  |___________|        |
    // |_______________________|  
    //  

    class Wrapper5 extends uvm_component;
        `uvm_component_utils(Wrapper5)

        Producer5 prod5;

        uvm_blocking_get_export#(Transaction) bg_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            prod5 = Producer5::type_id::create("prod5", this);
            bg_export = new("bg_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            bg_export.connect(prod5.bg_imp);
        endfunction

    endclass

    //  ______________________________________
    // |  Wrapper6                            |
    // |   _______________________            |
    // |  |  Wrapper5             |           |
    // |  |   ___________         |           |
    // |  |  |           |_       |           |
    // |  |  | Producer5 |_|imp-->|<>export-->|<>export
    // |  |  |___________|        |           |
    // |  |_______________________|           |
    // |______________________________________|   
    // 

    class Wrapper6 extends uvm_component;
        `uvm_component_utils(Wrapper6)

        Wrapper5 wrap5;

        uvm_blocking_get_export#(Transaction) bg_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            wrap5 = Wrapper5::type_id::create("wrap5", this);
            bg_export = new("bg_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            bg_export.connect(wrap5.bg_export);
        endfunction

    endclass

    //        ________________
    //       |                |
    //  imp<>|                |
    //       |    Consumer1   |
    //  imp<>|                |
    //       |   |write_1()|  |
    //       |   |write_2()|  |
    //       |________________|
    //

    `uvm_analysis_imp_decl(_1)
    `uvm_analysis_imp_decl(_2)

    class Consumer1 extends uvm_component;
        `uvm_component_utils(Consumer1)

        uvm_analysis_imp_1#(Transaction, Consumer1) a_imp_1;
        uvm_analysis_imp_2#(Transaction, Consumer1) a_imp_2;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            a_imp_1 = new("a_imp_1", this);
            a_imp_2 = new("a_imp_2", this);
        endfunction

        virtual function void write_1(Transaction t);
            `uvm_info(get_name(), $sformatf("Got 1 %s",
                    t.convert2string()), UVM_NONE);
        endfunction

        virtual function void write_2(Transaction t);
            `uvm_info(get_name(), $sformatf("Got 2 %s",
                    t.convert2string()), UVM_NONE);
        endfunction

    endclass

    //          _______________________________
    //         |  Wrapper2                     |
    //         |            ________________   |
    //         |           |                |  |
    // export<>|----->imp<>|                |  |
    //         |  |        |   Consumer1    |  |
    //         |   -->imp<>|                |  |
    //         |           |  |write_1()|   |  |
    //         |           |  |write_2()|   |  |
    //         |           |________________|  |
    //         |                               |
    //         |_______________________________|
    //        

    class Wrapper2 extends uvm_component;
        `uvm_component_utils(Wrapper2)

        Consumer1 cons;

        uvm_analysis_export#(Transaction) a_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            cons = Consumer1::type_id::create("cons", this);
            a_export = new("a_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            a_export.connect(cons.a_imp_1);
            a_export.connect(cons.a_imp_2);
        endfunction

    endclass

    //        ________________
    //      _|                |
    // port|_|    Consumer3   |
    //       |                |
    //       |     |get()|    |
    //       |________________|
    //

    class Consumer3 extends uvm_component;
        `uvm_component_utils(Consumer3)

        uvm_blocking_get_port#(Transaction) bg_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            bg_port = new("bg_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            t = new();
            repeat(5) begin
                bg_port.get(t);
                `uvm_info(get_name(), $sformatf("Got %s",
                    t.convert2string()), UVM_NONE);
            end
        endtask

    endclass

    //  ________________________________________________________________________________     
    // |  Wrapper7                                                                      |    
    // |                                                                                |    
    // |  ______________________________________                                        |    
    // | |  Wrapper6                            |                                       |    
    // | |   _______________________            |                                       |    
    // | |  |  Wrapper5             |           |                                       |    
    // | |  |   ___________         |           |                                       |    
    // | |  |  |           |        |           |                                       |
    // | |  |  | Producer5 |<>imp-->|<>export-->|<>export------------------------------>|<>export
    // | |  |  |___________|        |           |                                       |
    // | |  |_______________________|           |                                       |
    // | |______________________________________|                                       |
    // |                                                                                |
    // |  ___________                                                                   |
    // | |           |_                                                                 |_
    // | | Producer4 |_| port---------------------------------------------------------->|_|port
    // | |___________|                                                                  |
    // |                                                                                |
    // |  ________________________                                                      |
    // | |  Wrapper4              |                                                     |
    // | |   ___________          |                  ________________                   |
    // | |  |           |         |                _|                |                  |
    // | |  | Producer3 |<>imp--->|<>export-->port|_|   Consumer3    |                  |
    // | |  |___________|         |                 |                |                  |
    // | |____________________ ___|                 |    |get()|     |                  |
    // |                                            |________________|                  |
    // |  ________________________                                                      |
    // | |  Wrapper3              |                                                     |
    // | |   ___________          |                                                     |
    // | |  |           |_        |_                                                    |
    // | |  | Producer2 |_|port-->|_|export-------------------------------------------->|<>export
    // | |  |___________|         |                                                     |
    // | |____________________ ___|                                                     |
    // |                                                                                |
    // |  ________________________                    _______________________________   |
    // | |  Wrapper1              |                  |  Wrapper2                     |  |
    // | |   ___________          |                  |            ________________   |  |
    // | |  |           |_        |_                 |           |                |  |  |
    // | |  | Producer1 |_|port-->|_|port--> export<>|----->imp<>|                |  |  |
    // | |  |___________|         |                  |  |        |   Consumer1    |  |  |
    // | |____________________ ___|                  |   -->imp<>|                |  |  |
    // |                                             |           |  |write_1()|   |  |  |
    // |                                             |           |  |write_2()|   |  |  |
    // |                                             |           |________________|  |  |
    // |                                             |                               |  |
    // |                                             |_______________________________|  |
    // |                                                                                |
    // |________________________________________________________________________________|

    class Wrapper7 extends uvm_component;
        `uvm_component_utils(Wrapper7)

        Wrapper1 wrap1;
        Wrapper2 wrap2;
        Wrapper3 wrap3;
        Wrapper4 wrap4;
        Wrapper6 wrap6;

        Producer4 prod4;
        Consumer3 cons3;

        uvm_blocking_get_export#(Transaction) bg_export;
        uvm_analysis_port#(Transaction) a_port;
        uvm_nonblocking_put_export#(Transaction) nbp_export;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            wrap1      = Wrapper1::type_id::create("wrap1",  this);
            wrap2      = Wrapper2::type_id::create("wrap2",  this);
            wrap3      = Wrapper3::type_id::create("wrap3",  this);
            wrap4      = Wrapper4::type_id::create("wrap4",  this);
            wrap6      = Wrapper6::type_id::create("wrap6",  this);
            prod4      = Producer4::type_id::create("prod4", this);
            cons3      = Consumer3::type_id::create("cons3", this);
            bg_export  = new("bg_export",    this);
            a_port     = new("a_port",     this);
            nbp_export = new("nbp_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            wrap1.a_port.connect(wrap2.a_export);
            wrap3.nbp_export.connect(nbp_export);
            cons3.bg_port.connect(wrap4.bg_export);
            prod4.a_port.connect(a_port);
            bg_export.connect(wrap6.bg_export);
        endfunction

    endclass

    //        ________________
    //       |                |
    //       |                |
    //       |    Consumer2   |
    //  imp<>|                |
    //       |   |try_put()|  |
    //       |   |can_put()|  |
    //       |________________|
    //

    class Consumer2 extends uvm_component;
        `uvm_component_utils(Consumer2)

        uvm_nonblocking_put_imp#(Transaction, Consumer2) nbp_imp;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            nbp_imp = new("nbp_imp", this);
        endfunction

        virtual function try_put(Transaction t);
            `uvm_info(get_name(), $sformatf("Got %s",
                    t.convert2string()), UVM_NONE);
        endfunction

        virtual function bit can_put();
            return $urandom_range(0, 1);
        endfunction

    endclass

    //        ________________
    //       |                |
    //  imp<>|   Consumer4    |
    //       |                |
    //       |   |write()|    |
    //       |________________|
    //

    class Consumer4 extends uvm_component;
        `uvm_component_utils(Consumer4)

        uvm_analysis_imp#(Transaction, Consumer4) a_imp;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            a_imp = new("a_imp", this);
        endfunction

        virtual task write(Transaction t);
            `uvm_info(get_name(), $sformatf("Got %s",
                    t.convert2string()), UVM_NONE);
        endtask

    endclass

    //        ________________
    //      _|                |
    // port|_|   Consumer5    |
    //       |                |
    //       |    |get()|     |
    //       |________________|
    //

    class Consumer5 extends uvm_component;
        `uvm_component_utils(Consumer5)

        uvm_blocking_get_port#(Transaction) bg_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            bg_port = new("bg_port", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            t = new();
            repeat(5) begin
                bg_port.get(t);
                `uvm_info(get_name(), $sformatf("Got %s",
                    t.convert2string()), UVM_NONE);
            end
        endtask

    endclass

    //           ________________________________
    //          |  Wrapper8                      |
    //          |          ________________      |
    //         _|        _|                |     |
    //   port |_|-->port|_|   Consumer5    |     |
    //          |         |                |     |
    //          |         |    |get()|     |     |
    //          |         |________________|     |
    //          |                                |
    //          |         ________________       |
    //          |        |                |      |
    // export <>|-->imp<>|   Consumer4    |      |
    //          |        |                |      |
    //          |        |   |write()|    |      |
    //          |        |________________|      |
    //          |________________________________|
    //   

    class Wrapper8 extends uvm_component;
        `uvm_component_utils(Wrapper8)

        Consumer4 cons4;
        Consumer5 cons5;

        uvm_analysis_export#(Transaction) a_export;
        uvm_blocking_get_port#(Transaction) bg_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            cons4 = Consumer4::type_id::create("cons4", this);
            cons5 = Consumer5::type_id::create("cons5", this);
            a_export = new("a_export",  this);
            bg_port  = new("bg_port", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            a_export.connect(cons4.a_imp);
            cons5.bg_port.connect(bg_port);
        endfunction

    endclass

    //          _________________________________________________
    //         |  Wrapper9                                       |
    //         |            ________________________________     |
    //         |           |  Wrapper8                      |    |
    //         |           |          ________________      |    |
    //        _|          _|        _|                |     |    |
    //   port|_|---->port|_|-->port|_|   Consumer5    |     |    |
    //         |           |         |                |     |    |
    //         |           |         |    |get()|     |     |    |
    //         |           |         |________________|     |    |
    //         |           |                                |    |
    //         |           |         ________________       |    |
    //         |           |        |                |      |    |
    // export<>|-->export<>|-->imp<>|   Consumer4    |      |    |
    //         |           |        |                |      |    |
    //         |           |        |   |write()|    |      |    |
    //         |           |        |________________|      |    |
    //         |           |________________________________|    |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |                                                 |
    //         |         ________________                        |
    //         |        |                |                       |
    //         |        |                |                       |
    //         |        |    Consumer2   |                       |
    // export<>|-->imp<>|                |                       |
    //         |        |   |try_put()|  |                       |
    //         |        |   |can_put()|  |                       |
    //         |        |________________|                       |
    //         |                                                 |
    //         |_________________________________________________|


    class Wrapper9 extends uvm_component;
        `uvm_component_utils(Wrapper9)

        Wrapper8 wrap8;

        Consumer2 cons2;

        uvm_nonblocking_put_export#(Transaction) nbp_export;
        uvm_analysis_export#(Transaction) a_export;
        uvm_blocking_get_port#(Transaction) bg_port;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            wrap8 = Wrapper8::type_id::create("wrap8", this);
            cons2 = Consumer2::type_id::create("cons2", this);
            nbp_export = new("nbp_export", this);
            a_export = new("a_export", this);
            bg_port = new("bg_port", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            nbp_export.connect(cons2.nbp_imp);
            a_export.connect(wrap8.a_export);
            wrap8.bg_port.connect(bg_port);
        endfunction

    endclass

    //  _________________________________________________________________________________________________________________________________________________________________
    // |   Wrapper10                                                                                                                                                     |
    // |                                                                                                                                                                 |
    // |     ________________________________________________________________________________                                                                            |                      
    // |    |  Wrapper7                                                                      |                                                                           |             
    // |    |                                                                                |                                                                           |             
    // |    |  _______________________________________                                       |                      _________________________________________________    | 
    // |    | |  Wrapper6                             |                                      |                     |  Wrapper9                                       |   | 
    // |    | |   ________________________            |                                      |                     |            ________________________________     |   |
    // |    | |  |  Wrapper5              |           |                                      |                     |           |  Wrapper8                      |    |   |
    // |    | |  |   ___________          |           |                                      |                     |           |          ________________      |    |   |
    // |    | |  |  |           |         |           |                                      |_                   _|          _|        _|                |     |    |   |
    // |    | |  |  | Producer5 |<>imp--->|<>export-->|<>export----------------------------->|_|export------>port|_|---->port|_|-->port|_|   Consumer5    |     |    |   |
    // |    | |  |  |___________|         |           |                                      |                     |           |         |                |     |    |   |
    // |    | |  |____________________ ___|           |                                      |                     |           |         |    |get()|     |     |    |   |
    // |    | |_______________________________________|                                      |                     |           |         |________________|     |    |   |
    // |    |                                                                                |                     |           |                                |    |   |
    // |    |  ___________                                                                   |                     |           |         ________________       |    |   |
    // |    | |           |_                                                                 |_                    |           |        |                |      |    |   |
    // |    | | Producer4 |_|port----------------------------------------------------------->|_|port------>export<>|-->export<>|-->imp<>|   Consumer4    |      |    |   |
    // |    | |___________|                                                                  |                     |           |        |                |      |    |   |
    // |    |                                                                                |                     |           |        |   |write()|    |      |    |   |
    // |    |  ________________________                                                      |                     |           |        |________________|      |    |   |
    // |    | |  Wrapper4              |                                                     |                     |           |________________________________|    |   |
    // |    | |   ___________          |                  ________________                   |                     |                                                 |   |
    // |    | |  |           |         |                _|                |                  |                     |                                                 |   |
    // |    | |  | Producer3 |<>imp--->|<>export-->port|_|   Consumer3    |                  |                     |                                                 |   |
    // |    | |  |___________|         |                 |                |                  |                     |                                                 |   |
    // |    | |____________________ ___|                 |    |get()|     |                  |                     |                                                 |   |
    // |    |                                            |________________|                  |                     |                                                 |   |
    // |    |  ________________________                                                      |                     |                                                 |   |
    // |    | |  Wrapper3              |                                                     |                     |         ________________                        |   |
    // |    | |   ___________          |                                                     |                     |        |                |                       |   |
    // |    | |  |           |_        |_                                                    |                     |        |                |                       |   |
    // |    | |  | Producer2 |_|port-->|_|export-------------------------------------------->|<>export---->export<>|-->imp<>|   Consumer2    |                       |   |
    // |    | |  |___________|         |                                                     |                     |        |                |                       |   |
    // |    | |____________________ ___|                                                     |                     |        |   |try_put()|  |                       |   |
    // |    |                                                                                |                     |        |   |can_put()|  |                       |   |
    // |    |  ________________________                    _______________________________   |                     |        |                |                       |   |
    // |    | |  Wrapper1              |                  |  Wrapper2                     |  |                     |        |________________|                       |   |
    // |    | |   ___________          |                  |            ________________   |  |                     |                                                 |   |
    // |    | |  |           |_        |_                 |           |                |  |  |                     |_________________________________________________|   |
    // |    | |  | Producer1 |_|port-->|_|port--> export<>|----->imp<>|                |  |  |                                                                           |
    // |    | |  |___________|         |                  |  |        |   Consumer1    |  |  |                                                                           |
    // |    | |____________________ ___|                  |   -->imp<>|                |  |  |                                                                           |
    // |    |                                             |           |  |write_1()|   |  |  |                                                                           |
    // |    |                                             |           |  |write_2()|   |  |  |                                                                           |
    // |    |                                             |           |________________|  |  |                                                                           |
    // |    |                                             |                               |  |                                                                           |
    // |    |                                             |_______________________________|  |                                                                           |
    // |    |                                                                                |                                                                           |
    // |    |________________________________________________________________________________|                                                                           |
    // |                                                                                                                                                                 |
    // |_________________________________________________________________________________________________________________________________________________________________|

    class Wrapper10 extends uvm_component;
        `uvm_component_utils(Wrapper10)

        Wrapper7 wrap7;
        Wrapper9 wrap9;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            wrap7 = Wrapper7::type_id::create("wrap7", this);
            wrap9 = Wrapper9::type_id::create("wrap9", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            wrap9.bg_port.connect(wrap7.bg_export);
            wrap7.a_port.connect(wrap9.a_export);
            wrap7.nbp_export.connect(wrap9.nbp_export);
        endfunction

        virtual function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.print_topology();
        endfunction

    endclass

    initial begin
        run_test();
    end


endmodule