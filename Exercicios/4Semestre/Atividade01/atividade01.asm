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

# OBS: pesquisar a definição de número perfeito e semiprimo.
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
str5: .asciiz "\n\n5) Intervalo:\n"
chaveInteira: .asciiz "Insira uma chave inteira: "
strIntervalo: .asciiz "Números que estão entre ("
strIntervalo2: .asciiz " , "
chavePositiva: .asciiz "A chave deve ser maior que 1!\n"
str6: .asciiz "\n\n6) Iguais:\n"
totalRepeticoes: .asciiz "Total de repetições do número ("
str7: .asciiz "\n7) Soma dos perfeitos e semiprimos:"
ehPerfeito: .asciiz "\nPerfeito: "
strEhsemiPrimo: .asciiz "\nSemiprimo: "
strSomaPerfeitos: .asciiz "\nSoma dos númmeros perfeitos: "
strSomaPrimos: .asciiz "\nSoma dos númmeros semiprimos: "
strPerfPrimo: .asciiz "\n=>Perfeitos - Semiprimos = "
total: .asciiz "\nTotal: "
fechaPar: .asciiz "): "
barraN: .asciiz "\n"

.align 2
vet: .space 480                 # 4 Bytes cada inteiro (12 números)

.text
.globl main 
main:
    # Print passo 1)
    la $a0, str1                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Leitura do vetor
    la $a0, vet                 # $a0 = &vet
    jal leitura                 # Lê o vetor (retorna o endereço do vetor)
    
    # Print passo 2)
    la $a0, str2                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Escrita do vetor
    la $a0, vet                 # $a0 = &vet
    jal escrita                 # Escreve o vetor (retorna o endereço do vetor)
    
    # Ordena o vetor

    # Print passo 3)
    la $a0, str3                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Escrita do vetor ordenado
    la $a0, vet                 # $a0 = &vet
    jal escrita                 # Escreve o vetor (retorna o endereço do vetor)

    # Print passo 4)
    la $a0, str4                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Soma os pares do vetor
    la $a0, vet                 # $a0 = &vet
    jal somaPares               # Soma os pares

    # Print passo 5)
    la $a0, str5                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Intervalo entre k e 2k
    la $a0, vet                 # $a0 = &vet
    jal intervalo               # Verifica os números do intervalo

    # Print passo 6)
    la $a0, str6                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Verifica iguais
    la $a0, vet                 # $a0 = &vet
    jal iguais                  # Verifica os número iguais a chaveK

    # Print passo 7)
    la $a0, str7                # String do parametro da função
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(string)

    # Calcula a soma dos perfeitos e semiprimos
    la $a0, vet                 # $a0 = &vet
    jal perfeitosPrimos                  # Verifica os números 

    # Fim :)
    li $v0, 10                  # Código para finalizar o programa
    syscall                     # Finaliza o programa

# Lê os valores que serão armazaenados no vetor
leitura:
    # t0 = &vetor
    move $t0, $a0               # $t0 = $a0 (&vet)
    # vetor[i]
    move $t1, $t0               # $t1 = $t0
    # t2 = i
    li $t2, 0                   # $t2 = 0

    l:
        # Printf("Insira o valor de Vet[%d]", i);
        la $a0, ent             # $a0 = &ent
        li $v0, 4               # Escrever strings
        syscall                 # prinf(ent)
        move $a0, $t2           # $a0 = $t2
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf($t2)
        la $a0, ent2            # $a0 = &ent2
        li $v0, 4               # Escrever strings
        syscall                 # prinf(ent2)

        # Scanf("%d", vetor[i]);
        li $v0, 5               # Ler inteiros
        syscall                 # scanf(vetor[i])
        sw $v0, ($t1)           # vetor[i] = $v0 (valor lido)

        # i++;
        add $t1, $t1, 4         # &vetor[i + 1]
        addi $t2, $t2, 1        # i++

        blt $t2, 12, l          # if(i < 12): goto l

        # Return &vetor;
        move $v0, $t0           # $v0 = &vetor
        jr $ra                  # Retorna para a main

