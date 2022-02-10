;Digitalni sat

.model  small  ;memorijski model sa malom memorijom

nacrtaj_red            macro   _red,   _kol1,  _kol2,  _boja
            local   l1
            mov     ah,     0ch         ;nacrtaj piksel
            mov     bh,     0           ;stranica
            mov     al,     _boja       ;boja
            mov     cx,     _kol1       ;kolona
            mov     dx,     _red        ;red
    l1:     int     10h                 ;nacrtaj
            inc     cx                  ;sledeca kolona
            cmp     cx,     _kol2       ;uporedi
            jle     l1                  ;kraj?
            endm

nacrtaj_kolonu         macro   _kol,   _red1,  _red2,  _boja
            local   l2
            mov     ah,     0ch         ;nacrtaj piksel
            mov     bh,     0           ;stranica
            mov     al,     _boja       ;boja
            mov     cx,     _kol        ;kolona
            mov     dx,     _red1       ;red
    l2:     int     10h                 ;nacrtaj
            inc     dx                  ;sledeci red
            cmp     dx,     _red2       ;uporedi
            jle     l2                  ;kraj?
            endm

.stack 100h ;stek segment

.data    ;segment podataka
kol_shift         dw      0               ;pomeri kolonu
red_shift         dw      0               ;pomeri red
tmpkol1         dw      0               ;privremena vrednost kolone
tmpkol2         dw      0               ;privremena vrednost kolone
tmpkol3         dw      0               ;privremena vrednost kolone
tmpred1         dw      0               ;privremena vrednost reda
tmpred2         dw      0               ;privremena vrednost reda
tmpred3         dw      0               ;privremena vrednost reda
fontboja        db      31              ;boja fonta
vreme_buf       db      '00:00:00$'     ;vremenski buffer sat:min:sek
novi_vektor          dw      ?, ?
stari_vektor         dw      ?, ?

.CODE    ;segment koda
konvertuj             proc
;konvertujs u ascii
;ulaz al = broj
;izlaz ax = ascii cifre
xor     ah,     ah      
mov     dl,     10      ;deli ax sa 10
div     dl              ;ah = ostatak, al = kolicnik
or      ax,     3030h   ;konvertuj u ascii
               ret
konvertuj             endp

pokupi_vreme            proc
;pokupi vreme i skladisti ascii cifre u vremenski buffer
;input bx = adresa od vremenskog buffer-a
            mov     ah,     2ch     ;pokupi vreme
            int 21h                 ;ch = hr, cl = min, dh = sec

;konvertuj sate u ascii i skladisti
            mov     al,     ch      ;sat


    l6:     call    konvertuj         ;konvertuj u ascii
            mov     [bx],   ax        ;skladisti
;konvertuj minute u ascii i skladisti
            mov     al,     cl      ;minute
            call    konvertuj       ;konvertuj u ascii
            mov     [bx+3], ax      ;skladisti
;konvertuj sekunde u ascii i skladisti
            mov     al,     dh      ;sekunde
            call    konvertuj       ;konvertuj u ascii
            mov     [bx+6], ax      ;skladisti

            ret
pokupi_vreme            endp

vreme_int            proc
;prekid rutina aktivirana tajmerom
            push    ds                  
            mov     ax,     @data       
            mov     ds,     ax
;pokupi novo vreme
            lea     bx,     vreme_buf       ;bx pokazuje na vremenski buffer
            call    pokupi_vreme            ;skladisti vreme u buffer
;stampaj prvu cifru od sata
            mov     red_shift,    65     ;pomeranje reda
            mov     kol_shift,    30     ;pomeranje kolone
            call    stampaj_crno
            mov     al,     '0'
            cmp     [bx],   al
            jne     h11
            call    stampaj0
            jmp     h1d
    h11:    inc     al
            cmp     [bx],   al
            jne     h12
            call    stampaj1
            jmp     h1d
    h12:    inc     al
            cmp     [bx],   al
            jne     h13
            call    stampaj2
            jmp     h1d
    h13:    inc     al
            cmp     [bx],   al
            jne     h14
            call    stampaj3
            jmp     h1d
    h14:    inc     al
            cmp     [bx],   al
            jne     h15
            call    stampaj4
            jmp     h1d
    h15:    inc     al
            cmp     [bx],   al
            jne     h16
            call    stampaj5
            jmp     h1d
    h16:    inc     al
            cmp     [bx],   al
            jne     h17
            call    stampaj6
            jmp     h1d
    h17:    inc     al
            cmp     [bx],   al
            jne     h18
            call    stampaj7
            jmp     h1d
    h18:    inc     al
            cmp     [bx],   al
            jne     h19
            call    stampaj8
            jmp     h1d
    h19:    call    stampaj9
    h1d:
