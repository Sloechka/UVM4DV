class dummy_sequence extends uvm_sequence#(axis_transaction);

    `uvm_object_utils(dummy_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body();
        repeat(10) begin
            req = REQ::type_id::create(.name("req"), .contxt(get_full_name()));
            
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask: body

endclass: dummy_sequence
