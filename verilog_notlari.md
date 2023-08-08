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
| Replication (Kopyalama) | {n{m}}           | Çoğaltma-Kopyalama                |

Kopyalama Örneği:
``` verilog
{3{a}}          // "{a, a, a}" ifadesine eşittir
{b, {3{c, d}}}  // "{b, c, d, c, d, c, d}"  ifadesine eşittir
```

Eğer operandların bit uzunlukları birbirine eşit değilse, daha kısa olanın soluna sıfırlar eklenir.


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
    $monitor ("req0=%b, req1=%b, gnt0=%b, gnt1=%b", req0, req1, gnt0, gnt1);
    clock = 0;
    reset = 0;
    req0 = 0;
    req1 = 0;
        #5  reset = 1;
        #15 reset = 0;
        #10 req0 = 1;
        #10 req0 = 0;
        #10 req1 = 1;
        #10 req1 = 0;
        #10 {req0, req1} = 2'b11;
        #10 {req0, req1} = 2'b00;
        #10 $finish;
end

always begin
    #5 clock = ! clock;
end

arbiter U0 (
    .clock (clock),
    .reset (reset),
    .req_0 (req0),
    .req_1 (req1),
    .gnt_0 (gnt0),
    .gnt_1 (gnt1)
);

endmodule
```


## Syntax (Söz Dizimi) & Semantic (Anlam)
* C ile benzerdir.
* Büyük küçük harf duyarlıdır (case-sensitive).
* Tüm anahtar sözcükler küçük harflidir.

Kötü Kod Örneği:
``` verilog
module addbit (a, b, ci, sum, co);
input a, b, ci;output sum co;
wire a, b, ci, sum, co;endmodule
```

İyi Kod Örneği:
 ``` verilog
 module addbit  (
    a,
    b,
    ci,
    sum,
    co);
    
    input      a;
    input      b;
    input      ci;
    output     sum;
    output     co;
    wire       a;
    wire       b;
    wire       ci;
    wire       sum;
    wire       co;
    
 endmodule
 ```

 * Tek satırlık açıklama için // kullanılır.
 * Çok satırlık açıklama için /* */ kullanılır.

Açıklama Örneği:
``` verilog
/*  bu bir
    çok satırlı açıklama
    örneğidir */

module addbit (
    a,
    b,
    ci,
    sum,
    co
);

// giriş portları tek satırlık açıklama

input       a;
input       b;
input       ci;

// çıkış portları
output      sum;
output      co;

// veri tipleri
wire        a;
wire        b;
wire        ci;
wire        sum;
wire        co;

endmodule
```

* Sayılarla ilgili olarak Z ifadesi yüksek empedansı, X ifadesi ise bilinmeyeni belirtir.
* Reel sayılar X ve Z içermez.

### İşaretli-İşaretsiz Sayılar
32'hDEAD_BEEF: İşaretli veya işaretsiz bir pozitif sayıdır.
-14'h1234: İşaretli bir negatif sayıdır.

İşaretli-İşaretsiz Sayı Örneği:
``` verilog
module signed_number;

reg [31:0]  a;

initial begin
    a = 14'h1234;
    $display ("current value of a = %h", a);
    a = -14'h1234;
    $display ("current value of a = %h", a);
    a = 32'hDEAD_BEEF;
    $display ("current value of a = %h", a);
    a = -32'hDEAD_BEEF;
    $display ("current value of a = %h", a);
        #10 $finish;
end

endmodule

/* çıktılar
current value of a = 00001234
current value of a = ffffedcc
current value of a = deadbeef
current value of a = 21524111
*/

```

### Portlar
* Portlar bir modül ile onun çevresi arasındaki iletişimi sağlar.
* Bir hiyerarşide en üst seviyedeki modül hariç tüm modüllerin portları vardır.
* portlar; `input`, `output` ve `inout` şeklinde olabilir.
* İyi kod yazmak için her satırda yalnızca bir port belirtilebilir.

Port Bildirim Örneği:
``` verilog
input               clk         ;   // saat girişi
input   [15:0]      data_in     ;   // 16 bit veri girişi yolu
output  [7:0]       count       ;   // 8 bit sayaç çıkışı
inout               data_bi     ;   // çift yönlü veri yolu
```

Tam Bir Örnek:
``` verilog
module addbit (
    a       , // ilk giriş
    b       , // ikinci giriş
    ci      , // elde (carry) girişi
    sum     , // toplam çıkışı
    co      , // elde (carry) çıkışı
);

// giriş bildirimi (input declaration)
input   a;
input   b;
input   ci;

// çıkış bildirimi (output declaration)
output  sum;
output  co;

// port veri tipleri
wire    a;
wire    b;
wire    ci;
wire    sum;
wire    co;

// başlıyor
assign {co, sum} = a + b + ci;

endmodule // addbit modülünün sonu
```


## Modül Bağlantıları
### Dolaylı Bağlantılı Modüller
Bu yöntem de portlar sıralarına göre bağlanmıştır. Sıranın doğru olması önemlidir. Modüllerin dolaylı bağlanması iyi bir fikir değildir.

Modüllerin Dolaylı Bağlantısı Örneği:
``` verilog
//------------------------------------------------------------------
// basit bir toplayıcı devresi
// tasarım adı          : adder_implicit
// dosya adı            : adder_implicit.v
// fonksiyonu           : dolaylı modül bağlantısının işlenmesi
// kodlayan             : YONGA (Muhammed Conger)
//------------------------------------------------------------------

module adder_implicit (
    result      , // toplayıcının çıkışı
    carry       , // toplayıcının elde çıkışı
    r1          , // ilk giriş
    r2          , // ikinci giriş
    ci            // elde girişi
);

// giriş port bildirimi (input port declaration)
input       [3:0]   r1      ;
input       [3:0]   r2      ;
input               ci      ;

// çıkış port bildirimi (output port declaration)
output      [3:0]   result  ;
output              carry   ;

// port telleri (wires)
wire        [3:0]   r1      ;
wire        [3:0]   r2      ;
wire                ci      ;
wire        [3:0]   result  ;
wire                carry   ;

// iç değişkenler (internal variable)
wire                c1      ;
wire                c2      ;
wire                c3      ;

