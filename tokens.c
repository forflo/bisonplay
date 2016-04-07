#include <stdio.h>

int yylex(void){
     static int counter = 0;
     static int tokens[] = {
          (int) 'I', (int) '=',
          (int) 'I', (int) '(', (int) 'N', (int) ')', (int) ';',
     };

     return tokens[counter++];
}
