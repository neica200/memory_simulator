# Memory Simulator

A low-level memory management simulator written in assembly.
Supports both 1D and 2D memory models with operations like allocation, deallocation, and defragmentation.

---

## Project Structure

This repository contains two core modules:

* `memsim-1d.s` – linear (one-dimensional) memory simulation
* `memsim-2d.s` – two-dimensional memory simulation (grid-based)

Each module is a standalone assembly program that implements dynamic memory management primitives.

---

## Features

* **Dynamic memory allocation** with `add id size`
* **Data retrieval** using `get id`
* **Memory deallocation** via `delete id`
* **Manual defragmentation** with `defragment` to reclaim free space
* Supports both linear and matrix-style memory
* Efficient space reuse and predictable output
* Clean, modular subroutine-based implementation

---

## How to Build & Run

Tested with GNU Assembler (`as`) and Linker (`ld`) on Linux.

### Build Example (x86\_64):

```bash
as -o memsim-1d.o memsim-1d.s
ld -o memsim-1d memsim-1d.o
./memsim-1d
```
