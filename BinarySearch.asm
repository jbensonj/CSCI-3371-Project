.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data
	array DWORD 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
	num DWORD 13

.code
main PROC
    push OFFSET array               ; push offset to the stack (4)      
    push LENGTHOF array             ; push lengthof to the stack (4)	 
    push num						; push num to the stack (4)
    call BinSearch                    ; push return address to the stack (4) 
	add esp, 12

	Invoke ExitProcess, 0        
main ENDP

BinSearch PROC
    pushfd                          ; save all flags (4)
    push ebx                        ; save ebx to hold num (4)
    push esi                        ; save esi to hold offset (4)
 
    mov edx, [esp + 20]             ; mov lengthof to register
    cmp edx, 0                      ; Check if the array is empty
    je ArrayEmpty

; initializing values     
    mov ebx, [esp+16]               ; EBX will hold num
    mov esi, [esp+24]               ; ESI will hold offset
    mov ecx, 0                      ; ECX will be L, initialize with 0
    dec edx                         ; EDX will be R, initialize with LengthOf - 1 
    
Check:
    cmp ecx, edx                    ; While L <= R 
    jg ArrayEmpty                   ; Not found if L > R

;find mid
    mov eax, ecx                    ; EAX will hold Mid
    add eax, edx                    ; 
    shr eax, 1                      ; Mid = floor((L+R)/2)

;Search partitions for num 
    cmp [esi+eax*4], ebx            ; compare array[Mid] to num         
    jg LowerSearch                   
    je Done

    mov ecx, eax                    ; Adjust L to Mid + 1
    inc ecx
    jmp Check                       ; Continue looking in upper partition
LowerSearch:
    mov edx, eax                    ; Adjust R to Mid - 1
    dec edx                          
    jmp Check                       ; continue looking in lower partition

; EAX holds return value 
ArrayEmpty:
    xor eax, eax                    ; Clear EAX to return 0 if not found or empty 
Done:                         
    pop esi
    pop ebx                         ; restore saved registers
    popfd                           ; restore all flags
    ret
BinSearch ENDP    
END main
