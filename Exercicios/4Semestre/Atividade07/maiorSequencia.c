/**
 * @brief Encontra a maior sequencia de um vetor (auxilio para o MIPS)
*/

#include <stdio.h>
#include <stdlib.h>

void lerVetor(double *vetor, int tamanho){
    for(int i = 0; i < tamanho; i++){
        printf("[%d]: ", i);
        scanf("%lf", &vetor[i]);
    }
}

void encontraMaiorSequencia(double *vetor, int tamanho){
    double primeiro = vetor[0];
    double segundo = vetor[0];
    double somaMaior = vetor[0];

    for(int i = 0; i < tamanho; i++){
        double soma = vetor[i];

        for(int j = i + 1; j < tamanho; j++){
            soma += vetor[j];

            if(soma > somaMaior){
                somaMaior = soma;
                primeiro = vetor[i];
                segundo = vetor[j];
            }
        }
    }

    printf("-> Maior soma: %.2lf\n", somaMaior);
    printf("-> Intervalo [%.2lf, %.2lf]\n", primeiro, segundo);
}

int main(int argc, char const *argv[])
{
    double *vetor;
    int tamanho = 0;

    while(tamanho <= 0){
        printf("=> Digite a quantidade de elementos do vetor: ");
        scanf("%d", &tamanho);
    }

    vetor = malloc(sizeof(double) * tamanho);

    lerVetor(vetor, tamanho);

    encontraMaiorSequencia(vetor, tamanho);

    return 0;
}