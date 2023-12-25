class axis_sequence extends uvm_sequence#(axis_transaction);

    `uvm_object_utils(axis_sequence)

    rand bit [7:0] seq_id;

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


endclass: axis_sequence