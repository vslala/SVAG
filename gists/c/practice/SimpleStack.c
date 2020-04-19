#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Node {
	char* item;
	struct Node* next;
};

struct Node* headNode;

void push(char* item) {
	if (headNode == NULL) {
		headNode = malloc(sizeof(struct Node));
		headNode->item = item;
	} else {
		struct Node* newNode = malloc(sizeof(struct Node));
		newNode->item = item;
		newNode->next = headNode;
		headNode = newNode;
	}
}

char* pop() {
	headNode = headNode->next;
	return headNode->item;
}

void printItems() {
       	struct Node* itr = headNode;
	while (itr != NULL) {
		printf("%s\n", itr->item);
		itr = itr->next;
	}
}

int main() {
	push("Varun");
	push("Vaibhav");
	push("Mummy");
	push("Papa");
	printItems();
	
	pop();
	pop();
	printItems();
	
}
