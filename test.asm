.setcpu		"6502"
.autoimport	on

; iNES header
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02					; PRG-BANKS
	.byte	$01					; CHR-BANKS
	.byte	$01					; Vertical Mirror
	.byte	$00					; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

.segment "STARTUP"
.proc	Reset
	sei
	ldx	#$ff
	txs

; Screen off
	lda	#$00
	sta	$2000
	sta	$2001

; make palette table (BG only)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$10
copy_pal:
	lda	palettes, x
	sta	$2007
	inx
	dey
	bne	copy_pal

; write string to the name table
	lda	#$21
	sta	$2006
	lda	#$c9
	sta	$2006
	ldx	#$00
	ldy	#$0d
copy_map:
	lda	string, x
	sta	$2007
	inx
	dey
	bne	copy_map

; scroll setting
	lda	#$00
	sta	$2005
	sta	$2005

; screen on
	lda	#$08
	sta	$2000
	lda	#$1e
	sta	$2001

; loop infinite
	ldx #$00
mainloop:
	lda $2002
	bpl mainloop ; Waiting for vBlank
	; you can execute VRAM updating procedure while vBlank
	jmp	mainloop
.endproc

palettes:
	.byte	$0f, $00, $10, $20
	.byte	$0f, $06, $16, $26
	.byte	$0f, $08, $18, $28
	.byte	$0f, $0a, $1a, $2a

string:
	.byte	"HELLO, WORLD!"

.segment "VECINFO"
	.word	$0000
	.word	Reset
	.word	$0000

; pattern table
.segment "CHARS"
	.incbin	"test.chr" ; as BG
	.incbin	"test.chr" ; as sprite
