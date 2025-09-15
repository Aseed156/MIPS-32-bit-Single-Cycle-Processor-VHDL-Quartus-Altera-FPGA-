library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control is 
    port(
        pc          : in  std_logic_vector(31 downto 0);
        instruction : in  std_logic_vector(31 downto 0);
        reset       : in  std_logic;
        jump        : out std_logic;
        RegDst      : out std_logic;
        RegWrite    : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector(1 downto 0);
        ALUSrc      : out std_logic;
        beq_control : out std_logic;
        MemRead     : out std_logic;
        MemWrite    : out std_logic;
        leds_control: out std_logic_vector(9 downto 0)
    );
end control;

architecture behv of control is 
begin
    process(instruction, reset)
        variable opcode : std_logic_vector(5 downto 0);
    begin
        opcode := instruction(31 downto 26);
        if reset = '1' then
            jump        <= '0';
            RegDst      <= '0';
            ALUSrc      <= '0';
            MemToReg    <= '0';
            RegWrite    <= '0';
            MemRead     <= '0';
            MemWrite    <= '0';
            beq_control <= '0';
            ALUOp       <= "00";
            leds_control <= "0000000000";
        else
            case opcode is
                when "000000" =>  -- R-type
                    jump        <= '0';
                    RegDst      <= '1';
                    ALUSrc      <= '0';
                    MemToReg    <= '0';
                    RegWrite    <= '1';
                    MemRead     <= '0';
                    MemWrite    <= '0';
                    beq_control <= '0';
                    ALUOp       <= "10";
                    leds_control <= "0100100010";

                when "100011" =>  -- lw
                    jump        <= '0';
                    RegDst      <= '0';
                    ALUSrc      <= '1';
                    MemToReg    <= '1';
                    RegWrite    <= '1';
                    MemRead     <= '1';
                    MemWrite    <= '0';
                    beq_control <= '0';
                    ALUOp       <= "00";
                    leds_control <= "0011110000";

                when "101011" =>  -- sw
                    jump        <= '0';
                    RegDst      <= '0';
                    ALUSrc      <= '1';
                    MemToReg    <= '0';
                    RegWrite    <= '0';
                    MemRead     <= '0';
                    MemWrite    <= '1';
                    beq_control <= '0';
                    ALUOp       <= "00";
                    leds_control <= "0010001000";

                when "000100" =>  -- beq
                    jump        <= '0';
                    RegDst      <= '0';
                    ALUSrc      <= '0';
                    MemToReg    <= '0';
                    RegWrite    <= '0';
                    MemRead     <= '0';
                    MemWrite    <= '0';
                    beq_control <= '1';
                    ALUOp       <= "01";
                    leds_control <= "0000000101";

                when "000010" =>  -- jump
                    jump        <= '1';
                    RegDst      <= '0';
                    ALUSrc      <= '0';
                    MemToReg    <= '0';
                    RegWrite    <= '0';
                    MemRead     <= '0';
                    MemWrite    <= '0';
                    beq_control <= '0';
                    ALUOp       <= "00";
                    leds_control <= "1000000000";
						  
					   when "001000" =>  -- addi
                    jump        <= '0';
                    RegDst      <= '0';
                    ALUSrc      <= '1';
                    MemToReg    <= '0';
                    RegWrite    <= '1';
                    MemRead     <= '0';
                    MemWrite    <= '0';
                    beq_control <= '0';
                    ALUOp       <= "00";
                    leds_control <= "0010100000";

                when others =>
                    jump        <= '0';
                    RegDst      <= '0';
                    ALUSrc      <= '0';
                    MemToReg    <= '0';
                    RegWrite    <= '0';
                    MemRead     <= '0';
                    MemWrite    <= '0';
                    beq_control <= '0';
                    ALUOp       <= "00";
                    leds_control <= "0000000000";
            end case;
        end if;
    end process;
end behv;
