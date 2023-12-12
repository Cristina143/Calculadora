%{
int yylex();
int yy_scan_string();
int yyerror(const char *message){return 0;};
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
extern FILE *yyin;
%}

%token NUMERO
%token SQRT
%token STR_POW
%token STR_SHIFT_LEFT
%token EQUAL

%%

linea : expresion EQUAL { printf("%d\n", $1); }

expresion : expresion '+' termino               { $$ = $1 + $3; }
          | expresion '-' termino               { $$ = $1 - $3; }
          | termino
          ;

termino : termino '*' factor                  { $$ = $1 * $3; }
        | termino '/' factor                  { $$ = $1 / $3; }
        | termino '%' factor                  { $$ = $1 % $3; }
        | termino STR_SHIFT_LEFT factor       { $$ = $1 << $3; }
        | factor
        ;                                                               

factor : NUMERO
       | '-' factor                             { $$ = -$2; }
       | '(' expresion ')'                      { $$ = $2; }
       | '|' expresion '|'                      { $$ = abs($2); }
       | SQRT '(' expresion ')'                 { $$ = sqrt($3); }
       | NUMERO STR_POW factor                  { $$ = pow($1, $3); }
       ;

%%

int yywrap(void) {
    return 1;
}

int main() {

      FILE *lectura;
    lectura = fopen("num", "r");

    if (!lectura) {
        perror("Error al abrir el archivo");
        return 1;
    }

 char renglon[100];
    FILE *tempFile = fopen("tempfile.txt", "w");

    if (!tempFile) {
        perror("Error al abrir el archivo temporal");
        fclose(lectura);
 return 1;
    }

    while (fgets(renglon, sizeof(renglon), lectura) != NULL) {
        printf("%s", renglon);

        // Escribe la l  nea en el archivo temporal
        fprintf(tempFile, "%s", renglon);

        // Cierra y vuelve a abrir el archivo temporal en modo de lectura
        fclose(tempFile);
        tempFile = fopen("tempfile.txt", "r");

        if (!tempFile) {
            perror("Error al abrir el archivo temporal");
            fclose(lectura);
            return 1;
        }

        // Llama a yyparse() para analizar la entrada
        yyin = tempFile;
        yyparse();

        // Vuelve al modo de escritura para limpiar el archivo temporal
        fclose(tempFile);
 tempFile = fopen("tempfile.txt", "w");

        if (!tempFile) {
            perror("Error al abrir el archivo temporal");
            fclose(lectura);
            return 1;
        }
    }

    // Cierra los archivos
    fclose(lectura);
    fclose(tempFile);

    return 0;
}