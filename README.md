# 🧩 Y86 Processor Architecture (Spring 2024)

This project implements a **custom processor architecture** based on the **Y86 ISA**, developed in **Verilog**.

---

## 🎯 Objective

To design, implement, and test a working **Y86-compatible processor**, first as a **sequential design**, and then as a **5-stage pipelined processor** supporting all core Y86 instructions.

---

## ⚙️ Features

- **Sequential Design:** Implements all Y86 instructions (except `call` and `ret`)  
- **Pipelined Design:** 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback)  
- **Hazard Handling:** Data forwarding and stall logic for pipeline correctness  
- **Extended Support:** Optional `call` and `ret` implementation for full ISA coverage  
- **Testcases:** Custom programs to verify all instruction types and pipeline behavior  

---

## 🧠 Design Highlights

- **Language:** Verilog  
- **Design Style:** Modular — each stage (Fetch, Decode, Execute, Memory, Writeback) coded and tested independently  
- **Verification:** Simulation-based testing with waveform inspection and encoded Y86 programs  

---

## 🧪 Testing

- 2–4 testcases written in Y86 assembly and encoded manually  
- Verified using ModelSim/Vivado simulations  
- Example programs include simple arithmetic and sorting algorithms  

---

## 🧱 Project Phases

1. **Sequential Design** — Baseline single-cycle processor  
2. **Pipeline Design** — 5-stage pipelined architecture with hazard resolution  

---

## 🚀 Evaluation Timeline

- **Phase 1:** Sequential Design 
- **Final Phase:** Pipelined Design

---

## 📄 Report Summary

- Design overview and stage-wise explanation  
- Supported features and test results  
- Challenges and verification strategy  


---

