class axis_driver extends uvm_driver#(axis_transaction);

    `uvm_component_utils(axis_driver)

    virtual axis_if axis_vi;

    event reset_driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        assert(uvm_resource_db#(virtual axis_if)::read_by_type(get_full_name(), axis_vi, this))
        else $fatal(-1, "Can't access axis_if by %s", get_full_name());
    endfunction: build_phase

    task reset_phase(uvm_phase phase);
        axis_vi.valid <= 0;
        axis_vi.data <= 0;
        axis_vi.id <= 0;
        
        @(posedge axis_vi.rst_n);
        `uvm_info(get_name(), "reset deasserted", UVM_NONE)
    endtask: reset_phase

    task run_phase(uvm_phase phase);
        forever begin
            fork
                drive();
                begin
                    @(reset_driver);
                    `uvm_info(get_name(), "reset asserted", UVM_NONE)
                end
            join_any
            disable fork;
        end
    endtask: run_phase

    task drive();
        axis_transaction drv_trans;
        seq_item_port.get_next_item(drv_trans);

        `uvm_info(get_full_name(), $sformatf("driving trans %s", drv_trans.convert2string()), UVM_NONE)

        axis_vi.valid   <= 1'b1;
        axis_vi.id      <= drv_trans.id;
        axis_vi.data    <= drv_trans.data;

        do begin
            @(posedge axis_vi.clk);
        end while (axis_vi.ready != 1'b1);

        axis_vi.valid <= 0;
        seq_item_port.item_done();

        repeat($urandom_range(4, 0)) begin
            @(posedge axis_vi.clk);
        end
    endtask: drive

endclass: axis_driver
