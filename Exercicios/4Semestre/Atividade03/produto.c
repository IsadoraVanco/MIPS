/**
 * @brief Multiplicação de uma matriz por um vetor
*/
#include <stdio.h>

// Número de linhas da matriz resultante e da matriz A
#define LINHA 4
// Número de colunas da matriz resultante e da matriz B
#define COLUNA 1
// Número de colunas da matriz A e linhas da matriz B
#define TAMANHO 3

void leMatriz(int matriz[][TAMANHO], int linhas, int colunas){
    for(int i = 0; i < linhas; i++){
        for(int j = 0; j < colunas; j++){
            printf("Insira o valor de Mat[%d][%d]: ", i, j);
            scanf("%d", &matriz[i][j]);
        }
    }
}

void leVetor(int vetor[], int elementos){
    for(int i = 0; i < elementos; i++){
        printf("Insira o valor de Vetor[%d]: ", i);
        scanf("%d", &vetor[i]);
    }
}

void escreveMatriz(int matriz[][TAMANHO], int linhas, int colunas){
    for(int i = 0; i < linhas; i++) {
        for(int j = 0; j < colunas; j++) {
            printf("%d ", matriz[i][j]);
        }
        printf("\n");
    }
}

void multiplica(int matriz[][TAMANHO], int vetor[], int matrizMultiplicada[][COLUNA]){

    for(int i = 0; i < LINHA; i++){
        for(int j = 0; j < COLUNA; j++){
            int somaElemento = 0;

            for(int e = 0; e < TAMANHO; e++){
                somaElemento += matriz[i][e] * vetor[e];
            }

            matrizMultiplicada[i][j] = somaElemento;
        }
    }
}

int main(int argc, char const *argv[])
{
    int matriz[LINHA][TAMANHO];
    int vetor[TAMANHO];
    int matrizMultiplicada[LINHA][COLUNA];

    leMatriz(matriz, LINHA, TAMANHO);  
    leVetor(vetor, TAMANHO);  

    printf("Matriz:\n");
    escreveMatriz(matriz, LINHA, TAMANHO);

    printf("Vetor:\n");
    for(int i = 0; i < TAMANHO; i++){
        printf("%d ", vetor[i]);
    }
    printf("\n");

    multiplica(matriz, vetor, matrizMultiplicada);

    printf("Matriz Multiplicada:\n");
    for(int i = 0; i < LINHA; i++){
        for(int j = 0; j < COLUNA; j++){
            printf("%d ", matrizMultiplicada[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    return 0;
}
