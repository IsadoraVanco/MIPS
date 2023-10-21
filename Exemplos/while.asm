# Código C:
# while (save[i] == k){
#     i += 1;
# } 

# Supondo que i está associado a $s3, k a $s5 e que o endereço 
# de save está em $s6 qual é o código compilado para a 
# instrução while em C?
# ************************************************************

.data
save: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
string: .asciiz "\nDigite um valor: "
stringErro: .asciiz "\nUfa! Número diferente do esperado"
stringSucesso: .asciiz "\nUau! Você acertou todos!"

.text
.globl main
main:
    # $s1 = tamanho de save
    addi $s1, $zero, 10

    # $s3 = i
    addi $s3, $zero, 0

    # $s6 = ponteiro para save
    la $s6, save

    loop:
        # $s5 = k 
        jal leValor #Lê um valor  
        add $s5, $zero, $v0
        
        sll $t0, $s3, 2 # $t0 = 4 * i
        add $t0, $t0, $s6 # $t0 += &save[i]
        lw $t1, 0($t0) # $t1 = *save[i]

        bne $s5, $t1, errou # if(k != save[i]): errou
        addi $s3, $s3, 1 # i++
        beq $s3, $s1, sucesso # if(i == tamanho de save): sucesso

        j loop # Volta para o loop

leValor:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, string
    syscall # Print(string)

    # Configura o syscall para ler inteiros
    li $v0, 5 
    syscall # O número lido vai ficar em v0
    jr $ra # Volta para depois da chamada da função

errou:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, stringErro
    syscall # Print(stringErro)
    j exit # Vai para exit

sucesso:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, stringSucesso
    syscall # Print(stringSucesso)
    j exit # Vai para exit

exit: