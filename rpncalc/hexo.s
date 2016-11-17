@ Kyle Chickering

	.global hexo
	.func	hexo

@ Looks for value to be converted to hex ascii in the R0 register
@ clears R0-R3, return address of ascii string in R0

hexo:
    @save registers
    	STMFD	SP!, {R4-R12, R14}

    @ Code for function starts here

	LDR	R1, =hexbuf
	MOV	R2, #9

	MOV	R3, R0 @ Save input

loop:
	CMP	R2, #1
	BLE	done

	MOV	R4, #48 @ Value to add for numerical bytes

	MOV	R0, R3
	AND	R0, R3, #0xF
	CMP	R0, #10

	ADD	R0, R0, #48 @ Add 48 to the number
	BLT	number
	ADD	R0, R0, #7 @ Add another 7 if the byte is a letter 	

number:
	@ Store ASCII value in buffer, sub counter and LSR original number
	STRB	R0, [R1, R2]
	SUB	R2, R2, #1
	MOV	R3, R3, LSR #4
	BAL	loop

done:
	MOV	R0, R1 @ Move the address to the return register
    @ Code for function ends here

    @ Restore registers and return
    	LDMFD	SP!, {R4-R12, R14}
    	MOV	PC, LR

	.data

hexbuf:
	.asciz	"0x12345678"
