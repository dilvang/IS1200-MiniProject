  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
.globl hexasc
.globl delay
.globl time2string
.globl enable_interrupt
.data		# allt efter kommer vara data
.text		# allt under kommer vara assemblykod

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

hexasc :
 	andi $v0, $a0, 0xf		#vi vill endast spara 4 LSB f=1111 And med ett  binärt tal (resten framför blir 0)
 	addi $v0, $v0, 0x30		#vi omvandlar värdet i $v0 till ASCII-tabellvärdet
 	ble $v0, 0x39, finish		#villlkor: om $v0 (Ascii-omvandlet) är mindre än 0x39, siffran 9 --> branch to finsih
 	nop
 	addi $v0, $v0, 7		#om $v0 är större än 0x39 (9) då vill vi addera 7 till 0x39 och kan då nå (A-F)

 	finish :
 	jr $ra				#returnera det värde som finns i ascii-tabellen
	nop


delay:
		PUSH $ra
		li $t2, 0 			# int i = 0
		li $t3, 2500000		# constant from code 4711  # change this in the lab

	while:
		ble $a0, 0, done	# branch less or equal for 0 and t1
		nop			# no operation
		sub $a0, $a0, 1		# ms = ms - 1

	for:
		beq $t2, $t3, while	#  i < 4711;
		nop
		addi $t2, $t2, 1	# i = i + 1
		j for			# go back
		nop

	done:
		POP $ra
		jr $ra
		nop


  enable_interrupt:
     ei
     jr $ra
     nop

time2string:

PUSH $ra         # saving return value
andi     $a1, $a1, 0xffff #ignoring anything but the 16 least significant bit


srl     $t1, $a1, 12    # shift right 12 steps to aquire the 4 most significant digits in the NBCD
PUSH $a0
move     $a0, $t1    # move the 4 digits to a0
jal     hexasc        # jump to hexasc
nop
POP $a0
sb    $v0 ,0($a0)    # takes the return value and then stores it in a0


srl     $t2, $a1, 8    # shift right 8 steps to aquire the next 4 in the NBCD
PUSH $a0
move     $a0, $t2    # move the 4 digits to a2
jal     hexasc        # jump to hexasc
nop
POP $a0
sb    $v0,1($a0)    # takes the return value and then stores it in a0's adress


addi     $t4, $t4, 0x3A    # adds ascii-code for ':'
sb    $t4,2($a0)    # store byte in address of a0


srl     $t3, $a1, 4     # shift right 4 steps to aquire the next 4 in the NBCD
PUSH     $a0
move     $a0, $t3    # move the 4 digits to a2
jal     hexasc        # jump to hexasc
nop
POP    $a0
sb    $v0,3($a0)    # store byte in address of a0 av typen string



PUSH $a0
nop
move     $a0, $a1    # move the 4 digits to a0
jal     hexasc        # jump to hexasc
nop
POP $a0

sb    $v0,4($a0)    # sista siffran lagras i address of a0
li     $t4, 0x00    # load null byte to t4
sb    $t4,5($a0)    # store byte in address of a0

POP $ra
jr  $ra
nop
