#ifndef __KALLOC_H
#define __KALLOC_H

#include "types.h"

void*           kalloc(void);
void            kfree(void *);
void            kinit(void);
uint64          freemem_amount(void);
uint64          get_allocated_pages(void);
void            incref_page(uint64 pa);
int             get_page_ref(uint64 pa);

#endif