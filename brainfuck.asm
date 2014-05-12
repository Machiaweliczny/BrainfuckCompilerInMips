.data
# hardcoded interpreter
instrukcje: .space 12000
szostki: .space 200
pre: .word 0x23bdf830, 0x23b403e8
i1: .byte '>'
i1t: .word 0x22940004
i2: .byte '<'
i2t: .word 0x2294FFFC
i3: .byte '+'
i3t: .word 0x8e880000, 0x21080001 , 0xae880000
i4: .byte '-'
i4t: .word 0x8e880000, 0x2108FFFF, 0xae880000
i5: .byte '.'
i5t: .word 0x8e840000, 0x2402000B, 0x0000000C
i6: .byte ','
i6t: .word  0x2002000C, 0x0000000c, 0xae820000
i7: .byte '['
#lw $t0, ($s4) |  beq $t0, $zero, dziewiec
i7t: .word 0x8e880000 , 0x11000000
i8: .byte ']'
#lw $t0, ($s4) | bne $t0, $zer0, szesc
i8t: .word 0x8e880000 , 0x15000000
wyjdz: .word 0x23BD07D0 ,0x2402000A, 0x0000000C


plikpyt: .asciiz  "Podaj sciezke do pliku:\n"
filename: .asciiz "C:\\Users\\Damian\\Desktop\\Dev\\Mips2\\program.txt" #file name
.text

# mozna odhaczyc to bedzie wczytywalo
#zadaj pytanie
#la $a0, plikpyt
#jal print_string
#wczytaj sciezke do pliku
#addi $sp, $sp, -30
#move $a0, $sp
#li $a1, 30
#jal read_string

#otworz plik
la $a0, filename #hardcoded bo sie niewygodnie wpisuje
li $a1, 0 #read only
jal open_file #v0 - file descriptor
move $s0, $v0 # zapisujemy fd
#wczytaj zawartosc
subiu $sp, $sp, 1000
move $a0, $s0
move $a1, $sp
li $a2, 1000
jal read_from_file
move $a0, $s0
jal close_file

#debug wczytywania
#move $a0, $sp
#jal print_string
#wypisz zawartosc pliku

####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA####KOMPILACJA##
# s6 - s9 - nawiasy
# s4 - pointer
# s0 - reader
# s2 - upychanie instrukcji

#stosik na nawiasy otwierajace
la $s6, szostki
#set upychacz
la $s2, instrukcje
#set reader
move $s0, $sp
#miejsce
lw $t9, pre
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, pre + 4
sw $t9, ($s2)
addiu $s2, $s2, 4
#addi $sp, $sp, -2000
#addi $s4, $sp, 1000 # pointer
#no i lecim
lb $t1, i1
lb $t2, i2
lb $t3, i3
lb $t4, i4
lb $t5, i5
lb $t6, i6
lb $t7, i7
lb $t8, i8

loop:
lb $t0, ($s0)
I1: bne $t0, $t1, I2
jal increment_pointer
I2: bne $t0, $t2, I3
jal decrement_pointer
I3: bne $t0, $t3, I4
jal increment
I4: bne $t0, $t4, I5
jal decrement
I5: bne $t0, $t5, I6
jal kropka
I6: bne $t0, $t6, I7
jal przecinek
I7: bne $t0, $t7, I8
jal szesc
I8: bne $t0, $t8, end
jal dziewiec
loopend:
#sun czytacz
addiu $s0, $s0, 1
j loop
end:
#posprzataj w kompilowanym
lw $t9, wyjdz
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, wyjdz + 4
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, wyjdz + 8
sw $t9, ($s2)
addiu $s2, $s2, 4
# posprzataj 
addiu $sp, $sp, 3000

#odpal skompilowany program
la $t0, instrukcje
jr $t0

#jal exit #niepotrzebne

#TRANSLATORY
increment_pointer:
lw $t9, i1t
sw $t9, ($s2)
addiu $s2, $s2, 4
#addi $s4, $s4, 4
j loopend
decrement_pointer:
lw $t9, i2t
sw $t9, ($s2)
addiu $s2, $s2, 4
#addi $s4, $s4, -4
j loopend
increment:
lw $t9, i3t
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i3t+4
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i3t+8
sw $t9, ($s2)
addiu $s2, $s2, 4
#lw $t0, ($s4)
#addi $t0, $t0, 1
#sw $t0, ($s4)
j loopend
decrement:
lw $t9, i4t
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i4t+4
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i4t+8
sw $t9, ($s2)
addiu $s2, $s2, 4
#lw $t0, ($s4)
#addi $t0, $t0, -1
#sw $t0, ($s4) 
j loopend
kropka: # wypluwa
lw $t9, i5t
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i5t+4
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i5t+8
sw $t9, ($s2)
addiu $s2, $s2, 4
#lw $a0, ($s4)
#addi $v0, $zero, 11
##li $v0, 11
#syscall
j loopend
przecinek: #pobiera
lw $t9, i6t
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i6t+4
sw $t9, ($s2)
addiu $s2, $s2, 4
lw $t9, i6t+8
sw $t9, ($s2)
addiu $s2, $s2, 4
##li $v0, 12
#addi $v0, $zero, 12
#syscall
#sw $v0, ($s4)
j loopend
szesc: 
lw $t9, i7t
sw $t9, ($s2) # t0 do porownania
addiu $s2, $s2, 4
# to podstawi dziewiatka
sw $s2, ($s6)# zapami?taj dla 9
addiu $s6, $s6, 4
addiu $s2,$s2, 4
j loopend
dziewiec:# to moze byc niezly bugland
lw $t9, i8t 
sw $t9, ($s2) #t0 do porowania
addiu $s2, $s2, 4
#oblicz roznice
li $s1, -1 #do dzielenia
#wczytaj z szostek
subiu $s6, $s6, 4
lw $t0, ($s6)
addiu $t0, $t0, 4 # za skok
subu $t9, $s2, $t0
addiu $t9, $t9, 4 # BUGLAND
#divu $t9, $s1
srl $t9, $t9, 2
div $t9, $s1
mflo $s1
and $s3, $s1, 0x0000FFFF
lw $s1, i8t+4 # zaladuj porowanie
or $s3, $s3, $s1 # jest porowanie ze skokiem
sw $s3, ($s2) # zapisz skok
addiu $s2, $s2, 4
# teraz jeszcze ustaw 6-tce skok
#li $s1, 4 #do dzielenia
lw $t0, ($s6)
subu $t9, $s2, $t0
subi $t9, $t9, 4 #
#divu $t9, $s1
srl $t9, $t9, 2
move $s1, $t9
and $s3, $s1, 0x0000FFFF
lw $s1, i7t+4
or $s3,$s3, $s1
sw $s3, ($t0)
j loopend




















# OBLSLUGA PLIKOW # OBLSLUGA PLIKOW # OBLSLUGA PLIKOW # OBLSLUGA PLIKOW # OBLSLUGA PLIKOW # OBLSLUGA PLIKOW # OBLSLUGA PLIKOW
print_string: #a0 - adres
	li $v0, 4
	syscall
	jr $ra
	
read_string: # a0 - adres , a1 - size in bytes
	li $v0, 8
	syscall
	jr $ra

open_file: # a0 - string, a1 - flags, a2 - mode
	li $v0, 13
	syscall
	jr $ra

read_from_file: # a1 - input buffer, a2 - size in bytes 
	li $v0, 14
	syscall
	jr $ra
close_file:
	li $v0, 16
	syscall
	jr $ra
	
exit:
      li   $v0, 10          # system call for exit
      syscall               # we are out of here.	
