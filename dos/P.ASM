


son_1   db 90 dup (3)
	db -1

;       db 48,48,48,48,48,52,52,52,52,52,55,55,55,55,55
;       db 60,60,60,60,60,60,60,60,60,60
;       db 36,36,36,36,36,36,36,36,36,36,-1

vit equ 103
BEG EQU 100
EEND EQU 600
PAS EQU 20
son_2   glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>

	db -1


son_3   glis <130, 700 ,600>
	db -1


son_4   db 10 dup (20)
	db 10 dup (25)
	db 20 dup (0)
	db 10 dup (29)
	db 10 dup (0)
	db 10 dup (20)
	db 10 dup (25)
	db 10 dup (0)
	db 10 dup (20)
	db 10 dup (25)
	db 10 dup (29)
	db 10 dup (20)
	db 10 dup (25)
	db -1


son_8   glis <109, 400, 900>
	db   3 dup (0)
	glis <109, 400, 900>
	db   10 dup (0)
	glis <109, 400, 900>
	db   20 dup (0)
	glis <109, 400, 900>
	db -1

son_7   db -1


son_6   db 5 dup (20)
	db 5 dup (15)
	db -1



son_5   glis <vit, beg + 10 * PAS ,Eend + 10 * PAS>
	glis <vit, beg + 9 * PAS ,Eend + 9 * PAS>
	glis <vit, beg + 8 * PAS ,Eend + 8 * PAS>
	glis <vit, beg + 7 * PAS ,Eend + 7 * PAS>
	glis <vit, beg + 6 * PAS ,Eend + 6 * PAS>
	glis <vit, beg + 5 * PAS ,Eend + 5 * PAS>
	glis <vit, beg + 4 * PAS ,Eend + 4 * PAS>
	glis <vit, beg + 3 * PAS ,Eend + 3 * PAS>
	glis <vit, beg + 2 * PAS ,Eend + 2 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	db -1

	db -1

son_9   db 8 dup (36)
	db 8 dup (40)
	db 8 dup (43)
	db 8 dup (48)
	db -1


son_27  glis <103,33, 100>
	glis <103,50, 200>
	glis <103,100,300>
	glis <103,200,400>
	glis <103,300,500>
	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>

	glis <103,50, 200>
	glis <103,100,300>
	glis <103,200,400>
	glis <103,300,500>
	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>

	glis <103,200,400>
	glis <103,300,500>
	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>

	glis <103,300,500>
	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>
	db -1

son_20  glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	glis <101,175,225>
	glis <101,200,250>
	glis <101,225,275>
	glis <101,250,300>
	glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	db -1


son_11  glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>

	db -1

son_12  glis <130,700,300>
	glis <130,700,300>
	glis <130,300,700>
	db -1

son_13  db 35 dup (10)
	db 5  dup (0)

	db 10 dup (15)
	db 10 dup (14)
	db 10 dup (17)
	db 10 dup (10)
	db 10 dup (14)
	db 35 dup (15)
	db 5  dup (0)

	db 10 dup (15)
	db 5 dup (14)
	db 5 dup (15)
	db 5 dup (17)
	db 5 dup (15)

	db 5 dup (10)
	db 5 dup (12)
	db 5 dup (14)
	db 5 dup (10)

	db 20 dup (15)
	db -1

	db 10 dup (10)
	db 10 dup (14)
	db 40 dup (15)


	db -1

son_14  db 35 dup (30)
	db 5  dup (0)
	db 8 dup (32)
	db 2 dup (0)
	db 8 dup (30)
	db 2 dup (0)
	db 8 dup (28)
	db 2 dup (0)
	db 8 dup (27)
	db 2 dup (0)
	db 8 dup (28)
	db 2 dup (0)
	db 60 dup (30)

	db -1

son_15  glis <115,150,400>
	db 14 dup (0)
	glis <115,150,400>
	db 20 dup (0)
	glis <115,150,400>
	db -1

son_16  glis <113,4000, 4600>
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	db 20 dup (0)
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	db 20 dup (0)
	glis <113,4000, 4600>
	glis <113,4000, 4600>
	db 10 dup (0)
	glis <113,4000, 4600>
	db -1

