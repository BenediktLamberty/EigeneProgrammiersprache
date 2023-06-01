
# Program:
        .text
        
        # Var x decl in .data with value 99
            
        # Var i decl in .data with value 0
            
whileCondition1:
            
        lw $s0, i  # Identifier i to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 99  # Num 99 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        blt $s0, $s1, conTrue2  # comparator <
            
        li $s0, 0  # comparator descision
        b conExit2
conTrue2:
        li $s0, 1
conExit2:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile1
            
        # Body of While Loop
        
        lw $s0, i  # Identifier i to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        lw $s0, i  # Identifier i to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        add $s0, $s0, $s1  # + operation
                
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # assign value to var i
        sw $s0, i
            
        addi $sp, $sp, 4  # raising sp after expression
                
        b whileCondition1  # looping while
exitWhile1:
            
# Global Variables
        .data
        
        x: .word 99
                
        i: .word 0
                