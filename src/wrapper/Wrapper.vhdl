library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_components.all;

entity Wrapper is
    port (
        hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7 : out std_logic_vector(6 downto 0);
        topclock, topreset                             : in std_logic;
		  instruction												: out std_logic_vector(31 downto 0);
        leds                                           : out std_logic_vector(9 downto 0);
        sw                                             : in std_logic_vector(3 downto 0)
    );
end Wrapper;

architecture structural of Wrapper is
    signal top_pcout       : std_logic_vector(31 downto 0);
    signal top_instruction : std_logic_vector(31 downto 0);
    signal branch_addr     : std_logic_vector(31 downto 0) := (others => '0');
    signal branch_decision : std_logic;

    signal reg_rs, reg_rt, reg_rd : std_logic_vector(31 downto 0);
    signal j_addr, immediate      : std_logic_vector(31 downto 0);
    signal hexout                 : std_logic_vector(31 downto 0);
    signal jump, RegDst, RegWrite, MemToReg, ALUSrc, beq_control, MemRead, MemWrite : std_logic;
    signal ALUOp : std_logic_vector(1 downto 0);
    signal read_data : std_logic_vector(31 downto 0);
    signal address : std_logic_vector(31 downto 0);    
    signal opcode : std_logic_vector(5 downto 0);
    signal alu_result : std_logic_vector(31 downto 0);
	 signal leds_internal : std_logic_vector(9 downto 0);

 
begin
	instruction <= hexout;
    u_fetch: fetch
        port map (
            PC_out           => top_pcout,
            instruction      => top_instruction,
            branch_addr      => branch_addr,
            jump_addr        => j_addr,
            branch_decision  => branch_decision,
            jump_decision    => jump,
            reset            => topreset,
            clock            => topclock
        );
          
    u_control: control
        port map (
            pc => top_pcout, --in
            instruction => top_instruction, --in
            reset => topreset,
            jump => jump,
            RegDst => RegDst,
            RegWrite => RegWrite,
            MemToReg => MemToReg,
            ALUOp => ALUOp,
            ALUSrc => ALUSrc,
            beq_control => beq_control,
            MemRead => MemRead,
            MemWrite => MemWrite,
				leds_control => leds_internal
        );
        
    u_decode: decode
        port map (
        instruction   => top_instruction,
        memory_data   => read_data,
        alu_result    => alu_result,
        reset         => topreset,
        clock         => topclock,
        RegDst        => RegDst,
        RegWrite      => RegWrite,
        MemToReg      => MemToReg,
        PC_out        => top_pcout, -- Connect PC_out
        register_rs   => reg_rs,
        register_rt   => reg_rt,
        register_rd   => reg_rd,
        jump_addr     => j_addr,
        immediate     => immediate
    );
		  
		      
    u_execute: execute
        port map(
            register_rs => reg_rs,
            register_rt => reg_rt,
            PC4 => top_pcout,
            immediate => immediate,
            ALUOp => ALUOp,
            ALUSrc => ALUSrc,
            beq_control => beq_control,
            clock => topclock,
            alu_result => alu_result, --out
            branch_addr => branch_addr, --out
            branch_decision => branch_decision --out
        );
        
    u_memory: memory
        port map(
				clk => topclock,
            address => alu_result,
            write_data => reg_rt,
            MemWrite => MemWrite,
            MemRead => MemRead,
            read_data => read_data
        );
   
        
    opcode <= top_instruction(31 downto 26);
     
    with sw select hexout <=
        top_pcout when "0001",
        reg_rs when "0010",
        reg_rt when "0011",
        immediate when "0100",
        reg_rd when "0101",
        alu_result when "0110",
        read_data when "0111",
        branch_addr when "1000",
        top_instruction when others;
                
    u_hex0: SSD port map (bininput => hexout(3 downto 0),     cathodes => hex0);
    u_hex1: SSD port map (bininput => hexout(7 downto 4),     cathodes => hex1);
    u_hex2: SSD port map (bininput => hexout(11 downto 8),    cathodes => hex2);
    u_hex3: SSD port map (bininput => hexout(15 downto 12),   cathodes => hex3);
    u_hex4: SSD port map (bininput => hexout(19 downto 16),   cathodes => hex4);
    u_hex5: SSD port map (bininput => hexout(23 downto 20),   cathodes => hex5);
    u_hex6: SSD port map (bininput => hexout(27 downto 24),   cathodes => hex6);
    u_hex7: SSD port map (bininput => hexout(31 downto 28),   cathodes => hex7);
     
    leds <= leds_internal;

end structural;