;stampaj drugu cifru od sata
            mov     red_shift,    65
            mov     kol_shift,    70
            call    stampaj_crno
            mov     al,     '0'
            cmp     [bx+1], al
            jne     h21
            call    stampaj0
            jmp     h2d
    h21:    inc     al
            cmp     [bx+1], al
            jne     h22
            call    stampaj1
            jmp     h2d
    h22:    inc     al
            cmp     [bx+1], al
            jne     h23
            call    stampaj2
            jmp     h2d
    h23:    inc     al
            cmp     [bx+1], al
            jne     h24
            call    stampaj3
            jmp     h2d
    h24:    inc     al
            cmp     [bx+1], al
            jne     h25
            call    stampaj4
            jmp     h2d
    h25:    inc     al
            cmp     [bx+1], al
            jne     h26
            call    stampaj5
            jmp     h2d
    h26:    inc     al
            cmp     [bx+1], al
            jne     h27
            call    stampaj6
            jmp     h2d
    h27:    inc     al
            cmp     [bx+1], al
            jne     h28
            call    stampaj7
            jmp     h2d
    h28:    inc     al
            cmp     [bx+1], al
            jne     h29
            call    stampaj8
            jmp     h2d
    h29:    call    stampaj9
    h2d:
;stampaj dve tacke
            mov     red_shift,    65
            mov     kol_shift,    100
            call    stampaj_dvotacku
;stampaj prvu cifru minuta
            mov     red_shift,    65
            mov     kol_shift,    120
            call    stampaj_crno
            mov     al,     '0'
            cmp     [bx+3], al
            jne     m11
            call    stampaj0
            jmp     m1d
    m11:    inc     al
            cmp     [bx+3], al
            jne     m12
            call    stampaj1
            jmp     m1d
    m12:    inc     al
            cmp     [bx+3], al
            jne     m13
            call    stampaj2
            jmp     m1d
    m13:    inc     al
            cmp     [bx+3], al
            jne     m14
            call    stampaj3
            jmp     m1d
    m14:    inc     al
            cmp     [bx+3], al
            jne     m15
            call    stampaj4
            jmp     m1d
    m15:    inc     al
            cmp     [bx+3], al
            jne     m16
            call    stampaj5
            jmp     m1d
    m16:    inc     al
            cmp     [bx+3], al
            jne     m17
            call    stampaj6
            jmp     m1d
    m17:    inc     al
            cmp     [bx+3], al
            jne     m18
            call    stampaj7
            jmp     m1d
    m18:    inc     al
            cmp     [bx+3], al
            jne     m19
            call    stampaj8
            jmp     m1d
    m19:    call    stampaj9
    m1d:
;stampaj drugu cifru od minuta
            mov     red_shift,    65
            mov     kol_shift,    160
            call    stampaj_crno
            mov     al,     '0'
            cmp     [bx+4], al
            jne     m21
            call    stampaj0
            jmp     m2d
    m21:    inc     al
            cmp     [bx+4], al
            jne     m22
            call    stampaj1
            jmp     m2d
    m22:    inc     al
            cmp     [bx+4], al
            jne     m23
            call    stampaj2
            jmp     m2d
    m23:    inc     al
            cmp     [bx+4], al
            jne     m24
            call    stampaj3
            jmp     m2d
    m24:    inc     al
            cmp     [bx+4], al
            jne     m25
            call    stampaj4
            jmp     m2d
    m25:    inc     al
            cmp     [bx+4], al
            jne     m26
            call    stampaj5
            jmp     m2d
    m26:    inc     al
            cmp     [bx+4], al
            jne     m27
            call    stampaj6
            jmp     m2d
    m27:    inc     al
            cmp     [bx+4], al
            jne     m28
            call    stampaj7
            jmp     m2d
    m28:    inc     al
            cmp     [bx+4], al
            jne     m29
            call    stampaj8
            jmp     m2d
    m29:    call    stampaj9
    m2d:
