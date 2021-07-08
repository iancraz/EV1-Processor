# EV21 Processor

RISC Processor called EV21 implemented it in Quartus for the Altera Cyclone IV FPGA. It runs over a 87.5 MHz base clock, has branch prediction algorithms and a 5 stage pipeline.

# Table of contents

* [Introduction](#Introduction)
* [Implementation](#Implementation)
* [Instruction Set](#Instruction-Set)
* [Tests](#Tests)
* [Contact](#Contact)
* [License](#License)

# Introduction
>[Table of contents](#table-of-contents)

In the world of processors, there is two main types of implementations that are currently running in modern day applications:

* CISC Processors (Complex Instruction Set Computer) That in short, have many intructions in its instruction set

* RISC Processors (Reduced Instruction Set Computer) That in the other hand, they are characterized for having a low amount of instructions to use.

In this work, we focused on implementing a RISC Processor that was capable of implementing a 5 stage pipeline. The main focus was to make the branch prediction algorithm for jumps in code, the most optimized possible. In the next section we will get into a little more detail on how this was implemented.


# Implementation
>[Table of contents](#table-of-contents)

To implement this processor we used the Altera Cyclone IV in the DE0 Nano FPGA Evaluation Board. To program this design we used [Quartus](https://fpgasoftware.intel.com/?edition=lite) as the main compilation and debugging program, and the code was written in Verilog. A more detailed documentation of the processor can be found at [EV21 Documentation](https://github.com/iancraz/EV21-Processor/blob/main/EV21%20Documentation%20(English).pdf).

The main structure of the Processor can be seen as follows:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/docs/Diagram.png?raw=true" width=800 align=center>

Also, the Register Bank is implemented as:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/docs/Register_bank.png?raw=true" width=800 align=center>

As you can see, it is separeted in different modules, that working together they implement the 5 stage pipeline, it cosists of:

`Fetch --> Decode --> Operand --> Execute --> Retire`

Each of this stages will be explained in the following sections.

## Fetch

The Fetch Stage consist of four modules:

* `PC`(Program Counter)
* `Program Memory`
* `Instruction Register`

Where the Program counter must increment its counter so that it reads one instruction for every clock cylcle. It is important to note that the PC must be driven by the Processor clock and by the branch prediction Block (called `Bloque 1` in the diagram). The program Memory is an internal ROM memory containing the instructions uploaded to the processor. Finally the instruction Register must take the data from the program memory and output its Instruction code.

## Decode

The decode Stage is composed by the Micro Instruction ROM, and its purpose is to translate the instruction received from the Instruction Register to a corresponding Microinstruction Set by the programmers. It is important to know that in this design, every instruction is composed by one and only one microinstruction.

## Operand

The operand Stage consist of the output of the `Microinstruction 1` Block, this block is the block positionated on top of the `UC-1` block. This stage main purpose is to load the operand in the correspondign positions for the ALU (Aritmetic Logic Unit) to perform the correspondign operation over those operands.

## Execute

The execute Stage consist of the `Microinstruction 2` Block located under the `UC-1` block. The purpose of this stage is to tell the ALU to perform the operation to the operands previously loaded.

## Retire

Finally the Retire stage consist of the `Microinstruction 3` Block located under the `Microinstruction 2`. The main purpose of this stage is to save the results of the ALU in the corresponding register of the `Register Bank`.

# Instruction Set
>[Table of contents](#table-of-contents)

The intruction set used for this Processor is as follows:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/docs/Instr_set.png?raw=true" width=800 align=center>

You can see, that as many other RISC Processors, there are only two instructions for memory management, `MOM Y,W` and `MOM W,Y`.

# Tests
>[Table of contents](#table-of-contents)

To test the implementation of this processor a compiler was made from mnemonic notation in the instruction set to machine language instructions. The compiler can be found in `./Compilador` and the usage is as follows:

```
python evc.py <Name of the .ev Program to compile>
```
A `Program_memory.mif` file will be created if no error in the code has been found, to load this program in the Processor you must move this file to the `./EV21/` folder and compile the Quartus Project.

Some program examples can be found in the compilator folder.

## Test 1: Simple Program

The first program we have tested is the following:

```
MOK W,#10   //W=10
MOV 0,W     //R0 = W
MOK W,#19   //W=19
ADW 1,0     //R1=W+R0+CY
MOV W,1     //W=R1  -> W=29
MOM 0,W     //M(0) = W  
MOK W,#7    //W=7   
ADW 1,0     //R1 = R0+W+CY  ->R1 = 17
MOM W,0     //W=M(0)        ->W = 29
ADW 2,1     //R2 = R1+W+CY  ->R2 = 46
MOV W,2     //W=R2          ->W=46
NOP
NOP
ADK W,#-1
JMP 1
```

And the waveform read by an oscilloscope can be seen as Follows:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/Mediciones/TEST1%20-%20Program.png?raw=true" width=800 align=center>

## Test 2: Counter

The second Test program used was a simple counter program shown as:

```
NOP
NOP
MOK W,#1
MOV 0,W
MOK W,#0
NOP
NOP
NOP
NOP
ADR W,0
NOP
NOP
JMP 7
NOP
```

And the waveform read by an oscilloscope can be seen as Follows:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/Mediciones/TEST3%20-%20Contador.png?raw=true" width=800 align=center>

## Test 3: Input/Output

The third Test program implemented was a program to check if the input and output system was working propperly, for this, we inseted values on the input bus, and made the Processor copy thosw values on the Output bus.

```
NOP
NOP
NOP
NOP
NOP
MOV 30,28
NOP
NOP
NOP
NOP
JMP 3

```

And the waveform read by an oscilloscope can be seen as Follows:

<img src="https://github.com/iancraz/EV21-Processor/blob/main/Mediciones/TEST4%20-%20Copiador%20de%20INPUT%20a%20OUTPUT.png?raw=true" width=800 align=center>


# Contact
>[Table of contents](#table-of-contents)

Please do not hesitate to reach out to me if you find any issue with the code or if you have any questions.

* Personal email: [idiaz@itba.edu.ar](mailto:idiaz@itba.edu.ar)

* LinkedIn Profile: [https://www.linkedin.com/in/iancraz/](https://www.linkedin.com/in/iancraz/)

# License
>[Table of contents](#table-of-contents)

```
MIT License

Copyright (c) 2021 Ian Cruz Diaz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```