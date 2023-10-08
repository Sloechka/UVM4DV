module class_param_1;

    class my_param_class #(type T = int);

        T my_data; // my_data will be type T

        function void print();
            $display("my_data is '%s' type", $typename(my_data));
        endfunction

    endclass

    initial begin
        my_param_class #(bit) my_class_bit;   // my_data is 'bit' ----
        my_param_class #(reg) my_class_logic; // my_data is 'reg'--   |
        my_class_bit   = new(); //                                 |  |
        my_class_logic = new(); //                                 |  |
        my_class_bit.print();   // my_data is 'bit' type <---------|--
        my_class_logic.print(); // my_data is 'reg' type <---------
    end

endmodule