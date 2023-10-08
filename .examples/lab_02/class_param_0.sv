module class_param_0;

    class my_param_class #(parameter DEFAULT = 5);

        int my_data = DEFAULT;

        function void print();
            $display("my_data = %0d", my_data);
        endfunction

    endclass

    initial begin
        my_param_class #(5) my_class_5;
        my_param_class #(6) my_class_6;
        my_class_5 = new();
        my_class_6 = new();
        my_class_5.print();
        my_class_6.print();
    end

endmodule
