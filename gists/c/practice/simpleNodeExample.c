#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Node {
    char item[156];
    struct Node *next;
};

int main() {
    
    struct Node *node1 = malloc(sizeof(struct Node));
    struct Node *node2 = malloc(sizeof(struct Node));
    
    strcpy(node1->item, "Varun");
    node1->next = node2;
    
    strcpy(node2->item, "Vaibhav");
    
    struct Node *itr = node1;
    
    while (itr != NULL) {
        printf("%s\n", itr->item);
        itr = itr->next;
    }
             
}
