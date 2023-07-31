//-----------------------------------------------------------------------
//
// Bu benim ilk verilog programım
// tasarım ismi     : merhaba dünya
// dosya ismi       : hello_world.v
// fonksiyon        : bu program ekrana 'hello world' yazdıracaktır
// kodlayan         : YONGA (Muhammed Conger)
//
//-----------------------------------------------------------------------

module hello_world;

initial begin
    $display ("hello world");
        #10 $finish;
end

endmodule