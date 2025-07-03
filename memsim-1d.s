.data
    memorie: .space 4096
    n: .long 1024
    lungime: .long 0
    nr_operatii: .long 0
    operatie: .long 0
    descriptor: .long 0
    dimensiune: .long 0
    nr_operatii_add: .long 0
    initial: .long 0
    final: .long 0
    nr_fisiere: .long 0
    fisiere_numarate: .long 0
    index_curent: .long 0
    formatStringInt: .asciz "%d"
    formatString: .asciz "%d\n"
    formatStringPrintAdd: .asciz "%d: (%d, %d)\n"
    formatStringPrintGet: .asciz "(%d, %d)\n"
.text

.global main

main:
    /*initializare vector*/
    lea memorie, %edi
    movl $1023, %ecx
initializare:
    movl $0, (%edi, %ecx, 4)
    dec %ecx
    cmp $0,%ecx
    jge initializare


citire_nr_operatii:
/*citire nr_operatii*/
    movl $0, nr_fisiere
    mov $0, %ecx
    lea memorie, %edi
    push $nr_operatii
    push $formatStringInt
    call scanf
    pop %ebx
    pop %ebx



et_citire_operatie:
    cmpl $0, nr_operatii
    je et_exit
    
    push $operatie
    push $formatStringInt
    call scanf
    pop %ebx
    pop %ebx

    decl nr_operatii

    cmpl $1, operatie
    je add
    cmpl $2, operatie
    je get
    cmpl $3, operatie
    je delete
    cmpl $4, operatie
    je defragmentation

    add:
        /*citire nr fisierelor care vor fi adaugate*/
        push $nr_operatii_add
        push $formatStringInt
        call scanf
        pop %ebx
        pop %ebx

        interior_add:
            cmpl $0, nr_operatii_add
            je et_citire_operatie
            decl nr_operatii_add

            /*citire descriptor*/
            push $descriptor
            push $formatStringInt
            call scanf
            pop %ebx
            pop %ebx

            /*citire dimensiune*/
            push $dimensiune
            push $formatStringInt
            call scanf
            pop %ebx
            pop %ebx 

            movl $0, %ecx

            /*verific sa nu se verifice id-ul*/
                loop_valid:
                    cmpl $1024, %ecx
                    je initializare_ecx
                    movl  (%edi,%ecx,4),%ebx
                    cmpl descriptor,%ebx
                    je gresit
                    incl %ecx
                    jmp loop_valid

                 /*verificare spatiu disponibil+cate casute am nevoie libere*/
                 initializare_ecx:
                 movl $0,%ecx
                 verificare:
                    
                    movl dimensiune, %eax
                    movl %ecx, initial
                    
                loop_verificare:
                    
                    movl (%edi, %ecx, 4), %edx
                    inc %ecx
                    cmpl $1024, %ecx
                    je gresit
                    cmpl $0, %edx
                    jne verificare
                    subl $8,%eax
                    cmpl $8, %eax
                    jle corect
                    jmp loop_verificare

            corect:
                movl (%edi, %ecx, 4),%ebx
                cmpl $0, %ebx
                jne verificare
                movl %ecx, final
                
                /*output*/
                push %ecx
                push final
                push initial
                push descriptor
                push $formatStringPrintAdd
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ecx
                
                /*introducere id in vector*/
                movl initial, %ecx
                movl descriptor, %edx
                incl final
                loop_corect:
                    movl %edx, (%edi, %ecx, 4)
                    incl %ecx
                    cmpl %ecx,final
                    jne loop_corect
                incl nr_fisiere    
                jmp interior_add

                gresit:
                /*nu incape*/
                movl $0, initial
                movl $0, final

                push final
                push initial
                push descriptor
                push $formatStringPrintAdd
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx

                jmp interior_add



    
    get:
        /*citire descriptor */
            push $descriptor
            push $formatStringInt
            call scanf
            pop %ebx
            pop %ebx
       
        /*cautare descriptor*/
        movl $0, %ecx
        movl descriptor, %edx
        loop_cautare_get:
            cmp $1024, %ecx
            je nu_exista
            cmpl %edx, (%edi,%ecx,4)
            je gasit_get
            inc %ecx
            jmp loop_cautare_get

        gasit_get:
            movl %ecx, initial

            loop_gasit_get:
                cmpl %edx, (%edi,%ecx,4)
                jne final_get
                incl %ecx
                jmp loop_gasit_get

            final_get:
                decl %ecx
                movl %ecx, final

                push final
                push initial
                push $formatStringPrintGet
                call printf
                pop %ebx
                pop %ebx
                pop %ebx

                jmp et_citire_operatie

        nu_exista:
            movl $0, initial
            movl $0, final

                push final
                push initial
                push $formatStringPrintGet
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
            
            jmp et_citire_operatie

    delete:
        /*citire descriptor */
            push $descriptor
            push $formatStringInt
            call scanf
            pop %ebx
            pop %ebx

        movl $0, %ecx
        movl descriptor, %edx
        /*cautare fisier*/
        loop_cautare_delete:
            cmp $1024, %ecx
            je afisare_delete
            cmpl %edx, (%edi,%ecx,4)
            je sterge
            incl %ecx
            jmp loop_cautare_delete

        sterge:
            movl $0, (%edi, %ecx,4)
            incl %ecx
            cmpl %edx, (%edi,%ecx,4)
            jne decrementare
            jmp sterge

        decrementare:
            decl nr_fisiere
            jmp afisare_delete


        afisare_delete:
            
            movl $-1,%ecx
            afisare2:
                incl %ecx
                cmpl $1024, %ecx
                je et_citire_operatie
                cmpl $0,(%edi,%ecx,4)
                je afisare2
                movl %ecx, initial
                movl (%edi,%ecx,4),%edx
                loop_afisare2:
                    incl %ecx
                    cmpl $1024,%ecx
                    je print_delete
                    cmpl %edx,(%edi,%ecx,4)
                    jne print_delete
                    jmp loop_afisare2
                print_delete:
                    decl %ecx
                    movl %ecx,final

                    push %ecx
                    push final
                    push initial
                    push %edx
                    push $formatStringPrintAdd
                    call printf
                    pop %ebx
                    pop %ebx
                    pop %ebx
                    pop %ebx
                    pop %ecx

                    jmp afisare2

    defragmentation:
    movl $0, %ecx
    movl $0, fisiere_numarate
    movl $0, index_curent

        defrag:
        cmpl $1022, %ecx
        je afisare_defrag
        movl nr_fisiere,%ebx
        cmpl fisiere_numarate,%ebx
        je afisare_defrag
        movl (%edi,%ecx,4),%ebx
        cmpl $0, %ebx
        je defrag2
        movl (%edi,%ecx,4),%ebx
        cmpl index_curent, %ebx 
        je sari
        jmp actualizare
        actualizare:
            incl fisiere_numarate
            movl %ebx, index_curent
        sari:
            incl %ecx
            jmp defrag

        
            defrag2:
                movl %ecx,%edx
                incl %edx
                movl %ecx, %eax
                loop_defrag:
                    cmpl $1024,%edx
                    je defrag
                    movl (%edi,%edx,4), %ebx
                    mov %ebx, (%edi,%eax,4)
                    movl $0, (%edi,%edx,4)
                    incl %eax
                    incl %edx
                    jmp loop_defrag
        afisare_defrag:
            movl $-1,%ecx
            afisare1:
                incl %ecx
                cmpl $0,(%edi,%ecx,4)
                je afisare1
                cmpl $1024, %ecx
                je et_citire_operatie
                movl %ecx, initial
                movl (%edi,%ecx,4),%edx
                loop_afisare1:
                    incl %ecx
                    cmpl %edx,(%edi,%ecx,4)
                    jne print_defrag
                    jmp loop_afisare1
                print_defrag:
                    decl %ecx
                    movl %ecx,final

                    push %ecx
                    push final
                    push initial
                    push %edx
                    push $formatStringPrintAdd
                    call printf
                    pop %ebx
                    pop %ebx
                    pop %ebx
                    pop %ebx
                    pop %ecx

                    jmp afisare1


et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

.section .note.GNU-stack,"",@progbits