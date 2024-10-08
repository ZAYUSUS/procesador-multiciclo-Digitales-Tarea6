.option nopi
.text
.globl main
.type main, @function
main:
    la   s8,variable
    ld   s3,0(s8) # guarda 10 en s3
    # addi s3,zero,10
    addi s4,zero,9    # s4=9
    and  s5,s4,s3   # s5 = 1000 = 8 
	or   s6,s4,s3   # s6 = 1011 = 11
    jal  ra,sub_func # pasa a la funcion resta
sub_func:
	sub t2,s6,s5    # s6 - s5 = 3
    add t3,s6,s5    # t3 = s6-s5 = 11+8=19
    bne t2,s3,end
end:
	sd t2,0(a1)     # guarda 3 en memoria.

.section .rodata
variable:
	.dword 10