/**
 * @brief Verificando matrizes iguais
*/

#include <stdio.h>

#define TAMANHO 4

void lerMatrizQuadrada(int matriz[][TAMANHO]){
    for(int i = 0; i < TAMANHO; i++){
        for(int j = 0; j < TAMANHO; j++){
            printf("[%d][%d]: ", i, j);
            scanf("%d", matriz[i][j]);
        }
    }
}

void comparaIguais(int matrizA[][TAMANHO], int matrizB[][TAMANHO]){
    int iguais = 0;
    int total = 0;
    
    for(int i = 0; i < TAMANHO; i++){
        for(int j = 0; j < TAMANHO; j++){
            if(matrizA[i][j] == matrizB[i][j]){
                iguais++;
                total += i + j;
            }
        }
    }

    printf("Elementos iguais em posições iguais: %d\n", iguais);
    printf("Soma das linhas e colunas iguais: %d\n", total);
}

int main(int argc, char const *argv[])
{
    int matrizA[TAMANHO][TAMANHO];
    int matrizB[TAMANHO][TAMANHO];
    
    printf("=> Lendo matriz A:");
    lerMatrizQuadrada(matrizA);
    printf("=> Lendo matriz B:");
    lerMatrizQuadrada(matrizB);

    comparaIguais(matrizA, matrizB);

    return 0;
}
