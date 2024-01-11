library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_pipeline is
end tb_pipeline;

architecture rtl of tb_pipeline is
  constant clk_period : time := 10 ns;
  signal t_clk : bit := '1';
  signal t_ins: bit_vector(15 downto 0);

  component pipeline is
    port (
    clk : in bit ;
    opcode : in bit_vector(3 downto 0);
    Field1 : in bit_vector(3 downto 0);
    Field2 : in bit_vector(3 downto 0);
    Field3 : in bit_vector(3 downto 0)
        );
  end component pipeline;

  begin
    p_clk_gen : process is
        begin
          wait for clk_period/2;
          t_clk <= not t_clk;
        end process p_clk_gen;

UUT : pipeline PORT MAP(
    clk => t_clk,
    opcode => t_ins(15 downto 12),
    Field1 => t_ins(11 downto 8),
    Field2 => t_ins(7 downto 4),
    Field3 => t_ins(3 downto 0)
    );

process
  begin
   -- Store immediate 
   t_ins <= "0010"&"0000"&"0000"&"0000";-- 0 ---------> MEM 0000
   wait for 10 ns;
   t_ins <= "0010"&"0001"&"0000"&"0001";-- 1 ---------> MEM 0001
   wait for 10 ns;
   t_ins <= "0010"&"0010"&"0000"&"0010";-- 2 ---------> MEM 0010
   wait for 10 ns;
   t_ins <= "0010"&"0011"&"0000"&"0011";-- 3 ---------> MEM 0011
   wait for 10 ns;
   t_ins <= "0010"&"0100"&"0000"&"0100";-- 4 ---------> MEM 0100
   wait for 10 ns;
   t_ins <= "0010"&"0101"&"0000"&"0101";-- 5 ---------> MEM 0101
   wait for 10 ns;
   t_ins <= "0010"&"0110"&"0000"&"0110";-- 6 ---------> MEM 0110
   wait for 10 ns;
   t_ins <= "0010"&"0111"&"0000"&"0111";-- 7 ---------> MEM 0111
   wait for 10 ns;
   t_ins <= "0010"&"1000"&"0000"&"1000";-- 8 ---------> MEM 1000
   wait for 10 ns;
   t_ins <= "0010"&"1001"&"0000"&"1001";-- 9 ---------> MEM 1001
   wait for 10 ns;
   t_ins <= "0010"&"1010"&"0000"&"1010";-- 10 ---------> MEM 1010
   wait for 10 ns;
   t_ins <= "0010"&"1011"&"0000"&"1011";-- 11 ---------> MEM 1011
   wait for 10 ns;
   t_ins <= "0010"&"1100"&"0000"&"1100";-- 12 ---------> MEM 1100
   wait for 10 ns;
   t_ins <= "0010"&"1101"&"0000"&"1101";-- 13 ---------> MEM 1101
   wait for 10 ns;
   t_ins <= "0010"&"1110"&"0000"&"1110";-- 14 ---------> MEM 1110
   wait for 10 ns;
   t_ins <= "0010"&"1111"&"0000"&"1111";-- 15 ---------> MEM 1111
   wait for 10 ns;
   t_ins <= "0010"&"0100"&"0011"&"0100";-- 4 ---------> MEM 0100  (Hex 34)
   wait for 10 ns;
   t_ins <= "0010"&"0101"&"0101"&"0110";-- 5 ---------> MEM 0101  (hex 56)
   wait for 10 ns;

   ---- Load Resigters
   --t_ins <= "0001"&"0000"&"0100"&"0000";--load MEM 0100 to REG 0000
   --wait for 10 ns;
   --t_ins <= "0001"&"0001"&"0101"&"0000";--load MEM 0101 to REG 0001
   --wait for 10 ns;

   t_ins <= "0001"&"0110"&"0100"&"0000";--load MEM 0100 to REG 6
   wait for 10 ns;
   t_ins <= "0001"&"0111"&"0101"&"0000";--load MEM 0101 to REG 7
   wait for 10 ns;
  
   -- Store Register
   t_ins <= "0100"&"0000"&"1110"&"0000";--store REG-0000(MEM 0100) to MEM 1110
   wait for 10 ns;
   t_ins <= "0100"&"0001"&"1111"&"0000";--store REG-0001(MEM 0101) to MEM 1111
   wait for 10 ns;

   -- ADD
   --t_ins <= "1000"&"0010"&"0001"&"0000";--add REG 0000(MEM 0100=4) and REG 0001(MEM 0101=5) and store at reg-0010(value should be 9)
   --wait for 10 ns;

   t_ins <= "1000"&"0101"&"0111"&"0110";--add REG 0000(MEM 0100=4) and REG 0001(MEM 0101=5) and store at reg-0010(value should be 9)
   wait for 10 ns;

   -- Store Sum
   t_ins <= "0100"&"0011"&"0001"&"0000";-- store REG 0011 =9 to MEM 0001
   wait for 10 ns;
   t_ins <= "0100"&"0101"&"0101"&"0000";-- store REG 0011 =9 to MEM 0001
   wait for 100 ns;
  end process;
end rtl;
