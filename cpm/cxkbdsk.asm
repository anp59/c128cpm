	title	'C128 Kerberos disk support  11 Sep 2017'

	maclib	z80

	maclib	cxequ

	extrn	@dtbl		; DMA ram bank
	extrn	?dkmov$hl

	public	krb$is$present
	public	krb$sram$set$bank
	public	krb$buffer$to$dma

	public	kbdsk

	page
;
	CSEG		; place code in common memory

;
; Extended Disk Parameter Headers (XPDHs)
;
	dw	kbdsk$write
	dw	kbdsk$read
	dw	kbdsk$login
	dw	kbdsk$init
	db	0		; relative drive zero
	db	0		; format type byte
kbdsk:	
	dw	0			; TRANSLATE TABLE ADDRESS
	db	0,0,0,0,0,0,0,0,0	; BDOS SCRATCH AREA
     	db	0			; MEDIA FLAG
	dw	dpb$kb			; DISK PARAMETER BLOCK
	dw	00000h			; CHECKSUM VECTOR ALLOCATED BY
	dw	0FFFEh			; ALLOC VECTOR ALLOCATED BY GENCPM
	dw	0FFFEh			; DIRBCB
	dw	0FFFEh			; DTABCB
	dw	0FFFEh			; HASH ALLOC'D
	db	0			; HASH BANK


	;
	; DPB FOR Kerberos flash disk
	;

	; AU - 2048 bytes
	; SECTOR - 256 bytes
	; TRACK - 8 KiB bank
	; sectors/track - 32
	; 48 tracks
dpb$kb:
	DW	0064		; SPT - 128 BYTE RECORDS PER TRACK
	DB	04,0Fh		; BSH, BLM - BLOCK SHIFT AND MASK
	DB	01		; EXM - EXTENT MASK
	DW	00BFh		; DSM - MAXIMUM AU NUMBER
	DW	007Fh		; DRM - MAXIMUM DIRECTORY ENTRY NUMBER
	DB	0C0h,00h	; AL0, AL1 - ALLOC VECTOR FOR DIRECTORY
	DW	8000h		; CKS - CHECKSUM SIZE
	DW	0		; OFF - OFFSET FOR SYSTEM TRACKS
	DB	1,1		; PHYSICAL SECTOR SIZE SHIFT


kbdsk$init:
	call	krb$is$present
	ora	a
	rnz				; found Kerberos
	
;
;	device is missing, remove vector
;
	lxi	h,0			; remove vector to flash disk
	shld	@dtbl+('K'-'A')*2	; .. (drive K:)
kbdsk$login:
	ret

;
; disk READ and WRITE entry points.
; These entries are called with the following arguments:
;	relative drive number in @rdrv (8 bits)
;	absolute drive number in @adrv (8 bits)
;	disk transfer address in @dma (16 bits)
;	disk transfer bank	in @dbnk (8 bits)
;	disk track address	in @trk (16 bits)
;	disk sector address	in @sect (16 bits)
;	pointer to XDPH in <DE>
;
;   return with an error code in <A>
;	A=0	no errors
;	A=1	non-recoverable error
;	A=2	disk write protected
;	A=FF	media change detected
;

kbdsk$write:
	mvi	a,1			; set error
	ret

; hl - CPU address sector
erase$sector:
	push	h
	lhld	krb$flash$addr
	push	h
	call	prepare$write

	mvi	a,080h
	stax	d		; Cycle 3 - AAAh <- 80h
	mvi	a,0AAh
	stax	d		; Cycle 4 - AAAh <- AAh
	cma
	stax	b		; Cycle 5 - 555h <- 55h

	pop	h
	call	krb$flash$set$bank

	pop	h
	mvi	m,050h		; Cycle 6 - Sector base <- 50h

	; wait 25 ms - 50000 cycles at 2 MHz
	lxi	b,2800
erase$wait:
	dcx	b		; 6
	jrnz	erase$wait	; 12

	ret

prepare$write:
	call	krb$flash$set$bank$0
	lxi	b,08555h
	lxi	d,08AAAh

	mvi	a,0AAh
	stax	d		; Cycle 1 - AAAh <- AAh
	cma
	stax	b		; Cycle 2 - 555h <- 55h
	ret



; hl - CPU address sector
copy$sector$to$sram:
	push	h
	lxi	h,200h-16
	push	h
copy$next$bank:
	call	krb$sram$set$bank
	pop	d
	pop	h
	lxi	bc,krb$sram
copy$next$byte:
	mov	a,m
	outp	a
	inx	h
	inr	c
	jrnz	copy$next$byte
	inr	e
	rz
	push	h
	push	d
	xchg
	jr	copy$next$bank

kbdsk$read:
	lhld	@trk
	call	krb$disk$set$bank

	di

	lxi	h,force$map
	mov	a,m
	push	psw
	mvi	m,00111011b	; 00 - BANK 0, 11 - RAM, 10 - EXT ROM, 1 - RAM, 1 - RAM/ROM

	lda	@sect
	adi	080h
	mov	h,a
	xra	a
	mov	l,a
	lxi	d,@buffer
	lxi	b,0100h
	lddr

	pop	psw
	sta	force$map

	ei

krb$buffer$to$dma:
	lhld	@dma
	call	?dkmov$hl	; A=0 transfers data from buffer to local$DMA
	xra	a
	ret

krb$is$present:
	lda	krb$status
	ora	a
	rp

;	Detect kerberos SRAM

	xra	a
	lxi	b,krb$cart$ctl
	outp	a
	inr	c
	outp	a

	call	krb$sram$set$bank$0

	lxi	b,krb$sram
	xra	a
	outp	a

	lxi	hl,1FFh			; select bank 1FFh
	call	krb$sram$set$bank

	lxi	b,krb$sram
	dcr	a
	outp	a
	inp	e
	cmp	e
	jrnz	krb$missing

	call	krb$sram$set$bank$0

	lxi	b,krb$sram
	inp	a
	jrnz	krb$missing	; found Kerberos

	inr	a
	jr	krb$detect$done

krb$missing:
	xra	a
krb$detect$done:
	sta	krb$status
	ret

krb$flash$set$bank$0:
	lxi	hl,0
	jr	krb$flash$set$bank

;	hl - bank 0-47
krb$disk$set$bank:
	mov	a,l
	adi	8
	mov	l,a

;	hl - bank 0-1FF
krb$flash$set$bank:
	shld	krb$flash$addr
	jr	krb$set$banks

krb$sram$set$bank$0:
	lxi	hl,0			; select bank 0

;	hl - bank 0-1FF
krb$sram$set$bank:
	shld	krb$sram$addr
krb$set$banks:
	lxi	b,krb$flash$bank
	lxi	h,krb$flash$addr

	mov	a,m	; flash lo byte
	outp	a

	inx	h
	mov	a,m	; flash hi byte
	add	a

	inx	h
	mov	d,m	; sram lo byte
	inx	b
	outp	d

	inx	h
	ora	m
	inx	b
	outp	a
	ret

krb$flash$addr:
	dw	0h
krb$sram$addr:
	dw	0h

krb$status:
	db	0FFh
