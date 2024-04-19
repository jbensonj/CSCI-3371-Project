.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
array DWORD 10, 21, 5, 3, 8, 7, 19, 25, 13, 1

.code
main PROC
    mov esi, OFFSET array          ; Pointer to the array
    mov eax, LENGTHOF array        ; Number of elements in the array
    push eax                       ; Push number of elements onto stack
    push esi                       ; Push base address of array onto stack
    call QuickSort                 ; Call the QuickSort procedure
    add esp, 8                     ; Clean up the stack
    invoke ExitProcess, 0          ; Exit the process cleanly
main ENDP

QuickSort PROC
    push ebp              ;save stack frame
    mov ebp, esp          ;save stack pointer
    push ebx              ;save ebx
    push esi              ;save esi
    push edi              ;save edi
    mov esi, [ebp + 8]    ;pointer to OFFSET array
    mov eax, [ebp + 12]   ;pointer to LENGTHOF array
    mov ecx, TYPE esi     ;SIZEOF element in array
    mul ecx               ;multiply LENGTHOF array by SIZEOF an element
    mov ecx, eax          ;temp store of end of array in ecx
    mov eax, 0            ;eax will be our referance to the first element
    mov ebx, ecx          ;ebx will be our referance to the last element
   
    call RecursiveCall
       
    pop edi         ;restore edi
    pop esi         ;restore esi
    pop ebx         ;restore ebx
    pop ebp         ;restore ebp

    ret
QuickSort ENDP

RecursiveCall:
    cmp eax, ebx
    jge EndRecursion        ;exit recursion if partition is size of 1
   
    push eax                ;save eax as lower index
    push ebx                ;save ebx as higher index
    mov edi, [esi+eax]      ;edi will be our pivot which will just be the first element in the partition
   
    Partition:

        IncreaseLoop:
            add eax, TYPE esi
            cmp eax, ebx
            jge EndIncreaseLoop     ;if lowerIndex is greater than higherIndex meaning lowerIndex and higherIndex are pointing to same location (prepare to swap)
           
            cmp [esi+eax], edi
            jge EndIncreaseLoop     ;if lowerIndexValue is greater or equal to the pivotValue (prepare to swap)
           
            jmp IncreaseLoop        ;if none of these have happened we keep searching array for one of these cases

        EndIncreaseLoop:
            DecreaseLoop:
                sub ebx, TYPE esi
                cmp [esi+ebx], edi
                jle EndDecreaseLoop      ;if higherIndexValue is less than pivotValue (prepare to swap)
           
                jmp DecreaseLoop         ;if this condition isnt met keep searching array for a value higher than pivot

            EndDecreaseLoop:
                cmp eax, ebx
                jge EndPartition        ;if lowerIndex and higherIndex are pointing to the same memory location
       
                ;else swap higherIndexValue with lowerIndexValue
                push [esi+eax]
                push [esi+ebx]
                pop [esi+eax]
                pop [esi+ebx]
       
                jmp Partition           ;Partition loop through whole partition until lowerIndex == higherIndex
                
    EndPartition:       
        pop edi         ;store the higher index into edi
        pop ecx         ;store lower index into ecx
        cmp ecx, ebx    ;if lowerIndex and higherIndex point to the same element dont swap
        je EndSwap
   
        ;else swap higherIndexValue with lowerIndexValue
        push [esi+ecx]
        push [esi+ebx]
        pop [esi+ecx]
        pop [esi+ebx]
       
    EndSwap:
        mov eax, ecx        ;move lowerIndex back to eax and prepare to recursivly partitioning array
        push edi            ;save end of array
        push ebx            ;save start of lower partition
        sub ebx, TYPE esi   ;end of lower parition
        
        call RecursiveCall  ;QuickSort(array, low index, j-1) left partition
   
        pop eax             ;get start of upper partition
        add eax, TYPE esi   ;split array into upper partition
        pop ebx             ;end of upper partition
        
        call RecursiveCall  ;QuickSort(array, j+1, high index) right partition
   
EndRecursion:
ret              ;return to main

END main