;stampaj razmak
            mov     red_shift,    80
            mov     kol_shift,    190
;stampaj prvu cifru od sekundi
            mov     red_shift,    90
            mov     kol_shift,    200
            call    stampaj_crnosec
            mov     al,     '0'
            cmp     [bx+6], al
            jne     s11
            call    stampajsec0
            jmp     s1d
    s11:    inc     al
            cmp     [bx+6], al
            jne     s12
            call    stampajsec1
            jmp     s1d
    s12:    inc     al
            cmp     [bx+6], al
            jne     s13
            call    stampajsec2
            jmp     s1d
    s13:    inc     al
            cmp     [bx+6], al
            jne     s14
            call    stampajsec3
            jmp     s1d
    s14:    inc     al
            cmp     [bx+6], al
            jne     s15
            call    stampajsec4
            jmp     s1d
    s15:    inc     al
            cmp     [bx+6], al
            jne     s16
            call    stampajsec5
            jmp     s1d
    s16:    inc     al
            cmp     [bx+6], al
            jne     s17
            call    stampajsec6
            jmp     s1d
    s17:    inc     al
            cmp     [bx+6], al
            jne     s18
            call    stampajsec7
            jmp     s1d
    s18:    inc     al
            cmp     [bx+6], al
            jne     s19
            call    stampajsec8
            jmp     s1d
    s19:    call    stampajsec9
    s1d:
;stampaj drugu cifru sekundi
            mov     red_shift,    90
            mov     kol_shift,    220
            call    stampaj_crnosec
            mov     al,     '0'
            cmp     [bx+7], al
            jne     s21
            call    stampajsec0
            jmp     s2d
    s21:    inc     al
            cmp     [bx+7], al
            jne     s22
            call    stampajsec1
            jmp     s2d
    s22:    inc     al
            cmp     [bx+7], al
            jne     s23
            call    stampajsec2
            jmp     s2d
    s23:    inc     al
            cmp     [bx+7], al
            jne     s24
            call    stampajsec3
            jmp     s2d
    s24:    inc     al
            cmp     [bx+7], al
            jne     s25
            call    stampajsec4
            jmp     s2d
    s25:    inc     al
            cmp     [bx+7], al
            jne     s26
            call    stampajsec5
            jmp     s2d
    s26:    inc     al
            cmp     [bx+7], al
            jne     s27
            call    stampajsec6
            jmp     s2d
    s27:    inc     al
            cmp     [bx+7], al
            jne     s28
            call    stampajsec7
            jmp     s2d
    s28:    inc     al
            cmp     [bx+7], al
            jne     s29
            call    stampajsec8
            jmp     s2d
    s29:    call    stampajsec9
    s2d:

            pop     ds
            iret
vreme_int            endp

setup_int           proc
;cuva stari vektor i postavlja novi vektor
;input: al = prekid number
;       di = adresa od buffera starog vektora
;       si = adresa od buffera novog vektora
;cuva stari prekidni vektor
            mov     ah,     35h     ;35h pokupis vektor
            int     21h             ;es:bx = vektor
            mov     [di],   bx      ;cuva offset
            mov     [di+2], es      ;cuva segment
;setapuje novi vektor
            mov     dx,     [si]    ;dx sadrzi offset
            push    ds              ;cuva ds
            mov     ds,     [si+2]  ;ds sadrzi broj segmenta
            mov     ah,     25h     ;25h setuje vektor
            int     21h
            pop     ds              ;reskladisti ds
            ret
setup_int           endp

main                proc
            mov     ax,     @data
            mov     ds,     ax          ;initialize ds

;Setuje graficki mod u vga 320x200 256 boja
            mov     ah,     0           ;setuje mode
            mov     al,     13h         ;u 320x200 256
            int     10h

;setup prekid rutina
;postavlja segment:offset od vreme_int u novi_vektor
            mov     novi_vektor,    offset  vreme_int
            mov     novi_vektor+2,  seg     vreme_int
            lea     di,     stari_vektor     
            lea     si,     novi_vektor     ;si pokazuje na novi vektor
            mov     al,     1ch         ;tajmerski prekid
            call    setup_int           ;setup novi prekid vektor
