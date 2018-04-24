#
# UNIVALI - Universidade do Vale do Itajaí
# Disciplina: 4189 – Arquitetura e Organização de Computadores
# Atividade: Avaliação 03 – Simulador MIPS
# Grupo: - André Luiz da Silva
#        - Ivan Carlos dos Santos
#
#
#	REGISTRADORES USADOS:
#	
#	$a0 = ponteiro para SIZE
#	$a1 = ponteiro para endereço base de VET
#	$a2 = ponteiro para SUM
#
#	$t0 = registrador temporário para SIZE (valor)
#	$t1 = registrador temporário para VET (endereço, a fins de preservar endereço base original)
#	$t2 = registrador temporário para I (indice do laço)
#	$t3 = registrador temporário para valor do indice atual de VET
#	$t4 = registrador temporário para I * 4
#	
#	$v0	= registrador de retorno para os resultados parciais de SUM
#

.data
	vet		: .word		1,2,3,4,5,6,7,8	# vetor
	size	: .word		8				# tamanho do vetor
	sum		: .word		0				# somatorio

.text
main:
	la		$a0, size					# carrega ponteiro para size
	la		$a1, vet					# carrega ponteiro para o vetor
	la		$a2, sum					# carrega ponteiro para sum
	
	lw		$t0, ($a0)					# carrega o valor de $a0 (size) em $t0
	la		$t1, ($a1)					# carrega o endereço de $a1 (vet) em $t1 para uso temporario (incremento de endereço)
	li		$t2, 0						# carrega 0 em $t2 (registrador temporario para i)
	li		$v0, 0						# carrega 0 em $v0 (resultados parciais de sum)
	jal		proc_sum					# pula para o procedimento de soma, guardando o endereço da proxima instrução do main em $ra
	
	sw		$v0, ($a2)					# guarda o resultado da soma na memória (endereço apontado por $a2)
	
	j		fim							# pula para o fim do programa (para evitar possiveis erros)
	
	
proc_sum:								# procedimento para o somatorio (laco)

	beq 	$t0, $t2, saida_laco		# pula de label caso $t2 (i) seja igual a $t0 (size)
	
										# calcula o endereco de vet[i]
	sll		$t4, $t2, 2					# armazena em $t4 o produto de i * 4 (movido 2 bits à esquerda)
	add		$t1, $a1, $t4				# endereço atual = endereço base do vetor + i * 4
	
	lw		$t3, ($t1)					# carrega em $t3 o elemento A[i] apontado por $t1
	
	add		$v0, $v0, $t3				# soma = soma + elemento atual do vetor
	
	addi	$t2, $t2, 1					# i++
	j		proc_sum					# retorna para o começo do procedimento proc_sum

saida_laco:
	jr		$ra							# pula para as instruções seguintes pendentes no main (endereço apontado por $ra)

fim:
	nop									# fim do programa
