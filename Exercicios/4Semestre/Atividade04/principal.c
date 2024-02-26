/**
 * @brief Verifica a diagonal principal da matriz
*/

#include <stdio.h>

#define TAMANHO 4

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
    int somaSuperior = 0;
    int somaInferior = 0;
    int maior = matriz[0][1];
    int menor = matriz[1][0];

    for(int i = 0; i < TAMANHO; i++){
        for(int j = 0; j < TAMANHO; j++){
            if(j > i){
                somaSuperior += matriz[i][j];
                
                if(matriz[i][j] > maior){
                    maior = matriz[i][j];
                }
            }else if(j < i){
                somaInferior += matriz[i][j];

                if(matriz[i][j] < menor){
                    menor = matriz[i][j];
                }
            }
        }
    }

    printf("\n=> Soma dos superiores - soma dos inferiores: %d\n", somaSuperior - somaInferior);
    printf("=> Maior elemento acima da diagonal principal: %d\n", maior);
    printf("=> Menor elemento abaixo da diagonal principal: %d\n", menor);
}

void ordenaMatriz(int matriz[][TAMANHO]){
    //bubble => um pouco lento

    int temp;
    for (int i = 0; i < TAMANHO * TAMANHO - 1; i++) {
        for (int j = 0; j < TAMANHO * TAMANHO - i - 1; j++) {
            if (matriz[j / TAMANHO][j % TAMANHO] > matriz[(j + 1) / TAMANHO][(j + 1) % TAMANHO]) {
                temp = matriz[j / TAMANHO][j % TAMANHO];
                matriz[j / TAMANHO][j % TAMANHO] = matriz[(j + 1) / TAMANHO][(j + 1) % TAMANHO];
                matriz[(j + 1) / TAMANHO][(j + 1) % TAMANHO] = temp;
            }
        }
    }
}

int main(int argc, char const *argv[])
{
    int matrizA[TAMANHO][TAMANHO];
    
    printf("=> Lendo matriz A:");
    lerMatrizQuadrada(matrizA);

    printf("=> Matriz lida:\n");
    escreverMatrizQuadrada(matrizA);

    somaDiagonal(matrizA);

    ordenaMatriz(matrizA);

    printf("=> Matriz ordenada:\n");
    escreverMatrizQuadrada(matrizA);

    return 0;
}
