/**
 * @author radigast
 */

class dstream_config extends uvm_object;

  virtual dstream_if m_dstream_vif = null;

  // Constructor
  function new (string name = "dstream_cfg");
    super.new(name);
  endfunction: new

  static function dstream_config get_config( uvm_component c );
    dstream_config t;
  
    if( !uvm_config_db #(dstream_config)::get(c ,"","dstream_config", t) )
      `uvm_fatal( "DSRTEAM_UVC_CONFIG_ERROR" ,
        $sformatf("uvm_config_db #(dstream_config) has no resource associated with id %s and component %s",
          "dstream_config", c.get_full_name() ) )
    return t;
  endfunction

  // Field Macros
  `uvm_object_utils_begin(dstream_config)
  `uvm_object_utils_end

endclass: dstream_config
