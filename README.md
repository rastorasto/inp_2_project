# INP — Vigenère Cipher in MIPS64

Vigenère encryption in pure MIPS64 assembly for the EduMIPS64 simulator.

- Alternating add/subtract per key character, wraparound at 'z'
- Register-only data path, friendly to the simulator's pipeline view
- Simulator jar included

## Run

```bash
java -jar edumips64-1.3.0.jar -f hello.s
```

Coursework for *Návrh počítačových systémů (INP)* at FIT VUT Brno.
