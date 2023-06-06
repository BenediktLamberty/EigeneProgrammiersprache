
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
# list decl and init
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # list pointer to reg and stack
        move $s2, $v0
        addi $sp, $sp, -4
        sw $v0, ($sp)
            
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # save elem
        lw $t0 ($sp)
        addi $sp, $sp, 4
        sw $t0 ($s2)
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link memory
        sw $v0, 4($s2)
        # save ptr
        move $s2, $v0 
                
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # save elem
        lw $t0 ($sp)
        addi $sp, $sp, 4
        sw $t0 ($s2)
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link memory
        sw $v0, 4($s2)
        # save ptr
        move $s2, $v0 
                
        li $s0, 2  # Num 2 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # save elem
        lw $t0 ($sp)
        addi $sp, $sp, 4
        sw $t0 ($s2)
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link memory
        sw $v0, 4($s2)
        # save ptr
        move $s2, $v0 
                
        li $s0, 3  # Num 3 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # save last elem
        lw $t0 ($sp)
        addi $sp, $sp, 4
        sw $t0, ($s2)
        # add zero pointer
        sw $zero, 4($s2)
            
        lw $s0, ($sp)  # init variable x
        addi $sp, $sp, 4
        sw $s0, x
            
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        x: .space 4
                