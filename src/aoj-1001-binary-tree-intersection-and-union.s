// Created by Ayush Biswas at 2025/09/13 10:47
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1001
        .global     _main
        .text

BTree:
        btree.left  = 0
        btree.right = 8
        btree.size  = 16

_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

read$op:        .asciz  "%s"
read$tree:      .asciz  "%s"
endl:           .asciz  "\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.operation  = -8
        solve.tree1      = -16
        solve.tree2      = -24

        mov     x0, #2
        bl      _malloc
        str     x0, [fp, solve.operation]
        str     x0, [sp]
        adr     x0, read$op
        bl      _scanf

        // check for eof
        ldr     x0, [fp, solve.operation]
        ldrb    w5, [x0]
        mov     x0, #69
        cbz     w5, eof

        bl      _read_tree
        str     x0, [fp, solve.tree1]
        bl      _read_tree
        str     x0, [fp, solve.tree2]

        ldr     x0, [fp, solve.tree1]
        ldr     x1, [fp, solve.tree2]

        ldr     x2, [fp, solve.operation]
        ldrb    w2, [x2]
        cmp     w2, 'i'
        beq     intersection$solve
        bl      _btree_union
        b       union$solve    
intersection$solve:
        bl      _btree_interesection
union$solve:
        bl      _print_tree
        adr     x0, endl
        bl      _printf

        mov     x0, #0
eof:
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

/*
function btree_union
        takes union of two binary trees
*/
_btree_union:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        union.a         .req x19
        union.b         .req x20
        union.res       .req x21
        // check if any of them is non-zero
        mov     xzr, union.res
        cbnz    x0, do_union
        cbnz    x1, do_union
        b       done_union

do_union:
        // x0 = x0 ? x0 : x1, x1 = x1 ? x1 : x0
        cmp     x0, #0
        csel    x0, x0, x1, ne
        cmp     x1, #0
        csel    x1, x1, x0, ne
        // if both are same then just return first one
        cmp     x0, x1   
        beq     done_union

        // save arguments in non-volatile reg
        mov     union.a, x0
        mov     union.b, x1

        bl      _new_tree
        mov     union.res, x0
        // union of left subtree
        ldr     x0, [union.a, btree.left]
        ldr     x1, [union.b, btree.left]
        bl      _btree_union
        str     x0, [union.res, btree.left]
        // union of right subtree
        ldr     x0, [union.a, btree.right]
        ldr     x1, [union.b, btree.right]
        bl      _btree_union
        str     x0, [union.res, btree.right]

        mov     x0, union.res
done_union:

        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

/*
function btree_intersection
        takes intersection of two binary trees
*/
_btree_interesection:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        
        intersection.a   .req x19
        intersection.b   .req x20
        intersection.res .req x21
        // check if any of them is null
        mov     intersection.res, xzr
        cbz     x0, done_intersection
        cbz     x1, done_intersection
        // save args in non-volatile reg
        mov     intersection.a, x0
        mov     intersection.b, x1

        bl      _new_tree
        mov     intersection.res, x0
        // intersection of left subtree
        ldr     x0, [intersection.a, btree.left]
        ldr     x1, [intersection.b, btree.left]
        bl      _btree_interesection
        str     x0, [intersection.res, btree.left]
        // intersection of right subtree
        ldr     x0, [intersection.a, btree.right]
        ldr     x1, [intersection.b, btree.right]
        bl      _btree_interesection
        str     x0, [intersection.res, btree.right]
        // return the result in x0
done_intersection:
        mov     x0, intersection.res

        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret


/*
function read_tree
        reads a binary tree string from stdin
        returns btree
*/
_read_tree:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #16

        read_tree.tree_string = -8
        // read the tree string
        mov     x0, #302
        bl      _malloc
        str     x0, [fp, read_tree.tree_string]
        str     x0, [sp]
        adr     x0, read$tree
        bl      _scanf
        // build the tree
        ldr     x0, [fp, read_tree.tree_string]
        add     x0, x0, #1
        bl      _build_tree

        add     sp, sp, #16
        ldp     fp, lr, [sp], #16
        ret

/*
function build_tree
        builds a tree recursively from given string
        returns btree and unprocessed string
*/
_build_tree:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!

        build_tree.string .req x19
        build_tree.tree   .req x20
        
        mov     build_tree.string, x0

        bl      _new_tree
        mov     build_tree.tree, x0

//      read left subtree
        ldrb    w0, [build_tree.string]
        cmp     w0, '('
        bne     left_node_done
        add     x0, build_tree.string, #1
        bl      _build_tree
        str     x0, [build_tree.tree, btree.left]
        mov     build_tree.string, x1
left_node_done:
//      read right subtree
        ldrb    w0, [build_tree.string, #1]! // consider ',' in middle
        cmp     w0, '('
        bne     right_node_done
        add     x0, build_tree.string, #1
        bl      _build_tree
        str     x0, [build_tree.tree, btree.right]
        mov     build_tree.string, x1
right_node_done:
        add     x1, build_tree.string, #1  // return rest of the tree in x1
        mov     x0, build_tree.tree // return current node in x0

        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret


print$char:     .asciz  "%c"
                .align  2

/*
function print_tree
        takes a btree and print it on stdout in bracket notation
*/
_print_tree:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        sub     sp, sp, #16

        cbz     x0, null_tree

        mov     x19, x0
        // start current subtree
        mov     w1, '('
        strb    w1, [sp]
        adr     x0, print$char
        bl      _printf
        // print the left subtree
        ldr     x0, [x19, btree.left]
        bl      _print_tree
        // print comma marking mid point
        mov     w1, ','
        strb    w1, [sp]
        adr     x0, print$char
        bl      _printf
        // print the right subtree
        ldr     x0, [x19, btree.right]
        bl      _print_tree
        // close the subtree
        mov     w1, ')'
        strb    w1, [sp]
        adr     x0, print$char
        bl      _printf

null_tree:
        add     sp, sp, #16
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

/*
function new_tree
        allocates memory for btree and initializes 
        left and right subtree to null
*/
_new_tree:
        stp     fp, lr, [sp, #-16]!

        mov     x0, btree.size
        bl      _malloc

        str     xzr, [x0, btree.left]
        str     xzr, [x0, btree.right]

        ldp     fp, lr, [sp], #16
        ret