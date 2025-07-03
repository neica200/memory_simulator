.data
    memorie: .space 16777216
    n: .long 1024
    lungime: .long 0
    nr_operatii: .long 0
    operatie: .long 0
    descriptor: .long 0
    dimensiune: .long 0
    nr_operatii_add: .long 0
    initial1: .long 0
    final1: .long 0
    initial2: .long 0
    final2: .long 0
    nr_fisiere: .long 0
    fisiere_numarate: .long 0
    index_curent: .long 0
    i: .long 0
    j: .long 0
    ultimul_index_i: .long 0
    ultimul_index_j: .long 0
    lungime2: .long 0
    lungime3: .long 0
    inceput_de_sters: .long 0
    final_de_sters:.long 0
    fds: .long 0
    fstat:.space 512

    dinamica_1: .byte 0
    dinamica_2: .byte 0
    dinamica_3: .byte 0

    formatString: .asciz "%d\n"
    formatStringPrintAdd: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatStringPrintDelete: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatStringPrintGet: .asciz "((%d, %d), (%d, %d))\n"
    formatStringInt: .asciz "%d"
    formatStringPath: .asciz "%s"
    formatStringConcrete: .asciz  "(%d, %d) %d: ((%d, %d), (%d, %d))\n"
    stringPath: .space 10000
    formatRead:.asciz "r"
    copieStringPath: .space 10000

.text

.global main

main:
    /*initializare vector*/
    lea memorie, %edi
    movl $1048575, %ecx
    movl $0, i
    movl $0, j
