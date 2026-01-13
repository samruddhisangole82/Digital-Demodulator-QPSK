# QPSK Digital Demodulator (FPGA – Verilog HDL)

## 📌 Project Overview

This project implements a **QPSK (Quadrature Phase Shift Keying) Digital Demodulator** using **Verilog HDL**, targeted for **FPGA-based space communication systems**. The design supports data rates from **1 kbps to 4 Mbps** and follows concepts aligned with **CCSDS (Consultative Committee for Space Data Systems)** standards. The implementation is suitable for deployment on **Nexys 4 FPGA** and similar Xilinx-based platforms.

The goal of this project is to demonstrate **industry-relevant digital communication and FPGA design skills**, including digital signal processing, clocked logic design, and verification using testbenches.

---

## 🧠 Why QPSK?

QPSK is widely used in satellite and space communication because:

* It offers **high spectral efficiency** (2 bits per symbol)
* It provides a good balance between **data rate and noise immunity**
* It is commonly adopted in **CCSDS standards**

---

## 🏗️ System Architecture (High-Level)

**QPSK Demodulator Blocks:**

1. Input Sampling & Synchronization
2. Carrier Recovery / Reference Phase Handling
3. I/Q Signal Separation
4. Symbol Decision Logic
5. Bit Mapping (Symbol → Bits)
6. Output Data Stream Generation

Each block is implemented using **synchronous Verilog RTL**, optimized for FPGA synthesis.

---

## 🛠️ Tools & Technologies

* **Language:** Verilog HDL
* **Target Platform:** Nexys 4 FPGA (Xilinx)
* **Simulation:** ModelSim / Vivado Simulator
* **Scripting:** TCL (for constraints & automation)
* **Version Control:** Git & GitHub

---

## 📂 Repository Structure

```
Digital-Demodulator-QPSK/
│
├── src/          # Verilog source files (core demodulator logic)
├── tb/           # Testbenches for functional verification
├── constraints/  # FPGA constraints (XDC / TCL)
├── README.md     # Project documentation
└── .gitignore
```

---

## ✅ Key Features

* Fully digital QPSK demodulation
* Supports **1 kbps – 4 Mbps** data rates
* Modular and scalable RTL design
* FPGA-synthesizable Verilog code
* Testbench-based functional verification
* Industry-aligned communication design

---

## 🧪 Verification Strategy

* Self-checking Verilog testbenches
* Validation of symbol-to-bit mapping
* Corner-case testing for phase transitions
* Regression testing after RTL updates

---

## 🚀 Applications

* Satellite & space communication systems
* FPGA-based digital receivers
* SDR (Software Defined Radio) prototyping
* Academic & industry VLSI verification demos

---


## 👤 Author

**Samruddhi Sangole**
FPGA / VLSI Enthusiast

---

## 📜 License

This project is intended for **educational and research purposes**.