# Escreve os valores armazenados no vetor
escrita:
    # $t0 = &vet
    move $t0, $a0               # $t0 = $a0
    # $t1 = &vetor[i]
    move $t1, $t0               # $t1 = $t0
    # $t2 = i
    li $t2, 0                   # $t2 = 0

    e:
        # Printf("%d", vetor[i]);
        lw $a0, ($t1)           # $a0 = vetor[i]
        li $v0, 1               # Escrever inteiros
        syscall                 # printf(vetor[i])

        # Printf(" ");
        li $a0, 32              # Código ASCII para espaço
        li $v0, 11              # Escrever caractere
        syscall                 # printf(" ")

        # i++
        add $t1, $t1, 4         # &vetor[i + 1]
        addi $t2, $t2, 1        # i++

        blt $t2, 12, e          # if(i < 12): goto e

        # Return &vetor;
        move $v0, $t0           # $v0 = &vetor
        jr $ra                  # Retorna para a main

# Soma os pares do vetor e mostra o total
somaPares:
    # $t0 = &vet
    move $t0, $a0               # $t0 = $a0
    # $t1 = $vetor[i]
    move $t1, $t0               # $t1 = $t0
    # $t2 = i
    li $t2, 0                   # $t2 = 0
    # $t3 = soma
    addi $t3, $zero, 0          # $t3 = 0
    # $t4 = 2
    addi $t4, $zero, 2          # $t4 = 2

    lPares:
        # $t5 = vetor[i]
        lw $t5, ($t1)           # $t5 = $t1
        
        # Verifica se é 0
        beq $t5, 0, lpi         # if(vetor[i] == 0): goto lpi

        # Verifica se é par
        div $t5, $t4            # vetor[i] / 2
        # $t6 = resto da divisão
        mfhi $t6                # $t6 = vetor[i] % 2

        bne $t6, $zero, lpi     # if(vetor[i] % 2 != 0): goto lpi
        add $t3, $t3, $t5       # soma += vetor[i]

        # Printf("%d ", vetor[i])
        lw $a0, ($t1)           # $a0 = vetor[i]
        li $v0, 1               # Escrever inteiros
        syscall                 # printf(vetor[i])
        li $a0, 32              # Código ASCII para espaço
        li $v0, 11              # Escrever caractere
        syscall                 # printf(" ")

    lpi:
        # i++
        add $t1, $t1, 4         # &vetor[i + 1]
        addi $t2, $t2, 1        # i++

        blt $t2, 12, lPares     # if(i < 12): goto lPares

        # Mostra o total
        la $a0, total           # $a0 = total
        li $v0, 4               # Escrever strings
        syscall                 # prinf(total)

        move $a0, $t3           # $a0 = soma
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(soma)

        # Return &vetor;
        move $v0, $t0           # $v0 = &vetor
        jr $ra                  # Retorna para a main

