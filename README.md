### ASCON-128 Embeding project

This project is part of the course “Digital System Design”, which involves implementing the ASCON-128 encryption algorithm in SystemVerilog.

The following repository features the files and codes I used to implement the algorithm.

The BENCH folder features all codes linked to implementing and testing of the ecryption algorithm.

The RTL part contains the hardware design of the ASCON-128 encryption algorithm. 
It describes the system architecture and implements all functional modules such as :
- Permutation (simple and XOR)
- S-bo
- Diffusion layer
- Finite state machine (FSM)
- Registers (which allow to store the constant variables)
These modules represent the real circuit that could be synthesized into hardware (FPGA or ASIC).

The BENCH part contains the testbenches used for simulation and verification. 
These files do not represent hardware, as they aim to test and check the correctness of the RTL design. 
Each important module of the RTL folder has its own testbench to ensure proper functionality before integration.

In addition to the codes, you will also find my own report, for which I got the grade 17/20 - Equivalent to B+/A-.
The report is written in French, and I carried out this project on my own. 
