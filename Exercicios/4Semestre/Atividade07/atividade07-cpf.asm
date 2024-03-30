# 2. Baseado neste algoritmo, elaborar um programa, em código MIPS, 
# que leia um CPF, contendo 11 algarismos, separando os dígitos 
# do CPF dos dígitos verificadores por um traço(xxxxxxxxx-xx). 
# Em seguida, seu programa deve verificar se o CPF é válido ou 
# não. Não esqueça de validar a entrada de dados, que deve conter 
# 11 dígitos e um traço. 

# Aluna: Isadora Vanço
.data
strEntrada: .asciiz "=> Digite o CPF (123456789-XX): "
strFormatoIncorreto: .asciiz "\n-> Não está no formato correto!"
strValido: .asciiz "\n-> CPF Válido!"
strInvalido: .asciiz "\n-> CPF inválido!"
strDigitos: .asciiz "\n-> Dígitos verificadores: "

.text
.globl main
main:
    # Aloca espaço para o CPF
    li $a0, 12                      # $a0 = 11 digitos + '-'
    jal alocarEspaco                # Aloca o espaço pedido

    move $s0, $v0                   # $s0 = Endereço da string do CPF

    la $a0, strEntrada              # a0 = Mensagem para ler
    move $a1, $s0                   # a1 = Endereço da string
    jal lerString                   # Lê a string

    move $a0, $s0                   # a0 = endereço da String
    jal ehCPFValido                 # Verifica se o CPF é válido

    bne $v0, 1, invalido            # if($v0 != 1): goto invalido
        la $a0, strValido           # Endereço da string
        j printResultado            # goto printResultado
    invalido:   
        la $a0, strInvalido         # Endereço da string

    printResultado:
    jal mostrarString               # Mostra a string em a0

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

alocarEspaco:   # alocarEspaco(a0 = tamanho em Bytes)
    
    # O tamanho já está em a0
    li $v0, 9                       # Código para alocar espaço em heap
    syscall

    # Retorna o endereço em $v0
    jr $ra                          # Retorna para o endereço de chamada

mostrarString:  # mostrarString(a0 = endereço da string)
    # A mensagem já está em a0
    li $v0, 4                               # Código para impressão de string
    syscall 

    jr $ra                                  # Retorna para o endereço de chamada

mostrarInteiro: # mostrarInteiro(a0 = número)
    # O número já está em a0
    li $v0, 1                               # Código para impressão de inteiro
    syscall 

    jr $ra                                  # Retorna para o endereço de chamada

lerString:  # lerString(a0 = string de mensagem, a1 = endereço da string)
    
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de retorno

    # A mensagem já está em a0
    jal mostrarString                       # Mostra a string 
    
    move $a0, $a1                           # Endereço da string para leitura
    li $a1, 25                              # Número máximo de caracteres na string
    
    li $v0, 8                               # Código de leitura da string
    syscall                                 # Faz a leitura da string

    lw $ra, ($sp)                   # Recupera o retorno
    addi $sp, $sp, 4                # Libera o espaço na pilha

    # Retorna o endereço em $v0
    jr $ra                                  # Retorna para o endereço de chamada

ehDigito:   # ehDigito(a0 = digito)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $t0, ($sp)                   # Salva o valor do registrador

    lb $t0, ($a0)                   # t0 = *string

    blt $t0, 48, retornaDInvalido   # if(*string < '0'): goto retornaDInvalido
    bgt $t0, 57, retornaDInvalido   # if(*string > '9'): goto retornaDInvalido

    # Retornos
    li $v0, 1                       # Retorna 1 (é válido)
    j retornaDValido                # goto retornaDValido

    retornaDInvalido:
    li $v0, 0                       # Retorna 0 (é inválido)

    retornaDValido:
    lw $t0, ($sp)                   # Recupera o valor do registrador
    addi $sp, $sp, 4                # Libera o espaço na pilha

    # Retorna em v0 (1 se é digito valido, 0 caso contrario)
    jr $ra                          # Retorna

