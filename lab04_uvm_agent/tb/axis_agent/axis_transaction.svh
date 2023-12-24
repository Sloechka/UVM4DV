class axis_transaction extends uvm_sequence_item;
    
    `uvm_object_utils(axis_transaction)

    rand bit [7:0]  id;
    rand bit [31:0] data;

    function new(string name = "");
        super.new(name);
    endfunction: new

    function string convert2string();
        string str;
        str = {str, $sformatf("\id    : 0x%8h", id )};
        str = {str, $sformatf("\ndata : 0x%8h", data)};
        return str;
    endfunction: convert2string
    
endclass: axis_transaction