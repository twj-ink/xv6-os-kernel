#if defined(SCHEDULER_RR) || defined(SCHEDULER_PRIORITY) || defined(SCHEDULER_MLFQ)
#include "test.h"

#define MAX_LINES 100
#define MAX_LENGTH 256
#define TEST_CASES 3
#define MAX_PROCESSES 5

int scores[TEST_CASES] = {0, 0, 0};
int expected_order[TEST_CASES][MAX_PROCESSES] = {
    {3,2,1},
    {1,2,3},
    {2,0,0,0,1},
};

int expected_order_length[TEST_CASES] = {3,3,5};

const char* prefix[TEST_CASES] = {
    "RR Scheduler Process",
    "Priority Scheduler Process",
    "MLFQ Scheduler Process",
};

typedef struct priorities{
    int id;
    int origin_priority;
    int finish_priority;
} priorities;

priorities mlfq_info[MAX_PROCESSES];

int simple_strcmp(const char* s1, const char* s2, int n) {
    for (int i = 0; i < n; i++) {
        if (s1[i] != s2[i]) return 1;
        if (s1[i] == '\0') return 1;
    }
    return 0;
}

int extract_id(const char* str, const int max_length) {
    const char* pattern = "Process ";
    int pattern_len = strlen(pattern);
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
            const char* num_start = &str[i + pattern_len];
            int id = 0;
            
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
}

int extract_origin_priority(const char* str, const int max_length) {
    const char* pattern = "initial priority ";
    int pattern_len = strlen(pattern);
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
            const char* num_start = &str[i + pattern_len];
            int id = 0;
            
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
}

int extract_final_priority(const char* str, const int max_length) {
    const char* pattern = "final priority ";
    int pattern_len = strlen(pattern);
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
            const char* num_start = &str[i + pattern_len];
            int id = 0;
            
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
}

int check_completion_order(const char* prefix, const char* output, const int* expected_order, int order_length) {
    int ids[MAX_PROCESSES];
    int count = 0;
    const char* pattern = prefix;
    int prefix_len = strlen(prefix);
    
    for (int i = 0; output[i] != '\0'; i++) {
        if (simple_strcmp(&output[i], pattern, prefix_len) == 0) {
            const char* completed_ptr = &output[i];
            while (*completed_ptr != '\0') {
                if (simple_strcmp(completed_ptr, "completed", strlen("completed")) == 0) {
                    int len = completed_ptr - &output[i];
                    int id = extract_id(&output[i], len);
                    int initial_prio = extract_origin_priority(&output[i], len);
                    int final_prio = extract_final_priority(&output[i], len);
                    if (id >= 0 && count <= MAX_PROCESSES) {
                        ids[count] = id;
                    }
                    if (initial_prio != -1 && final_prio != -1) {
                        mlfq_info[count].id = id;
                        mlfq_info[count].origin_priority = initial_prio;
                        mlfq_info[count].finish_priority = final_prio;
                    }
                    count++;
                    break;
                }
                completed_ptr++;
            }
        }
    }

    if (count != order_length) {
        return 0;
    }

    for (int i = 0; i < order_length; i++) {
        if (expected_order[i] !=0 && ids[i] != expected_order[i]) {
            return 0;
        }
    }
    
    return 1;
}

