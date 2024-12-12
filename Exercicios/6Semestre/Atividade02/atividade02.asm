# Traduza o código apresentado para assembly de MIPS e 
# execute o mesmo em um simulador para verificar que o 
# mesmo funciona corretamente. Durante a tradução para 
# assembly, as variáveis locais devem ser mapeadas para os 
# registradores $s0, $s1, .... 
# A função int potencia(...) retorna um valor no registrador 
# $v0. Lembre-se de salvar/restaurar os devidos valores 
# na pilha.

# Aluna: Isadora Vanço

# ***** MACROS *********************************************

.macro mostrarTexto(%texto)
    move $a0, %texto
    li $v0, 4
    syscall	
.end_macro

.macro mostrarInteiro(%numero)
    move $a0, %numero
    li $v0, 1                      
    syscall
.end_macro

.macro lerInteiro
    li $v0, 5                   
    syscall                     
.end_macro

.macro finalizar
    li $v0, 10             
    syscall 
.end_macro

# *********************************************************************************
.data
strBase: .asciiz "Entre com a base:"
strExpoente: .asciiz "Entre com o expoente:"
strResultado: .asciiz "Resultado: "
strNewLine: .asciiz "\n"

# *********************************************************************************
.text
.globl main
main:
    la $a0, strBase
    mostrarTexto($a0)

    lerInteiro
    move $s0, $v0           # s0 = base

    la $a0, strExpoente
    mostrarTexto($a0)

    lerInteiro
    move $s1, $v0           # s1 = expoente

    la $a0, strResultado
    mostrarTexto($a0) 
    
    move $a0, $s0
    move $a1, $s1
    jal potencia
    move $s2, $v0           # s2 = resultado

    mostrarInteiro($s2)
    
    la $a0, strNewLine
    mostrarTexto($a0) 

    finalizar                

# ***** FUNÇÕES *********************************************

# int potencia(a0 = base, a1 = expoente)
potencia:
    addi $sp, $sp, -8
    sw $a1, 4($sp)
    sw $ra, 0($sp)

    slti $t0, $a1, 1     # if expoente < 1
    beq $t0, $zero, ptcRecursive

    addi $v0, $zero, 1      # return 1
    addi $sp, $sp, 8
    jr $ra

    ptcRecursive:
        addi $a1, $a1, -1
        jal potencia        # potencia(base, expoente-1)

    lw $a1, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8

    mul $v0, $a0, $v0

    jr $ra