son_17  db 23,23,23,23,20,20,20,20
	db -1

son_18  db 12 dup (40)
	db 2 dup (0)
	db 12 dup (37)

	db 25 dup (0)

	db 12 dup (40)
	db 2 dup (0)
	db 12 dup (37)

	db 25 dup (0)

	db -1


son_19  glis <101,25,75>
	glis <101,50,100>
	glis <101,75,125>
	glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	db -1

VIT1 equ 103
BEG1 EQU 100
EEND1 EQU 400
PAS1 EQU 40
son_24  glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit1, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit1, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit1, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit1, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit1, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit1, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit1, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit1, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit1, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit1, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit1, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit1, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit1, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>

	db -1


son_22  glis <vit1, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>
	glis <vit1, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit1, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit1, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit1, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit1, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit1, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit1, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit1, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit1, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit1, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit1, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit1, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit1, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	db -1

son_67  glis <vit1, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>
	glis <vit1, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit1, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit1, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit1, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit1, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit1, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit1, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit1, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit1, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit1, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit1, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit1, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit1, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>

	db -1

son_21  db 25,25,25,25
	db -1


;       db 8 dup (15)
;       db 8 dup (10)
	db -1

son_23  db -1


son_25  db 40,-1
son_26  db 60,-1

son_28  glis <119, 400,1800>
	db -1

son_29	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	glis <106,201,300>
	db  -1



son_31  glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	glis <101,175,225>
	glis <101,200,250>
	glis <101,225,275>
	glis <101,250,300>
	glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	db -1

son_32	glis <101,325,375>
	glis <101,300,350>
	glis <101,275,325>
	glis <101,250,300>
	glis <101,225,275>
	glis <101,200,250>
	glis <101,175,225>
	glis <101,150,200>
	glis <101,125,175>
	glis <101,100,150>
	db -1

son_33	db -1
son_34	db -1

son_35	glis <108,100,1000>
	db -1

son_36	db -1
son_37	db -1
son_38	db -1

son_40	db -1
son_41	db -1
son_42	db -1
son_43	db -1
son_44	db -1
son_45	db -1
son_46	db -1
son_47	db -1
son_48	db -1
son_49	db -1


son_50  db -1
son_51  glis <105,100,150>
	glis <105,150,100>
	db -1

son_52  glis <140,400,500>
	db  0
	glis <140,400,500>
	glis <150,500,360>
	db -1



son_53	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	glis <112,2000,2200>
	db -1

son_54	glis <112,120,100>
	db -1


son_61	glis <101,100,120>
son_55  glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	glis <101,175,225>
	glis <101,200,250>
	glis <101,225,275>
	glis <101,250,300>
	glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	db -1

son_57  glis <101,100,150>
son_56	glis <101,325,375>
	glis <101,300,350>
	glis <101,275,325>
	glis <101,250,300>
	glis <101,225,275>
	glis <101,200,250>
	glis <101,175,225>
	glis <101,150,200>
	glis <101,125,175>
	glis <101,100,150>
	db -1


son_58	glis <120,400,400>
	db 20 dup (0)
	glis <140,400,400>
	db -1


son_59	db -1

son_60	db -1

son_62	glis <115,400,400>
	db 10 dup (0)
	glis <190,400,400>
	db -1

son_63	glis <150,1000,800>
	glis <102,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	glis <103,500,400>
	db -1

son_64	glis <170,300,301>
	db -1

son_65	glis <150,1000,999>
	glis <130,1000,600>
	db -1

son_66	glis <102,150,200>
	glis <102,150,200>
	db -1

son_68  glis <170,800,500>
	db -1

son_69  glis <102,33, 100>
	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>

	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>
	glis <102,700,900>

	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,700,900>
	glis <102,800,1000>

	glis <102,600,800>
	glis <102,700,900>
	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>

	glis <102,700,900>
	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>
	glis <102,1300,1500>

	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>
	glis <102,1300,1500>
	glis <102,1400,1600>

	db -1


