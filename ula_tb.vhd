library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end ula_tb;

architecture tb_arch of ula_tb is
    -- Declaração do componente ULA
    component ulaRV
        generic (WSIZE: natural := 32);
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B   : in std_logic_vector(WSIZE-1 downto 0);
            Z      : out std_logic_vector(WSIZE-1 downto 0);
            cond   : out std_logic
        );
    end component;

    -- Declaração de sinais
    signal A_tb, B_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal opcode_tb  : std_logic_vector(3 downto 0) := "0000";
    signal Z_tb       : std_logic_vector(31 downto 0);
    signal cond_tb    : std_logic;

begin
    -- Instanciação da ULA
    uut: ulaRV
        port map (
            opcode => opcode_tb,
            A      => A_tb,
            B      => B_tb,
            Z      => Z_tb,
            cond   => cond_tb
        );

    -- Processo que gera estímulos
    stim_proc: process
    begin
        -- 1. ADD (0000) - Teste Positivo (A=10, B=5 -> Z=15)
        A_tb <= x"0000000A"; B_tb <= x"00000005"; opcode_tb <= "0000";
        wait for 10 ns; -- avançar o tempo de simulação

        -- 2. ADD (0000) - Teste Zero (A=5, B=-5 -> Z=0)
        A_tb <= x"00000005"; B_tb <= x"FFFFFFFB"; opcode_tb <= "0000";
        wait for 10 ns;

        -- 3. SUB (0001) - Teste Negativo (A=5, B=10 -> Z=-5)
        A_tb <= x"00000005"; B_tb <= x"0000000A"; opcode_tb <= "0001";
        wait for 10 ns;

        -- 4. AND (0010) (A=0xFFFF0000, B=0x00FF00FF -> Z=0x00FF0000)
        A_tb <= x"FFFF0000"; B_tb <= x"00FF00FF"; opcode_tb <= "0010";
        wait for 10 ns;

        -- 5. OR (0011)[cite: 1]
        A_tb <= x"F0F0F0F0"; B_tb <= x"0F0F0F0F"; opcode_tb <= "0011";
        wait for 10 ns;

        -- 6. XOR (0100)[cite: 1]
        A_tb <= x"AAAAAAAA"; B_tb <= x"55555555"; opcode_tb <= "0100";
        wait for 10 ns;

        -- 7. SLL (0101) - Shift Left Logica
        A_tb <= x"00000001"; B_tb <= x"00000004"; opcode_tb <= "0101";
        wait for 10 ns;

        -- 8. SRL (0110) - Shift Right Logical
        A_tb <= x"F0000000"; B_tb <= x"00000004"; opcode_tb <= "0110";
        wait for 10 ns;

        -- 9. SRA (0111) - Shift Right Arithmetic (preserva sinal)
        A_tb <= x"F0000000"; B_tb <= x"00000004"; opcode_tb <= "0111";
        wait for 10 ns;

        -- 10. SLT (1000) - Set Less Than (Com sinal: -1 < 1 -> Verdadeiro)
        A_tb <= x"FFFFFFFF"; B_tb <= x"00000001"; opcode_tb <= "1000";
        wait for 10 ns;

        -- 11. SLTU (1001) - Set Less Than Unsigned (Sem sinal: 0xFFFFFFFF < 1 -> Falso)
        A_tb <= x"FFFFFFFF"; B_tb <= x"00000001"; opcode_tb <= "1001";
        wait for 10 ns;

        -- 12. SGE (1010) - Set Greater/Equal (Com sinal: -1 >= 1 -> Falso)
        A_tb <= x"FFFFFFFF"; B_tb <= x"00000001"; opcode_tb <= "1010";
        wait for 10 ns;

        -- 13. SGEU (1011) - Set Greater/Equal Unsigned (Sem sinal: 0xFFFFFFFF >= 1 -> Verdadeiro)
        A_tb <= x"FFFFFFFF"; B_tb <= x"00000001"; opcode_tb <= "1011";
        wait for 10 ns;

        -- 14. SEQ (1100) - Set Equal (10 == 10 -> Verdadeiro)
        A_tb <= x"0000000A"; B_tb <= x"0000000A"; opcode_tb <= "1100";
        wait for 10 ns;

        -- 15. SNE (1101) - Set Not Equal (10 != 5 -> Verdadeiro)
        A_tb <= x"0000000A"; B_tb <= x"00000005"; opcode_tb <= "1101";
        wait for 10 ns;

        wait; -- Finaliza a simulação
    end process;
end tb_arch;
