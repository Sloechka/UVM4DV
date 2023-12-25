class axis_monitor extends uvm_monitor;
    `uvm_component_utils(axis_monitor)

    uvm_analysis_port#(axis_transaction) port;

    virtual axis_if axis_vi;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port", this);
        
        assert(uvm_resource_db#(virtual axis_if)::read_by_type(get_full_name(), axis_vi, this))
        else $fatal(-1, "Can't access axis_if by %s", get_full_name());
    endfunction: build_phase

    task reset_phase(uvm_phase phase);
        @(posedge axis_vi.rst_n);
        `uvm_info(get_name(), "reset deasserted", UVM_NONE)
    endtask: reset_phase

    task run_phase(uvm_phase phase);
        forever begin
            fork
                receive();
                begin
                    @(negedge axis_vi.rst_n);
                    `uvm_info(get_name(), "reset asserted", UVM_NONE)
                end
            join_any
            disable fork;
        end
    endtask: run_phase

    task receive();
        @(posedge axis_vi.clk);
        if(axis_vi.ready & axis_vi.valid) begin
            axis_transaction tr;
            tr = new("tr");

            tr.data = axis_vi.data;
            tr.id = axis_vi.id;

            `uvm_info(get_name(), $sformatf("complete tr:\n%s", tr.convert2string()), UVM_NONE)

            port.write(tr);
        end
    endtask: receive

endclass: axis_monitor
