# Atividade 01

Créditos ao prof° Wesley Attrot, autor do exercício.

Traduza o código a seguir para assembly de MIPS. Durante a tradução para assembly, as variáveis locais devem ser mapeadas para registradores $s0, $s1, .... A função int value() retorna um valor no registrador $v0 e não tem o seu código apresentado, bastando apenas ser chamada quando necessário
```
int value();

int func()
{
    int a,b,c;
    int r = -1;

    while(r == -1)
    {
        a = value();
        b = value();
        c = value();

        if((a<b+c) && (b<a+c) && (c<a+b))
        {
            if((a==b) && (b==c))
            {
                r = 0;
            }
            else
            {
                if((a==b) || (a==c) || (c==b))
                {
                    r = 1;
                }
                else
                {
                    r = 2;
                }
            }
        }
    }
    return r;
}
```
