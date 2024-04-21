.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data
	array DWORD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	num DWORD 0

.code
main PROC
    push OFFSET array          ; push offset to the stack (4)      
    push LENGTHOF array        ; push lengthof to the stack (4)	 
    push num			       ; push num to the stack (4)
    call BinSort               ; push rtnadd to the stack (4) 
	add esp, 12                ; clean up the stack

	Invoke ExitProcess, 0        
main ENDP

BinSort PROC
    pushfd                         ; save all flags (4)
    push ebx                       ; save ebx to hold num (4)
    push esi                       ; hold offset for efficient access (4)
    push edi                       ; hold lengthof for efficient access(4)

    ; Check if the array is empty
    mov edi, [esp + 24]            ; mov lengthof to saved register
    cmp edi, 0
    je ArrayEmpty

    ; initializing values to begin search    
    jmp SetSearchBounds   

Search:
    cmp eax, ecx                   ; when L=R we are done searching.
    jz  DontSearch                 ; L=R, don't search 

    cmp edx, ebx                   ; compare Mid to num and if Mid is larger or equal, then num must be in lower partition            
    jge LowerSearch                ; 
    mov eax, edx                   ; Mid < num -> set L = Mid + 1
    inc eax
    jmp FindMid                     ; Continue looking in upper bin
LowerSearch:
    mov ecx, edx                   ; Mid >= num -> set R to Mid   
    jmp FindMid                     ; continue looking in lower bin

SetSearchBounds:
    mov ebx, [esp+20]              ; EBX will be num
    mov esi, [esp+28]              ; mov offset to a saved register
    mov eax, [esi]                 ; EAX will be L, intialize by moving array[0] into eax
    dec edi                        ; adjust lengthof for 0 based index
    mov ecx, [esi+edi*4]             ; ECX will be R, initialize by moving array[edi] into ecx 
    jmp FindMid

COMMENT!
I'm comparing values here and it works just fine since this is a sorted list. it avoids having to check the stack or keep track of indexes.
Maybe searching by indexers instead of by values would be more efficient, but I think it would depend on the array to be searched
ideas?
!

FindMid:
    mov edx, eax
    add edx, ecx                    ; L+R
    shr edx, 1                     ; (L+R)/2
    jmp Search
    
 
DontSearch:
    cmp eax, ebx                    ; EAX holds return value.
    jz Done
ArrayEmpty:
    xor eax, eax                    ; Clear EAX to return 0 if not found or empty

COMMENT!
I wasn't sure what to use as a return value for unsuccessful searches
should we distinguish between num not found and an empty array?
!

Done:
    pop edi
    pop esi
    pop ebx                         ; restore callee saved registers
    popfd                           ; restore all flags
    
    ret                             ; EAX holds return value
BinSort ENDP    
END main

