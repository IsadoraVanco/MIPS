# 2. Elaborar um programa, em código MIPS, que faça a leitura de dois 
# números inteiros (A e B) fornecidos pelo usuário pelo teclado e que 
# forneça como saída todos os múltiplos de A no intervalo de A até AxB.

# O programa deverá prever respostas para entradas de A ou B que 
# sejam números menores ou igual a 0.
# O programa fonte deve ser comentado e enviado como programa02.asm.

# Aluna: Isadora Vanço
.data
valorA: .asciiz "\nDigite um valor para A: "
valorB: .asciiz "\nDigite um valor para B: "
erroNegativos: .asciiz "\nO número fornecido é negativo ou nulo"
multiplos: .asciiz "\nOs múltiplos de A, de A à AxB são:\n"
ln: .asciiz "\n"

.text
.globl main
main:
    # Leitura dos valores
    # $s0 = A
    jal leValorA # Lê o valor de A
    add $s0, $zero, $v0 # A recebe o valor retornado

    slti $t0, $s0, 1 #if (A < 1){ $t0 = 1: $t0 = 0}
    bne $t0, $zero, erro #if($t0 != 0): erro

    # $s1 = B
    jal leValorB # Lê o valor de A
    add $s1, $zero, $v0 # B recebe o valor retornado

    slti $t0, $s1, 1 #if (B < 1){ $t0 = 1: $t0 = 0}
    bne $t0, $zero, erro #if($t0 != 0): erro

    # Calcula AxB
    mul $s1, $s1, $s0 # B = B * A

    # $s2 = contador 
    add $s2, $zero, $s0 # contador = A

    # $s3 = fim
    addi $s3, $s1, 1 # fim = B + 1

    jal printMultiplos # Imprime a frase de múltiplos
    
    loop:
        # Verifica se é múltiplo
        div $s2, $s0 # contador % A
        mfhi $t0 # $t0 = resto da divisão feita
        bne $t0, $zero, incremento # if($t0 != 0): incremento
        
        add $a0, $zero, $s2 # Configura o argumento para a função de print
        jal printNumero # Printa o número múltiplo

        incremento:
            addi $s2, $s2, 1 # contador++
            beq $s2, $s3, exit # if(contador == fim): exit

        j loop

leValorA:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, valorA
    syscall # Print(valorA)

    # Configura o syscall para ler inteiros
    li $v0, 5 
    syscall # O número lido vai ficar em v0
    jr $ra # Volta para depois da chamada da função

leValorB:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, valorB
    syscall # Print(valorB)

    # Configura o syscall para ler inteiros
    li $v0, 5 
    syscall # O número lido vai ficar em v0
    jr $ra # Volta para depois da chamada da função

erro:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, erroNegativos
    syscall # Print(erroNegativos)

    j exit

printMultiplos:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, multiplos
    syscall # Print(multiplos)
    jr $ra # Volta para depois da chamada da função

printNumero:
    # O número foi passado pelo parametro $a0
    li $v0, 1 # Configura o syscall para escrever inteiros
    syscall # Print()

    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, ln # Configura o argumento para a chamada de sistema
    syscall # Print(ln)
    jr $ra # Volta para depois da chamada da função

exit:
