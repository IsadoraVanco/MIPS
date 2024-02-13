/**
 * Base para o código MIPS
*/
#include <stdio.h>

#define TAMANHO_STRING 100

void leitura(char* texto, char* string){
    printf("%s", texto);
    scanf("%s", string);
}

void escrita(char* string){
    printf("%s", string);
}

void intercala(char* string1, char* string2, char* string3){
    int i = 0;
    int str1 = 0;
    int str2 = 0;

    for(int i = 0; i < 2 * TAMANHO_STRING; ){
        if(string1[str1] != '\0' && string1[str1] != '\n'){
            string3[i] = string1[str1];
            str1++;
            i++;
        }else{
            str1 = -1;
        }

        if(string2[str2] != '\0' && string2[str2] != '\n'){
            string3[i] = string2[str2];
            str2++;
            i++;
        }else{
            str2 = -1;
        }

        if(str1 == -1 && str2 == -1){
            string3[i] = '\0';
            break;
        }
    }
}

int main(int argc, char const *argv[])
{
    char str1[TAMANHO_STRING];
    char str2[TAMANHO_STRING];
    char str3[2 * TAMANHO_STRING];

    printf("1) Lendo as strings: ");
    leitura("Insira a string 1: ", str1);
    leitura("Insira a string 2: ", str2);

    intercala(str1, str2, str3);
    printf("\n2) String intercalada: ");
    escrita(str3);

    return 0;
}
