# 2. Dizemos que uma matriz inteira Anxn é uma matriz de permutação 
# se em cada linha e em cada coluna houver n-1 elementos nulos e 
# um único elemento igual a 1. (Utilizar n = 3)

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
matInteira: .asciiz "Matriz inteira:\n"
resultado: .asciiz "=>Resultado: "
strEhPermuta: .asciiz "É de permutação\n"
strNaoehPermuta: .asciiz "Não é de permutação\n"

.align 2
Mat: .space 36  # Matriz de inteiros 3x3 (4Bytes)

.text
.globl main
main: 
    la $a0, Mat     # Endereço base de Mat
    li $a1, 3       # Número de linhas
    li $a2, 3       # Número de colunas
    jal leitura     # leitura(Mat, nlin, ncol)

    move $a0, $v0   # Endereço da matriz lida
    jal escrita     # escrita(Mat, nlin, ncol)

    move $a0, $v0   # Endereço da matriz lida
    jal verificaPermuta     # escrita(Mat, nlin, ncol)

    li $v0, 10      # Código para finalizar o programa
    syscall         # Finaliza o programa

indice:
    mul $v0, $t0, $a2       # i * ncol
    add $v0, $v0, $t1       # (i * ncol) + j
    sll $v0, $v0, 2         # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3       # Soma o endereço base de Mat

    jr $ra                  # Retorna para o caller

leitura:
    subi $sp, $sp, 4        # Espaço para um item na pilha
    sw $ra, ($sp)           # Salva o endereço base de Mat
    move $a3, $a0           # aux ($a3) = endereço base de Mat

    l:  
        la $a0, Ent1        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string

        move $a0, $t0       # Valor de i para impressão
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime i

        la $a0, Ent2        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string

        move $a0, $t1       # Valor de j para impressão
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime j

        la $a0, Ent3        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string  

        li $v0, 5           # Código de leitura de inteiro
        syscall             # Leitura do valor (retorna em $v0)

        move $t2, $v0       # aux = valor lido
        jal indice          # Calcula o endereço de Mat[i][j]

        sw $t2, ($v0)       # Mat[i][j] = aux
        addi $t1, $t1, 1    # j++
        
        blt $t1, $a2, l     # if(j < ncol): goto l
        
        li $t1, 0           # j = 0
        addi $t0, $t0, 1    # i++

        blt $t0, $a1, l     # if(i < nlin): goto l

        li $t0, 0           # i = 0
        lw $ra, ($sp)       # Recupera o retorno para a main
        addi $sp, $sp, 4    # Libera o espaço na pilha
        move $v0, $a3       # Endereço base da matriz para retorno

        jr $ra              # Retorna para a main

escrita:
    subi $sp, $sp, 4        # Espaço para um item na pilha
    sw $ra, ($sp)           # Salva o endereço base de Mat
    move $a3, $a0           # aux = endereço base de Mat

    la $a0, matInteira      # Carrega o endereço da string
    li $v0, 4               # Código de impressão de string
    syscall                 # Imprime a string 

    e:
        jal indice          # Calcula o endereço de Mat[i][j]

        lw $a0, ($v0)       # Valor em Mat[i][j]
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime Mat[i][j]

        la $a0, 32          # Código ASCII para espaço
        li $v0, 11          # Código de impressão de caractere
        syscall             # Imprime o espaço

        addi $t1, $t1, 1    # j++

        blt $t1, $a2, e     # if(j < ncol): goto e

        la $a0, 10          # Código ASCII para newline ('\n')
        syscall             # Pula a linha

        li $t1, 0           # j = 0
        addi $t0, $t0, 1    # i++

        blt $t0, $a1, e     # if(i < nlin): goto e

        li $t0, 0           # i = 0

        lw $ra, ($sp)       # Recupera o retorno para a main
        addi $sp, $sp, 4    # Libera o espaço na pilha
        move $v0, $a3       # Endereço base da matriz para retorno

        jr $ra              # Retorna para a main
    
verificaPermuta:
    
    subi $sp, $sp, 4        # Espaço para um item na pilha
    sw $ra, ($sp)           # Salva o endereço base de Mat

    # $s0 = elementos
    addi $s0, $zero, 0      # elementos = 0

    addi $t0, $zero, 0      # i = 0
    addi $t1, $zero, 0      # j = 0

    la $a0, resultado       # Carrega o endereço da string
    li $v0, 4               # Código de impressão de string
    syscall                 # Imprime a string 

    # Analisa as linhas
    lLinhas:
        jal indice          # Calcula o endereço de Mat[i][j]

        lw $t3, ($v0)       # Valor em Mat[i][j]

        beq $t3, 0, lContinua       # if(Mat[i][j] == 0): goto lContinua
        bne $t3, 1, naoEhPermuta    # if(Mat[i][j] != 1): goto naoEhPermuta

        addi $s0, $s0, 1            # elementosLinha++

    lContinua:
        addi $t1, $t1, 1    # j++

        blt $t1, $a2, lLinhas       # if(j < ncol): goto lLinhas

        bne $s0, 1, naoEhPermuta    # if(elementosLinha != 1): goto naoEhPermuta

        li $t1, 0           # j = 0
        addi $t0, $t0, 1    # i++
        addi $s0, $zero, 0      # elementos = 0

        blt $t0, $a1, lLinhas     # if(i < nlin): goto lLinhas

    addi $t0, $zero, 0      # i = 0
    addi $t1, $zero, 0      # j = 0

    # Analisa as colunas
    lColunas:
        jal indice          # Calcula o endereço de Mat[i][j]

        lw $t3, ($v0)       # Valor em Mat[i][j]

        beq $t3, 0, lContinua2       # if(Mat[i][j] == 0): goto lContinua
        bne $t3, 1, naoEhPermuta    # if(Mat[i][j] != 1): goto naoEhPermuta

        addi $s0, $s0, 1            # elementosLinha++

    lContinua2:
        addi $t0, $t0, 1    # i++

        blt $t0, $a1, lColunas       # if(i < nlin): goto lColunas

        bne $s0, 1, naoEhPermuta    # if(elementosLinha != 1): goto naoEhPermuta

        li $t0, 0           # i = 0
        addi $t1, $t1, 1    # j++
        addi $s0, $zero, 0      # elementos = 0

        blt $t1, $a2, lColunas     # if(j < nCol): goto lColunas

    la $a0, strEhPermuta     # Carrega o endereço da string
    li $v0, 4               # Código de impressão de string
    syscall  
    j fimVerifica

    naoEhPermuta:
        la $a0, strNaoehPermuta # Carrega o endereço da string
        li $v0, 4               # Código de impressão de string
        syscall                 # Imprime a string

    fimVerifica:

        lw $ra, ($sp)       # Recupera o retorno para a main
        addi $sp, $sp, 4    # Libera o espaço na pilha
        move $v0, $a3       # Endereço base da matriz para retorno

        jr $ra              # Retorna para a main

        