son_70	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>
	glis <102,700,900>

	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>
	glis <102,700,900>

	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>
	glis <102,700,900>
	db -1

vit2 equ 102
son_71  glis <vit2, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>
	glis <vit2, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit2, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit2, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit2, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit2, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit2, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit2, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit2, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit2, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit2, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit2, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit2, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit2, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit2, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	db -1

son_72	glis <103, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <103, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <103, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <103, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <103, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <103, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>
	db -1

son_73  glis <150,2000,2100>
	DB -1

son_74	db -1
	db -1

son_75	db 30,30,30,30
	db 31,31,31,31
	db 30,30,30,30
	db -1

son_76	db 29,29,29,29
	db 30,30,30,30
	db 31,31,31,31
	db -1

son_77	db 33,33,33,33
	db 32,32,32,32
	db 33,33,33,33
	db -1

son_78  db 32,32,31,31,30,30,29,30,30,31,31
	db -1

son_79	db 32,31,32,33,32,29,30,31,32,32,31
	db -1

son_80	db -1
son_81	db -1
son_82	db -1
son_83	db -1
son_84	db -1
son_85	db -1
son_86	db -1
son_87  db -1
son_88  db -1
son_89  db -1
son_90  db -1

son_10	glis <103,300,500>
	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>

	glis <103,400,600>
	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>
	glis <103,1000,1200>

	glis <103,500,700>
	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>
	glis <103,1000,1200>
	glis <103,1100,1300>

	glis <103,600,800>
	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>
	glis <103,1000,1200>
	glis <103,1100,1300>
	glis <103,1200,1400>

	glis <103,700,900>
	glis <103,800,1000>
	glis <103,900,1100>
	glis <103,1000,1200>
	glis <103,1100,1300>
	glis <103,1200,1400>
	glis <103,1300,1500>

	glis <103,800,1000>
	glis <103,900,1100>
	glis <103,1000,1200>
	glis <103,1100,1300>
	glis <103,1200,1400>
	glis <103,1300,1500>
	glis <103,1400,1600>


	db -1



DO EQU 0
RE EQU 2
MI EQU 4
FA EQU 5
SOL EQU 7
LA EQU 9
SSI EQU 11

OCTAVE EQU 12

son_91  DB      20 DUP (OCTAVE*3+DO)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+DO)
	DB      10/4 DUP (0)
	DB      40 DUP (OCTAVE*3+DO)
	DB      20/4 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      10/4 DUP (0)
	DB      40 DUP (OCTAVE*3+RE)
	DB      20/4 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+FA)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+SOL)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+DO)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*2+SSI)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+DO)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      10/4 DUP (0)
	DB      20 DUP (OCTAVE*2+SOL)
	DB      10/4 DUP (0)
	DB      -1




son_92  DB      40 DUP (OCTAVE*3+DO)
	DB      2 DUP (0)
	DB      20 DUP (OCTAVE*3+DO)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      40 DUP (OCTAVE*3+DO)
	DB      2 DUP (0)
	DB      20 DUP (OCTAVE*3+DO)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      30 DUP (OCTAVE*3+MI)
	DB      2 DUP (0)
	DB      -1

	EVEN


son_93  DB      10 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*2+SOL)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+FA)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)

	DB      10 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*2+SOL)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+MI)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      20 DUP (OCTAVE*3+RE)
	DB      1 DUP (0)
	DB      10 DUP (OCTAVE*3+DO)
	DB      1 DUP (0)
	db      -1


son_94  DB      20 DUP (OCTAVE*3+MI)
	DB      10 DUP (OCTAVE*3+RE)
	DB      20 DUP (OCTAVE*3+DO)
	db      0,0
	DB      10 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+RE)
	DB      10 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+RE)
	DB      20 DUP (OCTAVE*3+MI)
	DB      10 DUP (OCTAVE*3+DO)
	DB      20 DUP (OCTAVE*3+MI)
	DB      10 DUP (OCTAVE*3+RE)
	DB      20 DUP (OCTAVE*3+DO)
	db      0,0
	DB      10 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+RE)
	DB      10 DUP (OCTAVE*3+MI)
	DB      10 DUP (OCTAVE*3+RE)
	DB      40 DUP (OCTAVE*3+DO)
	db      -1

