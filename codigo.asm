# Organizacao de Computadores - Calculo do Modelo de Fundo
#
# Este programa em Assembly MIPS-32 calcula o modelo de fundo de uma cena
# a partir de uma sequencia de imagens no formato PGM (P2 - ASCII).
#
# Logica de Funcionamento:
# 1. Le uma serie de arquivos PGM de entrada.
# 2. Para cada pixel, soma os seus valores (em escala de cinza) de todas as imagens
#    em um buffer de inteiros (4 bytes por pixel para evitar overflow).
# 3. Apos somar todos os pixels de todas as imagens, calcula a media de cada pixel
#    dividindo o valor somado pelo numero total de imagens.
# 4. Escreve a imagem resultante (o modelo de fundo) em um novo arquivo PGM.
#
# Como usar:
# - Inicie o MARS a partir do terminal de dentro da pasta deste projeto.
# - Execute o programa. O arquivo de saida 'modelo_fundo.pgm' sera criado.

.data
# --- CONFIGURACOES DO USUARIO ---
largura:      .word 640          # Largura da imagem em pixels
altura:       .word 360          # Altura da imagem em pixels
num_frames:   .word 25           # Numero total de frames para processar

# Lista com os nomes dos arquivos PGM de entrada, cada um com uma label unica.
fname01:    .asciiz "frames/ezgif-frame-001.pgm"
fname02:    .asciiz "frames/ezgif-frame-002.pgm"
fname03:    .asciiz "frames/ezgif-frame-003.pgm"
fname04:    .asciiz "frames/ezgif-frame-004.pgm"
fname05:    .asciiz "frames/ezgif-frame-005.pgm"
fname06:    .asciiz "frames/ezgif-frame-006.pgm"
fname07:    .asciiz "frames/ezgif-frame-007.pgm"
fname08:    .asciiz "frames/ezgif-frame-008.pgm"
fname09:    .asciiz "frames/ezgif-frame-009.pgm"
fname10:    .asciiz "frames/ezgif-frame-010.pgm"
fname11:    .asciiz "frames/ezgif-frame-011.pgm"
fname12:    .asciiz "frames/ezgif-frame-012.pgm"
fname13:    .asciiz "frames/ezgif-frame-055.pgm"
fname14:    .asciiz "frames/ezgif-frame-056.pgm"
fname15:    .asciiz "frames/ezgif-frame-069.pgm"
fname16:    .asciiz "frames/ezgif-frame-070.pgm"
fname17:    .asciiz "frames/ezgif-frame-071.pgm"
fname18:    .asciiz "frames/ezgif-frame-088.pgm"
fname19:    .asciiz "frames/ezgif-frame-089.pgm"
fname20:    .asciiz "frames/ezgif-frame-090.pgm"
fname21:    .asciiz "frames/ezgif-frame-091.pgm"
fname22:    .asciiz "frames/ezgif-frame-092.pgm"
fname23:    .asciiz "frames/ezgif-frame-093.pgm"
fname24:    .asciiz "frames/ezgif-frame-094.pgm"
fname25:    .asciiz "frames/ezgif-frame-095.pgm"

# Nome do arquivo de saida
arquivo_saida:
    .asciiz "modelo_fundo.pgm"

# --- BUFFERS E VARIAVEIS INTERNAS ---
buffer_soma: .space 921600
buffer_leitura_num: .space 8
str_p2:       .asciiz "P2\n"
str_espaco:   .asciiz " "
str_newline:  .asciiz "\n"
str_maxval:   .asciiz "255\n"
msg_erro_abrir: .asciiz "ERRO: Nao foi possivel abrir o arquivo: "

.text
.globl main
# ==============================================================================
# FUNCAO PRINCIPAL (main)
# Orquestra todo o processo de leitura, calculo e escrita.
# ==============================================================================
main:
    lw $s0, largura
    lw $s1, altura
    lw $s2, num_frames
    mul $s3, $s0, $s1   # s3 = total de pixels
    
    # Processa cada frame individualmente 
    la $a0, fname01
    jal processa_um_frame
    la $a0, fname02
    jal processa_um_frame
    la $a0, fname03
    jal processa_um_frame
    la $a0, fname04
    jal processa_um_frame
    la $a0, fname05
    jal processa_um_frame
    la $a0, fname06
    jal processa_um_frame
    la $a0, fname07
    jal processa_um_frame
    la $a0, fname08
    jal processa_um_frame
    la $a0, fname09
    jal processa_um_frame
    la $a0, fname10
    jal processa_um_frame
    la $a0, fname11
    jal processa_um_frame
    la $a0, fname12
    jal processa_um_frame
    la $a0, fname13
    jal processa_um_frame
    la $a0, fname14
    jal processa_um_frame
    la $a0, fname15
    jal processa_um_frame
    la $a0, fname16
    jal processa_um_frame
    la $a0, fname17
    jal processa_um_frame
    la $a0, fname18
    jal processa_um_frame
    la $a0, fname19
    jal processa_um_frame
    la $a0, fname20
    jal processa_um_frame
    la $a0, fname21
    jal processa_um_frame
    la $a0, fname22
    jal processa_um_frame
    la $a0, fname23
    jal processa_um_frame
    la $a0, fname24
    jal processa_um_frame
    la $a0, fname25
    jal processa_um_frame

    jal calcula_media
    jal escreve_imagem_saida
    
    li $v0, 10
    syscall

# ==============================================================================
# FUNCAO: processa_um_frame
# Le um arquivo PGM, le cada pixel e soma ao buffer_soma.
# ==============================================================================
processa_um_frame:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $a0, 28($sp)
    
    li $v0, 13
    li $a1, 0
    syscall
    
    blt $v0, $zero, erro_abrir_arquivo
    move $s0, $v0
    
    li $s1, 0
