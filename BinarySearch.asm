;Binary Search method goes here
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
array DWORD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.code
main PROC
    ;set registers
    ;call Binary Seach
    add esp, 8                     ; Clean up the stack
    invoke ExitProcess, 0
main ENDP

;Binary Search Parameter
;any other nessesary fuctions


END main