initializare:
    movl $0, (%edi, %ecx, 4)
    decl %ecx
    cmp $0, %ecx
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
    cmpl $5,operatie
    je concrete

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

            movl $0, i
            movl $0, j
            movl $0, %ecx
            
            

            for_i_add:
                movl i,%ecx
                cmpl $1024, i
                je gresit
                movl i, %eax
                mull n 
                movl $0, j
                movl %ecx, initial1
                movl %ecx, initial2
                incl i 
                verificare:
                movl j, %ebx
                movl %ebx, final1
                movl dimensiune, %ebx
                
                for_j_add:
                    cmpl $1024,j
                    je for_i_add
                    movl (%edi, %eax,4), %edx
                    incl j 
                    incl %eax
                    cmpl $0,%edx
                    jne verificare
                    subl $8, %ebx
                    cmpl $8, %ebx
                    jle corect
                    jmp for_j_add

                
            corect:
                cmpl $1024,j
                je for_i_add
                movl (%edi, %eax,4), %edx
                cmpl $0, %edx
                jne verificare
                movl j, %edx
                movl %edx, final2

                push %eax
                push final2
                push initial2
                push final1
                push initial1
                push descriptor
                push $formatStringPrintAdd
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %eax

                movl final2,%ebx
                movl descriptor, %ecx
                
                loop_corect:
                    movl %ecx, (%edi,%eax,4)
                    decl %eax
                    decl %ebx
                    cmpl %ebx,final1
                    jne loop_corect
                     movl %ecx, (%edi,%eax,4)
                incl nr_fisiere
                jmp interior_add

             gresit:
                /*nu incape*/
                movl $0, initial1
                movl $0, final1
                movl $0,initial2
                movl $0,final2

                push final2
                push initial2
                push final1
                push initial1
                push descriptor
                push $formatStringPrintDelete
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx

                jmp interior_add




        

     get:
  
            push $descriptor
            push $formatStringInt
            call scanf
            pop %ebx
            pop %ebx

        movl $0,%eax
        movl $0,i
        movl $0,j
        movl descriptor,%ebx
         for_i_get:
                movl i,%ecx
                cmpl $1024, i
                je nu_exista
                movl $0, j
                movl i, %eax
                mull n 
                movl %ecx, initial1
                movl %ecx, initial2
                incl i
                for_j_get:
                    cmpl $1024,j
                    je for_i_get
                    cmpl %ebx, (%edi,%eax,4)
                    je gasit_get
                    incl %eax
                    incl j 
                    jmp for_j_get

                    gasit_get:
                    movl j, %ecx
                    movl %ecx,final1

                    loop_gasit_get:
                        cmpl %ebx, (%edi,%eax,4)
                        jne final_get
                        incl %eax
                        incl j
                        cmpl $1024,j
                        je final_get
                        jmp loop_gasit_get

                    final_get:
                        decl j

                        push j
                        push initial2
                        push final1
                        push initial1
                        push $formatStringPrintGet
                        call printf
                        pop %ebx
                        pop %ebx
                        pop %ebx
                        pop %ebx
                        pop %ebx

                        jmp et_citire_operatie

                nu_exista:
                    movl $0, initial1
                    movl $0,initial2
                    movl $0,final1
                    movl $0,final2

                        push final2
                        push initial2
                        push final1
                        push initial1
                        push $formatStringPrintGet
                        call printf
                        pop %ebx
                        pop %ebx
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

            movl $0, i
            movl $0,j 
            movl descriptor, %ebx
            movl $0,%eax
            for_i_delete:
                cmpl $1024, i
                je afisare_delete
                movl $0,j
                movl i, %eax
                mull n
                incl i
                for_j_delete:
                    cmpl $1024,j
                    je for_i_delete
                    cmpl %ebx, (%edi,%eax,4)
                    je sterge
                    incl %eax
                    incl j
                    jmp for_j_delete
                
                sterge:
                    movl $0,(%edi,%eax,4)
                    incl %eax
                    incl j
                    cmpl $1024,j 
                    je decrementare
                    cmpl %ebx,(%edi,%eax,4)
                    jne decrementare
                    jmp sterge
                
                decrementare:
                    decl nr_fisiere
                    jmp afisare_delete


            afisare_delete:
                movl $0,i
                for_i_afisare_delete:
                    cmpl $1024,i
                    je et_citire_operatie
                    movl $0,j
                    movl i,%eax
                    mull n
                    movl i, %ecx
                    movl %ecx, initial1
                    movl %ecx, initial2
                    incl i
                    decl %eax
                    decl j 
                    for_j_afisare_delete:
                        incl j 
                        incl %eax
                        cmpl $1024,j
                        je for_i_afisare_delete
                        cmpl $0,(%edi,%eax,4)
                        je for_j_afisare_delete
                        movl j, %edx
                        movl %edx,final1
                        movl (%edi,%eax,4),%edx

                        loop_afisare1:
                            incl %eax
                            incl j 
                            cmpl $1024,j
                            je print_delete
                            cmpl %edx, (%edi,%eax,4)
                            jne print_delete
                            jmp loop_afisare1
                        
                        print_delete:
                            decl j 
                            movl j,%ecx
                            movl %ecx, final2
                            decl %eax 
                           

                        
                            pushl %eax
                            pushl final2
                            pushl initial2
                            pushl final1
                            pushl initial1
                            pushl %edx
                            push $formatStringPrintDelete
                            call printf
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %eax

                            jmp for_j_afisare_delete

    defragmentation:
        /*de completat*/
        
       /* push $descriptor
            push $formatStringInt
            call printf
            pop %ebx
            pop %ebx*/
        movl $0,%eax
        movl $0,ultimul_index_i
        movl $0, ultimul_index_j
        /*calculez lungimea fisierului,verific daca pana la ultimul_index am spatiu si mut*/
        defrag_1:
            movl ultimul_index_i, %ecx
            movl %ecx,i
        for_i_defrag_cautare:
            cmpl $1024,i
            je afisare_defrag
            movl $0,j
            movl i,%eax
            mull n
            movl i,%ecx
            cmpl ultimul_index_i,%ecx
            je defrag_2
            incl i
            jmp for_j_defrag_cautare

            defrag_2:
                incl i
                movl ultimul_index_j,%ecx
                movl %ecx,j
                addl %ecx, %eax

            for_j_defrag_cautare:
                cmpl $1024,j
                je for_i_defrag_cautare
                movl (%edi,%eax,4),%edx
                movl %edx, descriptor
                cmpl $0,%edx
                jne calculare_lungime
                incl %eax
                incl j
                jmp for_j_defrag_cautare
            
                calculare_lungime:
                    movl j,%ecx
                    movl %ecx,initial1
                    movl %eax, inceput_de_sters
                    incl %eax
                    incl j 
                    loop_calculare_lungime:
                        cmpl $1024,j
                        je final_calcul 
                        movl (%edi,%eax,4),%ecx
                        cmpl %edx,%ecx
                        jne final_calcul
                        incl j 
                        incl %eax
                        jmp loop_calculare_lungime

                        final_calcul:
                            decl j
                            movl j,%ecx
                            movl %ecx,initial2
                            movl %eax, final_de_sters
                            subl initial1,%ecx
                            movl %ecx,lungime
                            incl lungime
                            jmp defrag

                            defrag:
                            movl ultimul_index_i,%ecx
                            movl %ecx, i
                            for_i_defrag:
                                movl $0,lungime3
                                movl $0,lungime2
                                movl i,%edx
                                movl %edx, final2
                                movl ultimul_index_i, %ecx
                                cmpl i,%ecx
                                jg defrag_1
                                movl i,%eax
                                movl ultimul_index_i, %ecx
                                mull n
                                movl $0,j
                                cmpl %ecx,i
                                je defrag_3
                                incl i
                                jmp for_j_defrag

                                defrag_3:
                                    movl ultimul_index_j,%ecx
                                    movl %ecx,j
                                    addl j,%eax
                                    incl i

                                for_j_defrag:
                                    cmpl $1024,j
                                    je for_i_defrag
                                    movl descriptor,%ecx
                                    cmpl %ecx,(%edi,%eax,4)
                                    je skip
                                    cmpl $0,(%edi,%eax,4)
                                    jne nu
                                    jmp skip_1
                                    skip:
                                    incl inceput_de_sters
                                    incl lungime3
                                    movl lungime3,%ecx
                                    cmpl %ecx,lungime
                                    je nu
                                    skip_1:
                                    incl lungime2
                                    movl lungime2,%ecx
                                    cmpl lungime,%ecx
                                    je gasit_defrag
                                    incl %eax
                                    incl j 
                                    jmp for_j_defrag

                                nu:
                                    movl initial2,%ecx
                                    movl %ecx, ultimul_index_j
                                    incl ultimul_index_j
                                    movl final2, %ecx
                                    movl %ecx, ultimul_index_i
                                    jmp defrag_1

                                gasit_defrag:
                                    decl i 
                                    movl i,%ecx
                                    movl %ecx,ultimul_index_i
                                    movl j,%ecx
                                    movl %ecx,ultimul_index_j
                                    incl ultimul_index_j
                                    loop_defrag_add:
                                        cmpl $0,lungime2
                                        je sterge_defrag
                                        movl descriptor, %ebx
                                        movl %ebx, (%edi,%eax,4)
                                        decl lungime2
                                        decl %eax
                                        jmp loop_defrag_add

                                    sterge_defrag:
                                    movl inceput_de_sters,%eax
                                    loop_sterge_defrag:
                                        cmpl %eax,final_de_sters
                                        je defrag_1
                                        movl $0,(%edi,%eax,4)
                                        incl %eax
                                        jmp loop_sterge_defrag

        afisare_defrag:
                movl $0,i
                for_i_afisare_defrag:
                    cmpl $1024,i
                    je et_citire_operatie
                    movl $0,j
                    movl i,%eax
                    mull n
                    movl i, %ecx
                    movl %ecx, initial1
                    movl %ecx, initial2
                    incl i
                    decl %eax
                    decl j 
                    for_j_afisare_defrag:
                        incl j 
                        incl %eax
                        cmpl $1024,j
                        je for_i_afisare_defrag
                        cmpl $0,(%edi,%eax,4)
                        je for_j_afisare_defrag
                        movl j, %edx
                        movl %edx,final1
                        movl (%edi,%eax,4),%edx

                        loop_afisare2:
                            incl %eax
                            incl j 
                            cmpl $1024,j
                            je print_defrag
                            cmpl %edx, (%edi,%eax,4)
                            jne print_defrag
                            jmp loop_afisare2
                        
                        print_defrag:
                            decl j 
                            movl j,%ecx
                            movl %ecx, final2
                            decl %eax 
                           

                        
                            pushl %eax
                            pushl final2
                            pushl initial2
                            pushl final1
                            pushl initial1
                            pushl %edx
                            push $formatStringPrintDelete
                            call printf
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %ebx
                            pop %eax

                            jmp for_j_afisare_defrag



