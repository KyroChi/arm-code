@ Kyle Chickering

	.global hexi
	.func	hexi

hexi:
	@ Save registers
	STMFD	SP!, {R4-R12, R14}

	@ Code for function starts here
	MOV	R1, #0 @ Pointer
	MOV	R8, #0 @ Counter

	MOV	R9, #0 @ Hex Number

loop:
	LDRB 	R2, [R0, R1]
	CMP	R2, #10 @ Check if newline
	BEQ	done
	CMP	R8, #10
	BEQ	done
	MOV	R9, R9, LSL #4
	BL	checkfirst

break:
	ADD	R8, R8, #1 @ Increment counter
	ADD	R1, R1, #1
	BAL	loop

checkfirst:	@ Check the first 
	@ Go here on first two iterations
	CMP	R8, #0
	BNE	next
	CMP	R2, #48
	BNE	badhex
	
	BAL	break

next:	@ Check the second letter
	CMP	R8, #1
	BNE	more
	CMP	R2, #120
	BNE	badform

	BAL	break

more:	@ Check the next 8 letters
	CMP	R2, #48 @ 0
	BLT	badform
	CMP	R2, #58 @ 0
	BLT	number

	CMP	R2, #65 @ A
	BLT	badform
	CMP	R2, #71 @ F
	BLT	letter

	BAL	badform

number:
	SUB	R2, R2, #48
	ADD	R9, R9, R2
	BAL	break

letter:
	SUB	R2, R2, #55
	ADD	R9, R9, R2
	BAL	break

badhex:
	LDR 	R0, =error2
	BL	stro
	BAL	error

badform:
	LDR	R0, =error1
	BL	stro
	BAL	error

toobig:
	LDR	R0, =error3
	BL	stro
	BL	error

error:
	MOV	R1, #1
	BL	done

clean:
	MOV	R1, #0
	BL	done

done:
	MOV	R0, R9
	LDMFD	SP!, {R4-R12, R14}
	MOV	PC, LR

	.data

error1:
	.asciz "Bad hex digit\n"

error2:
	.asciz "Bad hex format\n"

error3:
	.asciz "Hex value too long"