// başlıyor
addbit u0 (
    r1[0]       ,
    r2[0]       ,
    ci          ,
    result[0]   ,
    c1
);

addbit u1 (
    r1[1]       ,
    r2[1]       ,
    c1          ,
    result[1]   ,
    c2
);

addbit u2 (
    r1[2]       ,
    r2[2]       ,
    c2          ,
    result[2]   ,
    c3
);

addbit u3 (
    r1[3]       ,
    r2[3]       ,
    c3          ,
    result[0]   ,
    carry
);

endmodule // toplayıcı modülünün sonu
```

### İsimle Bağlantılı Modüller
Bu yöntemde port sıraları önemsizdir.

Modüllerin İsimle Bağlantısı Örneği:
``` verilog
//------------------------------------------------------------------
// basit bir toplayıcı devresi
// tasarım adı          : adder_implicit
// dosya adı            : adder_implicit.v
// fonksiyonu           : isimle modül bağlantısının işlenmesi
// kodlayan             : YONGA (Muhammed Conger)
//------------------------------------------------------------------

module adder_implicit (
    result      , // toplayıcının çıkışı
    carry       , // toplayıcının elde çıkışı
    r1          , // ilk giriş
    r2          , // ikinci giriş
    ci            // elde girişi
);

// giriş port bildirimi (input port declaration)
input       [3:0]   r1      ;
input       [3:0]   r2      ;
input               ci      ;

// çıkış port bildirimi (output port declaration)
output      [3:0]   result  ;
output              carry   ;

// port telleri (wires)
wire        [3:0]   r1      ;
wire        [3:0]   r2      ;
wire                ci      ;
wire        [3:0]   result  ;
wire                carry   ;

// iç değişkenler (internal variable)
wire                c1      ;
wire                c2      ;
wire                c3      ;

// başlıyor
addbit u0 (
    .a          (r1[0])         ,
    .b          (r2[0])         ,
    .ci         (ci)            ,
    .sum        (result[0])     ,
    .co         (c1)            ,
);

addbit u1 (
    .a          (r1[1])         ,
    .b          (r2[1])         ,
    .ci         (c1)            ,
    .sum        (result[1])     ,
    .co         (c2)            ,
);

addbit u2 (
    .a          (r1[2])         ,
    .b          (r2[2])         ,
    .ci         (c1)            ,
    .sum        (result[2])     ,
    .co         (c3)            ,
);

addbit u3 (
    .a          (r1[3])         ,
    .b          (r2[3])         ,
    .ci         (c3)            ,
    .sum        (result[3])     ,
    .co         (carry)         ,
);

endmodule // toplayıcı modülünün sonu
```


## Bir Modülün Başlatılması
``` verilog
//------------------------------------------------------------------
// basit eşlik (parity) devresi
// tasarım adı          : parity
// dosya adı            : parity.v
// fonksiyonu           : basit-ilkel bir modül bağlantısının işlenmesi
// kodlayan             : YONGA (Muhammed Conger)
//------------------------------------------------------------------

module parity (
    a       , // ilk giriş
    b       , // ikinci giriş
    c       , // üçüncü giriş
    d       , // dördüncü giriş
    y         // eşlik (parity) çıkışı
);

// giriş bildrimi
input       a       ;
input       b       ;
input       c       ;
input       d       ;

// çıkış bildirimi
output      y       ;

// port veri tipleri
wire        a       ;
wire        b       ;
wire        c       ;
wire        d       ;
wire        y       ;

// iç değişkenler
wire        out_0   ;
wire        out_1   ;

// başlıyor

xor u0 (out_0, a, b);

xor u1 (out_1, c, d);

xor u2 (y, out_0, out_1);

endmodule // eşlik (parity) modülünün sonu
```


## Sıralı İfade Grupları (begin-end)
* Ardışıl gruplar içindeki herhangi bir zamanlama bir önceki ifade ile ilişkilidir.
* Her bir gecikme bir önceki gecikmeye eklenir.


## Paralel İfade Grupları (fork-join)
* Tüm ifadeler paralel olarak hepsi aynı zamanda gerçekleşir.

Örneğin:
``` verilog
module initial_fork_join();
reg clk, reset, enable, data;

initial begin
    $monitor ("%g clk=%b reset=%b enable=%b data=%b",
        $time, clk, reset, enable, data);
    fork
        #1  clk = 0;
        #10 reset = 0;
        #5  enable = 0;
        #3  data = 0;
    join

        #1  $display ("%g terminating simulation", $time);
    $finish;
end

endmodule
```

Burada clk 1 birim, reset 10 birim, enable 5 birim, data ise 3 birim zaman sonra değerini alır. Haliyle tüm ifadeler paralel, aynı zamanda gerçekleşir. Sıralı ifade gruplarında ise (begin-end) zamanın hep bir önceki ifadenin zamanına eklenerek gerçekleştiğine dikkat edilmelidir. Görüldüğü üzere begin-end ve fork-join birlikte de kullanılabilir.


## Bloklayan ve Bloklamayan (Blocking & Nonblocking) Atamalar
Bloklayan (tıkayan) atamalar kodlandığı sırada gerçekleştirilir ve bu yüzden ardışıldır. Bloklayan atamalarda şuanki ifade gerçekleştirilene kadar bir sonraki ifade tıkanır. Atamaları "=" ile yapılır.

Bloklamayan ifadeler ise paralel olarak gerçekleştirilir. Bir sonraki ifadenin gerçekleştirilmesi mevcut ifadenin gerçekleşmesini beklemez, yani mevcut ifade bir sonraki ifadeyi tıkamaz. Atamaları ise "<=" ile yapılır.

## assign & deassign
`assign` prosedürel ifadesi bir yazmacın üzerine prosedürel olarak yazar. `deassign` prosedürel ifadesi ise bir yazmacın sürekli olarak atanmasını sonlandırır.


## force & release
Prosedürel sürekli atama ifadesinin başka bir biçimidir.


## case İfadesi
`case` bir ifadeyi seri bir durumla karşılaştırır ve ifadeyi gerçekleştirir ya da ilk eşleşen durumla ilgili olan bir grup ifadeyi gerçekleştirir.
* Tekli veya çoklu ifadeleri destekler.
* Çoklu ifadelerin gruplanması begin-end ile sağlanır.

Normal `case` Örneği:
``` verilog
module mux (a, b, c, d, sel, y);
input a, b, c, d;
input [1:0] sel;
output y;

