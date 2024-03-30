# 1. Elaborar um programa, em código MIPS, para que dada uma 
# sequência de n números reais (vetor com alocação dinâmica), 
# determine um segmento de nota máxima. 

# Aluna: Isadora Vanço
.data
strQuantidade: .asciiz "=> Digite a quantidade de elementos do vetor: "
strChave1: .asciiz "["
strChave2: .asciiz "]"
strPontos: .asciiz ": "
strMaiorSoma: .asciiz "-> Maior soma: "
strIntervalo: .asciiz "\n-> Intervalo "
strVirgula: .asciiz " , "

.text
.globl main
main:
    # Quantidade de elementos
    la $a0, strQuantidade           # A string de mensagem
    li $a1, 0                       # Número minimo (aberto)
    jal lerInteiro

    move $s0, $v0                   # s0 = tamanho

    # Aloca espaço para o vetor
    sll $a0, $s0, 3                 # Tamanho em bytes para alocação (double = 8 Bytes)
    jal alocarEspaco                # Aloca o espaço pedido

    move $s1, $v0                   # s1 = endereço do vetor

    # Lê o vetor
    move $a0, $s1                   # Endereço do vetor
    move $a1, $s0                   # Tamanho do vetor
    jal lerVetorDouble              # Lê o vetor

    # Encontra a maior sequência
    move $a0, $s1                   # Endereço do vetor
    move $a1, $s0                   # Tamanho do vetor
    jal encontrarMaiorSequencia     # Encontra a maior sequencia

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

alocarEspaco:   # ($v0 = endereço) alocarEspaco(a0 = tamanho em Bytes)
    # O tamanho já está em a0
    li $v0, 9                       # Código para alocar espaço em heap
    syscall

    # Retorna o endereço em $v0
    jr $ra                          # Retorna para o endereço de chamada

mostrarInteiro: # void mostrarInteiro(a0 = número)
    # O número já está em a0
    li $v0, 1                               # Código para impressão de inteiro
    syscall 

    jr $ra                                  # Retorna para o endereço de chamada

mostrarDouble: # void mostrarDouble(f12 = valor)
    # O número já está em a0
    li $v0, 3                               # Código para impressão de double
    syscall 

    jr $ra                                  # Retorna para o endereço de chamada

mostrarString:  # void mostrarString(a0 = endereço da string)
    # A mensagem já está em a0
    li $v0, 4                               # Código para impressão de string
    syscall 

    jr $ra                                  # Retorna para o endereço de chamada

lerInteiro:  # ($v0 = valor) lerInteiro(a0 = string de mensagem, a1 = mínimo (aberto))
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de retorno

    loopLerInteiro:
        # A mensagem já está em a0
        jal mostrarString                       # Mostra a string 
        
        li $v0, 5                               # Código de leitura de inteiro
        syscall                                 # Faz a leitura do inteiro
        
        ble $v0, $a1, loopLerInteiro            # if(v0 <= a1): goto loopLerInteiro

    lw $ra, ($sp)                   # Recupera o retorno
    addi $sp, $sp, 4                # Libera o espaço na pilha

    # Retorna o endereço em $v0
    jr $ra                                  # Retorna para o endereço de chamada

lerDouble:  # ($f0, $f1 = valor) lerDouble()
    li $v0, 7                               # Código de leitura de inteiro
    syscall                                 # Faz a leitura do inteiro
    
    # Retorna o valor em $f0 e $f1
    jr $ra                                  # Retorna para o endereço de chamada

lerVetorDouble: # lerVetorDouble(a0 = endereço do vetor, a1 = tamanho)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de retorno

    move $t0, $a0                   # t0 = vetor[i]
    li $t1, 0                       # i = 0
    
    loopLerVetorDouble:
        # Mostra indice
        la $a0, strChave1           # Mostra a chave1
        jal mostrarString

        move $a0, $t1               # Mostra i
        jal mostrarInteiro

        la $a0, strChave2           # Mostra a chave2
        jal mostrarString

        la $a0, strPontos           # Mostra pontos
        jal mostrarString

        jal lerDouble               # Lê o double

        s.d $f0, 0($t0)             # Salva o valor em vetor[i]

        addi $t1, $t1, 1            # i++
        addi $t0, $t0, 8            # vetor++

        blt $t1, $a1, loopLerVetorDouble    # if(i < tamanho): goto loopLerVetorDouble

    lw $ra, ($sp)                   # Recupera o retorno
    addi $sp, $sp, 4                # Libera o espaço na pilha

    jr $ra   

encontrarMaiorSequencia: # void encontrarMaiorSequencia(a0 = endereço do vetor, a1 = tamanho)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de retorno

    li $t0, 0                       # i = 0
    li $t1, 0                       # j = 0
    move $t2, $a0                   # vetor[i]
    move $t3, $a0                   # vetor[j]
    l.d $f4, 0($a0)                 # primeiro = vetor[0]
    l.d $f6, 0($a0)                 # segundo = vetor[0]
    l.d $f8, 0($a0)                 # somaMaior = vetor[0]

    loopEncontraMaior:
        l.d $f10, 0($t2)            # soma = vetor[i]

        addi $t1, $t0, 1            # j = i + 1
        addi $t3, $t2, 8            # vetor[i + 1]
        bge $t1, $a1, incrementaLoop

        loopEncontraMaior2:
            l.d $f20, 0($t3)        # f20 = vetor[j]
            add.d $f10, $f10, $f20  # soma += vetor[j]

            c.lt.d $f8, $f10
            bc1t atualizaValores
            # bgt $f10, $f8, atualizaValores  # if(soma > somaMaior): goto atualizaValores
            j incrementaLoop

            atualizaValores:
                mov.d $f8, $f10         # somaMaior = soma
                l.d $f4, 0($t2)         # primeiro = vetor[i]
                mov.d $f6, $f20         # segundo = vetor[j]

        incrementaLoop:
        addi $t1, $t1, 1            # j++
        addi $t3, $t3, 8            # vetor[j]++

        blt $t1, $a1, loopEncontraMaior2    # if(j < tamanho): goto loopEncontraMaior2

        addi $t0, $t0, 1            # i++
        addi $t2, $t2, 8            # vetor[i]++

        blt $t0, $a1, loopEncontraMaior # if(i < tamanho): goto loopEncontraMaior

    # Mostra resultados
    la $a0, strMaiorSoma
    jal mostrarString

    mov.d $f12, $f8
    jal mostrarDouble

    la $a0, strIntervalo
    jal mostrarString

    la $a0, strChave1
    jal mostrarString

    mov.d $f12, $f4
    jal mostrarDouble

    la $a0, strVirgula
    jal mostrarString

    mov.d $f12, $f6
    jal mostrarDouble
    
    la $a0, strChave2
    jal mostrarString

    lw $ra, ($sp)                   # Recupera o retorno
    addi $sp, $sp, 4                # Libera o espaço na pilha

    # Retorna o endereço em $v0
    jr $ra 