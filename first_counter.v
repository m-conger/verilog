//-----------------------------------------------------------------------
//
// Bu benim ikinci verilog programım
// tasarım ismi     : sayıcı
// dosya ismi       : first_counter.v
// fonksiyon        : 4-bit yukarı sayıcı
// kodlayan         : YONGA (Muhammed Conger)
//
//-----------------------------------------------------------------------

module first_counter (
    clock, // tasarımın saat girişi
    reset, // aktif yüksek senkron reset girişi
    enable, // sayaç için yukarı seviyede aktif etkinleştirme
    counter_out // sayacın 4 bit vektör çıkışı
); // port listesinin sonu

//--------------- giriş portları -----------------
input clock;
input reset;
input enable;

//--------------- çıkış portları -----------------
output [3:0] counter_out;


//--------------- giriş portları veri tipleri -----------------
wire clock;
wire reset;
wire enable;


//--------------- çıkış portları veri tipleri -----------------
reg [3:0] counter_out;


//--------------- başlıyor -----------------
always @(posedge clock)
begin : COUNTER // blok adı
    // şimdi saatin her bir yükselen kenarında reset aktif mi kontrolü yapılacak
    // eğer aktif ise sayacın çıkışına 4'b0000 yüklenecek
    if (reset == 1'b1) begin
        counter_out <= #1 4'b0000;
    end
    // eğer enable aktif ise sayaç artacak
    else if (enable == 1'b1) begin
        counter_out <= #1 counter_out + 1;
    end
end // COUNTER bloğunun sonu

endmodule // counter modülünün sonu