reg y;

always @(a or b or c or d or sel)
case (sel)
    0   :   y = a;
    1   :   y = b;
    2   :   y = c;
    3   :   y = d;
    default : $display("error in SEL");
endcase

endmodule
```

Default'suz `case` Örneği:
``` verilog
module mux_without_default (a, b, c, d, sel, y);
input a, b, c, d;
input [1:0] sel;
output y;

reg y;

always @(a or b or c or d or sel)
case (sel)
    0   :   y = a;
    1   :   y = b;
    2   :   y = c;
    3   :   y = d;
    2'bxx,2'bx0,2'bx1,2'b0x,2'b1x,
    2'bzz,2'bz0,2'bz1,2'b0z,2'b1z, : $display("error in SEL");
endcase

endmodule
```

`case`'in x ve z ile Kullanımı Örneği:
``` verilog
module case_xz(enable);
input enable;

always @(enable)
case (enable)
    1'bz : $display ("enable is floating");
    1'bx : $display ("enable is unknown");
    default : $display ("enable is %b", enable);
endcase

endmodule
```

Ayrıca x ve z için `casex` ve `casez` anahtar kelimeleri de bulunmaktadır.


## Döngüleme İfadeleri
* forever
* repeat
* while
* for

### forever Döngüsü
forever döngüsü sürekli olarak gerçekleştirilir ve döngü asla sonlanmaz.

Örneğin (serbest hareketli saat üreteci, free running clock generator):
``` verilog
module forever_example ();

reg clk;

initial begin
    #1 clk = 0;
    forever begin
        #5 clk = ! clk;
    end
end

initial begin
    $monitor ("Time = %d clk = %b", $time, clk);
    #100 $finish;
end

endmodule
```

### repeat Döngüsü
Döngü belirli bir sayıda gerçekleştirilebilir.

Örneğin:
``` verilog
// ...

repeat (8) begin
    // ...
end

// ...
```

### while Döngüsü
Döngü şartı sağlandığı sürece döngü gerçekleşir.

Örneğin:
``` verilog
// ...

while (data[0] == 0) begin
    // ...
end

// ...
```

### for Döngüsü
Örneğin:
``` verilog
// ...

for (i = 0; i < 256; i = i + 1) begin // (<başlangıç>; <deyim>; <adım>)
    // ...
end

// ...
```


## Sürekli Atama İfadeleri
Sürekli atama ifadeleri net'leri (wire veri tipini) sürer. Yapısal bağlantıları gösterir.

* Üç durumlu (tri-state) arabelleklerini modellemek için kullanılır.
* Kombinasyonel lojiği modüllemek için kullanılır.
* Prosedürel bloğun (`always` & `initial` bloklarının) dışındadır.
* Sürekli atamanın sol tarafı mutlaka bir veri tipinde olmalıdır.

Örneğin (tek bit toplayıcı):
``` verilog
module adder_using_assign ();
reg a, b;
wire sum, carry;

assign #5 (carry, sum) = a + b;

initial begin
    $monitor ("A = %b B = %b CARRY = %b sum = %b", a, b, carry, sum);
```

Örneğin (üç durumlu arabellek, tri-state buffer):
``` verilog
module module tri_buf_using_assign ();
reg data_in, enable;
wire pad;

assign pad = (enable) ? data_in : 1'bz;

initial begin
    $monitor ("TIME = %g ENABLE = %b DATA : %b PAD %b",
        $time, enable, data_in, pad);
    #1 enable = 0;
    #1 data_in = 1;
    #1 enable = 1;
    #1 data_in = 0;
    #1 enable = 0;
    #1 finish;
end

endmodule
```


## Yayılım Gecikmesi (Propagation Delay)
Sürekli atamalar belirtilmiş bir gecikmeye sahiptir. Sadece tüm geçişler için gecikmeler belirtilmiş olmalıdır. Bir "minimum:tipik:maksimum" gecikme aralığı belirtilmelidir.

Örneğin (üç durumlu arabellek, tri-state buffer):
``` verilog
module tri_buf_assign_delays();
reg data_in, enable;
wire pad;

assign #(1:2:3) pad = (enable) ? data_in : 1'bz;

initial begin
    $monitor ("ENABLE = %b DATA : %b PAD %b", enable, data_in, pad);
     #10    enable = 1;
     #10    data_in = 1;
     #10    enable = 1;
     #10    data_in = 0;
     #10    enable = 0;
     #10    $finish;
end

endmodule
```


## Prosedürel Blok Kontrolü
Prosedürel blok, simülasyon zamanın sıfır anında aktif olacaktır.


## Prosedürel Kodlama Kullanılarak Çoklu Lojik (Combo Logic)
Eğer koşullu kontrol `if` kullanılarak yapılıyorsa, `else` kullanılmak zorundadır. `else`'nin olmaması bir tutucu (latch) ile sonuçlanır. Eğer `else` yazılmak istenmiyor ise çoklu bloğun (combo logic) tüm değişkenlerine ilk değer verilmelidir.

Latch Oluşmasının Önlenmesi Örneği (tüm koşulların belirtilmesi):
``` verilog
module avoid_latch_else ();

reg q;
reg enable, d;

always @(enable or d)
if (enable) begin
    q = d;
end else begin
    q = 0;
end

endmodule
```

Latch Oluşmasının Önlenmesi Örneği (hataya meyilli değişkenlerin sıfır yapılması):
``` verilog
module avoid_latch_init ();

reg q;
reg enable, d;

always @(enable or d)
begin
    q = 0;
    if (enable) begin
        q = d;
    end
end

