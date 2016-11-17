@ Kyle Chickering

	.global _start

/*
 * Registers:
 * R12 - Buffer Pointer
 * R11 - Stack Pointer
 * R10 - Stack Address
 */

_start:
	MOV	R11, #0 @ Set the stack pointer to 0
	MOV	R12, #0 @ Set the buffer pointer to 0
	LDR	R10, =stack @ Create Stack

@ The main loop of the calculator 
mainloop:
	LDR	R0, =prompt
	BL	stro
	LDR	R0, =buffer
	BL	stri
	LDR	R0, =buffer

	LDRB	R2, [R0, R12]

	CMP	R2, #33 @ !
	BEQ	invert
	CMP	R2, #38 @ &
	BEQ	and
	CMP	R2, #43 @ +
	BEQ	add
	CMP	R2, #124 @ |
	BEQ	orvals
	CMP	R2, #45 @ -
	BEQ	subtract
	CMP	R2, #48 @ 0
	BEQ	zero
	CMP	R2, #50 @ 2
	BEQ	two
	CMP	R2, #104 @ h
	BEQ	help
	CMP	R2, #113 @ q
	BEQ	quit
	CMP	R2, #120 @ x examine
	BEQ	examine
	BL	errorchar

next:
	BL	mainloop

@ Pop a value off the stack
pop:
	CMP	R11, #0
	BEQ	underflow
	BL	next

@ Invert the top value on the stack
invert:
	CMP	R11, #0
	BEQ	underflow

	SUB	R11, R11, #4

	LDR	R2, [R10, R11]

	MVN	R2, R2

	STR	R2, [R10, R11]
	
	ADD	R11, R11, #4

	BL	next

@ And the top two values on the stack
and:
	@ Check for underflow
	CMP     R11, #0
        BEQ     underflow

	SUB	R11, R11, #4

	LDR	R2, [R10, R11]
	SUB	R11, R11, #4
	LDR	R3, [R10, R11]

	AND	R2, R3, R2

	STR	R2, [R10, R11]

	ADD	R11, R11, #4

	BL	next

@ Or the top two values on the stack
orvals:
	@ Check for underflow
	CMP	R11, #0
	BEQ	underflow

	SUB	R11, R11, #4

	LDR	R2, [R10, R11]
	SUB	R11, R11, #4
	LDR	R3, [R10, R11]

	ORR	R2, R3, R2

	STR	R2, [R10, R11]

	ADD	R11, R11, #4

	BL	next

@ Preform an addition operation
add:
	@ Check for underflow
	CMP	R11, #4
	BLE	underflow

	SUB	R11, R11, #4
	LDR	R2, [R10, R11]
	SUB	R11, R11, #4
	LDR	R3, [R10, R11]

	ADD	R3, R3, R2
	STR	R3, [R10, R11]

	ADD	R11, R11, #4

	BL	next

@ Preform a subtraction operation
subtract:
	@ Check for underflow
        CMP     R11, #1
        BLE     underflow

        SUB     R11, R11, #4
        LDR     R2, [R10, R11]
        SUB     R11, R11, #4
        LDR     R3, [R10, R11]

        SUB     R3, R2, R3
        STR     R3, [R10, R11]

        ADD     R11, R11, #4

        BL      next

@ Enter a hex value
zero:
	LDR	R0, =buffer
	BL	hexi
	
	STR	R0, [R10, R11]
	ADD	R11, R11, #4 @ Increment Stack pointer

	BL	next

@ Preform a twos compliment
two:
        CMP     R11, #0
        BEQ     underflow

        SUB     R11, R11, #4

        LDR     R2, [R10, R11]

        MVN     R2, R2
	ADD	R2, R2, #1

        STR     R2, [R10, R11]

        ADD     R11, R11, #4

        BL      next

@ Display the help menu
help:
	LDR	R0, =helptext
	BL	stro
	BL	next

@ Quit the calculator program and return the top stack value
quit:
    SUB R11, R11, #4
	LDR	R0, [R10, R11]
	MOV	R7, #1
	SWI	0

@ Examine the stack
examine:
	MOV	R9, R11 @ Save stack pointer
	
	@ Case there is nothing on the stack
	CMP	R9, #0
	BEQ	stackbottom

exloop:
	SUB	R9, R9, #4 @ Decrement temporary SP
	LDR	R0, [R10, R9]
	BL	hexo
	BL	stro
	LDR	R0, =new
	BL	stro

	CMP	R9, #0
	BGT	exloop
stackbottom:
	LDR	R0, =bottom
	BL	stro
	BL	next

underflow:
	LDR	R0, =underflowtext
	BL	stro
	BL	next

@ The character wasn't recognized
errorchar:
	LDR	R0, =errortext
	BL	stro
	BL	next

	.data

stack:
	.space	160

helptext:
	.asciz	"lab12:\n! - invert or not the top of stack value\n& - AND the top two values on the stack\n+ - ADD the top two values on the stack\n- - SUBTRACT the top two values on stack\n0 - Enter a hex value onto the stack\n2 - Take two's complement of value on top of stack\nh - Display the help page\nq - quit the hex calculator\nx - eXamine the stack\n| - OR the top two values on the stack\n"

errortext:
	.asciz 	"Didn't recognize character\n"

underflowtext:
	.asciz	"Stack underflow, not enough items on stack\n"

prompt:
	.asciz	"rpn: "

valueprompt:
	.asciz	"Enter a hex value: "

buffer:
	.asciz	"         "

hexbuff:
	.asciz "0x00000000"

bottom:
	.asciz "Bottom of Stack\n"

new:
	.asciz "\n"
