

// Register environment class puts together the model, adapter and the predictor
// (step 4) -->  изучить
class cam_reg_env extends uvm_env;
   `uvm_component_utils (cam_reg_env)
   function new (string name="cam_reg_env", uvm_component parent);
      super.new (name, parent);
   endfunction

   ral_sys_cam                      m_ral_model;         // Register Model
   a_layer_pkg::reg2a_layer_adapter m_reg2a_layer;       // Convert Reg Tx <-> Bus-type packets
   uvm_reg_predictor #(a_layer_pkg::a_layer_item)  m_a_layer2reg_predictor; // Map bus to register in model

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_ral_model            = ral_sys_cam :: type_id :: create ("m_ral_model", this);
      m_reg2a_layer          = a_layer_pkg :: reg2a_layer_adapter :: type_id :: create ("m_reg2a_layer");
      m_a_layer2reg_predictor  = uvm_reg_predictor #(a_layer_pkg::a_layer_item) :: type_id :: create ("m_a_layer2reg_predictor", this);

      m_ral_model.build();
      m_ral_model.lock_model();
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_a_layer2reg_predictor.map       = m_ral_model.default_map;
      m_a_layer2reg_predictor.adapter   = m_reg2a_layer;
   endfunction

endclass: cam_reg_env
