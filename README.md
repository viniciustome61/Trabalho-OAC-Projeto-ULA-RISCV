# Projeto ULA RISC-V

Este repositório contém uma Unidade Lógica e Aritmética (ULA) em VHDL, inspirada em instruções de arquitetura RISC-V. A implementação suporta operações aritméticas, lógicas e comparações em palavras de 32 bits.

## Visão geral

A entidade `ulaRV` recebe:

- `opcode`: código de operação em 4 bits
- `A` e `B`: entradas de 32 bits
- `Z`: resultado da operação
- `cond`: flag de condição, usada para comparações

A lógica foi implementada em um processo combinacional, com valores padrão para evitar latches indesejados.

## Operações suportadas

| Opcode | Operação | Descrição |
| --- | --- | --- |
| `0000` | ADD | Soma de `A` e `B` |
| `0001` | SUB | Subtração de `A` - `B` |
| `0010` | AND | Operação lógica AND |
| `0011` | OR | Operação lógica OR |
| `0100` | XOR | Operação lógica XOR |
| `0101` | SLL | Deslocamento lógico à esquerda |
| `0110` | SRL | Deslocamento lógico à direita |
| `0111` | SRA | Deslocamento aritmético à direita |
| `1000` | SLT | `A < B` com sinal |
| `1001` | SLTU | `A < B` sem sinal |
| `1010` | SGE | `A >= B` com sinal |
| `1011` | SGEU | `A >= B` sem sinal |
| `1100` | SEQ | `A == B` |
| `1101` | SNE | `A != B` |

## Estrutura do projeto

- `ulaRV.vhd`: implementação da ULA
- `ula_tb.vhd`: testbench para simulação e validação das operações
- `README.md`: documentação do projeto

## Implementação

A ULA foi escrita em VHDL usando `std_logic_vector` e `numeric_std` para realizar:

- operações aritméticas com sinal e sem sinal
- deslocamentos com controle de bits
- comparação entre operandos
- geração da flag `cond` para instruções condicionais

O arquivo principal define a entidade:

```vhdl
entity ulaRV is
    generic (WSIZE: natural := 32);
    port (
        opcode : in std_logic_vector(3 downto 0);
        A, B   : in std_logic_vector(WSIZE-1 downto 0);
        Z      : out std_logic_vector(WSIZE-1 downto 0);
        cond   : out std_logic
    );
end ulaRV;
```

## Testbench

O arquivo `ula_tb.vhd` instancia a ULA e aplica vários estímulos para verificar:

- soma e subtração
- operações lógicas
- deslocamentos
- comparações com sinal e sem sinal
- igualdade e diferença

Os casos de teste incluem exemplos de valores positivos, negativos e limites de representação em 32 bits.

## Como simular

Com GHDL, por exemplo:

```bash
ghdl -a ulaRV.vhd
ghdl -a ula_tb.vhd
ghdl -e ula_tb
ghdl -r ula_tb --stop-time=200ns
```

## Observações

- O projeto foi desenvolvido como uma implementação didática de uma ULA para estudo de arquitetura de computadores.
- A operação `cond` fica em nível lógico alto apenas para comparações verdadeiras.
- Para instruções que não estão implementadas, a arquitetura mantém a saída em zero.

## Autor

Projeto desenvolvido como parte de estudo de organização e arquitetura de computadores (OAC), com foco em lógica digital e modelagem em VHDL.
