# 1. Traduza o código a seguir para assembly de MIPS. 
# Durante a tradução para assembly, as variáveis locais devem 
# ser mapeadas para registradores $s0, $s1, .... 
# A função int value() retorna um valor no registrador $v0 e 
# não tem o seu código apresentado, bastando apenas ser chamada 
# quando necessário

# Aluna: Isadora Vanço
.data

.text
.globl main
main:
    jal func

    li $v0, 10             
    syscall                 # Finaliza o programa

# int value();
value:
    jr $ra

# int func();
func:
    subi $sp, $sp, 20           # Salva variáveis na pilha
    sw $s0, 0($sp)              # a 
    sw $s1, 4($sp)              # b
    sw $s2, 8($sp)              # c
    sw $s3, 12($sp)             # r
    sw $s4, 16($sp)             # -1
    sw $ra, 20($sp)             # Endereço de retorno

    addi $s3, $zero, -1         # r = -1
    addi $s4, $zero, -1         # -1

    j loopTest
    loopFunc:
        jal value               
        add $s0, $v0, $zero             # a = value()
        jal value               
        add $s1, $v0, $zero             # b = value()
        jal value               
        add $s2, $v0, $zero             # c = value()

        add $t0, $s1, $s2 
        slt $t1, $s0, $t0
        beq $t1, $zero, loopTest        # a < b + c

        add $t0, $s0, $s2 
        slt $t1, $s1, $t0
        beq $t1, $zero, loopTest        # b < a + c

        add $t0, $s0, $s1 
        slt $t1, $s2, $t0
        beq $t1, $zero, loopTest        # c < a + b

        bne $s0, $s1, isosceles         # a == b
        bne $s1, $s2, isosceles         # b == c

        addi $s3, $zero, 0              # r = 0

        j loopTest
        isosceles:
            bne $s0, $s1, escaleno      # a == b
            bne $s0, $s2, escaleno      # a == c
            bne $s2, $s1, escaleno      # c == b

            addi $s3, $zero, 1          # r = 1

            j loopTest
        escaleno:
            addi $s3, $zero, 2          # r = 2
    loopTest:
        beq $s3, $s4, loopFunc          # while(r == -1)

    add $v0, $s3, $zero                 # return r

    lw $s0, 0($sp)            
    lw $s1, 4($sp)           
    lw $s2, 8($sp)              
    lw $s3, 12($sp)            
    lw $s4, 16($sp)            
    lw $ra, 20($sp)             
    addi $sp, $sp, 24  

    jr $ra         