endmodule
```


## Prosedürel Kodlama Kullanılarak Ardışıl Lojik
* Ardışıl lojiği modellemek için bir prosedür bloğu saatin pozitif veya negatif kenarına hassas olmalıdır.
* Asenkron sıfırlama (reset) modellemek için prosedür bloğu hem saate hem de reset'e hassas olmalıdır.
* Ardışıl lojikteki tüm atamalar birbirini tıkamayan-engellemeyen (nonblocking) şekilde olmalıdır.

Bazen sensitive list'te çoklu kenar tetiklemeli değişkenlere sahip olmak istenebilir. Bu durum simülasyon için iyidir ancak sentez için gerçek hayattaki kadar hassas değildir. Flip-flop'un sadece bir saati, bir reset (sıfırlama) ve bir preset (önayarlı) olabilir.

Yeni başlayanların sıklıkla karşılaştıkları bir başka hata ise saatin (clock) flip-flop'un enable (etkin) girişine bağlanmasıdır. Bu durum da simülasyon için iyidir ancak sentez için doğru değildir.

İki saat kullanma Örneği (kötü kodlama):
``` verilog
module wrong_seq ();

reg q;
reg clk1, clk2, d1, d2;

always @(posedge clk1 or posedge clk2)
if (clk1) begin
    q <= d1;
end else if (clk2) begin
    q <= d2;
end

always
    #1      clk1 = ~clk1;

always
    #1.9    clk2 = ~clk2;

endmodule
```

Asenkron Reset ve Asenkron Preset'li D Flip-Flop Örneği:
``` verilog
module dff_async_reset_async_prst ();

reg clk, reset, preset, d;
reg q;

always @(posedge clk or posedge reset or posedge preset)
if (reset) begin
    q <= 0;
end else if (preset) begin
    q <= 1;
end else begin
    q <= d;
end

always
#1 clk = ~clk;

endmodule
```

Senkron Reset ve Senkron Preset'li D Flip-Flop Örneği:
``` verilog
module dff_sync_reset_sync_prst ();

reg clk, reset, preset, d;
reg q;

always @(posedge clk)
if (reset) begin
    q <= 0;
end else if (preset) begin
    q <= 1;
end else begin
    q <= d;
end

always
#1 clk = ~clk;

endmodule
```


## Prosedürel Blok Uyumluluğu
Eğer bir modülün içinde birden çok `always` bloğu varsa, tüm bloklar (`always` ve `initial`) sıfır zamanında gerçekleştirilmeye başlanacaktır ve eş zamanlı olarakçalışmaya devam edecektir. Eğer kodlama uygun şekilde yapılmamış ise bazen bu bir yarış durumuna neden olur.


## Yarış Durumu (Race Condition)
Örneğin:
``` verilog
module race_condition();
reg b;

initial begin
    b = 0;
end

initial begin
    b = 1;
end

endmodule
```

Yukarıdaki örnekte her iki blok da aynı zamanda gerçekleştiğinden b'nin değerinin ne olduğunu söylemek zordur. Yarış durumu verilog'ta sıkça olan bir olaydır.


## İsimlendirilmiş Bloklar
Bloklara isim verilebilir. `begin: <BLOK_ISMI>` şeklinde uygulanabilir. Ayrıca isimlendirilmiş bloklar `disable` ifadesi ile etkisizleştirilebilir.


## Procedural Timing Control
Prosedürel Blok ve Zamanlama Kontrolleri;
* Gecikme (delay) Kontrolleri
* Kenar Hassasiyetli Olay (edge-sensitive event) Kontrolleri
* Seviye Hassasiyetli Olay (level-sensitive event) Kontrolleri - Bekleme (wait) ifadeleri
* İsimlendirilmiş Olaylar


## Task & Functions (Görev ve Fonksiyonlar)

## Task (Görev)
* Veri göreve gönderilir.
* İşlem bittikten sonra sonuç döndürülür.
* Bunlar özel olarak veri girişleri (data ins) veri çıkışları (data outs) yada netlistdeki tel(wire) olarak isimlendirilmelidir.
* Task, kodun ana gövdesine eklenmiştir.
* Birden çok kez çağırılabilinir. Böylece kod tekrarlarından kaçınılmış olunur.
* Görevler(tasks) modülde kullanıldığı yerde tanımlanmıştır.
* Bir görevi farklı dosyalarda da tanımlamak mümkündür ve görevin olduğu derleme yönergesine göre eklenebilir.
* Görevler, posedge, negedge, delay ve wait gibi zamanlama gecikmelerini (timing delays) içerebilir.
* Görevler birçok sayıda giriş veya çıkışlara sahip olabilirler.
* Değişkenler görevlerin içinde bildirilirler ve sadece bu görev içinde görülebilir yani yerel değişkendir.
* Görev içindeki bildirim sırası görev çağırıldığında değişkenlerin göreve nasıl gönderileceğini tanımlamaktadır.
* Görevler yerel değişkenler kullanılmadığı zaman global değişkenleri kullanabilir.
* Yerel değişkenler kullanıldığında, temelde çıkış sadece görev gerçekleştirilmesinin soununda atanır.
* Görevler başka görevleri veya fonksiyonları çağırabilir.
* Görevler kombinasyonel ve ardışıl lojik modelleme için kullanılabilir.
* Bir görev özellikle bir ifade ile çağırılmalıdır, fonksiyonda olduğu gibi bir ifadenin içinde kullanılamaz.
* Bir görev `task` anahtar sözcüğüyle başlar ve `endtask` anahtar sözcüğüyle biter.
* Girişler ve çıkışlar `task` anahtar sözcüğünden sonra bildirilirler.
* Yerel değişkenler, giriş ve çıkışlar bildiriminde sonra bildirilirler.

Basit Bir Görev Örneği:
``` verilog
module simple_task ();

task convert;

input   [7:0] temp_in;
output  [7:0] temp_out;

begin
    temp_out = (9/5)*(temp_in+32);
end

endtask

endmodule
```

Global Değişkenler Kullanılan Görevler Örneği:
``` verilog
module task_global();

reg [7:0] temp_out;
reg [7:0] temp_in;

task convert;

begin
    temp_out = (9/5)*(temp_in+32);
end

endtask

endmodule
```

### Bir Görevin Çağrılması (Calling a Task)
Bir görevin ayrı bir dosyada kodlanması, bu görevin birçok modülde kullanılabilmesine olanak tanır. Örneğin yukarıdaki `simple_task` modül isimli görev "simple_task.v" isimli bir görev dosyası olsun. Bu dosya aşağıdaki örnekte olduğu gibi kullanılabilmektedir.

``` verilog
module task_calling (temp_a, temp_b, temp_c, temp_d);