loop_descarta_cabecalho:
    beq $s1, 3, fim_descarta_cabecalho
    li $v0, 14
    move $a0, $s0
    la $a1, buffer_leitura_num
    li $a2, 1
    syscall
    lb $t0, buffer_leitura_num
    li $t1, 10
    bne $t0, $t1, loop_descarta_cabecalho
    addi $s1, $s1, 1
    j loop_descarta_cabecalho
fim_descarta_cabecalho:
    
    li $s2, 0
    la $s3, buffer_soma
    lw $t5, largura
    lw $t6, altura
    mul $s5, $t5, $t6
loop_le_pixels:
    bge $s2, $s5, fim_loop_le_pixels
    move $a0, $s0
    jal read_integer_from_file
    lw $t0, 0($s3)
    add $t0, $t0, $v0
    sw $t0, 0($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 4
    j loop_le_pixels
fim_loop_le_pixels:

    li $v0, 16
    move $a0, $s0
    syscall

epilogo_processa_frame:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    addi $sp, $sp, 32
    jr $ra

erro_abrir_arquivo:
    li $v0, 4
    la $a0, msg_erro_abrir
    syscall
    lw $a0, 28($sp) 
    li $v0, 4
    syscall
    li $a0, 10
    li $v0, 11
    syscall
    li $v0, 10 
    syscall

# ==============================================================================
# FUNCAO: calcula_media
# Percorre o buffer_soma e divide cada valor pelo numero de frames.
# ==============================================================================
calcula_media:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    la $s0, buffer_soma
    lw $s1, largura
    lw $s2, altura
    mul $s3, $s1, $s2 # s3 = total de pixels
    lw $s4, num_frames
    li $s1, 0           # s1 = contador

loop_calcula_media:
    bge $s1, $s3, fim_calcula_media
    lw $t0, 0($s0)
    div $t0, $s4
    mflo $t1
    sw $t1, 0($s0)
    addi $s1, $s1, 1
    addi $s0, $s0, 4
    j loop_calcula_media
fim_calcula_media:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

# ==============================================================================
# FUNCAO: escreve_imagem_saida
# Cria o arquivo PGM final e escreve o cabecalho e os pixels do buffer.
# ==============================================================================
escreve_imagem_saida:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    
    li $v0, 13
    la $a0, arquivo_saida
    li $a1, 1
    syscall
    move $s0, $v0 
    
    li $v0, 15
    move $a0, $s0
    la $a1, str_p2
    li $a2, 3
    syscall

    lw $a1, largura
    la $a2, buffer_leitura_num
    jal integer_to_string
    li $v0, 15
    move $a0, $s0
    la $a1, buffer_leitura_num
    move $a2, $v1
    syscall

    li $v0, 15
    move $a0, $s0
    la $a1, str_espaco
    li $a2, 1
    syscall

    lw $a1, altura
    la $a2, buffer_leitura_num
    jal integer_to_string
    li $v0, 15
    move $a0, $s0
    la $a1, buffer_leitura_num
    move $a2, $v1
    syscall

    li $v0, 15
    move $a0, $s0
    la $a1, str_newline
    li $a2, 1
    syscall

    li $v0, 15
    move $a0, $s0
    la $a1, str_maxval
    li $a2, 4
    syscall
    
    li $s1, 0
    la $s2, buffer_soma
    li $s4, 0
    lw $t0, largura
    lw $t1, altura
    mul $s3, $t0, $t1
loop_escreve_pixels:
    bge $s1, $s3, fim_escreve_pixels
    lw $a1, 0($s2)
    la $a2, buffer_leitura_num
    jal integer_to_string
    li $v0, 15
    move $a0, $s0
    la $a1, buffer_leitura_num
    move $a2, $v1
    syscall
    
    addi $s4, $s4, 1
    li $t5, 16
    rem $t6, $s4, $t5
    bne $t6, $zero, escreve_espaco
    
    li $v0, 15
    move $a0, $s0
    la $a1, str_newline
    li $a2, 1
    syscall
    j continua_loop_escrita

escreve_espaco:
    li $v0, 15
    move $a0, $s0
    la $a1, str_espaco
    li $a2, 1
    syscall

continua_loop_escrita:
    addi $s1, $s1, 1
    addi $s2, $s2, 4
    j loop_escreve_pixels
fim_escreve_pixels:

    li $v0, 16
    move $a0, $s0
    syscall
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    addi $sp, $sp, 32
    jr $ra

# ==============================================================================
# FUNCAO HELPER: read_integer_from_file
# Le caracteres de um arquivo ate encontrar um espaco/newline,
# convertendo a sequencia de digitos para um inteiro.
# ==============================================================================
read_integer_from_file:
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    move $s0, $a0
    li $s1, 0
read_char_loop:
    li $v0, 14
    move $a0, $s0
    la $a1, buffer_leitura_num
    li $a2, 1
    syscall
    beq $v0, $zero, end_read_integer
    lb $t1, buffer_leitura_num
    blt $t1, '0', end_read_integer
    bgt $t1, '9', end_read_integer
    subi $t1, $t1, '0'
    mul $s1, $s1, 10
    add $s1, $s1, $t1
    j read_char_loop
end_read_integer:
    move $v0, $s1
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# ==============================================================================
# FUNCAO HELPER: integer_to_string
# Converte um inteiro para uma string ASCII.
# ==============================================================================
integer_to_string:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    
    move $t0, $a1
    move $t1, $a2

    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

