# 1. Elaborar um programa, em código MIPS, que faça a leitura 
# de uma matriz A de inteiros, de ordem 4x3, e a leitura de um 
# vetor de inteiros V com 3 elementos. Determinar o produto de 
# A por V. 

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
strMatA: .asciiz "=> Lendo Matriz A:\n"
strMatB: .asciiz "=> Lendo Matriz B:\n"
strMostraA: .asciiz "\n=> Matriz A lida:\n"
strMostraB: .asciiz "\n=> Matriz B lida:\n"
strMostraC: .asciiz "\n=> Matriz C = A * B:\n"

.align 2
Mat: .space 48                      # Matriz de inteiros 4x3 (4Bytes)
Vetor: .space 12                    # vetor de inteiros (3) (4Bytes)
Produto: .space 16                  # Matriz de inteiros resultante (4x1) (4Bytes)

.text
.globl main
main: 
    la $a0, strMatA                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, Mat                     # Endereço base de Mat
    li $a1, 4                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal leitura                     # leitura(Mat, nlin, ncol)

    la $a0, strMatB                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, Vetor                   # Endereço base de Vetor
    li $a1, 3                       # Número de linhas (3)
    li $a2, 1                       # Número de colunas do vetor (1)
    jal leitura                     # leVetor(Vetor, nElem, 1)

    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, Mat                     # Endereço da matriz lida
    li $a1, 4                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal escrita                     # escrita(Mat, nlin, ncol)

    la $a0, strMostraB              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, Vetor                   # Endereço da matriz lida
    li $a1, 3                       # Número de linhas (3)
    li $a2, 1                       # Número de colunas do vetor (1)
    jal escrita                     # escrita(Vetor, nlin, ncol)

    li $a0, 4                       # Número de linhas da resultante
    li $a1, 3                       # Tamanho das colunas da A e linhas da B 
    li $a2, 1                       # Número de colunas da resultante
    jal multiplica                  # Multiplica a matriz pelo vetor

    la $a0, strMostraC              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, Produto                 # Endereço da matriz produto
    li $a1, 4                       # Número de linhas
    li $a2, 1                       # Número de colunas
    jal escrita                     # escrita(Produto, nlin, ncol)

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

indice:     # indice(a2 = nCol, a3 = Endereço da matriz, t0 = i, t1 = j)
    mul $v0, $t0, $a2               # i * ncol
    add $v0, $v0, $t1               # (i * ncol) + j
    sll $v0, $v0, 2                 # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3               # Soma o endereço base de Mat

    jr $ra                          # Retorna para o caller

leitura:    # leitura(a0 = Endereço, a1 = nLinhas, a2 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    l:  
        la $a0, Ent1                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t0               # Valor de i para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime i

        la $a0, Ent2                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t1               # Valor de j para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime j

        la $a0, Ent3                # Carrega o endereço da string
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

multiplica: # multiplica(a0 = nLinhas de AC, a1 = tamanho de AB, a2 = nColunas de BC)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de onde a função foi chamada

    add $s0, $zero, $a2             # Salva nColunas BC
    add $s1, $zero, $a1             # Salva o tamanho AB
    add $s2, $zero, $a0             # Salva nLinhas AC

    add $s4, $zero, 0               # $s4 = i em nLinhas

    linhas:
        add $s5, $zero, 0           # $s5 = j em nColunas

        colunas:
            addi $t2, $zero, 0      # $t2 = soma dos elementos
            add $s3, $zero, 0       # $s3 = e em tamanho

            soma:
                addi $a2, $s1, 0    # $a2 = nColunas da A
                la $a3, Mat         # $a3 = Endereço da Matriz A
                addi $t0, $s4, 0    # $t0 = i
                addi $t1, $s3, 0    # $t1 = e
                jal indice          # Calcula o endereço de MatrizA[i][e]

                lw $t3, ($v0)       # $t3 = multiplicação dos elementos

                addi $a2, $s0, 0    # $a2 = nColunas da B
                la $a3, Vetor       # $a3 = Endereço da Matriz B
                addi $t0, $s3, 0    # $t0 = e
                addi $t1, $s5, 0    # $t1 = j
                jal indice          # Calcula o endereço de MatrizB[e][j]

                lw $t4, ($v0)       # $t4 = valor de matrizB[e][j]
                
                mul $t3, $t3, $t4   # $t3 = matrizA[i][e] * matrizB[e][j]
                add $t2, $t2, $t3   # somaElementos += matrizA[i][e] * matrizB[e][j]

                addi $s3, $s3, 1    # e++
                blt $s3, $s1, soma  # if(e < tamanho): goto soma

            addi $a2, $s0, 0        # $a2 = nColunas da C
            la $a3, Produto         # $a3 = Endereço da Matriz C
            addi $t0, $s4, 0        # $t0 = i
            addi $t1, $s5, 0        # $t1 = j
            jal indice              # Calcula o endereço de MatrizC[i][j]

            sw $t2, ($v0)           # MatrizC[i][j] = somaElemento
            
            addi $s5, $s5, 1        # j++
            blt $s5, $s0, colunas   #if(j < nColunas): goto linhas

        addi $s4, $s4, 1            # i++
        blt $s4, $s2, linhas        #if(i < nLinhas): goto linhas

    lw $ra, ($sp)                   # Recupera o retorno para a main
    addi $sp, $sp, 4                # Libera o espaço na pilha
    move $v0, $a3                   # Endereço base da matriz para retorno

    jr $ra                          # Retorna para a main