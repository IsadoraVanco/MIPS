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