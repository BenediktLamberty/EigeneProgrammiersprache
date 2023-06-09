
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
# list decl and init
            
        li $s0, 3  # Num 3 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 2  # Num 2 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # first malloc
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # list pointer to reg
        move $t2, $v0
        move $s2, $v0
        
        # fill list
        li $t1, 2
startFill1:
        ble $t1, $zero, endFill1
        addi $t1, $t1, -1
        # save elem
        lw $t0, ($sp)
        addi $sp, $sp, 4
        sw $t0, ($t2)
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link list
        sw $v0, 4($t2)
        move $t2, $v0
        b startFill1
endFill1:  
        # save elem
        lw $t0, ($sp)
        addi $sp, $sp, 4
        sw $t0, ($t2)
        # null pointer
        sw $zero, 4($t2) 
        # list ptr to stack
        addi $sp, $sp, -4
        sw $s2, ($sp)
            
        lw $s0, ($sp)  # init variable A
        addi $sp, $sp, 4
        sw $s0, A
            
# block of code
        
        # Var hbAMcMQabY decl in .data with value 0
            
        # Var i decl in .data with value 0
            
        # Var a decl in .data with value 0
            
# for each loop
        # set ptr var:

        lw $s0, A  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var hbAMcMQabY
        sw $s0, hbAMcMQabY
                
        addi $sp, $sp, 4
        # check for Null ptr

        lw $s0, hbAMcMQabY  # Identifier hbAMcMQabY to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t2, ($sp)
        addi $sp, $sp, 4
        beq $t2, $zero, endForEach2
forLoop2:

        lw $s0, hbAMcMQabY  # Identifier hbAMcMQabY to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t0, ($sp)
        lw $t0, ($t0)
        sw $t0, ($sp)

        lw $s0, ($sp)  # assign value to var a
        sw $s0, a
                
        addi $sp, $sp, 4    
        
        lw $s0, a  # Identifier a to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        lw $s0, i  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        

        lw $s0, hbAMcMQabY  # Identifier hbAMcMQabY to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s2, ($sp)
        addi $sp, $sp, 4
        lw $t2, 4($s2)
        beq $t2, $zero, endForEach2
        addi $sp, $sp, -4
        sw $t2, ($sp)

        lw $s0, ($sp)  # assign value to var hbAMcMQabY
        sw $s0, hbAMcMQabY
                
        addi $sp, $sp, 4

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
                
        addi $sp, $sp, 4
        b forLoop2
endForEach2:
        
# Global Variables
        .data
        
        A: .space 4
                
        hbAMcMQabY: .word 0
                
        i: .word 0
                
        a: .word 0
                