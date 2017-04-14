# Twin Tower of Hanoi game
#
# assume that input n is in r4, src/dst/tmp in r5/r6/r7
# return the number of steps in r2 (When call procedure, count add one)

# Stacks A/B/C are located in memory locations [0: 63], [64: 127], and [128, 191]
# r8/r9/r10 are designated as stack points for A/B/C
# Initially, stack pointers for A/B/C point to memory locations 0, 64, and 128 (initial TOS)
# Stacks are assumed to grow upward

#============= Sec_1/A : JNISS =================================
            xor     r2, r2, r2
            addi    r8, r0, 0       # r8  = 0x0000
            addi    r9, r0, 64      # r9  = 0x0040
			addi    r10, r0, 128    # r10 = 0x0060
#============= Sec_1/A : JNISS =================================

#============= Sec_1/B : SIMNIOS2 ==============================
#-- define towers (16 words) in data section
#-- 			.data
TowerA:		.skip	16*4				# use TowerA to dump stack in debug window
TowerB:		.skip	16*4
TowerC:		.skip	16*4
#-- 
#-- 		.extern		Graphic_MovePalet	# for Hardware test
#-- 		.global		HanoiTwinTower		# called by Hardware tester
#-- 
#-- 		.text
#-- 		movia	r8,  TowerA			# Stack pointer of Tower A
#-- 		movia	r9,  TowerB			# Stack pointer of Tower B
#-- 		movia	r10, TowerC			# Stack pointer of Tower C
#============= Sec_1/B : SIMNIOS2 ==============================


#------------------
START:
#------------------
            xor     r2, r2, r2
            addi    r4, r0, 7       # n = 7
			call	HanoiTwinTower
			trap					# replace by "Trap" for SIMNIOS2

#------------------Function called by Hardware tester
HanoiTwinTower:
#------------------

# Place a very large disk (which is not part of disks to move) at the bottom of the stack
# in order to make the size comparison easier when the pile becomes empty.

            addi    r17, r0, 0xffff
            stw     r17, 0(r8)
            addi    r8, r8, 4

# Place blue disks in pile A
#   Blue disks are FF00, FF01, FF02, etc. from the smallest to the largest

            add     r16, r0, r4
            ori     r17, r16, 0xff00
loopA:      stw     r17, 0(r8)
            addi    r8, r8, 4
            addi    r16, r16, -1
            ori     r17, r16, 0xff00
            bne     r16, r0, loopA

# Place a very large disk (which is not part of disks to move) at the bottom of the stack
# in order to make the size comparison easier when the pile becomes empty.

            addi    r17, r0, 0x00ff
            stw     r17, 0(r9)
            addi    r9, r9, 4

# Place white disks in pile B
#   White disks are 0000, 0001, 0002, etc. from the smallest to the largest

            add     r16, r0, r4
loopB:      stw     r16, 0(r9)
            addi    r9, r9, 4
            addi    r16, r16, -1
            bne     r16, r0, loopB

#===================================================================
#============== Program basicly start from here ====================
#===================================================================

main:       addi    r5, r0, 0       # src = A
            addi    r6, r0, 1       # dst = B
            addi    r7, r0, 2       # tmp = C
            call    swap			# Call swap(n, A, B)
			ret

#============= Swap prodruce Start =================================
# INPUT: 	src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
# swap(A, B, C)
swap:		addi	r27, r27, -40
			stw		r31,  0(r27)	# save return address
			stw		r3,   4(r27)
			stw		r4,   8(r27)
			stw		r5,  12(r27)
			stw		r6,  16(r27)
			stw		r7,  20(r27)
			stw		r8,  24(r27)
			stw		r9,  28(r27)
			stw		r10, 32(r27)	

# consolidate(N-1, B, A)
			addi	r4, r4, -1		# n = n - 1
			add 	r23, r5, r0		#switch parameters
			add 	r5, r6, r0
			add 	r6, r23, r0
			call 	cons

