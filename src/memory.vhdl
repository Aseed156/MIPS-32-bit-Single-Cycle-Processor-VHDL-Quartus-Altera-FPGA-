library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        clk        : in  std_logic;
        address    : in  std_logic_vector(31 downto 0);
        write_data : in  std_logic_vector(31 downto 0);
        MemRead    : in  std_logic;
        MemWrite   : in  std_logic;
        read_data  : out std_logic_vector(31 downto 0)
    );
end memory;

architecture Behavioral of memory is
    type mem_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal memory : mem_array := (
        X"00000000", X"00000001", X"00000002", X"00000003",
    X"00000004", X"00000005", X"00000006", X"00000007",
    X"00000008", X"00000009", X"0000000A", X"0000000B",
    X"0000000C", X"0000000D", X"0000000E", X"0000000F",
	 X"00000010", X"00000011", X"00000012", X"00000013",
    X"00000014", X"00000015", X"00000016", X"00000017",
    X"00000018", X"00000019", X"0000001A", X"0000001B",
    X"0000001C", X"0000001D", X"0000001E", X"0000001F",
        others => (others => '0')
    );
begin


    process(MemRead, memWrite, address)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                memory(to_integer(unsigned(address))) <= write_data;
			   elsif MemRead = '1' then
					 read_data <= memory(to_integer(unsigned(address)));
            end if;
        end if;
    end process;

     
end Behavioral;
