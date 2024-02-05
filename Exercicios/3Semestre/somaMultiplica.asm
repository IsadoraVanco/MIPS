# Slide 66
# Elaborar um programa para carregar o valor 3 no 
# registrador $t0, o valor 4 no registrador $t1. 
# Some os dois valores e multiplique por 4 
# (resultado em $t3). Utilize a chamada de sistema exit 
# para finalizar.

.text 
.globl main
main:
    addi $t0, $zero, 3
    addi $t1, $zero, 4
    add $t3, $t0, $t1
    sll $t3, $t3, 2

exit:
    addiu $v0, $0, 10 # Configura para encerrar 
    syscall