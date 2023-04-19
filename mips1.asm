# Program:
        .text
        
        # Var x decl in .data with value 10

        lw $t8, x  # Identifier x to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)

        li $t8, 90  # Num 90 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)

        lw $t8, ($sp)  # Binary + operation
        addi $sp, $sp, 4
        lw $t9, ($sp)
        add $t8, $t8, $t9
        sw $t8, ($sp)

        lw $t8, ($sp)  # Unary - operation
        neg $t8, $t8
        sw $t8, ($sp)

        lw $t8, ($sp)  # init variable y
        sw $t8, y
        
        lw $s0, y

# Global Variables
        .data

        x: .word 10

        y: .space 4
