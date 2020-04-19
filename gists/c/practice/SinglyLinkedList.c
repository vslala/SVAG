#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Node {
	char* item;
	struct Node* next;
};

struct Node* headNode;

void add(char* item) {
	if (NULL == headNode) {
		headNode = malloc(sizeof(struct Node));
		headNode->item = item;
	} else {
		struct Node* newNode = malloc(sizeof(struct Node));
		newNode->item = item;
		
		struct Node* itr = headNode;
		while (itr->next != NULL) {
			itr = itr->next;
		}
		
		itr->next = newNode;
	}
}

void printItems() {
	struct Node* itr = headNode;
	while (itr != NULL) {
		printf("%s\n", itr->item);
		itr = itr->next;
	}
}

int main() {
	add("Varun");
	add("Vaibhav");
	add("Mummy");
	add("Papa");
	
	printItems();
}







