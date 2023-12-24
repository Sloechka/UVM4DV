/**
 * @author radigast
 */


class ral_regs_ctrl extends uvm_reg;
  rand uvm_reg_field mode;

  `uvm_object_utils(ral_regs_ctrl)

  function new(string name = "ctrl");
    super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
  endfunction: new

  // Build all register field objects
  virtual function void build();
    this.mode   = uvm_reg_field::type_id::create("mode",,   get_full_name());
  
    this.mode.configure(.parent(this),
                        .size(2),
                        .lsb_pos(0),
                        .access("RW"),
                        .volatile(0),
                        .reset(1'h0),
                        .has_reset(1),
                        .is_rand(1),
                        .individually_accessible(0)
                       );
  endfunction
endclass

// (step 4) --> реализуйте оставшиеся регистры устройства по аналогии

  
class ral_regs_cam_mem extends uvm_mem;
  `uvm_object_utils(ral_regs_cam_mem)

  function new(string name = "cam_mem");
    super.new(name, 4*4, 32, "RW", build_coverage(UVM_NO_COVERAGE));
  endfunction: new

endclass

class ral_block_regs extends uvm_reg_block;
  rand ral_regs_ctrl              ctrl;              // RW
  // (step 4) --> интегрируейте оставшиеся регистры устройства по аналогии
 
  
  `uvm_object_utils(ral_block_regs)

  function new(string name = "regs");
    super.new(name, build_coverage(UVM_NO_COVERAGE));
  endfunction

  virtual function void build();
    this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

    this.ctrl = ral_regs_ctrl::type_id::create("ctrl",,get_full_name());
    this.ctrl.configure(this, null, "");
    this.ctrl.build();
    this.default_map.add_reg(this.ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);


  endfunction 
endclass

class ral_sys_cam extends uvm_reg_block;
  rand ral_block_regs regs;

  `uvm_object_utils(ral_sys_cam)
  function new(string name = "ral_sys_cam");
    super.new(name);
  endfunction

  function void build();
    this.default_map = create_map("", 32'h1000, 4, UVM_LITTLE_ENDIAN, 0);
    this.regs = ral_block_regs::type_id::create("regs",,get_full_name());
    this.regs.configure(this, "none");
    this.regs.build();
    this.default_map.add_submap(this.regs.default_map, `UVM_REG_ADDR_WIDTH'h0);
  endfunction
endclass