int test_mlfq_priority_change() {
    for (int i = 0; i < MAX_PROCESSES; i++) {
        priorities res = mlfq_info[i];
        if (res.id <= 0 || res.id > MAX_PROCESSES) {
            return 0;
        }
        if (res.origin_priority < 0 || res.finish_priority < 0) {
            return 0;
        }
        switch (res.id) {
            case 1:
            case 3:
                if (res.finish_priority <= res.origin_priority) {
                    printf("FAILED: CPU-intensive process %d should have a lower priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
                    return 0;
                }
                printf("CPU-intensive process %d have a lower priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
                break;
            case 4:
                if (res.finish_priority >= res.origin_priority) {
                    printf("FAILED: I/O-intensive process %d should have a higher priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
                    return 0;
                }
                printf("I/O-intensive process %d have a higher priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
                break;
            case 2:
            case 5:
                break;
        }
    }
    return 1;
}

int main(int argc, char* argv[]) {
    printf("Judger: Starting evaluation\n");
    int score = 0;
    
    if (argc == 3) {
        // Test finish order
        char* program_name = argv[1];
        char* output = argv[2];
        int index = -1;
        int need_check_priority_change = 0;
        printf("Test%s output:\n%s\n", program_name, output);
        switch (program_name[0]) {
            case '1': // rr
                index = 0;
                break;
            case '2': // priority
                index = 1;
                break;
            case '3': // mlfq
                index = 2;
                need_check_priority_change = 1;
                break;
        }
        printf("Expected order: ");
        for (int j = 0; j < MAX_PROCESSES; j++) {
            printf("%d ", expected_order[index][j]);
        }
        printf("\n");

        if (check_completion_order(prefix[index], output, expected_order[index], expected_order_length[index])) {
            if (!need_check_priority_change) {
                printf("Test%s PASSED\n", program_name);
                score = 1;
            } else {
                if (test_mlfq_priority_change() == 1) {
                    printf("Test%s PASSED priority_changes\n", program_name);
                    score = 1;
                } else {
                    printf("Test%s FAILED priority_changed\n", program_name);
                }
            }     
        } else {
            printf("Test%s FAILED\n", program_name);
        }
    } else {
        printf("Error: Not matched arguments\n");
    }
    
    printf("SCORE: %d\n", score);
    exit(0);
}
#endif

#if defined(TEST_COW) || defined(TEST_LAZY)

#include "test.h"

#define SIZE (1 << 12)  // 4KB (one page)
#define PGSIZE (1 << 12)

/*
* Desc:
* We test copy-on-write by forking a process and having both parent and child
* read from the same memory. Then we modify the memory in one process and check
* that the physical page count increases appropriately.
*
* Expected:
* After fork, physical page count should remain the same (shared pages).
* After writing to a page in either process, the page should be copied and
* the physical page count should increase by one.
*/

int main() {
    printf("Testing Copy-on-Write\n");
    
    // Get initial physical page count
    int initial_pages = getpgcnt();
    printf("Initial physical pages: %d\n", initial_pages);
    
    // Allocate and initialize a page
    char *mem = sbrk(SIZE);
    if (mem == (char*)-1) {
        printf("sbrk failed\n");
        exit(1);
    }
    
    int write_sum = 0;

    for (int i = 0; i < SIZE; i++) {
        mem[i] = i % 256;
        write_sum += mem[i];
    }
    
    int after_init_pages = getpgcnt();
    printf("Physical pages after initialization: %d (should be +1)\n", after_init_pages);
    
    if (after_init_pages != initial_pages + 1) {
        printf("ERROR: Expected %d pages, got %d\n", initial_pages + 1, after_init_pages);
        exit(1);
    }

    int sz = getprocsz();
    int delta_without_cow = 
        (sz / PGSIZE)   // copy allocated memory pages, in `uvmcopy`
        + 2             // mapping already allocated pages in user page table, in `uvmcopy`
        + 2             // mapping already allocated pages in kernel page table, in `uvmcopy`
        + 1             // user empty page table, in `allocproc`
        + 2             // mapping trampoline, in `proc_pagetable`
        + 1             // trapframe per proc, in `proc_pagetable`
        + 1             // kernel page table, in `proc_kpagetable`
        + 1 + 2         // kernel stack with mapping, in `proc_kpagetable`
        ;
    
    // Fork a process
    int pid = fork();
    if (pid < 0) {
        printf("fork failed\n");
        exit(1);
    }
    
    int after_fork_pages = getpgcnt();
    printf("Physical pages after fork: %d\n", after_fork_pages);
    
    if (after_fork_pages >= after_init_pages + delta_without_cow) {
        printf("ERROR: Page count changed too much from %d to %d after fork without write\n", after_init_pages, after_fork_pages);
    }
    
    if (pid == 0) {
        // Child process
        // Read from the shared page (should not trigger copy)
        int child_before_read = getpgcnt();
        printf("Physical pages before child read: %d\n", child_before_read);

        int sum = 0;
        for (int i = 0; i < SIZE; i++) {
            sum += mem[i];
        }
        printf("Child read sum: %d\n", sum);
        
        if (sum != write_sum) {
            printf("ERROR: Data corruption. Sum should be %d, but got %d\n", write_sum, sum);
            exit(2);
        }
        
        int child_after_read = getpgcnt();
        printf("Physical pages after child read: %d (should be same)\n", child_after_read);
        
        if (child_after_read != child_before_read) {
            printf("ERROR: Page count changed after read\n");
            exit(3);
        }
        
        // Write to the page (should trigger copy)
        mem[0] = 0xFF;
        int child_write_pages = getpgcnt();
        printf("Physical pages after child write: %d (should be increased)\n", child_write_pages);
        
        if (child_write_pages < after_fork_pages + 1) {
            printf("ERROR: Expected at least %d pages, got %d\n", after_fork_pages + 1, child_write_pages);
            exit(1);
        }
        
        exit(0);
    } else {
        // Parent process
        int status ;
        wait(&status);
        printf("wait status:%d\n", status);
        int before_write_pages = getpgcnt();
        
        // Check that parent's page is unchanged
        int sum = 0;
        for (int i = 0; i < SIZE; i++) {
            sum += mem[i];
        }
        printf("Parent read sum: %d\n", sum);

        if (sum != write_sum) {
            printf("ERROR: Data corruption. Sum should be %d, but got %d\n", write_sum, sum);
            exit(1);
        }
        
        int after_read_pages = getpgcnt();
        printf("Physical pages after child exit: %d (should be same as before read)\n", after_read_pages);
        
        if (after_read_pages != before_write_pages) {
            printf("ERROR: Expected %d pages, got %d\n", before_write_pages, after_read_pages);
            exit(1);
        }
        
        // Parent writes to the page (should not trigger copy as child is gone)
        mem[0] = 0xAA;
        int parent_write_pages = getpgcnt();
        printf("Physical pages after parent write: %d (should be same)\n", parent_write_pages);
        
        if (parent_write_pages != after_read_pages) {
            printf("ERROR: Page count changed after parent write\n");
            exit(1);
        }
    }
    
    printf("Copy-on-Write Test Completed Successfully\n");
    exit(0);
}
#endif