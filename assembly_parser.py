machine_code = []

FILE_NAME = 'assembly.txt'
OUT_FILE_NAME = 'machine_code.mem'

opcodes = {
    'mov': '000',
    'load': '001',
    'alu': '010',
    'save_alu': '011',
    'load_input': '100',
    'branch_if_zero': '101',
    'end': '111' 

}

print('PARSING', FILE_NAME)
with open(FILE_NAME, 'r') as f:
    lines = f.readlines()
    i = 0
    for line in lines:
        line = line.strip()
        # skip line if comment or blank
        if not line or line.startswith('//'):
            continue

        print('LINE:', i, ':', line)
        code = ''
        instruction = line.split()
        opcode_str = instruction[0]

        # if opcode_str == '//': continue
        
        # first, parse opcode
        if not opcodes.get(opcode_str):
            print('ASSEMBLY ERROR AT LINE:', i)
            exit()
        opcode = opcodes[opcode_str]
        print(opcode_str, ':', opcode)
        code += opcode


        # now do opcode-specific stuff
        if opcode_str == 'mov':
            source_reg = int(instruction[1])
            source_reg = bin(source_reg)[2:].zfill(4) #convert to binary form, 4 digits long

            dest_reg = int(instruction[2])
            dest_reg = bin(dest_reg)[2:].zfill(4)

            code += source_reg
            code += dest_reg
        
        elif opcode_str == 'load':
            source_reg = int(instruction[1])
            source_reg = bin(source_reg)[2:].zfill(4) #convert to binary form, 4 digits long

            value = int(instruction[2])
            value = bin(value)[2:].zfill(8)

            code += source_reg
            code += value
        elif opcode_str == 'alu':
            source_reg = int(instruction[1])
            source_reg = bin(source_reg)[2:].zfill(4) #convert to binary form, 4 digits long

            dest_reg = int(instruction[2])
            dest_reg = bin(dest_reg)[2:].zfill(4)

            code += source_reg
            code += dest_reg

            alu_mode = instruction[3] # alu mode is 3 bits
            if   alu_mode == 'add': code += '000'
            elif alu_mode == 'sub': code += '001'
            elif alu_mode == 'mul': code += '010'
            elif alu_mode == 'equals': code += '101'
        
        elif opcode_str == 'save_alu':
            source_reg = int(instruction[1])
            source_reg = bin(source_reg)[2:].zfill(4) #convert to binary form, 4 digits long
            code += source_reg
        
        elif opcode_str == 'branch_if_zero':
            source_reg = int(instruction[1])
            source_reg = bin(source_reg)[2:].zfill(4) #convert to binary form, 4 digits long

            value = int(instruction[2])
            value = bin(value)[2:].zfill(8)

            code += source_reg
            code += value

        elif opcode_str == 'end':
            code = '1111111111111111'



            



        # finally, pad with zeroes
        code = code + '0' * (16 - len(code))
        print(code)
        machine_code.append(code)


        i += 1
        print('\n')



        
print('FINAL MACHINE CODE:')
print(machine_code)

# write to file
print('writing to', OUT_FILE_NAME)
with open(OUT_FILE_NAME, 'w') as f:
    for line in machine_code:
        f.write(line + '\n')