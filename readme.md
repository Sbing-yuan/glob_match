# glob_match

SystemVerilog 自製字串 wildcard（萬用字元）比對函式，用於在 testbench 中對 `$value$plusargs` 讀入的字串（例如 `CASE`）做類似 shell glob 的模式比對

## 支援的萬用字元

| 字元 | 意義 |
|---|---|
| `*` | 匹配任意長度（含 0 個）的任意字元 |
| `?` | 匹配剛好一個任意字元 |

不支援 `[...]` 字元集合、`{...}` 多重選項等進階 glob 語法，僅支援 `*` 與 `?`。

## Function 原型

```systemverilog
function automatic bit glob_match(string pattern, string str);
```

| 參數 | 說明 |
|---|---|
| `pattern` | 萬用字元樣式，例如 `"I01*"`、`"*SPI"`、`"I0?_*"` |
| `str` | 要被比對的實際字串，例如從 `$value$plusargs` 讀到的 `CASE` |

**回傳值**：`1`（match）／`0`（不 match）。

## 使用方式

### 1. 將 function 加入你的 module 或 package

### 2. 搭配 `$value$plusargs` 判斷 CASE

## 完整範例（TestTop.sv）

```systemverilog
`timescale 1ns / 1ps

module TestTop;

  function automatic bit glob_match(string pattern, string str);
    int p_len = pattern.len();
    int s_len = str.len();
    int pi = 0, si = 0;
    int star_pi = -1, star_si = -1;

    while (si < s_len) begin
      if (pi < p_len && (pattern[pi] == "?" || pattern[pi] == str[si])) begin
        pi++; si++;
      end
      else if (pi < p_len && pattern[pi] == "*") begin
        star_pi = pi; star_si = si;
        pi++;
      end
      else if (star_pi != -1) begin
        pi = star_pi + 1;
        star_si++;
        si = star_si;
      end
      else return 0;
    end

    while (pi < p_len && pattern[pi] == "*") pi++;
    return (pi == p_len);
  endfunction

  initial begin
    string CASE;

    if ($value$plusargs("CASE=%s", CASE)) begin
      $display("Testcase : %s", CASE);

      if (glob_match("I01*", CASE))
        $display("\tImage Case I01");
      else if (glob_match("I02*", CASE))
        $display("\tImage Case I02");

      if (glob_match("*SPI", CASE))
        $display("\tInterface Case SPI");
      else if (glob_match("*I2C", CASE))
        $display("\tInterface Case I2C");
    end
  end

endmodule
```
