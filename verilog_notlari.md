# VERİLOG NOTLARI


## Tasarım Modelleri
Verilog ile 3 tür modelde tasarım yapılabilir.
* Yapısal:      gate-level
* Davranışsal:  always (Behavioral)
* Dataflow:     assign

(Yapısal tasarım günümüzde neredeyse kullanılmamaktadır.)


## Soyutlama
Tasarıma ilişkin öncelikle specifications (specs, belirtimler) oluşturulabilir. Böylece tasarıma dair lojik blokları kağıt üzerinde oluşabilecektir. Burada oluşturulacak olan bloklar arbiter olarak ifade edilebilir. Bu kutular verilog için module yapılarını temsil eder, soyutlar. Eğer çok küçük bir tasarım ise low-level design yapılarak durum makineleri tasarlanabilir. Ardından karnaugh haritaları ile gerekli devreler optimize edilerek elde edilir. Ancak karmaşık tasarımlar için bu gidişat uygulanabilir değildir. Bir HDL kullanılarak high-level design yapılır. RTL kodlamalarının ardından verification (doğrulama) işlemleri yapılır ve ardından synthesis (sentez) işlemi gerçekleştirilir.

İşte bir arbiter (module) örneği:

``` verilog
module arbiter (
    // 2 eğik çizgi açıklama satırı için kullanılır
    clock       , // clock
    reset       , // active high, syn reset
    req_0       , // request 0
    req_1       , // request 1
    gnt_0       , // grant 0
    gnt_1       , // grant 1
);

// tüm komutlar ; ile bitirilir

// giriş Portları
input   clock;
input   reset;
input   req_0;
input   req_1;
// çıkış portları
output  gnt_0;
output  gnt_1;
```

Bu örnekte sadece iki tip port vardır. Giriş ve çıkış portları. Ancak gerçek hayatta bi-directional (çift yönlü) portlar sıklıkla kullanılır. Verilog'ta çift yönlü portlar tanımlamak için `inout` kullanılır.

Örneğin:
``` verilog
inout read_enable; // "read_enable" portu çift yönlüdür.
```


## Sinyal Vektörleri
Sinyal vektörleri bir bit'ten daha fazla birleşik sinyal dizisini tanımlar

Örneğin:
``` verilog
inout [7:0] adress; // anlamlı bit en solda olacak şekilde sağdan sola doğru okuma yapılır. İhtiyaca göre tam tersi bir okuma da [0:7] şeklinde yapılabilir.
```


## Veri Tipleri
Temelde bir driver (sürücü= içerisindeki elektronların gidip geldiği bir yapıdır. Bir değer saklayabilir veya iki noktayı birbirine bağlayabilir. Değer saklayabilen tipe verilog'ta reg (register, yazmaç), iki noktayı birbirine bağlayan tipe ise verilog'ta wire (tel) denir.

Örneğin:
``` verilog
wire and_gate_output; // bir and kapısının çıkışındaki teli temsil eder. İki noktayı birleştirmek için kullanılır.
reg d_flip_flop_output; // tanımlanan ifade bir yazmaçtır (register) ve ilgili değeri üzerinde kaydeder.
reg [7:0] adress_bus; // tanımlanan ifadenin en sağdan 8 biti yazmaçtır
```

Bunların dışında da veri tipleri bulunmaktadır. İlerleyen konularda incelenecektir.


## Operatörler
| Operatör Tipi           | Operatör Sembolü | Yaptığı İşlem                     |
|-------------------------|------------------|-----------------------------------|
| Arithmetic (Aritmetik)  | *                | Çarpım                            |
|                         | /                | Bölme                             |
|                         | +                | Toplama                           |
|                         | -                | Çıkarma                           |
|                         | %                | Mod                               |
|                         | +                | Tekli Artış (unary plus)          |
|                         | -                | Tekli Azalış (unary minus)        |
| Logical (Lojik)         | !                | lojik Değil                       |
|                         | &&               | lojik VE                          |
|                         | \|\|             | Lojik VEYA                        |
| Relational (İlişkisel)  | >                | Büyüktür                          |
|                         | <                | Küçüktür                          |
|                         | >=               | Büyük Eşit                        |
|                         | <=               | Küçük Eşit                        |
| Equality (Eşitlik)      | ==               | Eşitlik (eşit mi?)                |
|                         | !=               | Eşitsizlik (eşit değil mi?)       |
| Reduction (İndirgeme)   | ~                | Bit Değil                         |
|                         | ~&               | VE DEĞİL                          |
|                         | \|               | VEYA                              |
|                         | ~\|              | VEYA DEĞİL                        |
|                         | ^                | DIŞLAYAN VEYA                     |
|                         | ^~               | DIŞLAYAN VEYA DEĞİL               |
|                         | ~^               | DIŞLAYAN VEYA DEĞİL               |
| Shift (Kaydırma)        | >>               | Sağa Kaydırma                     |
|                         | <<               | Sola Kaydırma                     |
| Concatenation (Bağlama) | {}               | Birbirine Bağlama (concatenation) |
| Conditional (Koşul)     | ?                | Koşul (conditional)               |


## Kontrol İfadeleri
### 1. if-else
Bir parça kodun yürütülüp yürütülmeyeceğini kontrol eder. Koşul sağlanıyorsa kod yürütülür, değilse kodun diğer kısmı koşulur.

Örneğin:
``` verilog
if (enable == 1'b1) begin
    data = 10;
    adress = 16'hDEAD;
    wr_enable = 1'b1;
end else begin
    data = 32'b0;
    adress = adress + 1;
end
```

(Begin ve end, C/C++'taki {} ifadesi gibi davranır. Yani ilgili kısmın çerçevesi denebilir.)

### 2. case
Case, bir değişkenin birden çok değer için kontrol edilmeye ihtiyacı varsa kullanılır.

Örneğin:
``` verilog
case (address)
    0 : $display ("It is 11:40PM");
    1 : $display ("I am feeling sleepy");
    2 : $display ("Let me skip this tutorial");
    default : $display ("Need to complete");
endcase
```

(If-else ifadesinde 'else' yoksa veya case ifadesinde 'default' yoksa ve kombinasyonel bir ifade yazacaksanız, sentez aracı "Latch" tercih eder. If-else ve case ifadeleri kombinasyonel lojik için tüm durumların kapsanmasına ihtiyaç duyar.)

### 3. while döngüsü
Normalde modellerde pek kullanılmaz ancak testbenchde sıkça kullanılır.

Örneğin:
``` verilog
while (free_time) begin
    $display ("Contiune with webpage development");
end
```

Bu örnekte "free_time" değişkeni bir olduğu sürece begin ve end arasındaki kod gerçekleşecektir.

Örnek 2:
``` verilog
module counter (clk, rst, enable, count);
input clk, rst, enable;
output [3:0] count;
reg [3:0] count;

always @(posedge clk or posedge rst)
if (rst) begin
    count <= 0;
end else begin : COUNT
    while (enable) begin
        count <= count + 1;
        disable COUNT;
    end
end

endmodule
```

### for döngüsü
Örneğin:
``` verilog
for (i = 0; i < 16; i = i+1) begin
    $display ("Current value of i is %d", i);
end
```

### Repeat (Tekrar)
For döngüsüne benzer. Farklı olarak dışarıdan bir değişken belirtilir ve artırılır. Döngü bildirilirken kodun kaz kez çalıştırılacağı bildirilir ve değişken artırılmaz.

Örneğin:
``` verilog
repeart (16) begin
    $display ("Current value of i is %d", i)
```

(Verilen örnekteki gibi pek kullanılmaz.)


## Değişken Ataması
Dijital olarak iki tip eleman vardır. Kombinasyonel ve sıralı. Verilog iki yönlü kombinasyonel lojik ve tek yönlü sıralı lojik modeli destekler.

* Kombinasyonel elemanlar `assing` (atama) ve `always` (her zaman) ifadeleriyle modellenebilir.
* Sıralı elemanlar sadece `always` ifadeleriyle modellenebilir.
* Üçüncü bir blok da sadece testbench için kullanılır. Buna ise initial block (başlangıç bloğu) denir.

### Initial Block (Başlangıç Bloğu)
Bir başlangıç bloğu sadece simülasyon başladığında gerçekleştirilir. Eğer birden fazla başlangıç bloğu var ise hepsi birden gerçekleştirilir.

Örneğin:
``` verilog
initial begin
    clk = 0;
    reset = 0;
    req_0 = 0;
    req_1 = 0;
end
```

(Verilen örnekte simülasyonun başında clk = 0 iken `begin` ve `end` bloğu arasındaki tüm değişkenler sıfır olarak sürülmektedir.)

### always bloğu
Initial bloğu sadece bir kez (simülasyon başında) gerçekleştirilirken always bloğu her zaman gerçekleştirilir. Diğer bir fark ise always bloğu bir `sensitive list` (hassasiyet listesi) içerebilir ve veya bununla ilgili bir `delay` (gecikme) içerebilir.

(Sensetive list, always bloğuna kodun ne zaman gerçekleştirileceğini söyler.)

Örneğin:
``` verilog
always @(a or b or sel)
begin
    y = 0;
    if (sel == 0) begin
        y = a;
    end else begin
        y = b;
    end
end
```

Verilen örnek 2x1 bir multiplexer (mux, çoklayıcı) yapısını ifade eder. Bu örnekte sensitive list a, b ve sel'dir.

(Always bloğu için `wire` veri tipinde kullanılamaz fakat `reg` ve integer veri tiplerinde kullanılabilir.)

İki tip sensitive list vardır. Bunlar seviye hassas (kombinasyonel devreler için) ve kenar hassas (flip-flop'lar için) sensitive list'lerdir.

Örneğin:
``` verilog
always @(posedge clk)
if (reset == 0) begin
    y <= 0;
end else if (sel == 0) begin
    y <= a;
end else begin
    y <= b;
end
```

Yukarıdaki örnek de bir 2x1 mux yapısıdır. Fakat y çıkışı artık bir flip-flop çıkışıdır. Altında yatan sebep sensitive list'inin kenar hassas tipte olmasından kaynaklıdır.

Görüldüğü üzere kombinasyonel lojikte "=" operatörü kullanılırken sıralı blokta "<=" operatörü kullanılmaktadır. "=" ifadesi kodu begin-end arasında sıralı olarak gerçekleştirirken, "<=" ifadesi kodu paralel olarak gerçekleştirmektedir.

Bir always bloğu sensitive list olmadan da kullanılabilir. Fakat bu durumda bir delay gereklidir.

Örneğin:
``` verilog
always begin
    #5 clk = ~clk;
end
```

Verilen örnekteki "#5" ifadesi, diğer ifadenin gerçekleştirilmesini 5 zaman birimi kadar geciktirmektedir.

### assign (atama) ifadesi
Bir `assign` ifadesi sadece kombinasyonel lojiği modeller ve devamlı gerçekleştirir. Bu nedenle `assign` ifadesi continuous assignment statement (sürekli atama ifadesi) olarak adlandırılır ve sensitive list'i yoktur.

Örneğin:
``` verilog
assign out = (enable) ? data : 1'bz;
```

Verilen örnek bir tri-state buffer (üç-durumlu arabellek) yapısını temsil eder. `enable` 1 olduğunda veri çıkışa sürülmektedir, değilse çıkış yüksek empedansa çekilmektedir. (Bir verinin yüksek empedanslı bir çevreye çekilmesi, sinyalin gücünü koruyarak daha doğru sonuçlar elde etmeye ve gürültüyü azaltmaya yarar.)


## Görev & Fonksiyon
Eğer daha önce kullanılan kodlar tekrar tekrar kullanılmak istenir ise adres tekrarlı kullanılmış kod yani task (görev) ve function (fonksiyon) verilog için desteklenmektedir.

Örneğin:
``` verilog
function parity;
input [31:0] data;
integer i;
begin
    parity = 0;
    for (i = 0; i < 32, i = i + 1) begin
        parity = parity ^ data[i];
    end
end

endfunction
```

Fonksiyonlar ve görevler aynı söz dizimine sahiptir. Tek fark task'lerde gecikmeler (delay) olabilir ancak fonksiyonların gecikmesi olamaz. Bu durum fonksiyonların kombinasyonel lojiği modellemek için kullanıldığını ifade eder. Diğer bir fark ise fonksiyonlar bir değer döndürebilirken task'ler değer döndüremez.


## Test Bench
Yazılan kodların belirtimlere (specifications) uygun çalışıp çalışmadığı test edilmelidir. Genel mantık girişlerin sürülmesi ve sürülen girişlere göre çıkışların beklenen değerlerle uyuşup uyuşmadığını kontrol etmektir.

Örneğin:
``` verilog
module arbiter (
    clock,
    reset,
    req_0,
    req_1,
    gnt_0,
    gnt_1
);

input clock, reset, req_0, req_1;
output gnt_0, gnt_1;

reg gnt_0, gnt_1;

always @(posedge clock or posedge reset)
if (reset) begin
    gnt_0 <= 0;
    gnt_1 <= 0;
end else if (req_0) begin
    gnt_0 <= 1;
    gnt_1 <= 0;
end else if (req_1) begin
    gnt_0 <= 0;
    gnt_1 <= 1;
end

endmodule
// testbench kodu buraya gelecek
module arbiter_tb;

reg clock, reset, req0, req1;
wire gnt0, gnt1;

initial begin
    $monitor ("req0=)
```