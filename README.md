# Pipelined MIPS Processor in Verilog

## Overview
For this lab, we had to implement a MIPS pipeline processor. This pipeline processor is 
broken down into five stages. The goal is to keep all stages busy at all times, which increases 
instruction throughput and therefore performance. We had to wire all the stages of the processor 
together, including the instruction fetch stage, instruction decode stage, execution stage, memory 
stage, and writeback stage. We also had to include pipeline registers, which pass data needed 
from one stage to the next stage. Finally, we had to include hazard detection and forwarding. 
Hazard detection is crucial as there are certain cases when the data needed by one instruction is 
not available yet from a previous one (data hazard). We also tested for control hazards which 
occur when the fetched instruction is not the correct one. So, forwarding is useful for minimizing 
delay when these hazards occur, as we may be able to forward the data that is needed later on. 
Most of the components were provided and modules were defined, though we had to finish the 
IF stage file, ID stage file, EX stage file, hazard detection file, and forwarding file. Then, in the 
MIPS file, we wired these stages together, added in the pipeline registers, and added in the data 
memory and a mux for the MEM and WB stage.
