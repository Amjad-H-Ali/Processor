
%macro compare 2			; compare(a, b) => TRUE/FALSE in rax
	and		rax, 0
	or		rax, %2						
	not		rax				; l = ~b
	and		rax, %1			; l = a & ~b
	and		rdi, 0
	or		rdi, %1
	not		rdi				; r = ~a
	and		rdi, %2			; r = ~a & b
	or		rax, rdi		; (a & ~b) | (~a & b)
	lahf
	shr		rax, 14			; ZF
	and		rax,  0x1
%endmacro

; get portion of register
%macro get_reg_part 3		; get_reg_part(reg, start_bit, end_bit) => reg_part in rax
	compare 64, %3
	shl		rax, 63					; is64 = { 0xF..FF & (end_bit==64) } | { 0x0 & ~(end_bit==64) }
	sar		rax, 63
	and		rdi, 0
	or		rdi, 0xFFFFFFFFFFFFFFFF	; chunk_start = 0xF..F << start_bit
	shl		rdi, %2
	and		rsi, 0
	or		rsi, 0xFFFFFFFFFFFFFFFF	; chunk_end = ~(0xF..F << end_bit)
	shl		rsi, %3
	not		rsi
	or		rax, rsi				; chunk_end  = is_64 | chunk_end
	and		rax, rdi				; chunk = chunk_start & chunk_end
	and 	rax, %1					; reg_part = reg & chunk 
	shr		rax, %2					; reg_part = reg_part >> start_bit
%endmacro

; set portion of register
%macro set_reg 4 			; set_reg(reg, start_bit, end_bit, data) => new reg output in rax
	compare 64, %3
	shl		rax, 63					; is64 = { 0xF..FF & (end_bit==64) } | { 0x0 & ~(end_bit==64) }
	sar		rax, 63
	and		rdi, 0
	or		rdi, 0xFFFFFFFFFFFFFFFF	; chunk_start = 0xF..F << start_bit
	shl		rdi, %2
	and		rsi, 0
	or		rsi, 0xFFFFFFFFFFFFFFFF	; chunk_end = ~(0xF..F << end_bit)
	shl		rsi, %3
	not		rsi
	or		rax, rsi				; chunk_end  = is_64 | chunk_end
	and		rax, rdi				; chunk = chunk_start & chunk_end
	and		rdi, 0
	or		rdi, %4					; data = data << start_bit
	shl		rdi, %2
	and 	rdi, rax				; data = data & chunk
	not		rax						; chunk = ~chunk
	and		rax, %1					; reg = reg & chunk
	or		rax, rdi				; reg = reg | data
%endmacro

; logical AND for datatypes
%macro and_64 2				; and_64(boolean, data) =>  if (boolean) return data, if (~boolean) return 0. Output in rax.
	and		rax, 0
	or		rax, %1			; store boolean in rax
	shl 	rax, 63
	sar		rax, 63			; rax = 0xF..FF if bool is 1, or 0x0 if bool is 0
	and		rax, %2			; rax =  rax & data
%endmacro

; printf for debugging
%macro _p_ 1
	mov		[rel restore], rax
	mov		[rel restore+1*8], rbx
	mov		[rel restore+2*8], rcx
	mov		[rel restore+3*8], rdx
	mov 	[rel restore+4*8], rdi
	mov   	[rel restore+5*8], rsi
	movq	[rel restore+6*8], xmm0
	lea rdi, [rel format]
	and rsi, 0
	or	rsi, %1
	xor rax, rax
	call _printf
	mov		rax, [rel restore]
	mov		rbx, [rel restore+1*8]
	mov		rcx, [rel restore+2*8]
	mov		rdx, [rel restore+3*8]
	mov	 	rdi, [rel restore+4*8]
	mov	    rsi, [rel restore+5*8]
	movq 	xmm0, [rel restore+6*8]
