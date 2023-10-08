//-----------------------------------------------
// Module: lab_02
//-----------------------------------------------

// Template for hierarchy

module lab_02_template;

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

        // Define analysis port
        // uvm_analysis_port#(Transaction) <port-name>

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create port
            // <port-name> = new(...)
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            repeat(5) begin
                t = new("tr");
                void'(t.randomize());
                // Use write TLM-API function in port
                // <port-name>.write(...);
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

        // Define nonblocking put port
        // uvm_nonblocking_put_port#(Transaction) <port-name>

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create port
            // <port-name> = new(...)
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            repeat(5) begin
                // Use TLM-API can_put() to wait
                // for possibility to put
                // wait(<port-name>.can_put());
                t = new("tr");
                void'(t.randomize());
                // Use write TLM-API function in port
                // <port-name>.try_put(...);
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

        // Define blocking get imp
        // uvm_nonblocking_put_port#(Transaction, <imp-provider>) <imp-name>

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create port
            // <imp-name> = new(...)
        endfunction

        // Implement TLM-API get()
        // virtual task get(output Transaction t);
        //     <do-some-creation>
        // endtask

    endclass



    //  ___________
    // |           |_
    // | Producer4 |_| port
    // |___________|
    // 

    // Create Producer4 class
    // It can be extended from Producer1

    // class Producer4 extends Producer1;
    //     <some-uvm-routines>
    // endclass



    //  ___________
    // |           |_
    // | Producer5 |_| port
    // |___________|
    // 

    // Create Producer4 class
    // It can be extended from Producer3

    // class Producer5 extends Producer3;
    //     <some-uvm-routines>
    // endclass



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

        // Define Producer1
        // Producer1 <prod-name>;

        // Define analysis port
        // uvm_analysis_port#(Transaction) <port-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create Producer and port
            // ::type_id::create(...)
            // new(...)
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Connect Producer's port with this class port
            // <prod-name>.<port-name>.connect(<port-name>);
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

        // Define Producer2
        // Producer2 <prod-name>;

        // Define nonblocking put export
        // uvm_nonblocking_put_export#(Transaction) <export-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create Producer and export
            // ::type_id::create(...)
            // new(...)
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Connect Producer's port with this class export
            // <prod-name>.<port-name>.connect(<export-name>);
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

        // Define Producer3
        // Producer3 <prod-name>;

        // Define blocking get export
        // uvm_blocking_get_export#(Transaction) <export-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create Producer and export
            // ::type_id::create(...)
            // new(...)
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Connect Producer's imp with this class export
            // <export-name>.connect(<prod-name>.<imp-name>);
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

    // This class is like Wrapper4

    // class Wrapper5 extends uvm_component;
    //     `uvm_component_utils(Wrapper5)

    //     Producer5 prod5;

    //     uvm_blocking_get_export#(Transaction) bg_export;

    //     <creation-and-connection>

    // endclass



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

        // Define Wrapper5
        // Wrapper5 <wrap-name>;

        // Define blocking get export
        // uvm_blocking_get_export#(Transaction) <export-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create wrapper and export
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Connect exports
            // <export-name>.connect(<wrap-name>.<export-name>);
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

    // Declare two implementations:

    // uvm_analysis_imp_1
    // uvm_analysis_imp_2

    // `uvm_analysis_imp_decl(...)
    // `uvm_analysis_imp_decl(...)

    class Consumer1 extends uvm_component;
        `uvm_component_utils(Consumer1)

        // Define implementations
        // ... <imp1-name>;
        // ... <imp2-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create implementations
            // new(...)
        endfunction
        
        // Implement TLM-API write_1() and write2() methods
        // as you wish (some prints and etc.)

        // virtual function void write_1(Transaction t);
        //     ...
        // endfunction

        // virtual function void write_2(Transaction t);
        //     ...
        // endfunction

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

        // Define Consumer1
        // Consumer1 <cons-name>;

        // Define analysis export
        // uvm_analysis_export#(Transaction) <export-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create neccessary fields
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Connect export to 2 implementations in Consumer via
            // <export-name>.connect(...)
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

        // Define clocking put port
        // uvm_blocking_get_port#(Transaction) <port-name>;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create port
        endfunction

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            t = new();
            // Implement getting transactions from
            // the consumer via <port-name>.get(...)
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

        // Define all neccessary components
        // Wrapper1 wrap1;
        // Wrapper2 wrap2;
        // ...
        // Wrapper6 wrap6;

        // Producer4 ...;
        // Consumer3 cons3;

        // Define neccessary ports and exports
        // uvm_blocking_get_export#(Transaction) ...;
        // uvm_analysis_port#(Transaction) ...;
        // uvm_nonblocking_put_export#(Transaction) ...;

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            // Create components
            // wrap1 = Wrapper1::type_id::create("wrap1",  this);
            // ...
            // cons3 = Consumer3::type_id::create("cons3", this);
            // Create exports
            // ... = new("bg_export",  this);
            // ... = new("a_port",     this);
            // ... = new("nbp_export", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            // Do all neccessary connections
            // wrap1.<port-name>.connect(wrap2.<export-name>);
            // ...
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

    // Create Consumer2 class with nonblocking put implementation

    // class Consumer2 extends uvm_component;
    //     `uvm_component_utils(Consumer2)
    //
    //    uvm_nonblocking_put_imp#(Transaction, ...) ...;
    //
    //    ...
    //
    //    virtual function try_put(Transaction t);
    //        ...
    //    endfunction
    //
    //    virtual function bit can_put();
    //        ...
    //    endfunction
    //
    // endclass



    //        ________________
    //       |                |
    //  imp<>|   Consumer4    |
    //       |                |
    //       |   |write()|    |
    //       |________________|
    //

    // Create Consumer4 class with analysis implementation

    // class Consumer4 extends uvm_component;
    //     `uvm_component_utils(Consumer4)
    //
    //     uvm_analysis_imp#(Transaction, ...) a_imp;
    //
    //     ...
    //
    //     virtual task write(Transaction t);
    //          ...
    //     endtask
    //
    // endclass



    //        ________________
    //      _|                |
    // port|_|   Consumer5    |
    //       |                |
    //       |    |get()|     |
    //       |________________|
    //

    class Consumer5 extends uvm_component;
        `uvm_component_utils(Consumer5)

        // Create blocking get port
        // uvm_blocking_get_port#(Transaction) <port-name>;

        // new() and creation here

        virtual task run_phase(uvm_phase phase);
            Transaction t;
            t = new();
            // Do some <port-name>.get(...) to
            // request transactions from consumer
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

    // Create Wrapper8
    // It has 2 consumers and port and export
    // Connect them in an appropriate way
    class Wrapper8 extends uvm_component;
        `uvm_component_utils(Wrapper8)

        // Consumer4 <cons4-name>;
        // Consumer5 <cons5-name>;

        // uvm_analysis_export#(Transaction) <export-name>;
        // uvm_blocking_get_port#(Transaction) <port-name>;

        // new() and creation here

        virtual function void connect_phase(uvm_phase phase);
            // <export-name>.connect(<cons4-name>.<imp-name>);
            // <cons5-name>.<port-name>.connect(<port-name>);
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


    // Create Wrapper8
    // It has Wrapper8, Consumer2 and some ports, exports
    // Connect them in an appropriate way
    class Wrapper9 extends uvm_component;
        `uvm_component_utils(Wrapper9)

        // Wrapper and consumer
        // ...

        // uvm_nonblocking_put_export#(Transaction) <export1-name>;
        // uvm_analysis_export#(Transaction) <export2-name>;
        // uvm_blocking_get_port#(Transaction) <port-name>;

        // new() and creation here

        virtual function void connect_phase(uvm_phase phase);
            // Connect it yourself!
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

    // Create final topology with Wrapper10
    // Simply create Wrapper7 and Wrapper9 and connect
    // neccessary ports

    class Wrapper10 extends uvm_component;
        `uvm_component_utils(Wrapper10)

        Wrapper7 wrap7;
        Wrapper9 wrap9;

        // new() and creation here

        virtual function void connect_phase(uvm_phase phase);
            // Do neccessary connections
        endfunction

        virtual function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.print_topology();
        endfunction

    endclass



    // Well done! Use Makefile to run your job in QuestaSim:

    // make example=lab_02_template testname=Wrapper10

    initial begin
        run_test();
    end


endmodule