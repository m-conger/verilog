`include "first_counter.v"
module first_counter_tb();
// girişlerin reg, çıkışların wire olarak bildirilmesi gerekmektedir
reg clock, reset, enable;
wire [3:0] counter_out;

// tüm değişkenlerin başlangıç değerleri
initial begin
    $display ("time/t clk reset enable counter");
    $monitor ("%g/t %b %b %b %b",
        $time, clock, reset, enable, counter_out);
    clock = 1;  // clock ilk değeri
    reset = 0; // reset ilk değeri
    enable = 0; // enable ilk değeri
    #5 reset = 1; // reset belirtimi
    #10 reset = 0; // reset'ten çıkış durumu
    #10 enable = 1; // enable durumu
    #100 enable = 0; // enable'dan çıkış durumu
    #5 $finish; // simülasyonu sonlandır
end

// saat üretici (clock generator)
always begin
    #5 clock = ~clock; // her 5 saat darbesinde durum değişimi
end

// testbench'ten test edilen cihaza (DUT, device under test) bağlantı
first_counter U_counter (
clock,
reset,
enable,
counter_out
);

endmodule