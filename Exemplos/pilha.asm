# Compilando um procedimento em C que não chama outro procedimento
# int exemploFolha(int g, int h, int i, int j)
# {
#    int f =(g+h) – (i+j);
#    return f;
# }

# As variáveis de parâmetro g, h, i e j correspondem aos registradores 
# $a0, $a1, $a2 e $a3, e f corresponde a $s0 (desta forma devemos salvar 
# $s0 na pilha). Resultado em $v0.
.data 
string: .asciiz "\nDigite um valor: "
valorFinal: .asciiz "\nO valor final é "
stringt0: .asciiz "\nO valor de t0 é "
stringt1: .asciiz "\nO valor de t1 é "
strings0: .asciiz "\nO valor de s0 é "

.text
.globl main
main:

    # $s1 = g
    jal leValor #Lê um valor  
    add $s1, $zero, $v0
    
    # $s2 = h
    jal leValor #Lê um valor  
    add $s2, $zero, $v0

    # $s3 = i
    jal leValor #Lê um valor  
    add $s3, $zero, $v0

    # $s4 = j
    jal leValor #Lê um valor  
    add $s4, $zero, $v0

    # Configura os parametros para passar para função
    add $a0, $zero, $s1 #$a0 = g
    add $a1, $zero, $s2 #$a1 = h
    add $a2, $zero, $s3 #$a2 = i
    add $a3, $zero, $s4 #$a0 = j
    jal exemploFolha

    # Restaura o valor restornado em $v0
    add $s5, $zero, $v0
    
    j exit

leValor:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, string
    syscall # Print(string)

    # Configura o syscall para ler inteiros
    li $v0, 5 
    syscall # O número lido vai ficar em v0
    jr $ra # Volta para depois da chamada da função

exemploFolha:
    # Para exemplificar, vamos definir valores para os registradores
    addi $s0, $zero, 33 # $s0 = f
    addi $t0, $zero, 44
    addi $t1, $zero, 55

    # Cria um espaço para três itens na pilha (3 * 4bytes)
    # E guarda os valores atuais na pilha
    # OBS: $sp é o stack pointer (ponteiro da pilha de chamada)
    addi $sp, $sp, -12 
    sw $t1, 8($sp) # pilha[2] = $t1 (g + h)
    sw $t0, 4($sp) # pilha[1] = $t0 (i + j)
    sw $s0, 0($sp) # pilha[2] = $s0 (resultado)

    add $t0, $a0, $a1 # $t0 = (g + h)
    add $t1, $a2, $a3 # $t1 = (i + j)
    sub $s0, $t0, $t1 # f = (g + h) - (i + j)

    add $v0,$s0,$zero # $v0 = f (para retornar)
    
    # Restaura os valores anteriores
    lw $s0, 0($sp) # $s0 = pilha[0]
    lw $t0,4($sp) # $t0 = pilha[1]
    lw $t1,8($sp) # $t1 = pilha[2]

    addi $sp, $sp, 12 # Volta o ponteiro da pilha para o inicio 
    jr $ra # Volta para onde chamou a função

exit:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, valorFinal
    syscall # Print(valorFinal)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s5
    syscall # Print(resultado)

    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, stringt0
    syscall # Print(stringt0)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $t0
    syscall # Print(t0)

    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, stringt1
    syscall # Print(stringt1)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $t1
    syscall # Print(t1)

     # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, strings0
    syscall # Print(strings0)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s0
    syscall # Print(s0)