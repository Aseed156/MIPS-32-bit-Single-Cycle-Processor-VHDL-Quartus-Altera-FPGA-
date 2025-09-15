library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port (
        PC_out          : out std_logic_vector(31 downto 0);
        instruction     : out std_logic_vector(31 downto 0);
        branch_addr     : in  std_logic_vector(31 downto 0);
        jump_addr       : in  std_logic_vector(31 downto 0);
        branch_decision : in  std_logic;
        jump_decision   : in  std_logic;
        reset           : in  std_logic;
        clock           : in  std_logic
    );
end fetch;

architecture bhv of fetch is
    type mem_array is array(0 to 16) of std_logic_vector(31 downto 0);
    signal mem : mem_array := (
		
		    -- Task: Custom 9 MIPS Instructions
    X"20090005", -- addi $9, $0, 5      ; $9 = 5
    X"200A0064", -- addi $10, $0, 100   ; $10 = 100
    X"AD2A0000", -- sw   $10, 0($9)     ; MEM[$9] = $10
    X"8D2B0000", -- lw   $11, 0($9)     ; $11 = MEM[$9]
    X"012A6020", -- add  $12, $9, $10   ; $12 = $9 + $10
    X"01496822", -- sub  $13, $10, $9   ; $13 = $10 - $9
    X"00097200", -- sll  $14, $9, 2     ; $14 = $9 << 2
    X"000A7C02", -- srl  $15, $10, 1    ; $15 = $10 >> 1
    X"116A0002", -- beq  $11, $10, skip ; if equal, skip next 2
    X"0800000C", -- j    to instruction 12
    X"20100001", -- addi $16, $0, 1     ; target of branch
    others => X"00000000"
    );

    signal PC    : std_logic_vector(31 downto 0) := (others => '0');
    signal index : integer := 0;
begin
    
    index <= to_integer(unsigned(PC(6 downto 2)));
    instruction <= mem(index) when index <= 8 else (others => '0');
    PC_out <= PC;

    
    process (clock, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clock) then
            if branch_decision = '1' then
                PC <= branch_addr;
            elsif jump_decision = '1' then
                PC <= jump_addr;
            else
                PC <= std_logic_vector(unsigned(PC) + 4);
            end if;
        end if;
    end process;
end bhv;
