The OS takes a physical resource (such as the processor, or memory, or a disk) and transforms it into a more general, powerful, and easy-to-use **virtual form** of itself. Thus, we sometimes refer to the operating system as a **virtual machine**.

## Limited Direct Execution

直接执行：程序直接在cpu上执行，OS做的事情是：在`process list`中创建一个条目 -> 分配内存 -> 将程序代码和相关数据加载到内存中 -> 设置栈清空寄存器 -> `call main()` -> 接下来交给程序运行`main()`并返回 -> 再交给OS清空内存并从`process list`中删除条目。