%endmacro
section .data
 	format: db "%llu", 0xa, 0
	mem: dq 16777216 dup(0x4444444444444444) ; 0 ≤ CODE < 3,145,728 : 3,145,728 units of space each 8 Bytes wide
											; 3,145,728 ≤ STACK < 4,194,304 : 2,097,152 units of space each 4 Bytes wide
											; 4,194,304 ≤ HEAP < 8,388,608 : 8,388,608 units of space each 4 Bytes wide
											; 8,388,608 ≤ INTERUPT_TABLE < 8,388,864 : 256 units of space each 8 Bytes wide
											; 8,388,864 ≤ RESERVED < 16,777,216

											; xmm0 & 0xFFFFFFFF = RIP
											; xmm1 & 0xFFFFFFFF = RSP
											; xmm2 & 0xFFFFFFFF = RBP
											; xmm3 & 0xFFFFFFFF = RCF
											; xmm4 - xmm15 & 0xFFFFFFFF = R(4 - 15)
											; xmm0 -xmm15 & 0xFFFFFFFF00000000 =  R(16 - 31)
											; mm0 = MEM_START
											; mm1 = STACK_START
											; mm2 = INTERUPT_TABLE
	restore: dq 8 dup(0)    ; for debugging, used in _p_ macro
section .text
	global _main
	extern _printf
_main:
	push rbp
	mov rbp, rsp
	; and rsp, 0xFFFFFFFFFFFFFFE0

	; lea rdi, [rel mem]
	and rdi, 0
	movq xmm0, rdi						; init RIP with 0

						mov	r8, 128
						mov r13, 1300
						mov r12, 3
						shl r12, 28
						or 	r12, 0x10000
						mov r11, 0xFFFFFFFFFFFFFFFF

						


;----------------------------------------------------------------------------------------------------; 
;								                xR11[0,32]										     ;
;----------------------------------------------------------------------------------------------------; 

	; xR11[0,32] = 
	; 1 ; 			{ (xR8==69) (xR13[0,32]) } +
	; 2	; 			{ (xR8==194) ( (0 ≤ xR12[15,23] ≤ 2) (xR12[28,32]) + (xR12[15,23]==59) (xR12[32,40]) ) } +
	; 3	; 			{ (xR8==192) (xR12[15,23]==32) (xR13[32,64]) } +
	; 4	; 			{ ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32]) }


;----------------------------------------------------------------------------------------------------; 
;	(2)							   (0 ≤ xR12[15,23] ≤ 2) (xR12[28,32])							     ;
;----------------------------------------------------------------------------------------------------;

	and rcx, 0
	or	rcx, r12						
	shr rcx, 15				; rcx = icode (lower byte)
	and rdx, 0
	or	rdx,rcx				; rdx = icode (lower byte)
	and	rcx, 0x1			; rcx = 1st bit of icode
	and rdx, 0x2
	shr rdx, 1				; rdx = 2nd bit of icode
	compare	rcx, rdx		; rax = (1st bit == 2nd bit)
	not rax		
	and rdx, 0
	or	rdx, rax			; rdx = ~(1st bit == 2nd bit)
	and rcx, 0							
	or 	rcx, r12
	and rcx, 0x007F8000
	shr	rcx, 17				; rcx = icode omitting first 2 bits
	compare rcx, 0			; rax = (icode>>2 == 0)
	and rdx, rax			; rdx = ~(1st bit == 2nd bit) & (icode>>2 == 0)
	and rcx, 0
	or  rcx, r12
	and rcx, 0x007F8000
	shr rcx, 15
	compare rcx, 0			; rax = (icode==0)
	or rdx, rax				; rdx = {~(1st bit == 2nd bit) (icode>>2 == 0)} + {icode==0}
	and rcx, 0
	or rcx, r12
	shr rcx, 28
	and rcx, 0xF			; rcx = r12[28,32]
	and_64 rdx, rcx						
	and rdx, 0
	or	rdx, rax			; rdx = { ~(1st bit == 2nd bit) (icode>>2 == 0) + (icode==0) } { r12[28,32] }

;----------------------------------------------------------------------------------------------------; 
;			END					   (0 ≤ xR12[15,23] ≤ 2) (xR12[28,32])							     ;
;----------------------------------------------------------------------------------------------------;


;----------------------------------------------------------------------------------------------------; 
;	(2)							   (xR12[15,23]==59) (xR12[32,40])							         ;
;----------------------------------------------------------------------------------------------------;

	and	rcx, 0
	or	rcx, r12
	and rcx, 0x007F8000
	shr rcx, 15				; rcx = icode
	compare rcx, 59
	and rcx, 0
	or 	rcx, rax			; rcx = (icode==59)
	and rdi, 0
	or 	rdi, r12
	shr rdi, 32							
	and rdi, 0x000000FF		; rdi = r12[32,40]
	and_64 rcx, rdi			; rax =  (icode==59) (r12[32,40])