ehFormatoCPF:   # ehFormatoCPF(a0 = endereço do cpf)
    subi $sp, $sp, 20               # Espaço para cinco itens na pilha
    sw $ra, 0($sp)                  # Salva o endereço de retorno
    sw $a0, 4($sp)                  # Salva o valor do registrador
    sw $t0, 8($sp)                  # Salva o valor do registrador
    sw $t1, 12($sp)                 # Salva o valor do registrador
    sw $t2, 16($sp)                 # Salva o valor do registrador

    move $t0, $a0                   # Copia o endereço da string
    li $t1, 0                       # i = 0

    loopFormato:
        # a0 já tem o endereço de um caractere
        jal ehDigito                # Verifica se é um dígito válido

        bne $v0, 1, retornaFInvalido    #if(v0 != 1): goto retornaFInvalido

        addi $t1, $t1, 1            # i++
        addi $a0, $a0, 1            # string++
        blt $t1, 9, loopFormato     # if(i < 9): goto loopFormato

    lb $t2, ($a0)                   # t2 = string[9]
    bne $t2, 45, retornaFInvalido   # if(string[9] != '-'): goto retornaFInvalido
    
    addi $a0, $a0, 1            # string++
    addi $t1, $t1, 1            # i++

    loopFormato2:
        # a0 já tem o endereço de um caractere
        jal ehDigito                # Verifica se é um dígito válido

        bne $v0, 1, retornaFInvalido    #if(v0 != 1): goto retornaFInvalido

        addi $t1, $t1, 1            # i++
        addi $a0, $a0, 1            # string++
        blt $t1, 12, loopFormato2   # if(i < 12): goto loopFormato2

    # Retornos
    li $v0, 1                       # Retorna 1 (é válido)
    j retornaFValido                # goto retornaFValido

    retornaFInvalido:
    li $v0, 0                       # Retorna 0 (é inválido)

    retornaFValido:
    lw $ra, 0($sp)                  # Recupera o endereço de retorno
    lw $a0, 4($sp)                  # Recupera o valor do registrador
    lw $t0, 8($sp)                  # Recupera o valor do registrador
    lw $t1, 12($sp)                 # Recupera o valor do registrador
    lw $t2, 16($sp)                 # Recupera o valor do registrador
    addi $sp, $sp, 20               # Libera o espaço na pilha

    jr $ra     
    
somarDigitos:    # somaDigitos(a0 = Endereço da string, a1 = multiplicador)
    
    subi $sp, $sp, 20               # Espaço para cinco itens na pilha
    sw $t0, 0($sp)                  # Salva o valor do registrador
    sw $t2, 4($sp)                  # Salva o valor do registrador
    sw $t3, 8($sp)                  # Salva o valor do registrador
    sw $t4, 12($sp)                 # Salva o valor do registrador
    sw $t5, 16($sp)                 # Salva o valor do registrador

    li $t0, 0                       # i = 0
    li $v0, 0                       # soma = 0
    move $t2, $a0                   # string[i]

    loopSoma:
        lb $t3, ($t2)               # t3 = string[i]
        subi $t4, $t3, 48           # string[i] - '0'

        sub $t5, $a1, $t0           # t5 = multiplicador - i
        mul $t4, $t4, $t5           # t4 = (string[i] - '0') * (multiplicador - i)

        add $v0, $v0, $t4           # soma += t4

        addi $t0, $t0, 1            # i++
        addi $t2, $t2, 1            # string++

        blt $t0, 9, loopSoma        # if(i < 9): goto loopSoma

    lw $t0, 0($sp)                  # Recupera o valor do registrador
    lw $t2, 4($sp)                  # Recupera o valor do registrador
    lw $t3, 8($sp)                  # Recupera o valor do registrador
    lw $t4, 12($sp)                 # Recupera o valor do registrador
    lw $t5, 16($sp)                 # Recupera o valor do registrador
    addi $sp, $sp, 20               # Libera o espaço na pilha

    # Retorna a soma em v0
    jr $ra                          # Retorna para a main

