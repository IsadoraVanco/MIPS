# 3. Elaborar  um  programa,  em  código  MIPS,  que  faça  a  
# leitura  de  uma  matriz  de números inteiros quadrada de 
# ordem 4  e apresente como saída: 
# * o resultado da subtração: da somatória dos elementos acima 
# da diagonal superior com a somatória dos elementos abaixo da 
# diagonal principal; 
# * o maior elemento acima da diagonal principal; 
# * o menor elemento abaixo da diagonal principal; 
# * a matriz ordenada (ordem crescente).

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
strMatA: .asciiz "=> Lendo a Matriz:\n"
strMostraA: .asciiz "\n=> Matriz lida:\n"
strSoma: .asciiz "\n=> Soma dos superiores - soma dos inferiores: "
strMaior: .asciiz "\n=> Maior elemento acima da diagonal principal: "
strMenor: .asciiz "\n=> Menor elemento abaixo da diagonal principal: "
strMatrizOrdenada: .asciiz "\n\n=> Matriz ordenada:\n"

.align 2
MatA: .space 64                     # Matriz de inteiros 4x4 (4Bytes)

.text
.globl main
main: 
    la $a0, strMatA                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço base de MatA
    li $a1, 3                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal leitura                     # leitura(MatA, nlin, ncol)

    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço da matriz lida
    li $a1, 3                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal escrita                     # escrita(MatA, nlin, ncol)

    li $a0, 3                       # Ordem da matriz
    jal soma                        # Soma a diagonal secundária

    li $a0, 3                       # Ordem da matriz
    jal ordena                      # Ordena a matriz

    la $a0, strMatrizOrdenada       # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço da matriz lida
    li $a1, 3                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal escrita                     # escrita(MatA, nlin, ncol)

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

        li $t0, 0           # i = 0
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

soma: # soma(a0 = ordem)
    subi $sp, $sp, 4                        # Espaço para um item na pilha
    sw $ra, ($sp)                           # Salva o endereço de onde foi chamada a função

    move $s0, $a0                           # ordem
    addi $s1, $zero, 0                      # somaSuperior = 0
    addi $s2, $zero, 0                      # somaInferior = 0
    addi $s3, $zero, 0                      # maior = 0
    addi $s4, $zero, 0                      # menor = 0

    # Atribui mat[0][1] ao maior
    li $t0, 0                               # $t0 = i
    li $t1, 1                               # $t1 = j
    la $a3, MatA                            # $a3 = &MatA
    jal indice                              # Calcula o endereço de Mat[0][1]

    lw $s3, ($v0)                           # maior = Mat[0][1]

    # Atribui mat[1][0] ao menor
    li $t0, 1                               # $t0 = i
    li $t1, 0                               # $t1 = j
    la $a3, MatA                            # $a3 = &MatA
    jal indice                              # Calcula o endereço de Mat[1][0]

    lw $s4, ($v0)                           # menor = Mat[1][0]

    # Começando o loop
    addi $t2, $zero, 0                      # i em nLinhas

    linhas:
        addi $t3, $zero, 0                  # j em nColunas

        colunas:
            beq $t2, $t3, continua          # if(i == j): goto continua

            move $t0, $t2                   # $t0 = i
            move $t1, $t3                   # $t1 = j
            la $a3, MatA                    # $a3 = &MatA
            jal indice                      # Calcula o endereço de Mat[i][j]

            lw $t4, ($v0)                   # $t4 = Mat[i][j]

            bgt $t3, $t2, superior          # if(j > i): goto superior
            add $s2, $s2, $t4               # somaInferior += Mat[i][j]
            ble $s4, $t4, continua          # if(menor <= Mat[i][j]): goto continua
            add $s4, $zero, $t4             # menor = Mat[i][j]
            
            j continua

            superior:
                add $s1, $s1, $t4           # somaSuperior += Mat[i][j]
                bge $s3, $t4, continua      # if(maior >= Mat[i][j]): goto continua
                add $s3, $zero, $t4         # maior = Mat[i][j]

            continua:
            addi $t3, $t3, 1                # j++
            blt $t3, $s0, colunas           # if(j < ordem): goto colunas
        
        addi $t2, $t2, 1                    # i++
        blt $t2, $s0, linhas                # if(i < ordem): goto linhas

    # Imprime o resultado
    sub $s1, $s1, $s2                       # somaSuperiores - somaInferiores

    la $a0, strSoma                         # Carrega o endereço da string
    li $v0, 4                               
    syscall                                

    move $a0, $s1                           # Carrega a soma
    li $v0, 1                               
    syscall                                 

    la $a0, strMaior                        # Carrega o endereço da string
    li $v0, 4                              
    syscall                                 

    move $a0, $s3                           # Carrega a soma
    li $v0, 1                              
    syscall                                

    la $a0, strMenor                        # Carrega o endereço da string
    li $v0, 4                               
    syscall                                

    move $a0, $s4                           # Carrega a soma
    li $v0, 1                      
    syscall                       

    lw $ra, ($sp)                           # Recupera o retorno para a main
    addi $sp, $sp, 4                        # Libera o espaço na pilha

    jr $ra                                  # Retorna para a main

ordena: # ordena(a0 = ordem)
    subi $sp, $sp, 4                        # Espaço para um item na pilha
    sw $ra, ($sp)                           # Salva o endereço de onde foi chamada a função
    
    move $s0, $a0                           # $s0 = ordem
    
    # Vamos tratar a matriz como um vetor
    mul $s1, $s0, $s0                       # ordem * ordem
    subi $s1, $s1, 1                        # $s1 = tamanho = ordem * ordem - 1
    
    li $t2, 0                               # $t2 = i em tamanho
    
    loopOrdena:
        li $t3, 0                           # $t3 = j em tamanho
        sub $s2, $s1, $t2                   # $s2 = parada = tamanho - i

        loopOrdena2:
            # Calcula matriz[0][j]
            li $t0, 0                       # $t0 = 0
            move $t1, $t3                   # $t1 = j
            la $a3, MatA                    # $a3 = &MatA
            jal indice                      # Calcula o endereço de Mat[0][j]

            lw $t4, ($v0)                   # $t4 = Mat[0][j]
            move $t5, $v0                   # $t5 = &Mat[0][j]

            # Calcula matriz[0][j + 1]
            li $t0, 0                       # $t0 = 0
            addi $t1, $t3, 1                # $t1 = j + 1
            jal indice                      # Calcula o endereço de Mat[0][j]

            lw $t6, ($v0)                   # $t6 = Mat[0][j + 1]
            move $t7, $v0                   # $t7 = &Mat[0][j + 1]

            ble $t4, $t6, continuaOrdena    # if(Mat[0][j] <= Mat[0][j + 1]): goto continuaOrdena

            move $s3, $t4                   # temp = Mat[0][j]
            sw $t6, ($t5)                   # &Mat[0][j] = Mat[0][j + 1]
            sw $s3, ($t7)                   # &Mat[0][j + 1] = temp
            
            continuaOrdena:
            addi $t3, $t3, 1                # j++
            blt $t3, $s2, loopOrdena2       # if(j < parada): goto loopOrdena2

        addi $t2, $t2, 1                    # i++
        blt $t2, $s1, loopOrdena            # if(i < tamanho): goto loopOrdena

    lw $ra, ($sp)                           # Recupera o retorno para a main
    addi $sp, $sp, 4                        # Libera o espaço na pilha

    jr $ra                      # Retorna para a main
