This repository presents a complete RTL implementation of the UART (Universal Asynchronous Receiver Transmitter) protocol using Verilog HDL, designed to enable asynchronous serial communication between digital systems. The project focuses on protocol accuracy, clean FSM-based design, and simulation-level verification, making it suitable for VLSI RTL design practice and demonstration.

# Overview
UART is a widely used asynchronous serial communication protocol that enables data exchange without a shared clock line. Communication relies on predefined parameters such as baud rate, data bits, start bit, stop bit, and optional parity. This implementation demonstrates a standard 8-bit UART communication system with independent transmitter and receiver modules.

# Architecture
The design is modular and consists of the following key blocks:
1.  UART Transmitter (TX)
    1] Converts parallel 8-bit data into serial form.
    2] Generates:
        a. Start bit (0)
        b. 8 data bits (LSB first)
        c. Stop bit (1)
    3] Uses a finite state machine (FSM) to control transmission flow.
    4] Bit timing is controlled using a baud rate clock divider derived from the system clock.
    5] Ensures stable and accurate bit transmission across the entire frame.

2️. UART Receiver (RX)
    1] Receives serial data asynchronously and reconstructs 8-bit parallel data.
    2] Detects the start bit and samples incoming data at the center of each bit period to reduce noise sensitivity.
    3] Implements an FSM to handle:
         a.Start bit detection
         b.Data bit reception
         c.Stop bit validation
    4] Asserts a data-ready signal once a complete frame is successfully received.

3️. Baud Rate Generator
    1] Generates baud-rate timing using a clock-divider counter.
    2] Configurable to support standard baud rates (e.g., 9600, 115200).
    3] Ensures synchronization between TX and RX timing.

4. Control Logic
    1] FSM-based control ensures deterministic state transitions and clean protocol handling.  
    2] Separate FSMs for TX and RX improve readability and scalability.
    3] Reset and enable controls are provided for safe operation and integration into larger systems.

5. Verification & Testbench
   A self-contained testbench is included to verify:
    1] Correct TX serialization
    2] RX data recovery
    3] Timing accuracy and state transitions
    4] Loopback-style testing validates end-to-end UART communication.
    5] Simulation results confirm compliance with UART frame format and timing requirements.

# Design Highlights
  1. Fully synthesizable RTL design
  2. Modular and reusable architecture
  3. FSM-based protocol control
  4. Configurable baud rate support
  5. Simulation-verified functionality

# Applications
  1. Embedded systems communication
  2. Microcontroller–FPGA data exchange

# Learning Outcomes
  1. This project helps in understanding
  2. Asynchronous serial communication fundamentals
  3. FSM design for protocol implementation
  4. Clock division and timing control
  5. RTL coding best practices
  6. UART protocol behavior at the hardware level
