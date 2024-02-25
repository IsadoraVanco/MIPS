/**
 * @brief Soma os valores da diagonal secundária
*/

#include <stdio.h>

#define TAMANHO 3

void lerMatrizQuadrada(int matriz[][TAMANHO]){
    for(int i = 0; i < TAMANHO; i++){
        for(int j = 0; j < TAMANHO; j++){
            printf("[%d][%d]: ", i, j);
            scanf("%d", &matriz[i][j]);
        }
    }
}

void escreverMatrizQuadrada(int matriz[][TAMANHO]){
    for(int i = 0; i < TAMANHO; i++){
        for(int j = 0; j < TAMANHO; j++){
            printf("%d ", matriz[i][j]);
        }
        printf("\n");
    }
}

void somaDiagonal(int matriz[][TAMANHO]){
    int soma = 0;

    // for(int i = 0; i < TAMANHO; i++){
    //     for(int j = 0; j < TAMANHO; j++){
    //         if(i + j == TAMANHO - 1){
    //             soma += matriz[i][j];
    //         }
    //     }
    // }

    // Ou simplesmente
    int j = TAMANHO - 1;

    for(int i = 0; i < TAMANHO; i++){
        soma += matriz[i][j];
        j--;
    }

    printf("=> Soma da diagonal secundária: %d\n", soma);
}

int main(int argc, char const *argv[])
{
    int matrizA[TAMANHO][TAMANHO];
    
    printf("=> Lendo matriz A:");
    lerMatrizQuadrada(matrizA);

    printf("=> Matriz lida:\n");
    escreverMatrizQuadrada(matrizA);

    somaDiagonal(matrizA);

    return 0;
}