input   [7:0] temp_a,   temp_c;
output  [7:0] temp_b,   temp_d;

reg     [7:0] temp_b,   temp_d;

`include "simple_task.v"

always @(temp_a)
begin
    convert (temp_a, temp_b);
end

always @(temp_c)
begin
    convert (temp_c, temp_d);
end

endmodule
```

CPU Yazma/Okuma Görevi (Write/Read Task) Örneği:
``` verilog
module bus_wr_rd_task();

reg clk, rd, wr, ce;
reg [7:0] addr, data_wr, data_rd;
reg [7:0] read_data;

initial begin
    clk = 0;
    read_data = 0;
    rd = 0;
    wr = 0;
    ce = 0;
    addr = 0;
    data_wr = 0;
    data_rd = 0;

    // yazma (write) ve okuma (read) görevleri burada çağrılmaktadır.
     #1     cpu_write(8'h11, 8'hAA);
     #1     cpu_read(8'h11, read_data);
     #1     cpu_write(8'h12, 8'hAB);
     #1     cpu_read(8'h12, read_data);
     #1     cpu_write(8'h13, 8'h0A);
     #1     cpu_read(8'h13, read_data);
     #100   $finish;
end

// saat üreteci (clock generator)
always
     #1     clk = ~clk;

// CPU okuma (read) görevi
task cpu_read;
    input   [7:0] address;
    output  [7:0] data;
    
    begin
        $display ("%g CPU READ TASK WITH ADDRESS : %h", $time, address);
        $display ("%g -> DRIVING CE, RD AND ADDRESS ON TO BUS", $time);
        @ (posedge clk);
        addr = address;
        ce = 1;
        rd = 1;
        @ (negedge clk);
        data = data_rd;
        @ (posedge clk);
        addr = 0;
        ce = 0;
        rd = 0;
        $display ("%g CPU READ DATA : %h", $time, data);
        $display ("=================");
    end
endtask

// CPU yazma (write) görevi
task cpu_write;
    input   [7:0] address;
    output  [7:0] data;
    
    begin
        $display ("%g CPU WRITE TASK WITH ADDRESS : %h DATA : %h", $time, address, data);
        $display ("%g -> DRIVING CE, WR, WR DATA AND ADDRESS ON TO BUS", $time);
        @ (posedge clk);
        addr = address;
        ce = 1;
        wr = 1;
        data_wr = data;
        @ (posedge clk);
        addr = 0;
        ce = 0;
        wr = 0;
        $display ("=================");
    end
endtask

// görevleri test etmek için bellek modeli
reg [7:0] mem[0:255];

always @(addr or ce or rd or wr or data_wr)
if (ce) begin
    if (wr) begin
        mem[addr] = data_wr;
    end

    if (rd) begin
        data_rd = mem[addr];
    end
end

endmodule
```

## Function (Fonksiyon)
Bir Verilog HDL fonksiyonu bir görevle (task) neredeyse aynıdır.
* Fonksiyon birden fazla çıkış süremez, gecikme içeremez.
* Fonksiyonlar kullanılacakları modülde tanımlanırlar.
* Fonksiyonlar ayrı dosyalarda tanımlanabilir ve derleme yönergesine göre görevler örneklenerek istenilen fonksiyon eklenir.
* Fonksiyonlar zamanlama gecikmelerini içeremez. Posedge, negedge ve #delay'de olduğu gibi. Bunun anlamı fonksiyonlar "sıfır" zaman gecikmesiyle gerçekleştirilir.
* Fonksiyonlar istediği sayıda girişe sahip olabilir ancak sadece bir tane çıkış içerebilir.
* Fonksiyon içerisinde bildirilen değişkenler sadece bu fonksiyon içinde görülebilir yerel değişkenlerdir.
* Fonksiyon içindeki bildirim sırası, değişkenlerin kullanan tarafından nasıl gönderileceğini tanımlar.
* Fonksiyonlar yerel değişkenler kullanılmadığı zaman global değişkenler kullanılabilir.
* Yerel değişkenler kullanıldığı zaman temelde çıkış sadece fonksiyon gerçekleştirildikten sonra atanır.
* Fonksiyonlar kombinasyonel lojiği modellemek için kullanılabilir.
* Fonksiyonlar diğer fonksiyonları çağırabilir ancak görevleri çağıramazlar.
* Bir fonksiyon `function` anahtar sözcüğü ile başlamaktadır ve `endfunction` fonksiyonu ile sonlandırılmaktadır.
* Girişler (inputs) `function` anahtar sözcüğünden sonra bildirilmektedir.

Basit Bir Fonksiyon Örneği
``` verilog
module simple_function ();

function myfunction;

input a, b, c, d;

begin
    myfunction = ((a+b) + (c-d));
end

endfunction

endmodule
```

Bir Fonksiyonun Çağrılması Örneği:
``` verilog
module function_calling (a, b, c, d, e, f);

input   a, b, c, d, e;
output  f;
wire    f;

`include "myfunction.v"

assign f = (myfunction (a, b, c, d)) ? e : 0;