;----------------------------------------------------------------------------------------------------; 
;	        END						(xR12[15,23]==59) (xR12[32,40])							         ;
;----------------------------------------------------------------------------------------------------;

	or	rdx, rax			; rdx = (0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])


;----------------------------------------------------------------------------------------------------; 
;	(2)	  { (xR8==194) ( (0 ≤ xR12[15,23] ≤ 2) (xR12[28,32]) + (xR12[15,23]==59) (xR12[32,40]) ) }	 ;
;----------------------------------------------------------------------------------------------------;

	compare r8, 194
	and rcx, 0
	or	rcx, rax			; rcx = (icode==194)
	and_64 rcx, rdx			; rax = {r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])}
	and rdx, 0
	or	rdx, rax			; rdx = {r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])}

;----------------------------------------------------------------------------------------------------; 
;	(2)     END	                                   													 ;
;----------------------------------------------------------------------------------------------------;



;----------------------------------------------------------------------------------------------------; 
;	(1)	                           { (xR8==69) (xR13[0,32]) }	 									 ;
;----------------------------------------------------------------------------------------------------;

	compare	r8, 69
	and	rcx, 0
	or	rcx, rax	
	and	r13d, r13d					
	and_64 rcx, r13 		; rax = (r8==69)(r13[0,32])
						
;----------------------------------------------------------------------------------------------------; 
;	(1)	    END 									 												 ;
;----------------------------------------------------------------------------------------------------;

	or	rdx, rax			; rdx = {(r8==69)(r13[0,32])} +
							;		{r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])} 

;----------------------------------------------------------------------------------------------------; 
;	(3)	                           { (xR8==192) (xR12[15,23]==32) (xR13[32,64]) }	 				 ;
;----------------------------------------------------------------------------------------------------;


	and rcx, 0
	or	rcx, r12
	and rcx, 0x007F8000
	shr rcx, 15				; rcx = icode
	compare rcx, 32			; rax = (xR12[15,23]==32)
	and	rcx, 0
	or	rcx, rax			; rcx = (xR12[15,23]==32)
	compare r8, 192			; rax = (xR8==192)
	and rcx, rax			; rcx = (xR8==192) (xR12[15,23]==32)
	and rdi, 0
	or  rdi, r13
	shr rdi, 32							
	and	edi, edi 			; rdi = xR13[32,64]
	and_64 rcx, rdi 		; rax = (xR8==192) (xR12[15,23]==32) (xR13[32,64])			

;----------------------------------------------------------------------------------------------------; 
;	 (3)       END	                   												 		         ;
;----------------------------------------------------------------------------------------------------;

	or  rdx, rax			; rdx = {(r8==69)(r13[0,32])} +
							;		{r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])} +
							;		{ (xR8==192) (xR12[15,23]==32) (xR13[32,64]) } 

;----------------------------------------------------------------------------------------------------; 
;	 (4)       { ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32]) }	                   	             ;											 		         
;----------------------------------------------------------------------------------------------------;
	
	compare r8, 69			; rax = (xR8==69)
	and rsi, 0
	or	rsi, rax						
	not rsi					; rsi = ~(xR8==69)
	compare r8, 192
	not rax
	and rsi, rax			; rsi = ~(xR8==69) ~(xR8==192)
	compare r8, 194
	not rax
	and rsi, rax			; rsi = ~(xR8==69) ~(xR8==192) ~(xR8==194)
	and_64 rsi, r11			; rax = ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11)
	and eax, eax			; rax = ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32])

;----------------------------------------------------------------------------------------------------; 
;	 (4)       END	                   												 		         ;
;----------------------------------------------------------------------------------------------------;

	or rdx, rax				; rdx = {(r8==69)(r13[0,32])} +
							;		{r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])} +
							;		{ (xR8==192) (xR12[15,23]==32) (xR13[32,64]) } +
							;		{  ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32]) }

	and edx, edx			; ensure high bits are zeroed out		
	and rax, 0
	or	rax, 0xFFFFFFFFFFFFFFFF
	shl	rax, 32
	and	r11, rax			; xR11[0,32] = 0x0..00
	or	r11, rdx			; xR11[0,32] = {(r8==69)(r13[0,32])} +
							;		{r8==194} {(0≤icode≤2) (r12[28,32]) + (icode==59) (r12[32,40])} +
							;		{ (xR8==192) (xR12[15,23]==32) (xR13[32,64]) } +
							;		{  ~(xR8==69) ~(xR8==192) ~(xR8==194) (xR11[0,32]) }