concrete:
    movb $48, dinamica_1
    movb $49, dinamica_2
    movb $49,dinamica_3

    push $copieStringPath
    push $formatStringPath
    call scanf
    pop %ebx
    pop %ebx

    skip_initializare:
    lea copieStringPath, %edi
    lea stringPath, %esi
    copiere:
    mov (%edi), %al
    mov %al,(%esi)
    inc %edi
    inc %esi
    cmp $0,(%edi)
    je sterge_concrete
    jmp copiere

    sterge_concrete:
    cmp $0,(%esi)
    je start
    mov $0,(%esi)
    jmp sterge_concrete

    start:

    movl $0, %eax
    movl $0, %ebx
    lea stringPath, %edi
    concatenare:
        
        movb (%edi), %al 
        cmpb $0,%al
        je gasit_concat
        incl %edi
        jmp concatenare

        gasit_concat:
            movb $47, (%edi)
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $101,(%edi) /*e*/
            incl %edi
            movb $120,(%edi) /*x*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            cmpb $57,dinamica_1 
            je skip_dec
            movb dinamica_1,%cl
            movb %cl,(%edi) /*cifra unitatilor*/
            incl %edi
            movb $46,(%edi) /*.*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $120,(%edi) /*x*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $0, (%edi)
            jmp continuare
            skip_dec:
            cmpb $57,dinamica_2
            je skip_suta
            movb dinamica_2,%cl
            movb %cl,(%edi)
            incl %edi
            movb $48,dinamica_1
            movb dinamica_1,%cl
            movb %cl,(%edi) /*cifra unitatilor*/
            incl %edi
            movb $46,(%edi) /*.*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $120,(%edi) /*x*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $0, (%edi)
            jmp continuare
            skip_suta:
            movb dinamica_3,%cl
            movb %cl,(%edi)
            incl %edi
            movb $48, dinamica_2
            movb dinamica_2,%cl
            movb %cl,(%edi)
            incl %edi
            movb $48,dinamica_1
            movb dinamica_1,%cl
            movb %cl,(%edi) /*cifra unitatilor*/
            incl %edi
            movb $46,(%edi) /*.*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $120,(%edi) /*x*/
            incl %edi
            movb $116,(%edi) /*t*/
            incl %edi
            movb $0,(%edi)
            jmp continuare

