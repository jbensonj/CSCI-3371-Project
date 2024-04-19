.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
array DWORD 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

.code
main PROC
    mov esi, OFFSET array          ; ESI points to the base of the array
    mov ecx, LENGTHOF array        ; ECX is the number of elements in the array
    call BubbleSort
    add esp, 8                     ; Clean up the stack
    invoke ExitProcess, 0
main ENDP

BubbleSort PROC
    pushad                          ; Save all registers
    dec ecx                         ; Decrement count for zero-based index in loops
    mov ebx, ecx                    ; EBX will track the outer loop counter

OuterLoop:
    mov edx, 0                      ; EDX will track the inner loop index
InnerLoop:
    mov eax, [esi + edx * 4]        ; Load current array element
    mov edi, [esi + edx * 4 + 4]    ; Load next array element
    cmp eax, edi                    ; Compare current and next elements
    jle NoSwap                      ; Jump if current <= next (no need to swap)

    ; Swap elements
    mov [esi + edx * 4], edi        ; Place next element in current position
    mov [esi + edx * 4 + 4], eax    ; Place current element in next position

NoSwap:
    inc edx                         ; Move to the next element
    cmp edx, ebx                    ; Check if we've reached the end of this pass
    jl InnerLoop                    ; Continue inner loop if not

    dec ebx                         ; Decrement outer loop counter
    jnz OuterLoop                   ; Repeat if more passes are needed

    popad                           ; Restore all registers
    ret

BubbleSort ENDP

END main
