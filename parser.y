%{
     #include "all.h"
     #include <stdio.h>
     extern int yylex (void);
     void yyerror (const char *msg);

     typedef struct nary_node * YYSTYPE;
     static YYSTYPE stmtmerge(YYSTYPE x0, YYSTYPE x1);
     static YYSTYPE stmtmerge2(YYSTYPE x0, YYSTYPE x1);

     struct nary_node *root;

     //for easy dot-code generation
     int arridx_cnt = 0, id_cnt = 0;
     int paro_cnt = 0, parc_cnt = 0, n_cnt = 0;
     int ass_cnt = 0, ambig_cnt = 0, eq_cnt = 0;
     int prog_cnt = 0, expr_cnt = 0, start_cnt = 0;
     int decl_cnt = 0, plus_cnt = 0, fcall_cnt = 0;
     int decla_cnt = 0, t_cnt = 0, i_cnt = 0;
%}

%define api.value.type { struct nary_node * }

%start start
%right '='

%debug

%glr-parser

%%

start: prog { root = make_node(start_cnt++, START, NULL, 1, $1); }
;

prog: assignment ';'
{ $$ = make_node(prog_cnt++, PROG, NULL, 1, $1); }
| prog assignment ';'
{ $$ = make_node(prog_cnt++, PROG, NULL, 2, $1, $2); }
;

assignment: 'I' '=' expression
{ $$ = make_node(ass_cnt++, ASSIGN, NULL, 3,
                 make_node(id_cnt++, I, NULL, 0),
                 make_node(eq_cnt++, EQ, NULL, 0), $3); }
;

expression: function_call
{ $$ = make_node(expr_cnt++, EXPR, NULL, 1, $1); }
%merge <stmtmerge2>
| array_indexing
{ $$ = make_node(expr_cnt++, EXPR, NULL, 1, $1); }
%merge <stmtmerge2>
| 'N'
{ $$ = make_node(n_cnt++, N, NULL, 0); }
;

function_call: 'I' '(' expression ')'
{ $$ = make_node(fcall_cnt++, FCALL, NULL, 4,
                 make_node(id_cnt++, I, NULL, 0),
                 make_node(paro_cnt++, PARO, NULL, 0),
                 $3,
                 make_node(parc_cnt++, PARC, NULL, 0)); }
| 'I'
{ $$ = make_node(fcall_cnt++, FCALL, NULL, 1,
                 make_node(id_cnt++, I, NULL, 0)); }
;

array_indexing: function_call '(' expression ')'
{ $$ = make_node(arridx_cnt++, ARRIDX, NULL, 4, $1,
                 make_node(paro_cnt++, PARO, NULL, 0),
                 $3,
                 make_node(parc_cnt++, PARC, NULL, 0)); }
%merge <stmtmerge>
| 'I' '(' expression ')'
{ $$ = make_node(arridx_cnt++, ARRIDX, NULL, 4,
                 make_node(id_cnt++, I, NULL, 0),
                 make_node(paro_cnt++, PARO, NULL, 0),
                 $3,
                 make_node(parc_cnt++, PARC, NULL, 0)); }
%merge <stmtmerge>
;


%%

static YYSTYPE stmtmerge2(YYSTYPE x0, YYSTYPE x1){
     return make_node(expr_cnt++, EXPR, NULL, 1,
                      make_node(ambig_cnt++, AMBIG, NULL, 2, x0, x1));
}

static YYSTYPE stmtmerge(YYSTYPE x0, YYSTYPE x1){
     return make_node(arridx_cnt++, ARRIDX, NULL, 1,
                      make_node(ambig_cnt++, AMBIG, NULL, 2, x0, x1));
}

void yyerror (const char* foo){
     fprintf(stderr, "FNORD!\n");
}

int main(void){
     yyparse();

     generate_dot(root);
     return 0;
}
