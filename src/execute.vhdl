library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is port(
    register_rs, register_rt: in std_logic_vector(31 downto 0);
    PC4, immediate: in std_logic_vector(31 downto 0);    
    ALUOp: in std_logic_vector(1 downto 0);
    ALUSrc: in std_logic;
    beq_control, clock: in std_logic;    
    alu_result, branch_addr: out std_logic_vector(31 downto 0);
    branch_decision: out std_logic
);
end execute;

architecture behv of execute is
    signal zero: std_logic;
begin
    process(register_rs,register_rt,immediate)
    variable alu_output : std_logic_vector(31 downto 0);
    variable branch_offset : std_logic_vector(31 downto 0);
    variable temp_branch_addr : std_logic_vector(31 downto 0);
    begin
            case ALUOp is
                when "00" => -- memory
                    alu_output := std_logic_vector(unsigned(register_rs) + unsigned(immediate));
                    if alu_output = x"00000000" then
                        zero <= '1';
                    else
                        zero <= '0';
                    end if;
                    
                when "01" => -- beq
                    alu_output := std_logic_vector(unsigned(register_rs) - unsigned(register_rt));
                    if alu_output = x"00000000" then
                        zero <= '1';
                    else
                        zero <= '0';
                    end if;
                    
                when "10" => -- r-type
                    case immediate(5 downto 0) is
                        when "100000" => -- add
                            alu_output := std_logic_vector(unsigned(register_rs) + unsigned(register_rt));
                        when "100010" => -- sub
                            alu_output := std_logic_vector(unsigned(register_rs) - unsigned(register_rt));
                        when "101010" => -- slt
                            if signed(register_rs) < signed(register_rt) then
                                alu_output := x"00000001";
                            else
                                alu_output := x"00000000";
                            end if;
                        when "000000" => -- sll
                            alu_output := std_logic_vector(shift_left(unsigned(register_rt), to_integer(unsigned(immediate(10 downto 6)))));
                        when "000010" => -- srl
                            alu_output := std_logic_vector(shift_right(unsigned(register_rt), 
                                              to_integer(unsigned(immediate(10 downto 6)))));
                        when others =>
                            alu_output := x"ffffffff";
                    end case;
                    
                when others =>
                    alu_output := x"ffffffff";
            end case;
				
				branch_offset := std_logic_vector(unsigned(immediate) sll 2); -- Shift immediate left by 2
				temp_branch_addr := std_logic_vector(unsigned(PC4) + 4 + unsigned(branch_offset));
				branch_decision <= (beq_control and zero);
				branch_addr <= temp_branch_addr;
            alu_result <= alu_output;
    end process;
end behv;
