# 🖥️ MIPS 32-bit Single-Cycle Processor (VHDL, Quartus, Altera FPGA)

##  Overview
This project implements a **32-bit single-cycle MIPS processor** designed in **VHDL**, synthesized using **Intel Quartus Prime**, and deployed on an **Altera Cyclone IV FPGA**.  

The processor supports a subset of MIPS instructions and demonstrates fundamental computer architecture concepts, including **instruction fetch, decode, execute, memory access, and write-back stages** — all completed in a single clock cycle.  
---
##  Features
- **Instruction Set Support:** Basic arithmetic, logical, memory, and control instructions  
- **Single-Cycle Datapath:** Fetch, Decode, Execute, Memory, and Writeback in one cycle  
- **Seven-Segment Display Integration:** Program counter, instructions, and outputs visualized on FPGA SSDs  
- **Custom Control Unit:** Generates control signals for each instruction type  
- **Memory Modules:** Instruction memory and data memory implemented in VHDL  
- **FPGA Deployment:** Verified on Altera Cyclone IV FPGA using Quartus  
---
## 📂 Project Structure
- `src/` → VHDL source files (datapath, ALU, control, fetch, decode, memory, etc.)  
- `wrappers/` → Wrapper modules for FPGA integration   
- `docs/` → Block diagrams, architecture explanation, and instruction set details  

## How to Run
1. Open the project in **Intel Quartus Prime**  
2. Compile and synthesize the VHDL files  
3. Upload to the **Altera Cyclone IV FPGA**  
4. Use onboard **switches/keys** to provide inputs and observe output on **LEDs/SSD**  

---

##  Educational Value
This project is intended for **Computer Architecture & Digital Design** learning.  
It provides a practical implementation of the MIPS ISA and bridges the gap between **theory and hardware**.  
