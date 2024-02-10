# Elaborar um programa, em código MIPS, que faça a leitura de 
# um vetor de n elementos (utilizar 12) inteiros e execute, 
# utilizando procedimentos, as seguintes operações:  

# a) Ordene o vetor em ordem crescente e apresentar o vetor ordenado;  
# b) Realize a soma dos elementos pares do vetor e apresentar o valor;  
# c) Leia uma chave k (número inteiro) e apresente na saída o número 
# de elementos do vetor que são maiores que a chave k e menores que 2*k; 
# d) Leia uma chave k (número inteiro) e apresente na saída o número 
# de elementos iguais a chave lida.  
# e) Apresenta na saída o resultado da soma dos números inteiros 
# perfeitos menos a soma dos números inteiros semiprimos.  

# OBS. pesquisar a definição de número perfeito e semiprimo.
# Analisar o(s) possível(eis) valor(es) para a chave k e caso 
# seja digitado um valor que não seja possível, uma mensagem deve 
# ser apresentada ao usuário.

# Aluna: Isadora Vanço
.data
str1: .asciiz "1) Lendo o vetor:\n"
ent: .asciiz "Insira o valor de Vet["
ent2: .asciiz "]"
str2: .asciiz "\n2) Mostra o vetor:\n"
str3: .asciiz "\n\n3) Mostra o vetor ordenado:\n"
str4: .asciiz "\n\n4) Soma os pares:\n"
totalPares: .asciiz "\nTotal: "
str5: .asciiz "\n\n5) Intervalo:\n"
str6: .asciiz "6) Iguais:\n"
str7: .asciiz "7) Soma dos perfeitos e semiprimos:\n"

.align 2
vet: .space 480             # 4 Bytes cada inteiro (12 números)

.text
.globl main 
main:
    # Print passo 1)
    la $a0, str1            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Leitura do vetor
    la $a0, vet             # $a0 = &vet
    jal leitura             # Lê o vetor (retorna o endereço do vetor)
    
    # Print passo 2)
    la $a0, str2            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Escrita do vetor
    la $a0, vet             # $a0 = &vet
    jal escrita             # Escreve o vetor (retorna o endereço do vetor)
    
    # Ordena o vetor

    # Print passo 3)
    la $a0, str3            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Escrita do vetor ordenado
    la $a0, vet             # $a0 = &vet
    jal escrita             # Escreve o vetor (retorna o endereço do vetor)

    # Print passo 4)
    la $a0, str4            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Soma os pares do vetor
    la $a0, vet             # $a0 = &vet
    jal somaPares           # Soma os pares

    # Print passo 5)
    la $a0, str5            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Print passo 6)
    la $a0, str6            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Print passo 7)
    la $a0, str7            # String do parametro da função
    li $v0, 4               # Escrever strings
    syscall                 # prinf(string)

    # Fim :)
    li $v0, 10              # Código para finalizar o programa
    syscall                 # Finaliza o programa

# Lê os valores que serão armazaenados no vetor
leitura:
    # t0 = &vetor
    move $t0, $a0           # $t0 = $a0 (&vet)
    # vetor[i]
    move $t1, $t0           # $t1 = $t0
    # t2 = i
    li $t2, 0               # $t2 = 0

    l:
        # Printf("Insira o valor de Vet[%d]", i);
        la $a0, ent         # $a0 = &ent
        li $v0, 4           # Escrever strings
        syscall             # prinf(ent)
        move $a0, $t2       # $a0 = $t2
        li $v0, 1           # Escrever inteiros
        syscall             # prinf($t2)
        la $a0, ent2        # $a0 = &ent2
        li $v0, 4           # Escrever strings
        syscall             # prinf(ent2)

        # Scanf("%d", vetor[i]);
        li $v0, 5           # Ler inteiros
        syscall             # scanf(vetor[i])
        sw $v0, ($t1)       # vetor[i] = $v0

        # i++;
        add $t1, $t1, 4     # &vetor[i + 1]
        addi $t2, $t2, 1    # i++

        blt $t2, 12, l      # if(i < 12): goto l

        # Return &vetor;
        move $v0, $t0       # $v0 = &vetor
        jr $ra              # Retorna para a main

# Escreve os valores armazenados no vetor
escrita:
    # $t0 = &vet
    move $t0, $a0           # $t0 = $a0
    # $t1 = &vetor[i]
    move $t1, $t0           # $t1 = $t0
    # $t2 = i
    li $t2, 0               # $t2 = 0

    e:
        # Printf("%d", vetor[i]);
        lw $a0, ($t1)       # $a0 = vetor[i]
        li $v0, 1           # Escrever inteiros
        syscall             # printf(vetor[i])

        # Printf(" ");
        li $a0, 32          # Código ASCII para espaço
        li $v0, 11          # Escrever caractere
        syscall             # printf(" ")

        # i++
        add $t1, $t1, 4     # &vetor[i + 1]
        addi $t2, $t2, 1    # i++

        blt $t2, 12, e      # if(i < 12): goto e

        # Return &vetor;
        move $v0, $t0       # $v0 = &vetor
        jr $ra              # Retorna para a main

# Soma os pares do vetor e mostra o total
somaPares:
    # $t0 = &vet
    move $t0, $a0           # $t0 = $a0
    # $t1 = $vetor[i]
    move $t1, $t0           # $t1 = $t0
    # $t2 = i
    li $t2, 0               # $t2 = 0
    # $t3 = soma
    addi $t3, $zero, 0      # $t3 = 0
    # $t4 = 2
    addi $t4, $zero, 2      # $t4 = 2

    lPares:
        # Verifica se é par
        # $t5 = vetor[i]
        lw $t5, ($t1)       # $t5 = $t1
        div $t5, $t4          # vetor[i] / 2
        # $t6 = resto da divisão
        mfhi $t6            # $t6 = vetor[i] % 2

        bne $t6, $zero, lpi # if(vetor[i] % 2 != 0): goto lpi
        add $t3, $t3, $t5   # soma += vetor[i]

        lw $a0, ($t1)       # $a0 = vetor[i]
        li $v0, 1           # Escrever inteiros
        syscall             # printf(vetor[i])

        # Printf(" ");
        li $a0, 32          # Código ASCII para espaço
        li $v0, 11          # Escrever caractere
        syscall             # printf(" ")

    lpi:
        # i++
        add $t1, $t1, 4     # &vetor[i + 1]
        addi $t2, $t2, 1    # i++

        blt $t2, 12, lPares # if(i < 12): goto lPares

        # Mostra o total
        la $a0, totalPares  # $a0 = totalPares
        li $v0, 4           # Escrever strings
        syscall             # prinf(totalPares)

        move $a0, $t3       # $a0 = soma
        li $v0, 1           # Escrever inteiros
        syscall             # prinf(soma)

        # Return &vetor;
        move $v0, $t0       # $v0 = &vetor
        jr $ra              # Retorna para a main
