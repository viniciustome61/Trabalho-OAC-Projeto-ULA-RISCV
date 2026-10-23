library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaRV is
    generic (WSIZE: natural := 32);
    port (
        opcode : in std_logic_vector(3 downto 0);
        A, B   : in std_logic_vector(WSIZE-1 downto 0);
        Z      : out std_logic_vector(WSIZE-1 downto 0);
        cond   : out std_logic
    );
end ulaRV;

architecture behavioral of ulaRV is
begin
    process (A, B, opcode)
    begin
        -- Valores por defeito para evitar a criação de latches indesejados
        Z <= (others => '0');
        cond <= '0';

        case opcode is
            when "0000" => -- ADD A, B
                Z <= std_logic_vector(signed(A) + signed(B));
                
            when "0001" => -- SUB A, B
                Z <= std_logic_vector(signed(A) - signed(B));
                
            when "0010" => -- AND A, B
                Z <= A and B;
                
            when "0011" => -- OR A, B
                Z <= A or B;
                
            when "0100" => -- XOR A, B
                Z <= A xor B;
                
            when "0101" => -- SLL A, B
                Z <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                
            when "0110" => -- SRL A, B
                Z <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                
            when "0111" => -- SRA A, B
                Z <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B(4 downto 0)))));
                
            when "1000" => -- SLT A, B
                if signed(A) < signed(B) then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when "1001" => -- SLTU A, B
                if unsigned(A) < unsigned(B) then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when "1010" => -- SGE A, B
                if signed(A) >= signed(B) then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when "1011" => -- SGEU A, B
                if unsigned(A) >= unsigned(B) then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when "1100" => -- SEQ A, B
                if A = B then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when "1101" => -- SNE A, B
                if A /= B then
                    Z <= (0 => '1', others => '0');
                    cond <= '1';
                end if;
                
            when others =>
                null;
        end case;
    end process;
end behavioral;