# Verifica quais números do vetor estão entre k e 2k
intervalo:
    # $t0 = &vet
    move $t0, $a0               # $t0 = $a0
    # $t1 = $vetor[i]
    move $t1, $t0               # $t1 = $t0
    # $t2 = i
    li $t2, 0                   # $t2 = 0
    # $t3 = soma
    addi $t3, $zero, 0          # $t3 = 0

    llit:
        # Lê uma chave 
        la $a0, chaveInteira    # $a0 = &chaveInteira
        li $v0, 4               # Escrever strings
        syscall                 # prinf(ent)
        li $v0, 5               # Ler inteiros
        syscall                 # scanf(vetor[i])

        # Se a chave k <= 1, lê de novo
        bgt $v0, 1, it           # if($v0 > 1): goto it

        # Prinf("A chave deve ser maior que 1!\n")
        la $a0, chavePositiva   # $a0 = &chavePositiva
        li $v0, 4               # Escrever strings
        syscall                 # prinf(chavePositiva)
        
        j llit                  # goto llit
    
    it: 
        # $t4 = chaveK
        move $t4, $v0           # $t4 = $v0 (valor lido)
        # $t5 = 2*chaveK
        sll $t5, $t4, 1         # $t5 = 2 * $t4

        # Prinf("Números que estão no intervalo de (%d , %d): \n", chaveK, chaveK * 2)
        la $a0, strIntervalo    # $a0 = &strIntervalo
        li $v0, 4               # Escrever strings
        syscall                 # prinf(strIntervalo)
        move $a0, $t4           # $a0 = chaveK
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(chaveK)
        la $a0, strIntervalo2   # $a0 = &strIntervalo2
        li $v0, 4               # Escrever strings
        syscall                 # prinf(strIntervalo2)
        move $a0, $t5           # $a0 = 2*chaveK
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(chaveK)
        la $a0, fechaPar        # $a0 = &fechaPar
        li $v0, 4               # Escrever strings
        syscall                 # prinf(fechaPar)
        la $a0, barraN          # $a0 = &barraN
        li $v0, 4               # Escrever strings
        syscall                 # prinf(barraN)

    lIntervalo:
        # $t6 = vetor[i]
        lw $t6, ($t1)           # $t6 = $t1

        # Verifica se está no intervalo (k, 2k)
        ble $t6, $t4, liit      # if(vetor[i] <= chaveK): goto liit
        bge $t6, $t5, liit      # if(vetor[i] >= 2*chaveK): goto liit

        # Printf("%d ", vetor[i]);
        lw $a0, ($t1)           # $a0 = vetor[i]
        li $v0, 1               # Escrever inteiros1
        syscall                 # printf(vetor[i])
        li $a0, 32              # Código ASCII para espaço
        li $v0, 11              # Escrever caractere
        syscall                 # printf(" ")

        addi $t3, $t3, 1        # soma++

    liit:
        # i++
        add $t1, $t1, 4         # &vetor[i + 1]
        addi $t2, $t2, 1        # i++

        blt $t2, 12, lIntervalo # if(i < 12): goto lIntervalo

        # Mostra o total
        la $a0, total           # $a0 = total
        li $v0, 4               # Escrever strings
        syscall                 # prinf(total)
        move $a0, $t3           # $a0 = soma
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(soma)

        # Return &vetor;
        move $v0, $t0           # $v0 = &vetor
        jr $ra                  # Retorna para a main

# Verifica quantos números iguais a chave K há no vetor
iguais:
    # $t0 = &vet
    move $t0, $a0               # $t0 = $a0
    # $t1 = &vetor[i]
    move $t1, $t0               # $t1 = $t0
    # $t2 = i
    li $t2, 0                   # $t2 = 0
    # $t3 = soma
    addi $t3, $zero, 0          # $t3 = 0
    
    # Lê uma chave 
    la $a0, chaveInteira        # $a0 = &chaveInteira
    li $v0, 4                   # Escrever strings
    syscall                     # prinf(chaveInteira)
    li $v0, 5                   # Ler inteiros
    syscall                     # scanf(vetor[i])

    # $t4 = chaveK
    move $t4, $v0               # $t4 = $v0 (valor lido)
    
    lIguais:
        # $t5 = vetor[i]
        lw $t5, ($t1)           # $t5 = $t1

        # Verifica se o número é igual à chave K
        bne $t5, $t4, liig      # if(vetor[i] != chaveK): goto liig

        addi $t3, $t3, 1        # soma++

    liig:
        # i++
        add $t1, $t1, 4         # &vetor[i + 1]
        addi $t2, $t2, 1        # i++

        blt $t2, 12, lIguais    # if(i < 12): goto lIguais

        # printf("Total de repetições do número (%d): %d\n", chaveK, soma)
        la $a0, totalRepeticoes # $a0 = totalRepeticoes
        li $v0, 4               # Escrever strings
        syscall                 # prinf(totalRepeticoes)
        move $a0, $t4           # $a0 = chaveK
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(chaveK)
        la $a0, fechaPar        # $a0 = fechaPar
        li $v0, 4               # Escrever strings
        syscall                 # prinf(fechaPar)
        move $a0, $t3           # $a0 = soma
        li $v0, 1               # Escrever inteiros
        syscall                 # prinf(soma)
        la $a0, barraN          # $a0 = barraN
        li $v0, 4               # Escrever strings
        syscall                 # prinf(barraN)

        # Return &vetor;
        move $v0, $t0           # $v0 = &vetor
        jr $ra                  # Retorna para a main

