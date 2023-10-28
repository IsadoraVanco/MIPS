# Slide 54
# int fact (int n){
#   if (n < 1) return f;
# else return n * fact(n - 1);
# }

.data
stringScan: .asciiz "\nDigite um número: "
stringResultado: .asciiz "\nO fatorial do número é "

.text
.globl main
main:
    # Leitura de um número
    
    # $s0 = n
    jal leValor 
    add $s0, $zero, $v0 

    # Chama o fatorial recursivo
    add $a0, $zero, $s0 
    jal fact
    # $s1 = n!
    add $s1, $zero, $v0

    # Mostra o resultado
    add $a0, $zero, $s1
    jal print

    j exit
fact:
    # O número n é passado por argumento $a0
    # Salva as informações na pilha

    addi $sp, $sp, -8 # ajusta a pilha para 2 itens (4 bytes)
    sw $ra, 4($sp) # salva o endereço de retorno
    sw $a0,0($sp) # salva o argumento n
    
    slti $t0, $a0, 1 # if(n < 1){$t0 = 1: $t0 = 0}
    beq $t0,$zero, casoRecursivo # if($t0 == 0): casoRecursivo
    # Caso base (n == 0)
    addi $v0, $zero, 1 # return 1
    addi $sp, $sp, 8 # retira 2 itens da pilha
    jr $ra # retorna para onde a função foi chamada

    casoRecursivo: # n >= 1
        addi $a0, $a0, -1 # n--

        jal fact # Vai para a função com n-1

        # Restaura as informações da pilha
        lw $a0, 0($sp) # retorna de jal: restaura o argumento n
        lw $ra, 4($sp) # restaura o endereço de retorno
        addi $sp, $sp, 8 # ajusta stack pointer para retirar 2 itens

        mul $v0, $a0, $v0 # retorna n*fact(n-1)
        jr $ra # retorna para o procedimento que chamou

leValor:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, stringScan # Configura o argumento da função
    syscall # Print(valor)

    li $v0, 5 # Configura o syscall para ler inteiros
    syscall # O número lido vai ficar em v0

    jr $ra # Volta para depois da chamada da função

print: 
    # O número será passado pelo argumento $a0
    add $t0, $zero, $a0

    la $a0, stringResultado
    li $v0, 4 
    syscall # Print(stringResultado)

    add $a0, $zero, $t0
    li $v0, 1 
    syscall # Print($a0)

    jr $ra # Volta para depois da chamada da função

exit: 