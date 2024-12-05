#include <stdio.h>
int main(){
    int current_value = 10;
    int add_per_loop = 20;
    int target = 50;
    int loop_counter = 1;
    do {
	
	printf("%d %d %d %d\n",current_value, add_per_loop, target, loop_counter);
        current_value += add_per_loop;
        loop_counter += 1;

    } while(current_value != target);
    
    printf("%d %d %d %d\n",current_value, add_per_loop, target, loop_counter);
}

