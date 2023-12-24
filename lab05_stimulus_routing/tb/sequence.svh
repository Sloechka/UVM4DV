// class dummy_v_sequence extends uvm_sequence;

//     `uvm_object_utils(dummy_v_sequence)

//     axis_sequence axis_seq1;
//     axis_sequence axis_seq2;
    
//     function new(string name = "");
//         super.new(name);
//     endfunction: new

//     task pre_body();
//         axis_seq1 = axis_sequence::type_id::create("axis_seq1");
//         axis_seq2 = axis_sequence::type_id::create("axis_seq2");
//     endtask: pre_body

//     task body();
//         axis_seq1.start(m_sequencer);
//         axis_seq2.start(m_sequencer);
//     endtask: body

// endclass: dummy_v_sequence