# move(B, C)
			add 	r23, r5, r0 	
			add 	r5, r6, r0
			add 	r6, r23, r0

			add 	r23, r6, r0
			add 	r6, r7, r0
			add 	r7, r23, r0

			call 	move

# double_hanoi(N-1, B, A)
			addi 	r4, r4, -1 		# n = n -1 
			add 	r23, r6, r0 	# switch parameters
			add 	r6, r7, r0
			add 	r7, r23, r0

			call 	dhan

# move(A, B)
			add 	r23, r5, r0
			add 	r5, r6, r0
			add 	r6, r23, r0

			call 	move

# double_hanoi(N-1, C, B)
			addi 	r4, r4, -1 		# n = n -1 
			add 	r23, r5, r0 	# switch parameters
			add 	r5, r7, r0
			add 	r7, r23, r0

			call 	dhan	

# distribute(N-1, B, A)
			addi 	r4, r4, -1 		# n = n -1 
			add 	r23, r5, r0 	# switch parameters
			add 	r5, r6, r0
			add 	r6, r23, r0

			add 	r23, r6, r0
			add 	r6, r7, r0
			add 	r7, r23, r0

			call 	dsrb	

#============= Consolidate prodruce Start ==========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
cons:

#============= Double Hanoi prodruce Start =========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
dhan:

#============= Distribute prodruce Start ===========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
dsrb:

# fin

fin:		ldw		r10, 32(r27)
			ldw		r9,  28(r27)
			ldw		r8,  24(r27)
			ldw		r7,  20(r27)
			ldw		r6,  16(r27)
			ldw		r5,  12(r27)
			ldw		r4,   8(r27)
			ldw		r3,   4(r27)
			ldw		r31,  0(r27)		# restore return address
			addi	r27, r27, 40
			ret

#============= Move prodruce Start =================================
# INPUT: 	src(r5), dst(r6)
# 
# OUTPUT: 	step++(r2)
#===================================================================
move:		addi	r24, r0, 1		# set 1 -> r24
			addi	r25, r0, 2		# set 2 -> r25

			beq     r5, r24, srcB  	# if r5 = 1, src = B
           	beq     r5, r25, srcC  	# if r5 = 2, src = C

srcA:		beq		r6, r24, ATB	# if r5 = 0 && r6 = 1, A -> B
			beq		r6, r25, ATC	# if r5 = 0 && r6 = 2, A -> C
			br		error			# else error

srcB:		beq		r6, r0, BTA		# if r5 = 1 && r6 = 0, B -> A
			beq		r6, r25, BTC	# if r5 = 1 && r6 = 2, B -> C
			br		error			# else error

srcC:		beq		r6, r0, CTA		# if r5 = 2 && r6 = 0, C -> A
			beq		r6, r24, CTB	# if r5 = 2 && r6 = 1, C -> B
			br		error			# else error

ATB:		addi    r8, r8, -4     	# A -> B
           	ldw     r23, 0(r8)
           	stw     r23, 0(r9)
           	addi    r9, r9, 4
           	br      done

ATC:		addi    r8, r8, -4     	# A -> C
           	ldw     r23, 0(r8)
           	stw     r23, 0(r10)
           	addi    r10, r10, 4
           	br      done

BTA:		addi    r9, r9, -4     	# B -> A
           	ldw     r23, 0(r9)
           	stw     r23, 0(r8)
           	addi    r8, r8, 4
           	br      done

BTC:		addi    r9, r9, -4     	# B -> C
           	ldw     r23, 0(r9)
           	stw     r23, 0(r8)
           	addi    r8, r8, 4
           	br      done

CTA:		addi    r10, r10, -4    # C -> A
           	ldw     r23, 0(r10)
           	stw     r23, 0(r8)
           	addi    r8, r8, 4
           	br      done

CTB:		addi    r10, r10, -4    # C -> B
           	ldw     r23, 0(r10)
           	stw     r23, 0(r9)
           	addi    r9, r9, 4
           	br      done

done:		addi    r3, r3, 1      	# increment no. of steps
           	ret

# move error

error:      addi    r2, r0, -1
			trap					# replace by "Trap" for SIMNIOS2
