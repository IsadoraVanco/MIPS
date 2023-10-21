# Código C: 
# if (i==j) {
#     f = g+h;
# } else {
#     f = g-h;
# }

# Supondo que as cinco variáveis de f a j correspondem aos 
# cinco registradores $s0 a $s4 qual é o código compilado 
# para a instrução if em C?
# **********************************************************

.data # Indica que dados serão guardados na memória
string: .asciiz "\nDigite um valor: "
valorFinal: .asciiz "\nO valor final é "

.text # Indica o início do código
.globl main # Indica o código da função global
main:

    # $s0 = f  
    add $s0, $zero, $zero

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

    bne $s3, $s4, else # if (i != j) : Else 
    add $s0, $s1, $s2 # f = g + h
    j exit # Vai para exit
    else:
        sub $s0, $s1, $s2 # f = g - h
        j exit # Vai para exit

leValor:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, string
    syscall # Print(string)

    # Configura o syscall para ler inteiros
    li $v0, 5 
    syscall # O número lido vai ficar em v0
    jr $ra # Volta para depois da chamada da função

exit:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, valorFinal
    syscall # Print(valorFinal)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s0
    syscall # Print(f)