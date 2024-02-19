# 3. Dada uma matriz de inteiros Amxn, imprimir o número de linhas
# e o número de colunas nulas da matriz. (utilizar n = m = 4)

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
matInteira: .asciiz "Matriz inteira:\n"
str1: .asciiz "=>Tem "
strLinhas1: .asciiz " linha nula e "
strLinhas: .asciiz " linhas nulas e "
strColunas1: .asciiz " coluna nula\n"
strColunas: .asciiz " colunas nulas\n"

.align 2
Mat: .space 64  # Matriz de inteiros 4x4 (4Bytes)

.text
.globl main
main: 
    la $a0, Mat             # Endereço base de Mat
    li $a1, 4               # Número de linhas
    li $a2, 4               # Número de colunas
    jal leitura             # leitura(Mat, nlin, ncol)

    move $a0, $v0           # Endereço da matriz lida
    jal escrita             # escrita(Mat, nlin, ncol)

    move $a0, $v0           # Endereço da matriz lida
    jal verificaNulas       # verificaNulas(Mat, nlin, ncol)

    li $v0, 10              # Código para finalizar o programa
    syscall                 # Finaliza o programa

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
    
verificaNulas:
    subi $sp, $sp, 4            # Espaço para um item na pilha
    sw $ra, ($sp)               # Salva o endereço base de Mat

    # $s0 = elementos
    addi $s0, $zero, 0          # elementos = 0
    # $s1 = linhas
    addi $s1, $zero, 0          # linhas = 0
    # $s2 = colunas
    addi $s2, $zero, 0          # colunas = 0

    addi $t0, $zero, 0          # i = 0
    addi $t1, $zero, 0          # j = 0

    # Analisa as linhas
    lLinhas:
        jal indice              # Calcula o endereço de Mat[i][j]

        lw $t3, ($v0)           # Valor em Mat[i][j]

        bne $t3, 0, lContinua   # if(Mat[i][j] != 0): goto lContinua

        addi $s0, $s0, 1        # elementos++

    lContinua:
        addi $t1, $t1, 1        # j++

        blt $t1, $a2, lLinhas   # if(j < ncol): goto lLinhas

        li $t1, 0               # j = 0
        addi $t0, $t0, 1        # i++

        bne $s0, $a2, ll        # if(elementos != ncol): goto lLinhas
        addi $s1, $s1, 1        # linhas++
    ll:
        addi $s0, $zero, 0      # elementos = 0
        blt $t0, $a1, lLinhas   # if(i < nlin): goto lLinhas

    addi $t0, $zero, 0          # i = 0
    addi $t1, $zero, 0          # j = 0
    addi $s0, $zero, 0          # elementos = 0

    # Analisa as colunas
    lColunas:
        jal indice              # Calcula o endereço de Mat[i][j]

        lw $t3, ($v0)           # Valor em Mat[i][j]

        bne $t3, 0, lContinua2  # if(Mat[i][j] != 0): goto lContinua

        addi $s0, $s0, 1        # elementos++

    lContinua2:
        addi $t0, $t0, 1        # i++

        blt $t0, $a1, lColunas  # if(i < nlin): goto lColunas

        li $t0, 0               # i = 0
        addi $t1, $t1, 1        # j++

        bne $s0, $a1, ll2       # if(elementos != nlin): goto lLinhas
        addi $s2, $s2, 1        # colunas++
    ll2:
        addi $s0, $zero, 0      # elementos = 0
        blt $t1, $a2, lColunas  # if(j < nCol): goto lColunas

    # Imprime o resultado
    la $a0, str1                # Carrega o endereço da string
    li $v0, 4                   # Código de impressão de string
    syscall  

    move $a0, $s1       
    li $v0, 1                   # Código para impressão de inteiro
    syscall             

        bgt $s1, 1, maisLinhas  # if(linhas > 1): goto maisLinhas

        la $a0, strLinhas1      # Carrega o endereço da string
        li $v0, 4               # Código de impressão de string
        syscall  

        j colunas

        maisLinhas:
        la $a0, strLinhas       # Carrega o endereço da string
        li $v0, 4               # Código de impressão de string
        syscall  

    colunas:                    # Imprime a string
        move $a0, $s2        
        li $v0, 1               # Código para impressão de inteiro
        syscall             

        bgt $s2, 1, maisColunas # if(linhas > 1): goto maisLinhas

        la $a0, strColunas1     # Carrega o endereço da string
        li $v0, 4               # Código de impressão de string
        syscall  
        j fim

        maisColunas:
        la $a0, strColunas      # Carrega o endereço da string
        li $v0, 4               # Código de impressão de string
        syscall  

    fim:
    lw $ra, ($sp)               # Recupera o retorno para a main
    addi $sp, $sp, 4            # Libera o espaço na pilha
    move $v0, $a3               # Endereço base da matriz para retorno

    jr $ra                      # Retorna para a main
   