calcularDigito: # calcularDigito(a0 = soma dos digitos)
    subi $sp, $sp, 8                # Espaço para dois itens na pilha
    sw $t0, 4($sp)                  # Salva o valor do registrador
    sw $t1, 0($sp)                  # Salva o valor do registrador
    
    li $t1, 11                      # t1 = 11
    div $a0, $t1                    # soma / 11
    mfhi $t0                        # $t0 = soma % 11

    blt $t0, 2, restoMenor          # if(soma % 11 < 2): goto restoMenor
        sub $v0, $t1, $t0           # v0 = 11 - soma % 11
        j retornaDigito             # goto retornaDigito
    restoMenor:
        li $v0, 0                   # v0 = 0

    retornaDigito:
    lw $t0, 4($sp)                  # Recupera o valor do registrador
    lw $t1, 0($sp)                  # Recupera o valor do registrador
    addi $sp, $sp, 8                # Libera o espaço na pilha

    # Retorna o valor do dígito em v0
    jr $ra                          # Retorna para a main

ehCPFValido:    # ehCPFValido(a0 = endereço do cpf)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de retorno

    # O endereço da string já está em a0
    jal ehFormatoCPF                # Verifica se está no formato certo

    bne $v0, 1, retornaFormato      # if($v0 != 1): goto retornaFormato

    # Calcula o primeiro dígito verificador
    # O endereço da string já está em a0
    li $a1, 10                      # Multiplicador
    jal somarDigitos                # Soma os digitos do CPF

    move $a1, $a0                   # a1 = Salva o endereço da string

    move $a0, $v0                   # a0 = Soma dos digitos
    jal calcularDigito              # Calcula digito verificador

    move $t0, $v0                   # $t0 = primeiroDigito

    # Calcula o segundo dígito verificador
    move $a0, $a1                   # O endereço da string
    li $a1, 11                      # Multiplicador
    jal somarDigitos                # Soma os digitos do CPF

    move $a1, $a0                   # a1 = Salva o endereço da string

    addi $t1, $a1, 10               # string[10]
    lb $t2, ($t1)                   # t2 = string[10]
    subi $t2, $t2, 48               # t2 = string[10] - '0'
    
    sll $t1, $t2, 1                 # t1 = ( string[10] - '0' ) * 2
    add $v0, $v0, $t1               # soma += (string[10] - '0') * 2

    move $a0, $v0                   # a0 = Soma dos digitos
    jal calcularDigito              # Calcula digito verificador

    move $t1, $v0                   # $t1 = segundoDigito

    # Resultados
    la $a0, strDigitos              # Mostra os dígitos verificadores
    jal mostrarString               # Mostra a string

    move $a0, $t0                   # a0 = o primeiro digito verificador
    jal mostrarInteiro              # Mostra o número inteiro

    move $a0, $t1                   # a0 = o segundo digito verificador
    jal mostrarInteiro              # Mostra o número inteiro

    # Verifica digitos
    addi $t2, $a1, 10               # string[10]
    lb $t3, ($t2)                   # t3 = string[10]
    subi $t3, $t3, 48               # t3 = string[10] - '0'

    bne $t3, $t0, retornaInvalido   # if(string[10] - '0' != primeiroDigito): goto retornaInvalido

    addi $t2, $a1, 11               # string[11]
    lb $t3, ($t2)                   # t3 = string[11]
    subi $t3, $t3, 48               # t3 = string[11] - '0'

    bne $t3, $t1, retornaInvalido   # if(string[11] - '0' != segundoDigito): goto retornaInvalido

    # Retornos
    li $v0, 1                       # Retorna 1 (é válido)
    j retornaValido                 # goto retornaValido

    retornaFormato:
    la $a0, strFormatoIncorreto     # Endereço da string
    jal mostrarString               # Mostra a string

    retornaInvalido:
    li $v0, 0                       # Retorna 0 (é inválido)

    retornaValido:
    lw $ra, ($sp)                   # Recupera o retorno
    addi $sp, $sp, 4                # Libera o espaço na pilha

    jr $ra                          # Retorna para a main