      xor     r2, r2, r2
      addi    r8, r0, 0       # r8  = 0x0000
      addi    r9, r0, 64      # r9  = 0x0040
	addi    r10, r0, 128    # r10 = 0x0060

      xor     r2, r2, r2
      addi    r4, r0, 7       # n = 7
	call	  HanoiTwinTower
	stop				# replace by "Trap" for SIMNIOS2

HanoiTwinTower:
      addi    r17, r0, 0xffff
      stw     r17, 0(r8)
      addi    r8, r8, 4

      add     r16, r0, r4
      ori     r17, r16, 0xff00

loopA:      
      stw     r17, 0(r8)
      addi    r8, r8, 4
      addi    r16, r16, -1
      ori     r17, r16, 0xff00
      bne     r16, r0, loopA

      addi    r17, r0, 0x00ff
      stw     r17, 0(r9)
      addi    r9, r9, 4

      add     r16, r0, r4

loopB:     
      stw     r16, 0(r9)
      addi    r9, r9, 4
      addi    r16, r16, -1
      bne     r16, r0, loopB

# Call swap(n, A, B)

      addi    r5, r0, 0       # src = A
      addi    r6, r0, 1       # dst = B
      addi    r7, r0, 2       # tmp = C
      call    swap
	ret

# move error

error:      
      addi    r2, r0, -1
	stop				# replace by "Trap" for SIMNIOS2
