-- all operations need to be clocked
-- one instruction in one cycle
-- instruction execute in-order


library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_BIT.ALL;

entity pipeline is
  port (
  clk : in bit ;
  opcode : in bit_vector(3 downto 0);
  Field1 : in bit_vector(3 downto 0);
  Field2 : in bit_vector(3 downto 0);
  Field3 : in bit_vector(3 downto 0)
  );
end pipeline;

architecture rtl of pipeline is

  -- define opcode
  constant LOAD_REG   : bit_vector(3 downto 0) := "0001";
  constant STORE_IMM  : bit_vector(3 downto 0) := "0010";
  constant STORE_REG  : bit_vector(3 downto 0) := "0100";
  constant ADD        : bit_vector(3 downto 0) := "1000";

  -- define memory and register file
  type chip_memory is array(15 downto 0) of bit_vector (7 downto 0);    
  type reg_file is array(15 downto 0) of bit_vector (7 downto 0);

  -- function to convert a bitvector to integer

  function to_Int (B: bit_vector) return integer is            
    variable bv: bit_vector(B'Length - 1 downto 0) := B;
    variable N: integer := 0;
    begin
        for i in 0 to (B'Length - 1) loop
            if bv(i) = '1' then
                N := N + (2**i);                       
            end if;
        end loop;
        return N;
  end to_Int;

  -- initiate memory and register file
  signal mem : chip_memory;
  signal reg : reg_file;

  -- define internal signal 
  signal opc_temp : bit_vector  (3 downto 0);   
  signal store_imm_en  : bit;              
  signal load_reg_en   : bit;
  signal store_reg_en  : bit;
  signal add_en : bit;

  signal int_Field1 : integer;
  signal int_Field2 : integer;
  signal int_Field3 : integer;
  signal DMA  : bit_vector(7 downto 0);




begin
  Scheduler : process(clk)
  begin
    if rising_edge (clk) then
      int_Field1 <=  to_Int(Field1);
      int_Field2 <=  to_Int(Field2);
      int_Field3 <=  to_Int(Field3);
      DMA(7 downto 4) <= Field2;
      DMA(3 downto 0) <= Field3;
      opc_temp <= opcode;
    end if;

    if rising_edge (clk) then
      case opcode is
        when LOAD_REG =>
          store_imm_en <= '0';
          load_reg_en  <= '1';
          store_reg_en <= '0';
          add_en       <= '0';
        when STORE_IMM =>
          store_imm_en <= '1';
          load_reg_en  <= '0';
          store_reg_en <= '0';
          add_en       <= '0';
        when STORE_REG =>
          store_imm_en <= '0';
          load_reg_en  <= '0';
          store_reg_en <= '1';
          add_en       <= '0';
        when ADD =>
          store_imm_en <= '0';
          load_reg_en  <= '0';
          store_reg_en <= '0';
          add_en      <= '1';
        when others =>
          store_imm_en <= '0';
          load_reg_en  <= '0';
          store_reg_en <= '0';
          add_en       <= '0';
      end case;
    end if;
  end process;

  ALU : process(clk)
  begin
    if rising_edge (clk) then
      if load_reg_en = '1' then
        reg(int_Field1) <= mem(int_Field2);
      elsif store_imm_en = '1' then
        mem(int_Field1) <= DMA;
      elsif store_reg_en = '1' then
        mem(int_Field2) <= reg(int_Field1);
      elsif add_en = '1' then
        reg(int_Field1) <= bit_vector(to_unsigned(to_Int(reg(int_Field2)) + to_Int(reg(int_Field3)),8));
      end if;
    end if;
  end process;
end rtl;