son_95  DB      10 DUP (OCTAVE*3+DO)
	DB      20 DUP (OCTAVE*3+FA)
	DB      10 DUP (OCTAVE*3+SOL)
	DB      20 DUP (OCTAVE*3+LA)
	DB      10 DUP (OCTAVE*3+SOL)
	DB      30 DUP (OCTAVE*3+FA)
	DB      20 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+DO)
	DB      20 DUP (OCTAVE*3+RE)
	DB      10 DUP (OCTAVE*3+RE)
	DB      10 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+DO)
	DB      10 DUP (OCTAVE*3+DO)
	DB      20 DUP (OCTAVE*3+RE)
	DB      10 DUP (OCTAVE*3+RE)
	DB      20 DUP (OCTAVE*3+DO)
	db      -1

son_96  DB      20 DUP (OCTAVE*2+SOL)
	DB      20 DUP (OCTAVE*2+LA)
	DB      20 DUP (OCTAVE*2+SSI)
	DB      20 DUP (OCTAVE*2+SOL)
	db      0,0
	DB      20 DUP (OCTAVE*2+SOL)
	DB      20 DUP (OCTAVE*2+LA)
	DB      20 DUP (OCTAVE*2+SSI)
	DB      20 DUP (OCTAVE*2+SOL)
	db      0
	DB      20 DUP (OCTAVE*2+SSI)
	DB      20 DUP (OCTAVE*3+DO)
	DB      40 DUP (OCTAVE*3+RE)
	DB      20 DUP (OCTAVE*2+SSI)
	DB      20 DUP (OCTAVE*3+DO)
	DB      40 DUP (OCTAVE*3+RE)
	db      -1


son_97  db 20 dup (20)
	db 2  dup (0)
	db 20 dup (20)
	db 2  dup (0)
	db 20 dup (20)
	db 2  dup (0)
	db 20 dup (22)
	db 2  dup (0)
	db 40 dup (24)
	db 2  dup (0)
	db 40 dup (22)
	db 2  dup (0)
	db 20 dup (20)
	db 2  dup (0)
	db 20 dup (24)
	db 2  dup (0)
	db 20 dup (22)
	db 2  dup (0)
	db 20 dup (22)
	db 2  dup (0)
	db 60 dup (20)
	db -1


SON_98  glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	glis <101,350,400>
	db -1



.CODE

	PUBLIC C timer_int
timer_int proc

	push es
	push ds
	push dx
	push cx
	push bx
	push ax
	mov ax,DGROUP
	mov ds,ax
	inc cntime
IF 0
	inc trigger
	test trigger,3
	jnz @@mine
	pushf
	call dword ptr [old_int8]
@@mine:
ENDIF
	mov al,20h
	out 20h,al
	test sound_onoff,1
	jz @@exit
	test music_onoff,1
	jz @@moff
	mov bx,music_time
	shr bx,3
	mov al,music[bx]
	cmp al,-1
	jnz @@play
	mov music_time,0
@@play: call pitch
	call toneset
	inc music_time
@@moff: cmp filsson,0
	jz @@exit
	cmp sound_time,0
	jnz @@not_init
	test music_onoff,1
	jnz @@non
	call toneon
@@non:  mov bx,filsson
	dec bx
	shl bx,1
	mov bx,tabl_snd[bx]
	mov sound_point,bx
@@not_init:
	mov bx,sound_point
	mov al,[bx]
	cmp al,-1               ; final tone
	jnz @@norm
	mov sound_time,0        ; recycle
	cmp filsrep,0
	jz @@stopit
	cmp filsrep,-1
	jz @@exit
	dec filsrep
	jmp @@exit
@@stopit:
	mov filsson,0
	test music_onoff,1
	jnz @@noff
	call toneoff
@@noff: jmp @@exit
@@norm: cmp al,100
	jc @@note
	cmp al,200
	jc @@glis
	; generate white noise (this will slow down the proccesor)
	sub al,200
	mov ch,al
	shl cx,2
	mov ax,0f000h   ; Bios ROM
	mov es,ax
	mov bx,0a000h
	in al,61h
