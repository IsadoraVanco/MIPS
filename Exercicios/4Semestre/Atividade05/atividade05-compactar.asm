# 4. Elaborar um programa que leia  um vetor Vet, de n elementos inteiros, 
# e o “compacte”, ou seja, elimine as posições com valor igual a zero. 
# Para isso, todos os elementos à frente do valor zero devem ser movidos 
# uma posição para trás do vetor. Apresente como saída o vetor compactado 
# (Vetcomp)

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]: "
strTamanho: .asciiz "=> Digite o tamanho do vetor: "
strTamanhoErro: .asciiz "=> O tamanho do vetor deve ser maior que zero!\n"
strA: .asciiz "=> Lendo o vetor:\n"
strMostraA: .asciiz "\n=> Vetor lido:\n"
strMostraCompactado: .asciiz "\n=> Vetor compactado:\n"

.text
.globl main
main:
    jal lerTamanho                  # Le o tamanho do vetor (retorna o valor em $v0)
    
    move $s0, $v0                   # Salva o tamanho do vetor ($s0)

    # Aloca espaço para o vetor 
    sll $a0, $s0, 2                 # $a0 = tamanho do vetor * 4 Bytes (inteiro)
    jal alocaEspaco                 # Aloca o espaço pedido (retorna o endereço em $v0)

    move $s1, $v0                   # Salva o endereço do vetor  ($s1)

    # Lendo o vetor 
    la $a0, strA                    # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # printf(strA)

    move $a0, $s1                   # Endereço base do vetor 
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal leitura                     # leitura(vetorA, nlin, ncol)

    # Mostra vetor lido
    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s1                   # Endereço base do vetor 
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal escrita                     # escrita(vetorA, nlin, ncol)

    # Compactar o vetor 
    move $a0, $s1                   # Endereço base do vetor 
    move $a1, $s0                   # Número de elementos do vetor
    jal compactar

    # Mostra o vetor compactado
    la $a0, strMostraCompactado     # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s1                   # Endereço base do vetor 
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal escrita                     # escrita(vetorA, nlin, ncol)

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

indice:     # indice(a2 = nCol, a3 = Endereço da matriz, t0 = i, t1 = j (0 para vetores))
    mul $v0, $t0, $a2               # i * ncol
    add $v0, $v0, $t1               # (i * ncol) + j
    sll $v0, $v0, 2                 # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3               # Soma o endereço base de Mat

    jr $ra                          # Retorna para o caller

lerTamanho:

    loopLer:
        la $a0, strTamanho          # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        li $v0, 5                   # Código de leitura de inteiro
        syscall                     # Leitura do valor (retorna em $v0)

        bgt $v0, 0, fimTamanho      # if(valor > 0): goto fimTamanho

        la $a0, strTamanhoErro      # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        j loopLer                   # goto loopLer
    
    fimTamanho:
    jr $ra

leitura:    # leitura(a0 = Endereço, a1 = nLinhas (1 para vetores), a2 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    l:  
        la $a0, Ent1                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t1               # Valor de j para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime j

        la $a0, Ent2                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        li $v0, 5                   # Código de leitura de inteiro
        syscall                     # Leitura do valor (retorna em $v0)

        move $t2, $v0               # aux = valor lido
        jal indice                  # Calcula o endereço de Mat[i][j]

        sw $t2, ($v0)               # Mat[i][j] = aux
        addi $t1, $t1, 1            # j++
        
        blt $t1, $a2, l             # if(j < ncol): goto l
        
        li $t1, 0                   # j = 0
        addi $t0, $t0, 1            # i++

        blt $t0, $a1, l             # if(i < nlin): goto l

        li $t0, 0                   # i = 0
        lw $ra, ($sp)               # Recupera o retorno para a main
        addi $sp, $sp, 4            # Libera o espaço na pilha
        move $v0, $a3               # Endereço base da matriz para retorno

        jr $ra                      # Retorna para a main

escrita:    # escrita(a0 = Endereço, a1 = nLinhas, a2 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    addi $t0, $zero, 0              # i = 0
    addi $t1, $zero, 0              # j = 0
    e:
        jal indice                  # Calcula o endereço de Mat[i][j]

        lw $a0, ($v0)               # Valor em Mat[i][j]
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime Mat[i][j]

        la $a0, 32                  # Código ASCII para espaço
        li $v0, 11                  # Código de impressão de caractere
        syscall                     # Imprime o espaço

        addi $t1, $t1, 1            # j++

        blt $t1, $a2, e             # if(j < ncol): goto e

        la $a0, 10                  # Código ASCII para newline ('\n')
        syscall                     # Pula a linha

        li $t1, 0                   # j = 0
        addi $t0, $t0, 1            # i++

        blt $t0, $a1, e             # if(i < nlin): goto e  

        lw $ra, ($sp)               # Recupera o retorno para a main
        addi $sp, $sp, 4            # Libera o espaço na pilha
        move $v0, $a3               # Endereço base da matriz para retorno

        jr $ra                      # Retorna para a main

alocaEspaco: # alocaEspaco(a0 = tamanho em Bytes)
    # O tamanho já está em a0
    li $v0, 9                       # Código para alocar espaço em heap
    syscall

    jr $ra

compactar:  # compactar(a0 = endereço do vetor, a1 = nElementos)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de onde chamou a função 

    li $t0, 0                       # i = 0
    li $t1, 0                       # j = 0
    li $t2, 0                       # k = indice que será arrumado 
    move $t3, $a0                     # Endereço do indice k
    li $t5, 0                       # Aux do j

    loopCompactar:
        lw $t4, ($a0)               # $t4 = vetor[j]

        bne $t4, 0, fimCompactar    # if(vetor[j] != 0): goto fimCompactar

        move $t5, $t1               # Aux = j
        move $t2, $t1               # k = j
        move $t3, $a0               # &vetor[k] ($t3)
        
        arrumaIndice:
            addi $t2, $t2, 1        # k++
            addi $t3, $t3, 4        # &vetor[k]++
            bge $t2, $a1, fimCompactar  # if(k >= nElementos): goto fimCompactar

            lw $t6, ($t3)           # $t6 = vetor[k]

            beq $t6, 0, arrumaIndice    # if(vetor[k] == 0): goto arrumaIndice

            # Faz a troca 
            sw $t6, ($a0)           # &vetor[j] = vetor[k]
            sw $zero, ($t3)         # &vetor[k] = 0

        fimCompactar:
        addi $t1, $t1, 1            # j++
        addi $a0, $a0, 4            # vetor++
        blt $t1, $a1, loopCompactar # if(j < nElementos): goto loopCompactar

    lw $ra, ($sp)                   # Recupera o retorno para a main
    addi $sp, $sp, 4                # Libera o espaço na pilha

    jr $ra                          # Retorna para a main
