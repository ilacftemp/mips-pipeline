# CPU MIPS Pipeline em VHDL

Implementação de um processador **MIPS pipeline de 5 estágios (IF, ID, EX, MEM, WB)** em **VHDL**, desenvolvido como projeto acadêmico na disciplina de Arquitetura de Computadores.

## Funcionalidades
- **Pipeline de 5 estágios**: IF, ID, EX, MEM, WB.
- **Banco de registradores 2R/1W** com registrador zero fixo.
- **Unidade de controle** (decoders de opcode/funct).
- **ULA 32 bits** com operações aritméticas e lógicas.
- **Memória RAM e ROM** (dados e instruções).
- **Hazard detection** e **forwarding** para evitar bolhas no pipeline.
- **Registradores de pipeline** entre estágios.
- Saída para **display de 7 segmentos** (debug/FPGA).

## Ferramentas utilizadas
- **Quartus Prime**
- **FPGA**
- **RTL Viewer**

## Estrutura do projeto

```markdown
├── mips.vhd              # Top-level
├── instanciaIF.vhd       # Instruction Fetch
├── instanciaID.vhd       # Instruction Decode
├── instanciaEX.vhd       # Execute
├── instanciaMEM.vhd      # Memory
├── instanciaWB.vhd       # Writeback
├── bancoReg.vhd          # Banco de registradores (2R/1W)
├── ULA32bits.vhd         # ULA 32 bits
├── RAMMIPS.vhd / ROMMIPS.vhd
├── unidadeControle.vhd   # Unidade de controle
├── mux*, somador*        # Componentes auxiliares
└── conversorHex7Seg.vhd  # Saída debug (7 segmentos)
```

## Resultados
- Pipeline funcional com forwarding e hazard detection.
- Programas de teste executados corretamente na FPGA.
- Depuração via RTL Viewer confirmou propagação correta dos sinais.

## Autores
Projeto desenvolvido no curso de **Engenharia da Computação – Insper**, por Ilana Chaia Finger e Eduardo Selber.
Disciplina: Arquitetura de Computadores.