@@lp:   test byte ptr es:[bx],1
	jz @@off
	or al,3
	jmp @@on
@@off:  and al,NOT 3
@@on:   out 61h,al
	inc bx
	loop @@lp
	or al,3
	out 61h,al
	jmp @@next
@@glis: cmp glis_time,0
	jnz @@glisit
	sub al,100              ; al length in 55/4 ms
	xor cx,cx
	xor dx,dx
	mov cl,al
	mov glis_time,cl
	mov ax,[bx+3]
	sub ax,[bx+1]
	sbb dx,0
	idiv cx
	mov glis_inc,ax
	mov ax,[bx+1]
	mov glis_freq,ax
@@glisit:
	mov cx,glis_freq
	cmp pause,1
	jne @@frq
	mov pauseend, 1
@@frq:
	call freq
	call toneset

	cmp pauseend, 1
	jne @@next1
	mov pause, 0
	mov pauseend, 0
	call toneon

@@next1:
	mov ax,glis_inc
	add glis_freq,ax
	dec glis_time
	jnz @@inc
	add sound_point,5       ; skip command
	jmp @@inc


@@note:
	cmp  al,0
	jne  @@nopause
	call toneoff
	mov  pause,1
	jmp  @@pit

@@nopause:
	cmp pause,1
	jne @@pit
	mov pauseend, 1
@@pit:
	call pitch
	call toneset

	cmp pauseend, 1
	jne @@next
	mov pause, 0
	mov pauseend, 0
	call toneon

@@next: inc sound_point
@@inc:  inc sound_time


@@exit: pop ax
	pop bx
	pop cx
	pop dx
	pop ds
	pop es
	ret
timer_int endp



keyboard_int proc far
	push ds
	push ax
	push dx
	mov ax,DGROUP
	mov ds,ax
	in al,60h


;       cmp al,02ah
;       jne nosh
;
;lll:    in al,60h
;       cmp al,01ch
;       jne lll
;
;nosh:

	push es
	push ax
	xor ax, ax
	mov es, ax
	mov al, byte ptr es:[0417h]
	and al,0dfh
	mov byte ptr es:[0417h], al
	pop ax
	pop es

	mov dx, 1
	cmp al, 039h
	je  spon
	mov dx, 0
	cmp al, 0b9h
	jne spoff
spon:   mov byte ptr state_space, dl
spoff:

	mov dx, 1
	cmp al, 04bh
	je  lon
	mov dx, 0
	cmp al, 0cbh
	jne loff
lon:    mov byte ptr state_left, dl
loff:

	mov dx, 1
	cmp al, 04dh
	je  ron
	mov dx, 0
	cmp al, 0cdh
	jne roff
ron:    mov byte ptr state_right, dl
roff:

	mov byte ptr Key_Code,al
	pushf

	cmp byte ptr keyison, 0
	jne kkeyon

	push es
	mov ax, 40h
	mov es, ax
	mov ax, es:[01ch]
	mov es:[01ah], ax
	pop es
kkeyon:
	call dword ptr [old_int9]

endkey:
	pop dx
	pop ax
	pop ds
	iret
keyboard_int endp




;routine to select tone
toneset proc near
;load the time period into the timer
	mov al,cl       ;lower byte
	out 042h,al     ;out to timer
	mov al,ch       ;upper byte
	out 042h,al     ;out to timer
	ret
toneset endp

	PUBLIC toneon
;routine to turn on tone
toneon  proc C
;turn speaker and timer on
	in al,061h      ;get contents of system port B
	or al,3         ;turn speaker and timer on
	out 061h,al     ;send out new values to port B
	ret
toneon  endp

	PUBLIC toneoff
;routine to turn tone off
toneoff proc C
;turn off timer2 and speaker
	in al,061h              ;get port B
	and al,11111100b        ;turn off timer and speaker
	out 061h,al
	ret
toneoff endp