;----------------------------------------------------------------------------------------------------; 
;		    END						           xR11[0,32]										     ;
;----------------------------------------------------------------------------------------------------; 



;----------------------------------------------------------------------------------------------------; 
;								                xR11[0,64]										     ;
;----------------------------------------------------------------------------------------------------; 

	; xR11[0,64] = 
	; 1 ;			{ (xR8==128) (RCF[3,5]==0) (RIP)mem } +
	; 2 ;			{ ~(xR8==128) (xR11) }


;----------------------------------------------------------------------------------------------------; 
;	(1)							   { (xR8==128) (RCF[3,5]==0) (RIP)mem }							 ;
;----------------------------------------------------------------------------------------------------;

	movq  rcx, xmm3			; xmm3 is RCF register		
	shr	  rcx, 3	
	and	  rcx, 0x00000003	; rcx = RCF[3,5] (PROGRAM_STATUS_REGISTER)
	compare rcx, 0			; rax = (RCF[3,5]==0)
	and   rcx, 0
	or	  rcx, rax			; rcx = (RCF[3,5]==0)
	compare r8, 128			; rax = (xR8==128)
	and	  rcx, rax			; rcx = (xR8==128) (RCF[3,5]==0)
	movq  rax, xmm0			; xmm0 is RIP register, rax = RIP
	lea	  rsi, [rel mem]	; rsi = base
	and   rdi, 0
	or    rdi, [rsi+rax]	; rdi = (RIP)mem
	and_64 rcx, rdi			; rax = (xR8==128) (RCF[3,5]==0) (RIP)mem

;----------------------------------------------------------------------------------------------------; 
;	(1)     END							 															 ;
;----------------------------------------------------------------------------------------------------;

	and rdx, 0
	or	rdx, rax			; rdx = (xR8==128) (RCF[3,5]==0) (RIP)mem

;----------------------------------------------------------------------------------------------------; 
;	 (2)                           { ~(xR8==128) (xR11)}	                   	 				     ;											 		        
;----------------------------------------------------------------------------------------------------;
	
	
	compare r8, 128				
	not rax
	and rsi, rax			; rsi = ~(xR8==128)
	and_64 rsi, r11			; rax = ~(xR8==128) (xR11)

;----------------------------------------------------------------------------------------------------; 
;	 (2)    END	                   												 		             ;
;----------------------------------------------------------------------------------------------------;

	or rdx, rax				; rdx = { (xR8==128) (RCF[3,5]==0) (RIP)mem } +
							;		{ ~(xR8==128) (xR11)}
	and r11, 0
	or	r11, rdx			; xR11[0,64] = 
							; 		{ (xR8==128) (RCF[3,5]==0) (RIP)mem } +
							; 		{ ~(xR8==128) (xR11) }

;----------------------------------------------------------------------------------------------------; 
;		    END						           xR11[0,64]										     ;
;----------------------------------------------------------------------------------------------------; 