# Calcula a soma dos números perfeitos e números semiprimos
perfeitosPrimos:
    # $s0 = &vet
    move $s0, $a0                               # $s0 = $a0
    # $s1 = &vetor[i]
    move $s1, $s0                               # $s1 = $s0
    # $s2 = i
    li $s2, 0                                   # $s2 = 0
    # $s3 = somaPerfeitos
    addi $s3, $zero, 0                          # $s3 = 0
    # $s4 = somaSemiprimos
    addi $s4, $zero, 0                          # $s4 = 0        
    
    # Loop principal
    loopPp:
        # $s7 = vetor[i]
        lw $s7, ($s1)                           # $s7 = $s1

        # *********************************************************
        # Verifica se o número é perfeito
        lpp:    
            # Verifica se é menor que 1
            ble $s7, 1, lps                     # if(vetor[i] <= 1): goto lps

            # $t0 = somaMultiplos (todo número é multiplo de 1)
            addi $t0, $zero, 1                  # $t0 = 1
            # $t1 = multiploAtual
            sub $t1, $s7, 1                     # $t1 = vetor[i] - 1
            
            # Loop principal dos perfeitos
            lPerfeitos:
                blt $t1, 2, veSoma              # if(multiploAtual < 2): goto veSoma

                # Verifica se é multiplo
                div $s7, $t1                    # vetor[i] / multiploAtual
                # $t2 = vetor[i] % multiploAtual
                mfhi $t2                        # $t2 = vetor[i] % multiploAtual

                bne $t2, $zero, dPerf           # if(vetor[i] % multiploAtual != 0): goto dPerf
                add $t0, $t0, $t1               # somaMultiplos += multiploAtual

                # Vai para a verificação de semiprimos
                blt $s7, $t0, lps               # if(vetor[i] < somaMultiplos): goto lps

                # Decrementa o multiploAtual para o loop principal dos perfeitos
                dPerf:
                    subi $t1, $t1, 1            # multiploAtual--
                    j lPerfeitos                # goto lPerfeitos

            # Fim do loop principal dos perfeitos
            veSoma:
                # Vai para a verificação de semiprimos
                bne $s7, $t0, lps               # if(vetor[i] != somaMultiplos): goto lps

                add $s3, $s3, $s7               # somaPerfeitos += vetor[i]

                # printf("\nPerfeito: %d", vetor[i])
                la $a0, ehPerfeito              # $a0 = &ehPerfeito
                li $v0, 4                       # Escrever strings
                syscall                         # prinf(ehPerfeito)
                move $a0, $s7                   # $a0 = vetor[i]
                li $v0, 1                       # Escrever inteiros
                syscall                         # prinf(vetor[i])

        # *********************************************************
        # Verifica se o número é semiprimo
        lps:
            # $t0 = |vetor[i]|
            add $t0, $s7, $zero                 # $t0 = $s7

            bge $t0, 0, lsa                     # if(vetor[i] >= 0): goto lsa
            mul $t0, $t0, -1                    # vetor[i] *= -1

        lsa:
            # $t1 = multiploSemiprimo
            sub $t1, $t0, 1                     # $t1 = vetor[i] - 1

            # Loop principal dos Semiprimos
            lSemprimos:
                # Se acabou o loop e não achou primos
                blt $t1, 2, lppi                # if(multiploSemiprimo < 2): goto lppi

                # Verifica se é multiplo
                div $t0, $t1                    # |vetor[i]| / multiploSemiprimo
                
                # $t2 = |vetor[i]| % multiploSemiprimo
                mfhi $t2                        # $t2 = |vetor[i]| % multiploSemiprimo

                bne $t2, $zero, dSemPr          # if(|vetor[i]| % multiploSemiprimo != 0): goto dSemPr
                
                # *********************************************************
                # Verifica se esse multiplo é primo

                # $t3 = multiploPrimo
                sub $t3, $t1, 1                 # $t3 = multiploSemiprimo - 1
                
                # Loop principal dos primos
                lPrimos:
                    blt $t3, 2, ehPrimo         # if(multiploPrimo < 2): goto ehPrimo

                    # Verifica se é multiplo
                    div $s7, $t1                # multiploSemiprimo / multiploPrimo
                    # $t4 = multiploSemiprimo % multiploPrimo
                    mfhi $t4                    # $t4 = multiploSemiprimo % multiploPrimo

                    # Não é primo
                    beq $t4, $zero, dSemPr      # if(multiploSemiprimo % multiploPrimo == 0): goto dSemPr
                    
                    subi $t3, $t3, 1            # multiploPrimo--
                    j lPrimos                   # goto lPrimos
                
                # **********************************************************
                # Verifica se o coeficiente é primo
                ehPrimo:
                    div $t0, $t1                # |vetor[i]| / multiploSemiprimo
                    # coeficiente = |vetor[i]| / multiploSemiprimo
                    mflo $t4                    # $t4 = |vetor[i]| / multiploSemiprimo

                    # $t3 = multiploPrimo
                    sub $t3, $t4, 1             # $t3 = coeficiente - 1
                    
                    # Loop principal dos primos2
                    lPrimos2:
                        blt $t3, 2, ehSemiPrimo # if(multiploPrimo < 2): goto ehSemiPrimo

                        # Verifica se é multiplo
                        div $t4, $t3            # coeficiente / multiploPrimo
                        # $t5 = coeficiente % multiploPrimo
                        mfhi $t5                # $t5 = multiploSemiprimo % multiploPrimo

                        # Não é primo
                        beq $t5, $zero, dSemPr  # if(multiploSemiprimo % multiploPrimo == 0): goto dSemPr
                        
                        subi $t3, $t3, 1        # multiploPrimo--
                        j lPrimos2              # goto lPrimos2


            # **********************************************************
            # Decrementa o multiploSemiprimo
            dSemPr:
                subi $t1, $t1, 1                # multiploSemiprimo--
                j lSemprimos                    # goto lSemprimos    

            ehSemiPrimo:
                add $s4, $s4, $s7               # somaSemiprimos += vetor[i]

                la $a0, strEhsemiPrimo          # $a0 = &strEhsemiPrimo
                li $v0, 4                       # Escrever strings
                syscall                         # prinf(strEhsemiPrimo)
                move $a0, $s7                   # $a0 = vetor[i]
                li $v0, 1                       # Escrever inteiros
                syscall    

    # *********************************************************
    # Fim do loop principal
    lppi:
        # i++
        add $s1, $s1, 4                         # &vetor[i + 1]
        addi $s2, $s2, 1                        # i++

        blt $s2, 12, loopPp                     # if(i < 12): goto loopPp

        # printf("Soma dos númmeros perfeitos: %d", somaPerfeitos)
        la $a0, strSomaPerfeitos                # $a0 = strSomaPerfeitos
        li $v0, 4                               # Escrever strings
        syscall                                 # prinf(strSomaPerfeitos)
        move $a0, $s3                           # $a0 = somaPerfeitos
        li $v0, 1                               # Escrever inteiros
        syscall                                 # prinf(somaPerfeitos)

        # printf("\nSoma dos númmeros semiprimos: %d\n", somaPrimos)
        la $a0, strSomaPrimos                   # $a0 = strSomaPrimos
        li $v0, 4                               # Escrever strings
        syscall                                 # prinf(strSomaPrimos)
        move $a0, $s4                           # $a0 = somaSemiprimos
        li $v0, 1                               # Escrever inteiros
        syscall                                 # prinf(somaSemiprimos)

        sub $t0, $s3, $s4                       # $t0 = somaPerfeitos - somaSemiprimos
        
        # printf("\n=>Perfeitos - Semiprimos = %d", somaPerfeitos - somaPrimos)
        la $a0, strPerfPrimo                    # $a0 = strPerfPrimo
        li $v0, 4                               # Escrever strings
        syscall                                 # prinf(strPerfPrimo)
        move $a0, $t0                           # $a0 = somaPerfeitos - somaSemiprimos
        li $v0, 1                               # Escrever inteiros
        syscall                                 # prinf(somaPerfeitos - somaSemiprimos)

        # Return &vetor;
        move $v0, $t0                           # $v0 = &vetor
        jr $ra                                  # Retorna para a main
    