freq    proc near
	push dx
	mov dx,12h
	mov ax,34deh
	div cx
	mov cx,ax
	pop dx
	ret
freq    endp


; in    AL

pitch   proc near
	mov ah,0
	mov cl,12
	div cl
	mov dl,al
	mov al,ah
	cbw
	sal ax,1
	mov bx,ax
	mov cx,notes[bx]
	call freq
	xchg cx,dx
	sub cl,4
	jnc @@sr
	neg cl
	and cl,7
	shl dx,cl
	jmp @@dd
@@sr:   shr dx,cl
@@dd:   xchg cx,dx
	ret
pitch   endp

	PUBLIC trap_interrupts
trap_interrupts PROC C
	xor ax,ax
	mov es,ax
	cli

	mov ax,es:[4*8]
	mov word ptr old_int8,ax
	mov ax,es:[4*8+2]
	mov word ptr old_int8+2,ax

;       mov ax,offset timer_int
;       mov es:[4*8],ax
;       mov ax,cs
;       mov es:[4*8+2],ax

	mov ax,es:[4*9]
	mov word ptr old_int9,ax
	mov ax,es:[4*9+2]
	mov word ptr old_int9+2,ax
	mov ax,offset keyboard_int
	mov es:[4*9],ax
	mov ax,cs
	mov es:[4*9+2],ax

;       mov al,36h
;       out 43h,al      ; counter 0 in mode 3
;       mov al,0B6h
;       out 43h,al      ; counter 2 in mode 3
;       mov ax,4000h    ; constant for 55/4 ms
;       out 40h,al
;       mov al,ah
;       out 40h,al

	sti
	ret
trap_interrupts ENDP

	PUBLIC release_interrupts
release_interrupts PROC C
	xor ax,ax
	mov es,ax
	cli
	mov ax,0        ; constant for 55 ms
	out 40h,al
	mov al,ah
	out 40h,al
	mov ax,0554h    ; constant for beep
	out 42h,al
	mov al,ah
	out 42h,al

;       mov ax,word ptr old_int8
;       mov es:[4*8],ax
;       mov ax,word ptr old_int8+2
;       mov es:[4*8+2],ax

	mov ax,word ptr old_int9
	mov es:[4*9],ax
	mov ax,word ptr old_int9+2
	mov es:[4*9+2],ax
	sti
	ret
release_interrupts ENDP

;========
;opentime
;========

;        Indique le debut d'une operation plus ou moins longue
;        (ne fait rien, enregistre simplement le temps absolu).

	PUBLIC opentime
opentime PROC C
	mov ax,cntime
	mov mtime,ax
	ret
opentime endp

;=========
;closetime
;=========

;        Indique la fin d'une operation plus on moins longue,
;        avec attente si la duree etait plus petite que le temps total souhaite.

	PUBLIC closetime
closetime PROC C t:WORD
	test speed_onoff,1
	jnz @@return
	cmp word ptr t,0
	jz @@return
	mov cx,t
	add cx,mtime
@@more: mov ax,cntime
	sub ax,cx       ; ax = diff in 20 ms
	jge @@return
	cmp ax,-50
	jnc @@more      ; do not wait more than 1 sec
@@return:
	ret
closetime endp

	PUBLIC vfy_mouse
vfy_mouse PROC C
	mov ax,0        ; int mouse
	int 33h
	cmp ax,-1
	jnz not_supported_mouse
	mov ax,1
	jmp @@return
not_supported_mouse:
	mov ax,-1
@@return:
	ret
vfy_mouse endp


	PUBLIC disable_mouse
disable_mouse PROC C
	mov dx,int_port
	or dx,dx
	jz @@return
	in al,dx
	or al,int_mask
	out dx,al
@@return:
	ret
disable_mouse endp

	PUBLIC enable_mouse
enable_mouse PROC C
	mov dx,int_port
	or dx,dx
	jz @@return
	in al,dx
	not al
	or al,int_mask
	not al
	out dx,al
@@return:
	ret
enable_mouse endp


; Gestion de la protection
; ------------------------