endmodule
```


## System Task & Function (Sistem Görev ve Fonksiyonları)
* Simülasyon sırasında giriş ve çıkış üretmek için görevler (tasks) ve fonksiyonlar (functions) vardır. Bunların isimleri dolar işaretiyle ($) başlar.
* Sentez araçları sistem fonksiyonlarını ayrıştırır ve gözardı eder. Bundan dolayı sentezlenebilir modellere bile eklenebilir.
* ` $display`, `$strobe`, `$monitor` komutları aynı sözdizimine sahiptir ve simülasyon esnasında metni ekranda gösterir.
* GTKWave, Undertow veya Debussy dalgaformu gösterme aracından daha az kullanışlıdır.
* `$display` ve `$strobe` her seferinde bir kez metni ekranda gösterir ancak `$monitor`, parametrelerden birinin değiştiği her seferde metni ekranda gösterir.
* `$display` ile `$strobe` arasındaki fark, `$strobe` gerçekleştiği andan ziyade mevcut simülasyon zaman birimin en sonunda parametrelerini gösterir.
* `$time`, `$stime`, `$realtime` komutları mevcut simülasyon zamanlarını sırasıyla 64-bit’lik tamsayı, 32-bit’lik tamsayı ve reelsayı olarak döndürür.
* `$reset` komutu simülasyon zamanını 0’a döndürerek sıfırlar.
* `$stop` komutu simülatörü durdurur ve etkileşimli moda geçirerek kullanıcıya komut girmesi sağlanır.
* `$finish` komutu simülatörden çıkarak işletim sistemine dönmeyi sağlar.
* `$scope(hiyerarşi_adi)` komutu mevcut hiyerarşik kapsamı "hiyerarşi_adi" olarak atar.
* `$showscopes(n)` komutu mevcut kapsamda tüm modülleri, görevleri ve blok isimlerini listeler.
* `$random` komutu çağırıldığı her anda rasgele bir tamsayı üretir. Eğer sıra tekrarlanabilirse, ilk olarak bir sayısal argüman (seed) verilir. Diğer türlü "seed" bilgisayarın saatinden türetilir.
* `$dumpfile`, `$dumpvar`, `$dumpon`, `$dumpoff`, `$dumpall` komutları debussy gibi simülasyon izleyicisine değişkenlerin değişimini döker. Döküm dosyaları bir simülasyondaki tüm değişkenleri dökebilir durumdadır. Bu durum hata ayıklama (debugging) için kullanışlıdır ancak çok yavaş olabilir.
* `$fopen`, `$fdisplay`, `$fstrobe`, `$fmonitor`, `$fwrite` komutları daha seçici olarak dosyalara yazar.
* `$fopen` komutubir çıkış dosyası açar ve bu açık dosyaya diğer komutlar tarafından ulaşmaya imkan sağlar.
* `$fclose` komutu osyayı kapatır böylece diğer programlar bu dosyaya ulaşabilir. 
* `$fdisplay` ve `$fwrite` komutları bir dosyaya biçimli yazmayı sağlar. Birbiriyle aynıdır fakat `$fdisplay` komutu her bir gerçekleşmede yeni bir satır eklerken, `$write` komutu, eklemez.
* `$strobe` komutu da gerçekleştirildiğinde dosyaya yazar fakat yazmadan önce zaman adımındaki tüm işlemlerin tamamlanmasını bekler.


## Testbench Yazma Sanatı
Günümüzde ASIC ve diğer sayısal tasarımlar oldukça karmaşık bir hal almıştır. Haliyle artık testbench yazmak RTL kodun kendisini yazmak kadar karmaşıktır. Gelinen noktada tipik olarak bir ASIC için harcanan sürenin 60-70%'i doğrulama (verification), geçerleme (validation) ve test (testing) aşamaları için harcanmaktadır.

Testbench yazmak için öncelikle DUT (design under test, test altındaki tasarım) belirtimleri (specification) bilinmelidir. Belirtimler açıkça anlaşılmış olmalı ve testbench mimarisinin ve test senaryosunun temel dokümanlarının detaylı olarak yapılması gerekmektedir.

Örneğin (sayaç, counter):
``` verilog
//-----------------------------------------------------------------------
//
// tasarım ismi     : counter (sayaç)
// dosya ismi       : counter.v
// fonksiyon        : 4-bit up counter
// kodlayan         : YONGA (Muhammed Conger)
//
//-----------------------------------------------------------------------

module countert (clk, reset, enable, count);
input           clk, reset, enable;
output  [3:0]   count;
reg     [3:0]   count;

