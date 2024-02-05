# Atividade 02 - MIPS

Créditos ao prof° Fábio Martins, autor dos exercícios.

1. Escreva um programa, em código MIPS, que dado um inteiro positivo n, verificar se n é um inteiro perfeito. Um inteiro positivo n é perfeito se for igual à soma de seus divisores positivos diferentes de n. Exemplo: 6 é perfeito, pois 1+2+3 = 6. Enviar o código fonte comentado e testado no MARS.

2. Escreva os programas abaixo, utilizando procedimentos, em código MIPS. O código deve comentado e testado no MARS. Enviar o código fonte.
```
#include <stdio.h>

int squares [64];

void storeValues (int n) {
    int i;
    for(i = 0; i < n ; i++) {
        squares [i] = i * i;
    }
}

int computeSum(int n) {
    int i, sum;
    sum = 0;
    for (i = 0; i < n ; i++){
        sum += squares [i];
    }
    return sum;
}

int main () {
    int upTo;
    scanf ("%d" &upTo) ;
    storeValues(upTo);
    printf("sum = %d\n", computeSum (upTo));
    return 0;
}

```

