/*!
 * @author radigast
 */

class lab_env_config extends uvm_object;
    `uvm_object_utils(lab_env_config)

    dstream_config m_dstream_agent_config;

    function new( string name = "" );
        super.new( name );
        m_dstream_agent_config = new();
    endfunction


    static function lab_env_config get_config( uvm_component c );
        lab_env_config t;
  
        if( !uvm_config_db #(lab_env_config)::get(c ,"","lab_env_config", t) )
            `uvm_fatal( "ENV_CONFIG_ERROR" ,
                $sformatf("uvm_config_db #(lab_env_config) has no resource associated with id %s",
                "lab_env_config" ) )
        return t;
    endfunction

endclass