;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 
;								                xR12[32,64]										     																								     ;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 

	; xR12[32,64] = 
	;1;				{ [xR8==224] [(xR12[15,23]==0) + (xR12[15,23]==9)] [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem } +
	;2;				{ (xR8==225) (xR12[15,23]==59) (xR12[32,64])mem } +
	;3;				{ (xR8==160) (INSTRUCTION_FORMAT_CORRECT) (xR11[8,40]) } +
	;4;				{ [xR8==167] [(xR11[0,8]==44) (xR11[13,45]) + (9 ≤ xR11[0,8] < 10) (xR11[18,50]) + (0 ≤ xR11[0,8] < 2) (xR11[27,59]) ] } +
	;5;				{ (xR8==194) ~(xR12[15,23]==33) ~(xR12[15,23]==59) ~(xR12[15,23]==60) (xR13[0,32]) } +
	;6;				{ [xR8==192] [(xR12[15,23]==24) (xR13[32,64]) (xR14[32,64]) + (xR12[15,23]==25) ((xR13[32,64]) + (xR14[32,64])) + (xR12[15,23]==26) ((xR13[32,64]) ~(xR14[32,64]) + ~(xR13[32,64]) (xR14[32,64])) + (xR12[15,23]==27) ((xR13[32,64]) << ((xR14[32,64]) (31))) + (xR12[15,23]==28) ((xR13[32,64]) >> ((xR14[32,64]) (31))) + (xR12[15,23]==29) ((xR13[32,64]) >>> ((xR14[32,64]) (31))) + (xR12[15,23]==51) ~(xR13[32,64])] }
	;7;				{ [(xR8==196) + (xR8==197)] [xR13[0,32]] } +
	;8;				{ ~(xR8==160) ~(xR8==167) ~(xR8==192) ~(xR8==194) ~(xR8==196) ~(xR8==197) ~(xR8==224) ~(xR8==225) (xR12[32,64]) }


;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 
;	(1)							   { [xR8==224] [(xR12[15,23]==0) + (xR12[15,23]==9)] [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem }							     								 ;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	
	
							; xR12[32,64] ≤ 0x2000000 (MEM_SIZE: 33,554,432 1 byte wide units )
							; [(xR12[32,64]) (0xFC000000 == 0)] [((xR12[32,64]) (0x2000000) == 0) + ((xR12[32,64]) (0x1FFFFFF) == 0)]
	and	rsi, 0
	or rsi, r12
	shr rsi, 32				; rsi = xR12[32,64]
	and rdx, 0
	or rdx, rsi				; rdx = xR12[32,64]
	and rdx, 0xFC000000		; MEM is 0x2000000 bytes wide. Thus, xR12[32,64] cannot contain number bigger than that.
	compare rdx, 0			; rax = (xR12[32,64]) (0xFC000000) == 0
	and rdx, 0
	or rdx, rax				; rdx = (xR12[32,64]) (0xFC000000) == 0
	and rcx, 0
	or rcx, rsi				; rcx = xR12[32,64]
	and rcx, 0x2000000		; rcx = (xR12[32,64]) (0x2000000)
	compare rcx, 0x2000000  ; rax = ((xR12[32,64]) (0x2000000) == 0)
	and rcx, 0
	or rcx, rax				; rcx = ((xR12[32,64]) (0x2000000) == 0)
	and rsi, 0x1FFFFFF		; rsi = (xR12[32,64]) (0x1FFFFFF)
	compare rsi, 0			; rax = ((xR12[32,64]) (0x1FFFFFF) == 0)
	or rcx, rax				; rcx = [((xR12[32,64]) (0x2000000) == 0) + ((xR12[32,64]) (0x1FFFFFF) == 0)]
	and rdx, rcx			; rdx = [(xR12[32,64]) (0xFC000000 == 0)] [((xR12[32,64]) (0x2000000) == 0) + ((xR12[32,64]) (0x1FFFFFF) == 0)]
							; rdx = xR12[32,64] ≤ 0x2000000
	and rcx, 0
	or rcx,  r12
	shr rcx, 32				; rcx = xR12[32,64]
	and_64 rdx, rcx			; rax = (xR12[32,64] ≤ 0x2000000) xR12[32,64] (either 0 or xR12[32,64] if within boundary)
	movq rsi, mm0			; rsi = MEM_START, mm0 is MEM_START
	and rcx, 0
	or rcx, [rsi+rax]		; rcx = [xR12[32,64]]mem or [0]mem
	and_64 rdx, rcx			; rax = [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem
	and rdx, 0				
	or rdx, rax				; rdx = [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem
	and rcx, 0
	or	rcx, r12
	and rcx, 0x007F8000
	shr rcx, 15				; rcx = icode
	compare rcx, 0			; rax = (icode == 0)
	and rsi, 0
	or rsi, rax				; rsi = (icode == 0)
	compare rcx, 9			; rax = (icode == 9)
	or rsi, rax				; rsi = (icode == 0) + (icode == 9)
	and rdx, rsi			; rdx = [(xR12[15,23]==0) + (xR12[15,23]==9)] [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem
	compare r8, 224			; rax = (xR8==224)
	and rdx, rax			; rdx = [xR8==224] [(xR12[15,23]==0) + (xR12[15,23]==9)] [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 
;			END					   { [xR8==224] [(xR12[15,23]==0) + (xR12[15,23]==9)] [MEM_MIN ≤ xR12[32,64] ≤ MEM_MAX] [xR12[32,64]]mem }							    								 ;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 
;		    END						           xR12[32,64]										    																									 ;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------; 



	_p_ r11
	; xor rsi, rsi
	; lea rax, [rel mem]
	; mov r9, 10
	; movq xmm0, r9
	; movq r9, xmm1
	; add rax, 0
	; or byte [rel mem], 100
	; or  sil, [rel rax]
	; mov rax, 0
	
	

	mov rsp, rbp
	pop rbp
	ret

