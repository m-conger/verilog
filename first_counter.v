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
begin : COUNTER
