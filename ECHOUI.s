#------------------------------------------------------------------------------
# Project : Cyclic Hanoi Tower
#
#------------------------------------------------------------------------------

		#--------------------------------------------
		.data		#### section of data
		#--------------------------------------------
TowerA:	.skip	15*4
EndA:	.word	-1

TowerB:	.skip	15*4
EndB:	.word	-1

TowerC:	.skip	15*4
EndC:	.word	-1


		#--------------------------------------------
		.text		#### section of code
		#--------------------------------------------
# Towers A, B, and C are adjacent Towers in clockwise direction
# stack pointers for Towers A, B, and C are r8, r9, and r10
# stacks r8, r9, and r10 grow upward
Start:
		movia	r8,  TowerA		# initialize stack pointers
		movia	r9,  TowerB
		movia	r10, TowerC
		addi	r4, r0, 6		# n = 5
#	initialize Tower A (R8) with n palets
		add     r16, r0, r4
loop:	stw     r16, 0(r8)
		addi    r8, r8, 4
		addi    r16, r16, -1
		bne     r16, r0, loop
							   # r4 = n = nbr of palets
		addi    r5, r0, 0      # src = A
		addi    r6, r0, 1      # dst = B
		addi    r7, r0, 2      # tmp = C
		xor     r2, r2, r2	   # number of steps

		call	move_cw	

		trap					# end of program


#---------------------------------------------------------------
# Entree :	R4=n, R5=src, R6=dst, R7=tmp
#			Src, Dst, Tmp : 0= TowerA, 1=TowerB, 2=TowerC
# Return :	R2 = numbers of steps
#---------------------------------------------------------------
move_cw:   addi		r27, r27, -32
		   stw		r31, 0(r27)
		   stw		r4, 4(r27)
		   stw		r5, 8(r27)
		   stw		r6, 12(r27)
		   stw		r7, 16(r27)
		   addi		r11, r0, 1
		   bgt		r4, r11, cond_1
		   beq		r4, r11, cond_2
		  

cond_1:		addi	r4, r4, -1
			ldw		r6, 16(r27)
			ldw		r5, 8(r27)
			ldw		r7, 12(r27)
			call move_ccw
			

			addi	r4, r0, 1
			ldw		r5, 8(r27)
			ldw		r6, 12(r27)
			ldw		r7, 16(r27)
			call move_cw
			
			ldw		r4, 4(r27)
			addi	r4, r4, -1
			ldw		r5, 16(r27)
			ldw		r6, 12(r27)
			ldw		r7, 8(r27)
			call move_ccw

			br finish
				



cond_2:		call move_palet
			br finish


#---------------------------------------------------------------
# Entree :	R4=n, R5=src, R6=dst, R7=tmp
#			Src, Dst, Tmp : 0= TowerA, 1=TowerB, 2=TowerC
# Return :	R2 = numbers of steps
#---------------------------------------------------------------
move_ccw:  addi		r27, r27, -32
		   stw		r31,0(r27)
		   stw		r4, 4(r27)
		   stw		r5, 8(r27)
		   stw		r6, 12(r27)
		   stw		r7, 16(r27)
		   addi		r11, r0, 1
		   bgt		r4, r11, condi_1
		   beq		r4, r11, condi_2
		   

condi_1:	addi	r4, r4, -1
			ldw		r5, 8(r27)
			ldw		r6, 12(r27)
			ldw		r7, 16(r27)
			call move_ccw
			

			addi	r4, r0, 1
			ldw		r6, 16(r27)
			ldw		r5, 8(r27)
			ldw		r7, 12(r27)
			call move_cw
			
			ldw		r4, 4(r27)
			addi	r4, r4, -1	# n<- n-1
			ldw		r5, 12(r27)	# src<-dst
			ldw		r6, 8(r27) # dst<-src
			ldw		r7, 16(r27)
			call move_cw
			

			addi	r4, r0, 1 #n<-1
			ldw		r5, 16(r27)
			ldw		r6, 12(r27)
			ldw		r7, 8(r27)
			call move_cw
			
			ldw		r4, 4(r27)
			addi	r4, r4, -1
			ldw		r5, 8(r27)
			ldw		r6, 12(r27)
			ldw		r7, 16(r27)
			call move_ccw

			br finish



condi_2:	addi	r4, r0, 1
			ldw		r6, 16(r27)
			ldw		r5, 8(r27)
			ldw		r7, 12(r27)
			call move_cw
			

			addi	r4, r0, 1
			ldw		r5, 16(r27)
			ldw		r6, 12(r27)
			ldw		r7, 8(r27)
			call move_cw
			br finish


finish:		ldw		r31, 0(r27)
			ldw		r4, 4(r27)
			ldw		r5, 8(r27)
			ldw		r6, 12(r27)
			ldw		r7, 16(r27)
			addi	r27, r27, 32
			ret


#---------------------------------------------------------------
# src is stored in r5
#   if src = A, dst = B
#   if src = B, dst = C
#   if src = C, dst = A
#---------------------------------------------------------------
move_palet:      
		   addi    r24, r0, 1     # r24 <- 1
           addi    r25, r0, 2     # r25 <- 2

           beq     r5, r24, dstC  # if r5 = 1, src = B, dst = C
           beq     r5, r25, dstA  # if r5 = 2, src = C, dst = A
		   ### else r5 = 0
dstB:      addi    r8, r8, -4     # A -> B
           ldw     r23, 0(r8)
           stw     r23, 0(r9)
           addi    r9, r9, 4
           br      done

dstC:      addi    r9, r9, -4     # B -> C
           ldw     r23, 0(r9)
           stw     r23, 0(r10)
           addi    r10, r10, 4
           br      done

dstA:      addi    r10, r10, -4   # C -> A
           ldw     r23, 0(r10)
           stw     r23, 0(r8)
           addi    r8, r8, 4

# to increment the number of steps
done:      addi    r2, r2, 1      # increment no. of steps
           ret
