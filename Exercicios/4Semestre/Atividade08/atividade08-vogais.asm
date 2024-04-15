# 2. Elaborar  um  programa,  em  código  MIPS,  que  receba  
# do  usuário  um  arquivo  texto.  Crie outro arquivo texto 
# contendo o texto do arquivo de entrada, mas com as vogais 
# substituídas por ‘*’ (asterisco).

# Aluna: Isadora Vanço
.data
bufferConversao: .space 20
nomeArquivo: .asciiz "primosGemeos.txt"
strLerInteiro: .asciiz "=> Digite um número maior que zero: "
strTituloArquivo: .asciiz "Números primos gêmeos de 1 até "
strPontos: .asciiz ":\n\n"
strPrimoGemeo: .asciiz " é primo gêmeo, pois "
strPrimo: .asciiz " também é primo\n"

.text
.globl main
main:
    la $a0, strLerInteiro
    lerInteiro($a0)

    move $s0, $v0           # s0 = n

    la $a0, nomeArquivo
    jal abrirArquivo

    move $s1, $v0           # s1 = ponteiro do arquivo

    # Escreve no arquivo
    move $a0, $s1
    la $a1, strTituloArquivo
    li $a2, 31
    jal escreverStringArquivo

    move $a0, $s1
    move $a1, $s0 
    jal escreverInteiroArquivo

    move $a0, $s1
    la $a1, strPontos
    li $a2, 4
    jal escreverStringArquivo

    li $s2, 2       # i = 2

    loopVerificarPrimos:
        # Verifica se n é primo
        move $a0, $s2 
        jal ehPrimo

        bne $v0, 1, continuaLoopPrimos  # if(ehPrimo(n) != 1): goto continuaLoopPrimos

        # Verifica se (n + 2) é primo
        addi $a0, $s2, 2
        jal ehPrimo

        bne $v0, 1, continuaLoopPrimos  # if(ehPrimo(n + 2) != 1): goto continuaLoopPrimos

        # Escreve no arquivo
        move $a0, $s1
        move $a1, $s2 
        jal escreverInteiroArquivo

        move $a0, $s1
        la $a1, strPrimoGemeo
        li $a2, 21
        jal escreverStringArquivo

        move $a0, $s1
        addi $a1, $s2, 2
        jal escreverInteiroArquivo

        move $a0, $s1
        la $a1, strPrimo
        li $a2, 17
        jal escreverStringArquivo

        continuaLoopPrimos:
            addi $s2, $s2, 1    # i++
            ble $s2, $s0, loopVerificarPrimos   # if(i <= n): goto loopVerificarPrimos

    move $a0, $s1
    jal fecharArquivo

    finalizarPrograma

# ********* AUXILIARES *****************************************************

# Finaliza o programa com código de saída de sucesso
.macro finalizarPrograma
    li $v0, 10
    syscall
.end_macro

# ********* LEITURA *****************************************************

# Lê um inteiro
.macro lerInteiro(%string)  # (0-int) 
    floopLer:
        la $a0, %string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        li $v0, 5                   # Código de leitura de inteiro
        syscall                     # Leitura do valor (retorna em $v0)

        blez $v0, floopLer      # if(valor <= 0): goto floopLer
    
.end_macro

# ********* CONVERSÕES *****************************************************

# converte um inteiro em string
.macro converterInteiroString(%numero)  # (0-string, 1-numCaracteres)
    # Salva os valores dos registradores
    subi $sp, $sp, 12              
    sw $t0, 0($sp)                  
    sw $t1, 4($sp) 
    sw $t2, 8($sp)            
    
    # Inicialização 
    la $v0, bufferConversao
    li $v1, 0   # v1 = numCaracteres
    li $t1, 0   # t1 = i
    la $t2, bufferConversao # t2 = &buffer

    fContarCaracteres:
        div %numero, %numero, 10
        mfhi $t0
        
        # Salva o resto da divisão
        subi $sp, $sp, 4
        sw $t0, ($sp)

        addi $v1, $v1, 1    # numCaracteres++

        bnez %numero, fContarCaracteres # if(numero != 0): goto fContarCaracteres

    fAdicionarCaracteres:
        # Desempilha os restos de divisão
        lw $t0, ($sp)
        addi $sp, $sp, 4

        addi $t0, $t0, 48   # Converte (0-9) para caractere 

        sb $t0, ($t2)   # buffer = t0

        addi $t2, $t2, 1    # buffer++
        addi $t1, $t1, 1    # i++

        bne $t1, $v1, fAdicionarCaracteres  # if(i != numCaracteres): goto fAdicionarCaracteres

    sb $zero, ($t2)     # buffer = NULL
    
    # Recupera os valores dos registradores
    lw $t0, 0($sp)                  
    lw $t1, 4($sp)  
    lw $t2, 8($sp)               
    addi $sp, $sp, 12                
    
.end_macro

# ********* ARQUIVO *****************************************************

# Abre o arquivo e retorna seu ponteiro
.macro abrirArquivo(%nomeArquivo)   # (0-ponteiro do arquivo)
    la $a0, %nomeArquivo
    li $a1, 1   # Somente escrita
    li $v0, 13  # Abertura do arquivo
    syscall

    # O ponteiro está em v0
.end_macro

# Fecha um arquivo
.macro fecharArquivo(%ponteiroArquivo)
    la $a0, %ponteiroArquivo
    li $v0, 16  # Fechar o arquivo
    syscall

.end_macro

# Escreve uma string em um arquivo
.macro escreverStringArquivo(%ponteiroArquivo, %string, %numCaracteres)
    # a0, a1 e a2 já estão carregados
    la $a0, %ponteiroArquivo
    la $a1, %string
    la $a2, %numCaracteres
    li $v0, 15      # Escrita no arquivo
    syscall

.end_macro

escreverInteiroArquivo: # void escreverInteiroArquivo(0-ponteiroArquivo, 1-numero)
    # Salva os valores dos registradores
    subi $sp, $sp, 8              
    sw $ra, 0($sp)  
    sw $a0, 4($sp)  
     
    move $a0, $a1
    jal converterInteiroString

    lw $a0, 4($sp)

    move $a1, $v0   # endereço da string
    move $a2, $v1   # número de caracteres
    jal escreverStringArquivo

    # Recupera os valores dos registradores
    lw $ra, 0($sp)              
    addi $sp, $sp, 8                
    
    jr $ra

lerArquivo:
    li $v0, 14       # Syscall 14: Ler arquivo
    move 	$a0, $s0		# $a0 = $s0
    la      $a1, buffer   # $a1 = &buffer
    li		$a2, 1		# $a2 = 1
    syscall						# execute