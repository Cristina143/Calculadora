%{
#include "y.tab.h"
%}

%option noyywrap

%%

[0-9]+                          { yylval = atoi(yytext); return NUMERO; }
[-+*/\|\%\(\)\n]                { return *yytext; }
[<]                          	{ return STR_SHIFT_LEFT; }
[_]                          	{ return SQRT; }
[\^]                            { return STR_POW; }
[ \t]                           ;
=                               { return EQUAL; }
.                               ;

%%