;citanje tastature
            mov     ah,     0
            int     16h
;reskladisti stari prekid vektor
            lea     di,     novi_vektor     
            lea     si,     stari_vektor     
            mov     al,     1ch         ;tajmerski prekid
            call    setup_int           ;reskladisti stari vektor
;reset u text mode
            mov     ah,     0
            mov     al,     3
            int     10h
;exit
            mov     ah,     4ch     ;return
            int 21h                 ;u dos
main                endp

stampaj0              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja  
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
        
            ret
stampaj0              endp

stampajsec0              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             
               ret
stampajsec0              endp

stampaj1              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    20
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

              ret
stampaj1              endp

stampajsec1              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    10
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

               ret
stampajsec1              endp

stampaj2              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred2,    tmpred3,    fontboja   
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred2,    fontboja
             

              ret
stampaj2              endp

stampajsec2              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred2,    tmpred3,    fontboja 
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred2,    fontboja
             

               ret
stampajsec2              endp

stampaj3              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

             ret
stampaj3              endp

stampajsec3              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampajsec3              endp

stampaj4              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja 
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampaj4              endp

stampajsec4              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja

            ret
stampajsec4              endp

stampaj5              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred2,    tmpred3,    fontboja

            ret
stampaj5              endp

stampajsec5              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred2,    tmpred3,    fontboja

            ret
stampajsec5              endp

stampaj6              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred2,    tmpred3,    fontboja

            ret
stampaj6              endp

stampajsec6              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred2,    tmpred3,    fontboja

             
            ret
stampajsec6              endp


stampaj7              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampaj7              endp

stampajsec7              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampajsec7              endp

stampaj8              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja     
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampaj8              endp

stampajsec8              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    fontboja           
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampajsec8              endp


stampaj9              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja          
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampaj9              endp

stampajsec9              proc

            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja       
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    fontboja
             

            ret
stampajsec9              endp


stampaj_dvotacku         proc

            mov     ax,         kol_shift
            mov     tmpkol1,    8
            add     tmpkol1,    ax
            mov     tmpkol2,    12
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    16
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja             
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred2,    fontboja
             

            mov     ax,         kol_shift
            mov     tmpkol1,    8
            add     tmpkol1,    ax
            mov     tmpkol2,    12
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    30
            add     tmpred1,    ax
            mov     tmpred2,    34
            add     tmpred2,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    fontboja
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred2,    fontboja           
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred2,    fontboja
            

            ret
stampaj_dvotacku         endp

stampaj_crno         proc
            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    30
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    20
            add     tmpred2,    ax
            mov     tmpred3,    50
            add     tmpred3,    ax
            nacrtaj_red       tmpred1,    tmpkol1,    tmpkol2,    0
            nacrtaj_red       tmpred2,    tmpkol1,    tmpkol2,    0
            nacrtaj_red       tmpred3,    tmpkol1,    tmpkol2,    0
            nacrtaj_kolonu    tmpkol1,    tmpred1,    tmpred3,    0
            nacrtaj_kolonu    tmpkol2,    tmpred1,    tmpred3,    0

            ret
stampaj_crno         endp

stampaj_crnosec         proc
            mov     ax,         kol_shift
            mov     tmpkol1,    0
            add     tmpkol1,    ax
            mov     tmpkol2,    15
            add     tmpkol2,    ax
            mov     ax,         red_shift
            mov     tmpred1,    0
            add     tmpred1,    ax
            mov     tmpred2,    10
            add     tmpred2,    ax
            mov     tmpred3,    25
            add     tmpred3,    ax
            nacrtaj_red        tmpred1,    tmpkol1,    tmpkol2,    0
            nacrtaj_red        tmpred2,    tmpkol1,    tmpkol2,    0
            nacrtaj_red        tmpred3,    tmpkol1,    tmpkol2,    0
            nacrtaj_kolonu     tmpkol1,    tmpred1,    tmpred3,    0
            nacrtaj_kolonu     tmpkol2,    tmpred1,    tmpred3,    0
            ret
stampaj_crnosec         endp


end main
