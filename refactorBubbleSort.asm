.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
array DWORD 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

.code
main PROC
    push OFFSET array          ; 
    push LENGTHOF array        ; 
    call BubbleSort
    add esp, 8                 ; Clean up the stack
    invoke ExitProcess, 0
main ENDP

BubbleSort PROC
    pushfd                          ; save user environment
    push ebp                        ; 
    mov ebp, [esp + 16]             ; move OFFSET to ebp
    mov ecx, [esp + 12]             ; move LENGTHOF to ecx
    dec ecx                         ; Decrement count for zero-based index in loops

OuterLoop:
    mov edx, 0                      ; EDX will track the inner loop index
InnerLoop:
    mov eax, [ebp + edx * 4]        ; Load current array element
    mov edi, [ebp + edx * 4 + 4]    ; Load next array element
    cmp eax, edi                    ; Compare current and next elements
    jle NoSwap                      ; Jump if current <= next (no need to swap)

    ; Swap elements
    mov [ebp + edx * 4], edi        ; Place next element in current position
    mov [ebp + edx * 4 + 4], eax    ; Place current element in next position

NoSwap:
    inc edx                         ; Move to the next element
    cmp edx, ecx                    ; Check if we've reached the end of this pass
    jl InnerLoop                    ; Continue inner loop if not

    dec ecx                         ; Decrement outer loop counter
    jnz OuterLoop                   ; Repeat if more passes are needed

    pop ebp
    popfd                           ; Restore user environment
    ret

BubbleSort ENDP

END main
