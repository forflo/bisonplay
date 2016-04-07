#ifndef NARY_TREE
#define NARY_TREE

struct nary_node {
	void *content; //pointer to the content
    int node_type;
    char name[20];
	struct nary_node **nodes; //array of pointers to child nodes
	int leaf; //1 if leaf 0 if node. If leaf = 0 => nnode > 0
	int nnode; //number of following childnodes 
};

void generate_dot(struct nary_node *root);

struct nary_node *new_node(void *content);
int add_node(struct nary_node *parent, void *child_content);
int free_node(struct nary_node *node);
int add_child(struct nary_node *parent, struct nary_node *child);
int destroy_tree(struct nary_node *tree);
struct nary_node *clone_node(struct nary_node *original);

int traverse_preorder(struct nary_node *node, 
        int (*callback)(void *c, void *u), 
        void *userparam);
int traverse_postorder(struct nary_node *node, 
	    int (*callback)(void *c, void *u), 
        void *u);

#endif /* NARY_TREE */

#include <stdlib.h>
#include <stdio.h>

#include <string.h>
#ifndef PARSER_UTIL
#define PARSER_UTIL

#include <stdarg.h>

/* Variadic convenience functionlfor syntax tree generation 
	Param: operation = The use of the node e.g. an if node would have
			P_OP_IF
		v = An valid pointer to an instance of struct value
		childs = The number of additional parameters
		... = The additional parameters have to be of type struct nary_node *
			These Pointers will be added to the generated node as childs in
			exactly the order they have been specified. 

	Return: Valid instance of struct nary_node or NULL if error occured 

	Example:
	-------
	The call make_node(P_OP_NOOP, NULL, a, b, c);
	generates a new node and adds a as his first child, b as
	his second and c as his last child. */
struct nary_node *make_node(int cnt, int operation, void *v, int childs, ...);

struct token_value { void *value; int length; };


#endif /* PARSER_UTIL */

#ifndef NODE_DEFINES
#define NODE_DEFINES

/* Generator Makro for automatic
   enum and string-table generation.
   This is also commonly known as X-Macro */
#define LIST_NTYPE(F)   \
    F(FCALL) \
    F(ASSIGN) \
    F(START) \
    F(ARRIDX) \
    F(PROG) \
    F(I) \
    F(EXPR) \
    F(AMBIG) \
    F(PARO)\
    F(PARC)\
    F(N) \
    F(EQ) \
    F(NUM)

#define GENERATE_STRING(X) #X,
#define GENERATE_ENUM(X) X,

/* Code for non Terminals */
enum node_types { LIST_NTYPE(GENERATE_ENUM) };

#endif /* NODE_DEFINES */

static const char *NODETYPE_STRING_TAB[] = { LIST_NTYPE(GENERATE_STRING) };
