# 1. Escreva um programa, em código MIPS, que dado um inteiro positivo n, 
# verificar se n é um inteiro perfeito. Um inteiro positivo n é perfeito 
# se for igual à soma de seus divisores positivos diferentes de n. 
# Exemplo: 6 é perfeito, pois 1+2+3 = 6. Enviar o código fonte 
# comentado e testado no MARS.

# Aluna: Isadora Vanço
.data
valor: .asciiz "\nDigite um valor para n: "
erroNegativos: .asciiz "\nO número fornecido é negativo ou nulo"
naoPerfeito: .asciiz "\nO número n não é perfeito"
ehPerfeito: .asciiz "\nO número n é perfeito"

.text
.globl main
main:
    # Leitura do valor

    # $s0 = n
    jal leValor # Lê o valor de n
    add $s0, $zero, $v0 # n recebe o valor retornado

    slti $t0, $s0, 1 # if (n < 1){$t0 = 1: $t0 = 0}
    bne $t0, $zero, erro # if($t0 != 0): erro

    addi $t0, $zero, 1 # $t0 = 1
    beq $s0, $t0, numeroNaoPerfeito # if(n == 1): numeroNaoPerfeito

    # Inicializa o contador

    # $s1 = contador
    sub $s1, $s0, 1 # contador = n - 1 

    # Inicializa a soma dos múltiplos
    
    declaraSoma:
    # $s2 = soma
    addi $s2, $zero, 1 # soma = 1 (todo número é multiplo de 1)
    
    # Verifica os múltiplos 

    loop:
        slti $t0, $s1, 2 # if(contador < 2){$t0 = 1: $t0 = 0}
        bne $t0, $zero, verificaSoma #if($t0 != 0): verificaSoma

        # Verifica se é multiplo
        div $s0, $s1 # n / contador
        mfhi $t0 # $t0 = n % contador

        bne $t0, $zero, decremento # if(n % contador != 0): decremento
        add $s2, $s2, $s1 # soma += contador

        slt $t0, $s0, $s2 # if(n < soma){$t0 = 1: $t0 = 0}
        bne $t0, $zero, numeroNaoPerfeito # if($t0 != 0): numeroNaoPerfeito

        decremento:
        subi $s1, $s1, 1 # contador--

        j loop # Vai para loop

    # Verifica o total somado

    verificaSoma:
        
        bne $s2, $s0, numeroNaoPerfeito # if(soma != n): numeroNaoPerfeito

        numeroPerfeito:
            la $a0, ehPerfeito
            jal print
            j exit

        numeroNaoPerfeito:
            la $a0, naoPerfeito
            jal print
            j exit
    
leValor:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, valor # Configura o argumento da função
    syscall # Print(valor)

    li $v0, 5 # Configura o syscall para ler inteiros
    syscall # O número lido vai ficar em v0

    jr $ra # Volta para depois da chamada da função

print: 
    # A string será passada pelo argumento $a0
    li $v0, 4 # Configura o syscall para escrever strings
    syscall # Print($a0)

    jr $ra # Volta para depois da chamada da função

erro:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, erroNegativos # Configura o argumento da função
    syscall # Print(erroNegativos)

    j exit # Vai para exit

exit: