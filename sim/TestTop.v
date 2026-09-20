`timescale 1ns / 1ps

module TestTop;

initial begin
    string CASE;
    if ($value$plusargs("CASE=%s", CASE)) begin
        $display("Testcase : %s", CASE);

        if     (glob_match("I01*", CASE))
            $display("\tImage Case I01");
        else if(glob_match("I02*", CASE))
            $display("\tImage Case I02");

        if     (glob_match("*SPI", CASE))
            $display("\tInterface Case SPI");
        else if(glob_match("I02*", CASE))
            $display("\tInterface Case I2C");

    end
end

endmodule

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
