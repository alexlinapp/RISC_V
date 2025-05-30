// addi x1, x0, 5
// addi x2, x0, -1
// beq x1, x0, FIRST
// addi x8, x0, 1
// FIRST:
// bge x1, x2, SECOND
// addi x8, x8, 2
// SECOND:
// bgeu x1, x2, THIRD
// addi x8, x8, 4
// THIRD:
