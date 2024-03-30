/**
 * @brief Verificador de CPF (auxiliar do MIPS)
*/

#include <stdio.h>
#include <stdbool.h>

bool ehDigito(char *digito){

    // de 0 a 9
    if(*digito < 48 || *digito > 57) {
        return false;
    }

    return true;
}

bool ehFormatoCPF(char *cpf){

    // Verifica se todos os caracteres são dígitos
    // E se o CPF tem está no formato 123456789-XX
    for (int i = 0; i < 9; ++i) {
        if(!ehDigito(&cpf[i])){
            // printf("-> Digito %c incorreto\n", cpf[i]);
            return false;
        }
    }

    // Melhor doq fazer verificação toda vez no loop :)
    if(cpf[9] != '-'){
        // printf("-> Digito %c incorreto\n", cpf[9]);
        return false;
    }

    for(int i = 10; i < 12; i++){
        if(!ehDigito(&cpf[i])){
            // printf("-> Digito %c incorreto\n", cpf[i]);
            return false;
        }
    }

    return true;
}

bool ehValido(char *cpf) {

    if(!ehFormatoCPF(cpf)){
        printf("-> Não está no formato correto!\n");
        return false;
    }

    printf("-> Está no formato correto!\n");
    
    // Calcula o primeiro dígito verificador
    int soma = 0;
    for(int i = 0; i < 9; i++){
        soma += (cpf[i] - '0') * (10 - i);
    }

    // int primeiroDigito = (soma * 10) % 11;
    int resto = soma % 11;
    int primeiroDigito;

    if(resto < 2){
        primeiroDigito = 0;
    }else{
        primeiroDigito = 11 - resto;
    }

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 9; i++) {
        soma += (cpf[i] - '0') * (11 - i);
    }

    soma += (cpf[10] - '0') * 2;

    // int segundoDigito = (soma * 10) % 11;
    resto = soma % 11;
    int segundoDigito;

    if(resto < 2){
        segundoDigito = 0;
    }else{
        segundoDigito = 11 - resto;
    }

    printf("-> Dígitos verificadores: %d%d\n", primeiroDigito, segundoDigito);

    // Verifica se os dígitos verificadores são iguais aos do CPF
    return (primeiroDigito == (cpf[10] - '0')) && (segundoDigito == (cpf[11] - '0'));
}

int main() {
    char cpf[15];

    printf("=> Digite o CPF (123456789-XX): ");
    scanf("%s", cpf);    

    if(ehValido(cpf)){
        printf("-> CPF válido!\n");
    }else{
        printf("-> CPF inválido!\n");
    }

    return 0;
}