continuare:
    pt_test_1:
    lea stringPath,%edi

    movl $5,%eax
    lea stringPath, %ebx
    movl $0,%ecx
    movl $0, %edx
    int $0x80
    
    cmp $0,%eax
    jle et_citire_operatie

    

    movl %eax, fds

    movl $255,%ecx
    movl $0, %edx
    div %ecx
    incl %edx
    movl %edx, descriptor        

    movl $108, %eax
    movl fds, %ebx
    lea fstat, %ecx
    int $0x80

    lea fstat, %edi

    movl $0,%edx
    movl $5,%ebx
    movl (%edi,%ebx,4),%eax
    movl $1024, %ecx
    divl %ecx
    movl %eax, dimensiune

    incl dinamica_1

    /*verific intai daca exista deja acest descrpitor*/
    movl $0, %eax
    movl $0, %ebx
    movl $0, %ecx
    movl $0, %edx
    movl $0,i
    movl $0,j 
    lea memorie, %edi
    for_i_verificare:
        movl i,%ecx
        cmpl $1024, i
        je bun
        movl i, %eax
        mull n 
        movl $0, j
        incl i
                for_j_verificare:
                    cmpl $1024,j
                    je for_i_verificare
                    movl (%edi, %eax,4), %edx
                    incl j 
                    incl %eax
                    cmpl descriptor,%edx
                    je gresit_concrete
                    jmp for_j_verificare

    /*efectiv add*/
    bun:
    movl $0, %eax
    movl $0, %ebx
    movl $0, %ecx
    movl $0, %edx
    movl $0,i
    movl $0,j 
    lea memorie, %edi
    for_i_add_concrete:
                movl i,%ecx
                cmpl $1024, i
                je gresit_concrete
                movl i, %eax
                mull n 
                movl $0, j
                movl %ecx, initial1
                movl %ecx, initial2
                incl i 
                verificare_concrete:
                movl j, %ebx
                movl %ebx, final1
                movl dimensiune, %ebx
                
                for_j_add_concrete:
                    cmpl $1024,j
                    je for_i_add_concrete
                    movl (%edi, %eax,4), %edx
                    incl j 
                    incl %eax
                    cmpl $0,%edx
                    jne verificare_concrete
                    subl $8, %ebx
                    cmpl $8, %ebx
                    jle corect_concrete
                    jmp for_j_add_concrete

                
            corect_concrete:
                cmpl $1024,j
                je for_i_add_concrete
                movl (%edi, %eax,4), %edx
                cmpl $0, %edx
                jne verificare_concrete
                movl j, %edx
                movl %edx, final2

                push %eax
                push final2
                push initial2
                push final1
                push initial1
                push descriptor
                push dimensiune
                push descriptor
                push $formatStringConcrete
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %eax


                movl final2,%ebx
                movl descriptor, %ecx
                
                loop_corect_concrete:
                    movl %ecx, (%edi,%eax,4)
                    decl %eax
                    decl %ebx
                    cmpl %ebx,final1
                    jne loop_corect_concrete
                     movl %ecx, (%edi,%eax,4)
                incl nr_fisiere
                jmp skip_initializare

             gresit_concrete:
                /*nu incape*/
                movl $0, initial1
                movl $0, final1
                movl $0,initial2
                movl $0,final2

                push final2
                push initial2
                push final1
                push initial1
                push descriptor
                push dimensiune
                push descriptor
                push $formatStringConcrete
                call printf
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx
                pop %ebx

                jmp skip_initializare




        
et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

.section .note.GNU-stack,"",@progbits