.DATA
oint78  dw ?,?
para3inch db 0DFh,2,25h,1,0Fh,0Eh,0FFh,36h,6Fh,0Fh,8
para5inch db 0DFh,2,25h,1,10h,20h,0FFh,32h,6Fh,0Fh,8
ident   db 'Emil Laurentiu',0
buffer  db 512 dup (?)

.CODE
	PUBLIC vfy_prot
vfy_prot PROC C
IFNDEF  DEBUG
	local drive:BYTE

	push ds
	pop es                  ; es = ds
; code ident string
	mov si,offset ident
	cmp byte ptr [si],'E'
	jnz @@fin
@@more1:lodsb
	cmp al,0
	jz @@fin
	xor al,55h
	mov [si-1],al
	jmp @@more1
@@fin:  mov ah,19h              ; get default drive
	int 21h
	cmp al,2
	jc diskette
; hard disk verify code
	mov cx,3                ; retries number
@@lp1:  push cx
	mov ah,2                ; read sector 3
	mov dl,80h              ; hard disk
	mov cx,3
	mov dh,ch
	mov al,1
	mov bx,offset buffer
	int 13h
	pop cx
	jnc oksec3
	loop @@lp1
	jmp ans_demo
oksec3:
	mov si,offset ident
	add bx,20h              ; !! changer ici la valeur
				; en fonction de chaque logiciel
				; BLUPI-M = 0, BLUPI-S = 10h
@@more2:lodsb
	cmp al,0
	jz ans_cont
	cmp al,[bx]
	jnz ans_demo
	inc bx
	jmp @@more2
diskette:
	mov drive,al
; read boot sector
	mov cx,3        ; retries
@@lpb:  push cx
	mov ah,2        ; read sector
	mov dl,drive
	mov cx,1
	mov dh,ch
	mov al,cl
	mov bx,offset buffer
	int 13h
	pop cx
	jnc okboot
	loop @@lpb
okboot:
	cmp [bx+13h],MIN_SECTORS
	jb ans_quit
	cmp [bx+13h],2 * 40 * 9         ; (360K 5")
	jz valueok
	cmp [bx+13h],2 * 80 * 15        ; (1.2M 5")
	jz valueok
	cmp [bx+13h],2 * 80 * 9         ; (720K 3")
	jz valueok
	cmp [bx+13h],2 * 80 * 18        ; (1.4M 3")
	jz valueok
	jmp ans_quit
valueok:
	xor ax,ax       ; save original para table
	mov es,ax
	mov di,4*1eh
	mov ax,es:[di]
	mov oint78,ax
	mov ax,es:[di+2]
	mov oint78+2,ax
	mov ax,offset para3inch
	cmp [bx+13h],2 * 80 * 9         ; (720K 3")
	jz tableok
	cmp [bx+13h],2 * 80 * 18        ; (1.4M 3")
	jz tableok
	mov ax,offset para5inch
tableok:
	stosw           ; change table
	mov ax,ds
	stosw
	push ds
	pop es          ; restore es
; read sector 3 and verify ident string
	mov cx,3        ; retries
@@lp2:  push cx
	mov ah,2        ; read sector
	mov dl,drive
	mov dh,1        ; head 1
	mov ch,79       ; track
	mov cl,3        ; sector
	mov al,1        ; read one sector
	mov bx,offset buffer
	int 13h
	pop cx
	jnc readok
	loop @@lp2
	mov ax,0        ; answer demo
	jmp restore
readok:
	mov si,offset ident
@@more3:lodsb
	cmp al,0
	jz vfyok
	cmp al,[bx]
	jnz vfyfailed
	inc bx
	jmp @@more3
vfyfailed:
	mov ax,0        ; answer demo
	jmp restore
vfyok:  mov ax,1        ; answer continue
restore:push ax
	xor ax,ax       ; restore parameter table
	mov es,ax
	mov di,4*1eh
	mov ax,oint78
	stosw
	mov ax,oint78+2
	stosw
	pop ax
	ret
ans_quit:
	mov ax,-1
	ret
ans_demo:
	mov ax,0
	ret
ans_cont:
ENDIF
	mov ax,1
	ret
vfy_prot endp

	END
