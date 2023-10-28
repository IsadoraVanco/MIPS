# Slide 68
# Elaborar um programa em MIPS que tenha 
# como entrada o número de avaliações de 
# uma disciplina e forneça como saída a 
# média das notas.
.data 
stringQuantidade: .asciiz "\nDigite o número de notas para fazer a média: "
stringNotas: .asciiz "\nDigite uma nota: "
stringMedia: .asciiz "\nA média das notas é: "

.text 
.globl main
main:
    # Número de notas
    la $a0, stringQuantidade
    jal scan

    # $s0 = número de notas
    add $s0, $zero, $v0
    # $s1 = contador
    add $s1, $zero, $v0

    # $s2 = soma das notas
    add $s2, $zero, $zero

    loop:
        beq $s1, $zero, calculaResultado

        la $a0, stringNotas
        jal scan
        add $s2, $s2, $v0

        subi $s1, $s1, 1

        j loop
    
    calculaResultado:
        div $s2, $s0
        mflo $t0

        add $a0, $zero, $t0
        jal print

    j exit

scan:
    # A string será passada como argumento
    li $v0, 4 # Configura o syscall para escrever strings
    syscall # Print(string)

    li $v0, 5 # Configura o syscall para ler inteiros
    syscall # O número lido vai ficar em v0

    # Retornará o número lido
    jr $ra # Volta para depois da chamada da função

print:
    # O número será passado como argumento
    add $t0, $zero, $a0

    la $a0, stringMedia
    li $v0, 4 # Configura o syscall para escrever strings
    syscall # Print(string)

    add $a0, $zero, $t0
    li $v0, 1
    syscall
    
    jr $ra

exit:
    addiu $v0, $0, 10 # Configura para encerrar 
    syscall