always @(posedge clk)
if (reset == 1'b1) begin
    count <= 0;
end else if (enable == 1'b1) begin
    count <= count + 1;
end

endmodule
```


## Test Planı
Aşağıdaki testbench ortamı ile kendi kendini test eden otomatik bir testbench yazılmak istensin.

![Image](https://www.asic-world.com/images/verilog/vcount_tb.gif)

DUT testbench'te örneklenir ve testbench bir saat üreteci, reset (sıfırlama) üreteci, enable (etkin) lojik üreteci ve temel olarak sayacın beklenen değerini hesaplayan ve bunu sayacın çıkışındaki değer ile karşılaştıran bir karşılatırma lojik içerir.


## Testbench Yazma
Herhangi bir testbench oluşturmanın ilk adımı DUT'a girişleri `reg` olarak bildiren ve DUT'tan çıkışları bir `wire` olarak alan bir şablon oluşturmaktır. Ardından aşağıda gösterildiği gibi DUT örneklenmelidir. (NOT: Testbench'te port listesi yoktur.)

``` verilog
module counter_tb;
    reg             clk, reset, enable;
    wire    [3:0]   count;

    counter     U0 (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .count  (count)
    );

endmodule
```


Saat Üreteçli Testbench:
``` verilog
module counter_tb;
    reg             clk, reset, enable;
    wire    [3:0]   count;

    counter     U0 (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .count  (count)
    );

    initial
    begin
        clk = 0;
        reset = 0;
        enable = 0;
    end

    always
         #5 clk = ! clk;

endmodule
```

Bir başlangıç (initial) bloğu verilog'ta sadece bir kez gerçekleştirilir. Böylece simülator `clk`, `reset` ve `enable` değerlerini 0 olarak atar.


## Bellek Modelleme
Belleklerin davranışsal modelleri yazmaç değişkenlerinin dizisiyle bildirilerek modellenir. Dizideki herhangi bir sözcüğe dizinin indisiyle erişilebilir. Dizideki ayrık bir bit'e ulaşmak için geçici bir değişken gereklidir.

Söz Dizimi:
``` verilog
reg [wordsize:0] array_name [0:arraysize]
```


### Bildirim (Declaration)
``` verilog
reg [7:0] my_memory [0:255];
```

Burada `[7:0]` belleğin genişliği ve `[0:255]` ise belleğin derinliğidir. Parametreleri şöyledir;
* Genişlik (With): 8 bit (En yüksek bit en soldadır.)
* Derinlik (Depth): 256 (0'ıncı adres, dizideki 0'ıncı bölgeyi belirtir.)


### Değerlerin Saklanması
``` verilog
my_memory[address] = data_in;
```


### Değerlerin Okunması
``` verilog
data_out = my_memory[address];
```


### Bit Okuma (Read)
Bazen sadece bir bit'in okunmasına ihtiyaç duyulabilir. Ancak verilog bir bit'lik okumaya ya da yazmaya izin vermez. Bu nedenle şu şekilde bir incelik düşünülmüştür;
``` verilog
data_out = my_memory[address];

data_out_it_0 = data_out[0];
```


### Belleği Parafe Etmek (Initializing Memories)
Bir bellek dizisi diskteki bellek örüntü dosyasından okuyarak ve onu bellek dizisinde saklayarak parafe edebilir (başlatabilir). Bunu yapabilmek için sistem görevlerinden `$readmemb` ve `$readmemh` ifadeleri kullanılır. `$readmemb` belleğin içeriğinin ikili gösterimi için kullanılırken `$readmemh` ise belleğin içeriğinin hex-16'lık gösterimi için kullanılır.

Söz Dizimi:
``` verilog
$readmemh("file_name", mem_array, start_addr, stop_addr);
```

Basit Bellek Örneği:
``` verilog
module memory();
reg [7:0] my_memory [0:255];

initial begin
    $readmemh("memory.list", my_memory);
end

endmodule
```

"memory.list" Dosyası Örneği:
``` verilog
// açıklamalara (comments) izin verilir
1100_1100   // bu ilk adrestir              :8'h00
1010_1010   // bu ikinci adrestir           :8'h01
@ 55        // yeni bir adres atla (jump)   :8'h55
0101_1010   // bu adres                     :8'h55
0110_1001   // bu adres                     :8'h56
```


## FSM Modelleme
Durum makineleri veya sonlu durum makineleri (FSM) sayısal tasarımın kalbidir.

### Durum Makine Tipleri
Herbirinden üretilen çıkışlara göre sınıflandırılmış iki tip durum makinesi bulunmaktadır. "Mealy" ve "Moore" durum makineleri.

Durum makineleri durumların şifrelenmesine göre de sınıflandırılabilir. Şifreleme (encoding) stili kritik bir faktördür. Bu FSM'nin hızına ve kapı karmaşıklığına karar verir. "binary", "gray", "one-hot", "one-cold" ve "almost one-hot", FSM için kullanılan farklı tipteki şifreleme stilleridir.


### Mealy Modeli
Çıkışlardan biri ya da birkaçı şuanki durumun bir ya da birkaç girişinin bir fonksiyonudur.

![Image](https://www.asic-world.com/images/verilog/mealy_fsm.gif)


### Moore Modeli
Çıkışlar sadece şuanki durumun bir fonksiyonudur.

![Image](https://www.asic-world.com/images/verilog/moore_fsm.gif)


### Durum Makinelerinin Modellenmesi
FSM kodlanırken kombinasyonel ve ardışıl lojik iki farklı always bloğunda olabilir. Her iki şekilde de bir sonraki durum lojiği (next state logic) always bloğunda kombinasyoneldir. Durum yazmaçları (state registers) ve çıkış lojiği (output logic) ise ardışıl lojiktir. Bu ayrıntılar oldukça önemlidir. Bu sayede bir sonraki durum lojiği için asenkron sinyaller FSM'yi beslemeden önce senkronlaştırılabilir. Ayrıca FSM'nin her zaman ayrı bir verilog dosyasında tutulması iyi olacaktır.

Parametreler gibi sabit bildirimi kullanmak ya da `'define` (tanımlamak) ile FSM'nin durumlarını tanımlamak kodu daha okunabilir ve daha kolay yönetilebilir yapmaktadır.


### Örnek Arbiter (Arabulucu)

![Image](https://www.asic-world.com/images/verilog/aribiter_fsm.gif)


### Verilog Kodu
FSM kodu üç bölüm içerir.
* Encoding (Şifreleme)
* Combinational (Kombinasyonel)
* Sequential (Ardışıl)


## Encoding Section (Şifreleme Bölümü)
Birçok şifreleme şekli bulunmaktadır. Bunlardan birkaçı aşağıda verilmiştir;
* Binary Encoding
* One Hot Encoding
* One Cold Encoding
* Almost One Hot Encoding
* Almost One Cold Encoding
* Gray Encoding


### One Hot Encoding
``` verilog
parameter   [4:0]   IDLE    = 5'b0_0001;
parameter   [4:0]   GNT0    = 5'b0_0010;
parameter   [4:0]   GNT1    = 5'b0_0100;
parameter   [4:0]   GNT2    = 5'b0_1000;
parameter   [4:0]   GNT3    = 5'b1_0000;
```


### Binary Encoding
``` verilog
parameter   [2:0]   IDLE    = 3'b0_000;
parameter   [2:0]   GNT0    = 3'b0_001;
parameter   [2:0]   GNT1    = 3'b0_010;
parameter   [2:0]   GNT2    = 3'b0_011;
parameter   [2:0]   GNT3    = 3'b1_100;
```


### Gray Encoding
``` verilog
parameter   [2:0]   IDLE    = 3'b0_000;
parameter   [2:0]   GNT0    = 3'b0_001;
parameter   [2:0]   GNT1    = 3'b0_011;
parameter   [2:0]   GNT2    = 3'b0_010;
parameter   [2:0]   GNT3    = 3'b1_110;
```


## Combinational Section (Kombinasyonel Bölüm)
Bu bölüm fonksiyonlarla, atama ifadeleriyle veya bir `case` ifadesi ile `always` bloğu kullanılarak modellenebilir.

``` verilog
always @ (state or req_0 or req_1 or req_2 or req_3)
begin       
  next_state = 0;
  case(state)
    IDLE : if (req_0 == 1'b1) begin
  	     next_state = GNT0;
           end else if (req_1 == 1'b1) begin
  	     next_state= GNT1;
           end else if (req_2 == 1'b1) begin
  	     next_state= GNT2;
           end else if (req_3 == 1'b1) begin
  	     next_state= GNT3;
	   end else begin
  	     next_state = IDLE;
           end			
    GNT0 : if (req_0 == 1'b0) begin
  	     next_state = IDLE;
           end else begin
	     next_state = GNT0;
	  end
    GNT1 : if (req_1 == 1'b0) begin
  	     next_state = IDLE;
           end else begin
	     next_state = GNT1;
	  end
    GNT2 : if (req_2 == 1'b0) begin
  	     next_state = IDLE;
           end else begin
	     next_state = GNT2;
	  end
    GNT3 : if (req_3 == 1'b0) begin
  	     next_state = IDLE;
           end else begin
	     next_state = GNT3;
	  end
   default : next_state = IDLE;
  endcase
end
```


## Sequential Section (Ardışıl Bölüm)
Bu bölümde modelleme sadece kenar hassasiyetli lojik olan `posedge` veya `negedge` saatli `always` bloğu kullanılarak yapılmak zorundadır.

``` verilog
always @ (posedge clock)
begin : OUTPUT_LOGIC
  if (reset == 1'b1) begin
    gnt_0 <= #1 1'b0;
    gnt_1 <= #1 1'b0;
    gnt_2 <= #1 1'b0;
    gnt_3 <= #1 1'b0;
    state <= #1 IDLE;
  end else begin
    state <= #1 next_state;
    case(state)
        IDLE : begin
                 gnt_0 <= #1 1'b0;
                 gnt_1 <= #1 1'b0;
                 gnt_2 <= #1 1'b0;
                 gnt_3 <= #1 1'b0;
	           end
  	    GNT0 : begin
  	             gnt_0 <= #1 1'b1;
  	           end
        GNT1 : begin
                 gnt_1 <= #1 1'b1;
               end
        GNT2 : begin
                 gnt_2 <= #1 1'b1;
               end
        GNT3 : begin
                 gnt_3 <= #1 1'b1;
               end
     default : begin
                 state <= #1 IDLE;
               end
    endcase
  end
end
```

### Binary Encoding Kullanmanın Tam Kodu
``` verilog
module fsm_full(
clock ,
reset ,
req_0 ,
req_1 ,
req_2 ,
req_3 ,
gnt_0 ,
gnt_1 ,
gnt_2 ,
gnt_3
);

input  clock ;
input  reset ;
input  req_0 ;
input  req_1 ;
input  req_2 ;
input  req_3 ;
output gnt_0 ;
output gnt_1 ;
output gnt_2 ;
output gnt_3 ;

reg    gnt_0 ;
reg    gnt_1 ;
reg    gnt_2 ;
reg    gnt_3 ;

parameter  [2:0]  IDLE  = 3'b000;
parameter  [2:0]  GNT0  = 3'b001;
parameter  [2:0]  GNT1  = 3'b010;
parameter  [2:0]  GNT2  = 3'b011;
parameter  [2:0]  GNT3  = 3'b100;

reg [2:0] state, next_state;

always @ (state or req_0 or req_1 or req_2 or req_3)
begin  
  next_state = 0;
  case(state)
    IDLE : if (req_0 == 1'b1) begin
  	            next_state = GNT0;
           end else if (req_1 == 1'b1) begin
  	            next_state= GNT1;
           end else if (req_2 == 1'b1) begin
  	            next_state= GNT2;
           end else if (req_3 == 1'b1) begin
  	            next_state= GNT3;
	       end else begin
  	            next_state = IDLE;
           end		
    GNT0 : if (req_0 == 1'b0) begin
  	            next_state = IDLE;
           end else begin
	            next_state = GNT0;
	       end
    GNT1 : if (req_1 == 1'b0) begin
  	            next_state = IDLE;
           end else begin
	            next_state = GNT1;
	       end
    GNT2 : if (req_2 == 1'b0) begin
  	            next_state = IDLE;
           end else begin
	            next_state = GNT2;
	       end
    GNT3 : if (req_3 == 1'b0) begin
  	            next_state = IDLE;
           end else begin
	            next_state = GNT3;
	       end
      default : next_state = IDLE;
  endcase
end

always @ (posedge clock)
begin : OUTPUT_LOGIC
  if (reset) begin
    gnt_0 <= #1 1'b0;
    gnt_1 <= #1 1'b0;
    gnt_2 <= #1 1'b0;
    gnt_3 <= #1 1'b0;
    state <= #1 IDLE;
  end else begin
    state <= #1 next_state;
    case(state)
	    IDLE : begin
                gnt_0 <= #1 1'b0;
                gnt_1 <= #1 1'b0;
                gnt_2 <= #1 1'b0;
                gnt_3 <= #1 1'b0;
	           end
  	    GNT0 : begin
  	            gnt_0 <= #1 1'b1;
  	           end
        GNT1 : begin
                 gnt_1 <= #1 1'b1;
               end
        GNT2 : begin
                 gnt_2 <= #1 1'b1;
               end
        GNT3 : begin
                 gnt_3 <= #1 1'b1;
               end
     default : begin
                 state <= #1 IDLE;
               end
    endcase
  end
end

endmodule
```


### Testbench
``` verilog
`include "fsm_full.v"

module fsm_full_tb();
reg     clock , reset ;
reg     req_0 , req_1 , req_2 , req_3 ; 
wire    gnt_0 , gnt_1 , gnt_2 , gnt_3 ;

initial begin
  $display("Time\t    R0 R1 R2 R3 G0 G1 G2 G3");
  $monitor("%g\t    %b  %b  %b  %b  %b  %b  %b  %b", 
    $time, req_0, req_1, req_2, req_3, gnt_0, gnt_1, gnt_2, gnt_3);
  clock = 0;
  reset = 0;
  req_0 = 0;
  req_1 = 0;
  req_2 = 0;
  req_3 = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 req_0 = 1;
  #20 req_0 = 0;
  #10 req_1 = 1;
  #20 req_1 = 0;
  #10 req_2 = 1;
  #20 req_2 = 0;
  #10 req_3 = 1;
  #20 req_3 = 0;
  #10 $finish;
end

always
 #2 clock = ~clock;


fsm_full U_fsm_full(
clock ,
reset ,
req_0 ,
req_1 ,
req_2 ,
req_3 ,
gnt_0 ,
gnt_1 ,
gnt_2 ,
gnt_3
);


endmodule
```


## Parameterized Modules (Parametreleştirilmiş Modüller)
Devam edecek..