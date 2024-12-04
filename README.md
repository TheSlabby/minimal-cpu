# minimal-cpu
Basic CPU implementation in Verilog, with custom assembly language and parser.



### Opcodes
These opcodes should allow for almost any algorithm
```python
opcodes = {
    'mov': '000',
    'load': '001',
    'alu': '010',
    'save_alu': '011',
    'load_input': '100',
    'branch_if_zero': '101',
    'end': '111' 
}
```



### Limitations
* registers are 32-bit
* max 256 lines of code
* `load` can only use 8-bit values, despite 32-bit registers
* 16 general-purpose registers

### Example Programs
Fibbonaci Sequence
```
// FIBONACCI SEQUENCE
load 0 1        // first variable
load 1 1        // second variable
load 2 0        // constant = 0

mov 0 15        // OUTPUT CURRENT NUMBER (register 15 goes to basic_output)

alu 0 1 add     // add first & second variables
save_alu 4      // save output to the fourth register

mov 1 0         // set first variable = second variable
mov 4 1         // set second variable = current fibbonaci number

branch_if_zero 2 2      // loop indefinitely (reg 0 is a constant equal to 0. therefore, this condition is always true)

load 14 1               // it should never here, but if it does its bugged
end
```
**This converts to machine code:** ```0010000000000010
0010001000000010
0010010000000000
0000000111100000
0100000000100000
0110100000000000
0000001000000000
0000100000100000
1010010000000100
0011110000000010
1111111111111111```
