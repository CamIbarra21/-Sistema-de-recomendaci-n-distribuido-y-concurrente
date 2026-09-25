#ifdef PEG
struct T_SRC {
	char *fl; int ln;
} T_SRC[NTRANS];

void
tr_2_src(int m, char *file, int ln)
{	T_SRC[m].fl = file;
	T_SRC[m].ln = ln;
}

void
putpeg(int n, int m)
{	printf("%5d	trans %4d ", m, n);
	printf("%s:%d\n",
		T_SRC[n].fl, T_SRC[n].ln);
}
#endif

void
settable(void)
{	Trans *T;
	Trans *settr(int, int, int, int, int, char *, int, int, int);

	trans = (Trans ***) emalloc(5*sizeof(Trans **));

	/* proctype 3: todos_los_workers_terminan */

	trans[3] = (Trans **) emalloc(14*sizeof(Trans *));

	trans[3][6]	= settr(253,0,5,1,0,".(goto)", 0, 2, 0);
	T = trans[3][5] = settr(252,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(252,0,1,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(252,0,3,0,0,"DO", 0, 2, 0);
	trans[3][1]	= settr(248,0,10,3,0,"((!(!(productor_termino_de_enviar))&&!((cantidad_workers_finalizados==2))))", 1, 2, 0);
	trans[3][2]	= settr(249,0,10,1,0,"goto accept_S4", 0, 2, 0);
	trans[3][3]	= settr(250,0,5,1,0,"(1)", 0, 2, 0);
	trans[3][4]	= settr(251,0,5,1,0,"goto T0_init", 0, 2, 0);
	trans[3][7]	= settr(254,0,10,1,0,"break", 0, 2, 0);
	trans[3][11]	= settr(258,0,10,1,0,".(goto)", 0, 2, 0);
	T = trans[3][10] = settr(257,0,0,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(257,0,8,0,0,"DO", 0, 2, 0);
	trans[3][8]	= settr(255,0,10,4,0,"(!((cantidad_workers_finalizados==2)))", 1, 2, 0);
	trans[3][9]	= settr(256,0,10,1,0,"goto accept_S4", 0, 2, 0);
	trans[3][12]	= settr(259,0,13,1,0,"break", 0, 2, 0);
	trans[3][13]	= settr(260,0,0,5,5,"-end-", 0, 3500, 0);

	/* proctype 2: :init: */

	trans[2] = (Trans **) emalloc(46*sizeof(Trans *));

	trans[2][1]	= settr(203,0,2,6,6,"cursos_aprobados_por_estudiante[0] = 3", 1, 2, 0);
	trans[2][2]	= settr(204,0,3,7,7,"cursos_aprobados_por_estudiante[1] = 5", 1, 2, 0);
	trans[2][3]	= settr(205,0,4,8,8,"cursos_aprobados_por_estudiante[2] = 7", 1, 2, 0);
	trans[2][4]	= settr(206,0,5,9,9,"afinidad_por_nucleo[((0*2)+0)] = 80", 1, 2, 0);
	trans[2][5]	= settr(207,0,6,10,10,"afinidad_por_nucleo[((0*2)+1)] = 30", 1, 2, 0);
	trans[2][6]	= settr(208,0,7,11,11,"afinidad_por_nucleo[((1*2)+0)] = 20", 1, 2, 0);
	trans[2][7]	= settr(209,0,8,12,12,"afinidad_por_nucleo[((1*2)+1)] = 70", 1, 2, 0);
	trans[2][8]	= settr(210,0,9,13,13,"afinidad_por_nucleo[((2*2)+0)] = 60", 1, 2, 0);
	trans[2][9]	= settr(211,0,10,14,14,"afinidad_por_nucleo[((2*2)+1)] = 60", 1, 2, 0);
	trans[2][10]	= settr(212,0,11,15,15,"habilidad_por_nucleo[((0*2)+0)] = 70", 1, 2, 0);
	trans[2][11]	= settr(213,0,12,16,16,"habilidad_por_nucleo[((0*2)+1)] = 40", 1, 2, 0);
	trans[2][12]	= settr(214,0,13,17,17,"habilidad_por_nucleo[((1*2)+0)] = 35", 1, 2, 0);
	trans[2][13]	= settr(215,0,14,18,18,"habilidad_por_nucleo[((1*2)+1)] = 85", 1, 2, 0);
	trans[2][14]	= settr(216,0,15,19,19,"habilidad_por_nucleo[((2*2)+0)] = 55", 1, 2, 0);
	trans[2][15]	= settr(217,0,16,20,20,"habilidad_por_nucleo[((2*2)+1)] = 50", 1, 2, 0);
	trans[2][16]	= settr(218,0,17,21,21,"nucleo_del_curso[0] = 0", 1, 2, 0);
	trans[2][17]	= settr(219,0,18,22,22,"nucleo_del_curso[1] = 0", 1, 2, 0);
	trans[2][18]	= settr(220,0,19,23,23,"nucleo_del_curso[2] = 1", 1, 2, 0);
	trans[2][19]	= settr(221,0,20,24,24,"nucleo_del_curso[3] = 1", 1, 2, 0);
	trans[2][20]	= settr(222,0,21,25,25,"prerequisitos_del_curso[((0*2)+0)] = 255", 1, 2, 0);
	trans[2][21]	= settr(223,0,22,26,26,"prerequisitos_del_curso[((0*2)+1)] = 255", 1, 2, 0);
	trans[2][22]	= settr(224,0,23,27,27,"prerequisitos_del_curso[((1*2)+0)] = 0", 1, 2, 0);
	trans[2][23]	= settr(225,0,24,28,28,"prerequisitos_del_curso[((1*2)+1)] = 255", 1, 2, 0);
	trans[2][24]	= settr(226,0,25,29,29,"prerequisitos_del_curso[((2*2)+0)] = 255", 1, 2, 0);
	trans[2][25]	= settr(227,0,26,30,30,"prerequisitos_del_curso[((2*2)+1)] = 255", 1, 2, 0);
	trans[2][26]	= settr(228,0,27,31,31,"prerequisitos_del_curso[((3*2)+0)] = 1", 1, 2, 0);
	trans[2][27]	= settr(229,0,28,32,32,"prerequisitos_del_curso[((3*2)+1)] = 2", 1, 2, 0);
	trans[2][28]	= settr(230,0,29,33,33,"(run Productor())", 0, 2, 0);
	trans[2][29]	= settr(231,0,30,34,34,"(run WorkerRecomendador(0))", 0, 2, 0);
	trans[2][30]	= settr(232,0,41,35,35,"(run WorkerRecomendador(1))", 0, 2, 0);
	trans[2][42]	= settr(244,0,41,1,0,".(goto)", 0, 2, 0);
	T = trans[2][41] = settr(243,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(243,0,31,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(243,0,39,0,0,"DO", 0, 2, 0);
	trans[2][31]	= settr(233,0,37,36,0,"(((cantidad_workers_finalizados<2)||(len(canal_recomendaciones_calculadas)>0)))", 1, 2, 0);
	T = trans[2][37] = settr(239,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(239,0,32,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(239,0,34,0,0,"IF", 0, 2, 0);
	trans[2][32]	= settr(234,0,33,37,37,"canal_recomendaciones_calculadas?estudiante_resultado,curso_uno_resultado,curso_dos_resultado", 1, 504, 0);
	trans[2][33]	= settr(235,0,41,38,0,"printf('Recolector: estudiante %d recomendado con cursos %d y %d\\n',estudiante_resultado,curso_uno_resultado,curso_dos_resultado)", 0, 2, 0);
	trans[2][38]	= settr(240,0,41,1,0,".(goto)", 0, 2, 0);
	trans[2][34]	= settr(236,0,35,39,39,"canal_aviso_worker_finalizado?id_worker_que_aviso", 1, 505, 0);
	trans[2][35]	= settr(237,0,36,40,40,"cantidad_workers_finalizados = (cantidad_workers_finalizados+1)", 1, 2, 0);
	trans[2][36]	= settr(238,0,41,41,0,"printf('Recolector: worker %d finalizó (%d/%d)\\n',id_worker_que_aviso,cantidad_workers_finalizados,2)", 1, 2, 0);
	trans[2][39]	= settr(241,0,44,2,0,"else", 0, 2, 0);
	trans[2][40]	= settr(242,0,44,1,0,"goto :b5", 0, 2, 0); /* m: 44 -> 0,45 */
	reached2[44] = 1;
	trans[2][43]	= settr(245,0,44,1,0,"break", 0, 2, 0);
	trans[2][44]	= settr(246,0,45,42,42,"printf('Sistema finalizado correctamente.\\n')", 0, 2, 0);
	trans[2][45]	= settr(247,0,0,43,43,"-end-", 0, 3500, 0);

	/* proctype 1: WorkerRecomendador */

	trans[1] = (Trans **) emalloc(191*sizeof(Trans *));

	trans[1][186]	= settr(198,0,185,1,0,".(goto)", 0, 2, 0);
	T = trans[1][185] = settr(197,0,0,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(197,0,1,0,0,"DO", 0, 2, 0);
	trans[1][1]	= settr(13,0,2,44,0,"(!(trabajo_terminado))", 0, 2, 0);
	trans[1][2]	= settr(14,0,183,45,45,"canal_estudiantes_pendientes?id_estudiante_recibido", 1, 503, 0);
	T = trans[1][183] = settr(195,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(195,0,3,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(195,0,6,0,0,"IF", 0, 2, 0);
	trans[1][3]	= settr(15,0,4,46,46,"((id_estudiante_recibido==255))", 0, 2, 0);
	trans[1][4]	= settr(16,0,5,47,47,"canal_estudiantes_pendientes!255", 1, 3, 0);
	trans[1][5]	= settr(17,0,185,48,48,"trabajo_terminado = 1", 0, 2, 0);
	trans[1][184]	= settr(196,0,185,1,0,".(goto)", 0, 2, 0);
	trans[1][6]	= settr(18,0,7,2,0,"else", 0, 2, 0);
	trans[1][7]	= settr(19,0,71,49,49,"mejor_vecino_1 = 255", 0, 2, 0); /* m: 8 -> 0,71 */
	reached1[8] = 1;
	trans[1][8]	= settr(0,0,0,0,0,"mejor_similitud_1 = 0",0,0,0);
	trans[1][9]	= settr(0,0,0,0,0,"mejor_vecino_2 = 255",0,0,0);
	trans[1][10]	= settr(0,0,0,0,0,"mejor_similitud_2 = 0",0,0,0);
	trans[1][11]	= settr(0,0,0,0,0,"id_vecino_actual = 0",0,0,0);
	trans[1][72]	= settr(84,0,71,1,0,".(goto)", 0, 2, 0);
	T = trans[1][71] = settr(83,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(83,0,12,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(83,0,69,0,0,"DO", 0, 2, 0);
	trans[1][12]	= settr(24,0,66,50,0,"((id_vecino_actual<=(3-1)))", 0, 2, 0);
	T = trans[1][66] = settr(78,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(78,0,13,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(78,0,64,0,0,"IF", 0, 2, 0);
	trans[1][13]	= settr(25,0,51,51,0,"((id_vecino_actual!=id_estudiante_recibido))", 0, 2, 0);
	T = trans[ 1][51] = settr(63,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(63,0,14,0,0,"sub-sequence", 0, 2, 0);
	trans[1][14]	= settr(26,0,42,52,52,"interseccion = 0", 0, 2, 0); /* m: 15 -> 0,42 */
	reached1[15] = 1;
	trans[1][15]	= settr(0,0,0,0,0,"union_total = 0",0,0,0);
	trans[1][16]	= settr(0,0,0,0,0,"indice_bit = 0",0,0,0);
	trans[1][17]	= settr(0,0,0,0,0,"bit_a = 0",0,0,0);
	trans[1][18]	= settr(0,0,0,0,0,"bit_b = 0",0,0,0);
	trans[1][19]	= settr(0,0,0,0,0,"interseccion = 0",0,0,0);
	trans[1][20]	= settr(0,0,0,0,0,"union_total = 0",0,0,0);
	trans[1][21]	= settr(0,0,0,0,0,"indice_bit = 0",0,0,0);
	trans[1][43]	= settr(55,0,42,1,0,".(goto)", 0, 2, 0);
	T = trans[1][42] = settr(54,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(54,0,22,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(54,0,40,0,0,"DO", 0, 2, 0);
	trans[1][22]	= settr(34,0,24,53,0,"((indice_bit<=(4-1)))", 0, 2, 0);
	T = trans[ 1][24] = settr(36,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(36,0,23,0,0,"sub-sequence", 0, 2, 0);
	trans[1][23]	= settr(35,0,26,54,54,"bit_a = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>indice_bit)&1)", 1, 2, 0);
	T = trans[ 1][26] = settr(38,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(38,0,25,0,0,"sub-sequence", 0, 2, 0);
	trans[1][25]	= settr(37,0,31,55,55,"bit_b = ((cursos_aprobados_por_estudiante[id_vecino_actual]>>indice_bit)&1)", 1, 2, 0);
	T = trans[1][31] = settr(43,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(43,0,27,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(43,0,29,0,0,"IF", 0, 2, 0);
	trans[1][27]	= settr(39,0,37,56,56,"(((bit_a==1)&&(bit_b==1)))", 0, 2, 0); /* m: 28 -> 37,0 */
	reached1[28] = 1;
	trans[1][28]	= settr(0,0,0,0,0,"interseccion = (interseccion+1)",0,0,0);
	trans[1][32]	= settr(44,0,37,1,0,".(goto)", 0, 2, 0);
	trans[1][29]	= settr(41,0,30,2,0,"else", 0, 2, 0);
	trans[1][30]	= settr(42,0,37,1,0,"(1)", 0, 2, 0);
	T = trans[1][37] = settr(49,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(49,0,33,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(49,0,35,0,0,"IF", 0, 2, 0);
	trans[1][33]	= settr(45,0,42,57,57,"(((bit_a==1)||(bit_b==1)))", 0, 2, 0); /* m: 34 -> 42,0 */
	reached1[34] = 1;
	trans[1][34]	= settr(0,0,0,0,0,"union_total = (union_total+1)",0,0,0);
	trans[1][38]	= settr(50,0,39,1,0,".(goto)", 0, 2, 0); /* m: 39 -> 0,42 */
	reached1[39] = 1;
	trans[1][35]	= settr(47,0,36,2,0,"else", 0, 2, 0);
	trans[1][36]	= settr(48,0,42,58,58,"(1)", 0, 2, 0); /* m: 39 -> 42,0 */
	reached1[39] = 1;
	trans[1][39]	= settr(51,0,42,59,59,"indice_bit = (indice_bit+1)", 0, 2, 0);
	trans[1][40]	= settr(52,0,49,2,0,"else", 0, 2, 0);
	trans[1][41]	= settr(53,0,49,1,0,"goto :b3", 0, 2, 0);
	trans[1][44]	= settr(56,0,49,1,0,"break", 0, 2, 0);
	T = trans[1][49] = settr(61,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(61,0,45,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(61,0,47,0,0,"IF", 0, 2, 0);
	trans[1][45]	= settr(57,0,62,60,60,"((union_total==0))", 0, 2, 0); /* m: 46 -> 62,0 */
	reached1[46] = 1;
	trans[1][46]	= settr(0,0,0,0,0,"similitud_actual = 0",0,0,0);
	trans[1][50]	= settr(62,0,62,1,0,".(goto)", 0, 2, 0);
	trans[1][47]	= settr(59,0,48,2,0,"else", 0, 2, 0);
	trans[1][48]	= settr(60,0,62,61,61,"similitud_actual = ((interseccion*100)/union_total)", 0, 2, 0);
	T = trans[1][62] = settr(74,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(74,0,52,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(74,0,57,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(74,0,60,0,0,"IF", 0, 2, 0);
	trans[1][52]	= settr(64,0,71,62,62,"((similitud_actual>mejor_similitud_1))", 0, 2, 0); /* m: 53 -> 71,0 */
	reached1[53] = 1;
	trans[1][53]	= settr(0,0,0,0,0,"mejor_similitud_2 = mejor_similitud_1",0,0,0);
	trans[1][54]	= settr(0,0,0,0,0,"mejor_vecino_2 = mejor_vecino_1",0,0,0);
	trans[1][55]	= settr(0,0,0,0,0,"mejor_similitud_1 = similitud_actual",0,0,0);
	trans[1][56]	= settr(0,0,0,0,0,"mejor_vecino_1 = id_vecino_actual",0,0,0);
	trans[1][63]	= settr(75,0,68,1,0,".(goto)", 0, 2, 0); /* m: 68 -> 0,71 */
	reached1[68] = 1;
	trans[1][57]	= settr(69,0,71,63,63,"((similitud_actual>mejor_similitud_2))", 0, 2, 0); /* m: 58 -> 71,0 */
	reached1[58] = 1;
	trans[1][58]	= settr(0,0,0,0,0,"mejor_similitud_2 = similitud_actual",0,0,0);
	trans[1][59]	= settr(0,0,0,0,0,"mejor_vecino_2 = id_vecino_actual",0,0,0);
	trans[1][60]	= settr(72,0,61,2,0,"else", 0, 2, 0);
	trans[1][61]	= settr(73,0,71,64,64,"(1)", 0, 2, 0); /* m: 68 -> 71,0 */
	reached1[68] = 1;
	trans[1][67]	= settr(79,0,68,1,0,".(goto)", 0, 2, 0); /* m: 68 -> 0,71 */
	reached1[68] = 1;
	trans[1][64]	= settr(76,0,65,2,0,"else", 0, 2, 0);
	trans[1][65]	= settr(77,0,71,65,65,"(1)", 0, 2, 0); /* m: 68 -> 71,0 */
	reached1[68] = 1;
	trans[1][68]	= settr(80,0,71,66,66,"id_vecino_actual = (id_vecino_actual+1)", 0, 2, 0);
	trans[1][69]	= settr(81,0,74,2,0,"else", 0, 2, 0);
	trans[1][70]	= settr(82,0,74,1,0,"goto :b2", 0, 2, 0); /* m: 74 -> 0,178 */
	reached1[74] = 1;
	trans[1][73]	= settr(85,0,74,1,0,"break", 0, 2, 0);
	trans[1][74]	= settr(86,0,178,67,67,"mejor_curso_1 = 255", 0, 2, 0); /* m: 75 -> 0,178 */
	reached1[75] = 1;
	trans[1][75]	= settr(0,0,0,0,0,"mejor_puntaje_1 = 0",0,0,0);
	trans[1][76]	= settr(0,0,0,0,0,"mejor_curso_2 = 255",0,0,0);
	trans[1][77]	= settr(0,0,0,0,0,"mejor_puntaje_2 = 0",0,0,0);
	trans[1][78]	= settr(0,0,0,0,0,"id_curso_candidato = 0",0,0,0);
	trans[1][179]	= settr(191,0,178,1,0,".(goto)", 0, 2, 0);
	T = trans[1][178] = settr(190,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(190,0,79,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(190,0,176,0,0,"DO", 0, 2, 0);
	trans[1][79]	= settr(91,0,81,68,0,"((id_curso_candidato<=(4-1)))", 0, 2, 0);
	T = trans[ 1][81] = settr(93,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(93,0,80,0,0,"sub-sequence", 0, 2, 0);
	trans[1][80]	= settr(92,0,173,69,69,"bit_ya_aprobado = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_curso_candidato)&1)", 1, 2, 0);
	T = trans[1][173] = settr(185,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(185,0,82,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(185,0,84,0,0,"IF", 0, 2, 0);
	trans[1][82]	= settr(94,0,83,70,70,"((bit_ya_aprobado==1))", 0, 2, 0);
	trans[1][83]	= settr(95,0,178,71,71,"(1)", 0, 2, 0); /* m: 175 -> 178,0 */
	reached1[175] = 1;
	trans[1][174]	= settr(186,0,175,1,0,".(goto)", 0, 2, 0); /* m: 175 -> 0,178 */
	reached1[175] = 1;
	trans[1][84]	= settr(96,0,119,2,0,"else", 0, 2, 0);
	T = trans[ 1][119] = settr(131,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(131,0,85,0,0,"sub-sequence", 0, 2, 0);
	trans[1][85]	= settr(97,0,89,72,72,"id_prerequisito_0 = 0", 0, 2, 0); /* m: 86 -> 0,89 */
	reached1[86] = 1;
	trans[1][86]	= settr(0,0,0,0,0,"id_prerequisito_1 = 0",0,0,0);
	trans[1][87]	= settr(0,0,0,0,0,"bit_prerequisito = 0",0,0,0);
	T = trans[ 1][89] = settr(101,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(101,0,88,0,0,"sub-sequence", 0, 2, 0);
	trans[1][88]	= settr(100,0,91,73,73,"id_prerequisito_0 = prerequisitos_del_curso[((id_curso_candidato*2)+0)]", 1, 2, 0);
	T = trans[ 1][91] = settr(103,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(103,0,90,0,0,"sub-sequence", 0, 2, 0);
	trans[1][90]	= settr(102,0,92,74,74,"id_prerequisito_1 = prerequisitos_del_curso[((id_curso_candidato*2)+1)]", 1, 2, 0);
	trans[1][92]	= settr(104,0,104,75,75,"curso_cumple_prerequisitos = 1", 0, 2, 0);
	T = trans[1][104] = settr(116,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(116,0,93,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(116,0,102,0,0,"IF", 0, 2, 0);
	trans[1][93]	= settr(105,0,95,76,0,"((id_prerequisito_0!=255))", 0, 2, 0);
	T = trans[ 1][95] = settr(107,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(107,0,94,0,0,"sub-sequence", 0, 2, 0);
	trans[1][94]	= settr(106,0,100,77,77,"bit_prerequisito = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_prerequisito_0)&1)", 1, 2, 0);
	T = trans[1][100] = settr(112,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(112,0,96,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(112,0,98,0,0,"IF", 0, 2, 0);
	trans[1][96]	= settr(108,0,117,78,78,"((bit_prerequisito==0))", 0, 2, 0); /* m: 97 -> 117,0 */
	reached1[97] = 1;
	trans[1][97]	= settr(0,0,0,0,0,"curso_cumple_prerequisitos = 0",0,0,0);
	trans[1][101]	= settr(113,0,117,1,0,".(goto)", 0, 2, 0);
	trans[1][98]	= settr(110,0,99,2,0,"else", 0, 2, 0);
	trans[1][99]	= settr(111,0,117,1,0,"(1)", 0, 2, 0);
	trans[1][105]	= settr(117,0,117,1,0,".(goto)", 0, 2, 0);
	trans[1][102]	= settr(114,0,103,2,0,"else", 0, 2, 0);
	trans[1][103]	= settr(115,0,117,1,0,"(1)", 0, 2, 0);
	T = trans[1][117] = settr(129,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(129,0,106,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(129,0,115,0,0,"IF", 0, 2, 0);
	trans[1][106]	= settr(118,0,108,79,0,"((id_prerequisito_1!=255))", 0, 2, 0);
	T = trans[ 1][108] = settr(120,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(120,0,107,0,0,"sub-sequence", 0, 2, 0);
	trans[1][107]	= settr(119,0,113,80,80,"bit_prerequisito = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_prerequisito_1)&1)", 1, 2, 0);
	T = trans[1][113] = settr(125,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(125,0,109,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(125,0,111,0,0,"IF", 0, 2, 0);
	trans[1][109]	= settr(121,0,171,81,81,"((bit_prerequisito==0))", 0, 2, 0); /* m: 110 -> 171,0 */
	reached1[110] = 1;
	trans[1][110]	= settr(0,0,0,0,0,"curso_cumple_prerequisitos = 0",0,0,0);
	trans[1][114]	= settr(126,0,171,1,0,".(goto)", 0, 2, 0);
	trans[1][111]	= settr(123,0,112,2,0,"else", 0, 2, 0);
	trans[1][112]	= settr(124,0,171,1,0,"(1)", 0, 2, 0);
	trans[1][118]	= settr(130,0,171,1,0,".(goto)", 0, 2, 0);
	trans[1][115]	= settr(127,0,116,2,0,"else", 0, 2, 0);
	trans[1][116]	= settr(128,0,171,1,0,"(1)", 0, 2, 0);
	T = trans[1][171] = settr(183,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(183,0,120,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(183,0,169,0,0,"IF", 0, 2, 0);
	trans[1][120]	= settr(132,0,121,82,82,"((curso_cumple_prerequisitos==1))", 0, 2, 0);
	trans[1][121]	= settr(133,0,123,83,83,"id_nucleo_del_curso = nucleo_del_curso[id_curso_candidato]", 1, 2, 0);
	T = trans[ 1][123] = settr(135,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(135,0,122,0,0,"sub-sequence", 0, 2, 0);
	trans[1][122]	= settr(134,0,124,84,84,"valor_afinidad = afinidad_por_nucleo[((id_estudiante_recibido*2)+id_nucleo_del_curso)]", 1, 2, 0);
	trans[1][124]	= settr(136,0,126,85,85,"aporte_afinidad = ((valor_afinidad*25)/100)", 0, 2, 0);
	T = trans[ 1][126] = settr(138,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(138,0,125,0,0,"sub-sequence", 0, 2, 0);
	trans[1][125]	= settr(137,0,127,86,86,"valor_habilidad = habilidad_por_nucleo[((id_estudiante_recibido*2)+id_nucleo_del_curso)]", 1, 2, 0);
	trans[1][127]	= settr(139,0,140,87,87,"aporte_habilidad = ((valor_habilidad*25)/100)", 0, 2, 0); /* m: 128 -> 0,140 */
	reached1[128] = 1;
	trans[1][128]	= settr(0,0,0,0,0,"cantidad_vecinos_que_aprobaron = 0",0,0,0);
	T = trans[1][140] = settr(152,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(152,0,129,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(152,0,138,0,0,"IF", 0, 2, 0);
	trans[1][129]	= settr(141,0,131,88,0,"((mejor_vecino_1!=255))", 0, 2, 0);
	T = trans[ 1][131] = settr(143,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(143,0,130,0,0,"sub-sequence", 0, 2, 0);
	trans[1][130]	= settr(142,0,136,89,89,"bit_vecino_aprobo = ((cursos_aprobados_por_estudiante[mejor_vecino_1]>>id_curso_candidato)&1)", 1, 2, 0);
	T = trans[1][136] = settr(148,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(148,0,132,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(148,0,134,0,0,"IF", 0, 2, 0);
	trans[1][132]	= settr(144,0,153,90,90,"((bit_vecino_aprobo==1))", 0, 2, 0); /* m: 133 -> 153,0 */
	reached1[133] = 1;
	trans[1][133]	= settr(0,0,0,0,0,"cantidad_vecinos_que_aprobaron = (cantidad_vecinos_que_aprobaron+1)",0,0,0);
	trans[1][137]	= settr(149,0,153,1,0,".(goto)", 0, 2, 0);
	trans[1][134]	= settr(146,0,135,2,0,"else", 0, 2, 0);
	trans[1][135]	= settr(147,0,153,1,0,"(1)", 0, 2, 0);
	trans[1][141]	= settr(153,0,153,1,0,".(goto)", 0, 2, 0);
	trans[1][138]	= settr(150,0,139,2,0,"else", 0, 2, 0);
	trans[1][139]	= settr(151,0,153,1,0,"(1)", 0, 2, 0);
	T = trans[1][153] = settr(165,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(165,0,142,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(165,0,151,0,0,"IF", 0, 2, 0);
	trans[1][142]	= settr(154,0,144,91,0,"((mejor_vecino_2!=255))", 0, 2, 0);
	T = trans[ 1][144] = settr(156,0,0,0,0,"sub-sequence", 0, 2, 0);
	T->nxt	= settr(156,0,143,0,0,"sub-sequence", 0, 2, 0);
	trans[1][143]	= settr(155,0,149,92,92,"bit_vecino_aprobo = ((cursos_aprobados_por_estudiante[mejor_vecino_2]>>id_curso_candidato)&1)", 1, 2, 0);
	T = trans[1][149] = settr(161,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(161,0,145,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(161,0,147,0,0,"IF", 0, 2, 0);
	trans[1][145]	= settr(157,0,167,93,93,"((bit_vecino_aprobo==1))", 0, 2, 0); /* m: 146 -> 167,0 */
	reached1[146] = 1;
	trans[1][146]	= settr(0,0,0,0,0,"cantidad_vecinos_que_aprobaron = (cantidad_vecinos_que_aprobaron+1)",0,0,0);
	trans[1][150]	= settr(162,0,155,1,0,".(goto)", 0, 2, 0); /* m: 155 -> 0,167 */
	reached1[155] = 1;
	trans[1][147]	= settr(159,0,148,2,0,"else", 0, 2, 0);
	trans[1][148]	= settr(160,0,167,94,94,"(1)", 0, 2, 0); /* m: 155 -> 167,0 */
	reached1[155] = 1;
	trans[1][154]	= settr(166,0,155,1,0,".(goto)", 0, 2, 0); /* m: 155 -> 0,167 */
	reached1[155] = 1;
	trans[1][151]	= settr(163,0,152,2,0,"else", 0, 2, 0);
	trans[1][152]	= settr(164,0,167,95,95,"(1)", 0, 2, 0); /* m: 155 -> 167,0 */
	reached1[155] = 1;
	trans[1][155]	= settr(167,0,167,96,96,"aporte_colaborativo = ((cantidad_vecinos_que_aprobaron*50)/2)", 0, 2, 0); /* m: 156 -> 0,167 */
	reached1[156] = 1;
	trans[1][156]	= settr(0,0,0,0,0,"puntaje_curso = ((aporte_afinidad+aporte_habilidad)+aporte_colaborativo)",0,0,0);
	T = trans[1][167] = settr(179,0,0,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(179,0,157,0,0,"IF", 0, 2, 0);
	T = T->nxt	= settr(179,0,162,0,0,"IF", 0, 2, 0);
	    T->nxt	= settr(179,0,165,0,0,"IF", 0, 2, 0);
	trans[1][157]	= settr(169,0,178,97,97,"((puntaje_curso>mejor_puntaje_1))", 0, 2, 0); /* m: 158 -> 178,0 */
	reached1[158] = 1;
	trans[1][158]	= settr(0,0,0,0,0,"mejor_puntaje_2 = mejor_puntaje_1",0,0,0);
	trans[1][159]	= settr(0,0,0,0,0,"mejor_curso_2 = mejor_curso_1",0,0,0);
	trans[1][160]	= settr(0,0,0,0,0,"mejor_puntaje_1 = puntaje_curso",0,0,0);
	trans[1][161]	= settr(0,0,0,0,0,"mejor_curso_1 = id_curso_candidato",0,0,0);
	trans[1][168]	= settr(180,0,175,1,0,".(goto)", 0, 2, 0); /* m: 175 -> 0,178 */
	reached1[175] = 1;
	trans[1][162]	= settr(174,0,178,98,98,"((puntaje_curso>mejor_puntaje_2))", 0, 2, 0); /* m: 163 -> 178,0 */
	reached1[163] = 1;
	trans[1][163]	= settr(0,0,0,0,0,"mejor_puntaje_2 = puntaje_curso",0,0,0);
	trans[1][164]	= settr(0,0,0,0,0,"mejor_curso_2 = id_curso_candidato",0,0,0);
	trans[1][165]	= settr(177,0,166,2,0,"else", 0, 2, 0);
	trans[1][166]	= settr(178,0,178,99,99,"(1)", 0, 2, 0); /* m: 175 -> 178,0 */
	reached1[175] = 1;
	trans[1][172]	= settr(184,0,175,1,0,".(goto)", 0, 2, 0); /* m: 175 -> 0,178 */
	reached1[175] = 1;
	trans[1][169]	= settr(181,0,170,2,0,"else", 0, 2, 0);
	trans[1][170]	= settr(182,0,178,100,100,"(1)", 0, 2, 0); /* m: 175 -> 178,0 */
	reached1[175] = 1;
	trans[1][175]	= settr(187,0,178,101,101,"id_curso_candidato = (id_curso_candidato+1)", 0, 2, 0);
	trans[1][176]	= settr(188,0,181,2,0,"else", 0, 2, 0);
	trans[1][177]	= settr(189,0,181,1,0,"goto :b4", 0, 2, 0);
	trans[1][180]	= settr(192,0,181,1,0,"break", 0, 2, 0);
	trans[1][181]	= settr(193,0,182,102,102,"canal_recomendaciones_calculadas!id_estudiante_recibido,mejor_curso_1,mejor_curso_2", 1, 4, 0);
	trans[1][182]	= settr(194,0,185,103,0,"printf('Worker %d: estudiante %d -> cursos [%d, %d] (puntajes %d, %d)\\n',identificador_worker,id_estudiante_recibido,mejor_curso_1,mejor_curso_2,mejor_puntaje_1,mejor_puntaje_2)", 0, 2, 0);
	trans[1][187]	= settr(199,0,188,1,0,"break", 0, 2, 0);
	trans[1][188]	= settr(200,0,189,104,104,"canal_aviso_worker_finalizado!identificador_worker", 1, 5, 0);
	trans[1][189]	= settr(201,0,190,105,0,"printf('Worker %d: terminado\\n',identificador_worker)", 0, 2, 0);
	trans[1][190]	= settr(202,0,0,106,106,"-end-", 0, 3500, 0);

	/* proctype 0: Productor */

	trans[0] = (Trans **) emalloc(14*sizeof(Trans *));

	trans[0][1]	= settr(0,0,8,107,107,"indice_estudiante_actual = 0", 0, 2, 0);
	trans[0][9]	= settr(8,0,8,1,0,".(goto)", 0, 2, 0);
	T = trans[0][8] = settr(7,0,0,0,0,"DO", 0, 2, 0);
	T = T->nxt	= settr(7,0,2,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(7,0,6,0,0,"DO", 0, 2, 0);
	trans[0][2]	= settr(1,0,3,108,0,"((indice_estudiante_actual<=(3-1)))", 0, 2, 0);
	trans[0][3]	= settr(2,0,4,109,109,"canal_estudiantes_pendientes!indice_estudiante_actual", 1, 3, 0);
	trans[0][4]	= settr(3,0,8,110,110,"printf('Productor: enviado estudiante %d\\n',indice_estudiante_actual)", 0, 2, 0); /* m: 5 -> 0,8 */
	reached0[5] = 1;
	trans[0][5]	= settr(0,0,0,0,0,"indice_estudiante_actual = (indice_estudiante_actual+1)",0,0,0);
	trans[0][6]	= settr(5,0,11,2,0,"else", 0, 2, 0);
	trans[0][7]	= settr(6,0,11,1,0,"goto :b0", 0, 2, 0);
	trans[0][10]	= settr(9,0,11,1,0,"break", 0, 2, 0);
	trans[0][11]	= settr(10,0,12,111,111,"canal_estudiantes_pendientes!255", 1, 3, 0);
	trans[0][12]	= settr(11,0,13,112,112,"productor_termino_de_enviar = 1", 1, 2, 0);
	trans[0][13]	= settr(12,0,0,113,113,"-end-", 0, 3500, 0);
	/* np_ demon: */
	trans[_NP_] = (Trans **) emalloc(3*sizeof(Trans *));
	T = trans[_NP_][0] = settr(9997,0,1,_T5,0,"(np_)", 1,2,0);
	    T->nxt	  = settr(9998,0,0,_T2,0,"(1)",   0,2,0);
	T = trans[_NP_][1] = settr(9999,0,1,_T5,0,"(np_)", 1,2,0);
}

Trans *
settr(	int t_id, int a, int b, int c, int d,
	char *t, int g, int tpe0, int tpe1)
{	Trans *tmp = (Trans *) emalloc(sizeof(Trans));

	tmp->atom  = a&(6|32);	/* only (2|8|32) have meaning */
	if (!g) tmp->atom |= 8;	/* no global references */
	tmp->st    = b;
	tmp->tpe[0] = tpe0;
	tmp->tpe[1] = tpe1;
	tmp->tp    = t;
	tmp->t_id  = t_id;
	tmp->forw  = c;
	tmp->back  = d;
	return tmp;
}

Trans *
cpytr(Trans *a)
{	Trans *tmp = (Trans *) emalloc(sizeof(Trans));

	int i;
	tmp->atom  = a->atom;
	tmp->st    = a->st;
#ifdef HAS_UNLESS
	tmp->e_trans = a->e_trans;
	for (i = 0; i < HAS_UNLESS; i++)
		tmp->escp[i] = a->escp[i];
#endif
	tmp->tpe[0] = a->tpe[0];
	tmp->tpe[1] = a->tpe[1];
	for (i = 0; i < 6; i++)
	{	tmp->qu[i] = a->qu[i];
		tmp->ty[i] = a->ty[i];
	}
	tmp->tp    = (char *) emalloc(strlen(a->tp)+1);
	strcpy(tmp->tp, a->tp);
	tmp->t_id  = a->t_id;
	tmp->forw  = a->forw;
	tmp->back  = a->back;
	return tmp;
}

#ifndef NOREDUCE
int
srinc_set(int n)
{	if (n <= 2) return LOCAL;
	if (n <= 2+  DELTA) return Q_FULL_F; /* 's' or nfull  */
	if (n <= 2+2*DELTA) return Q_EMPT_F; /* 'r' or nempty */
	if (n <= 2+3*DELTA) return Q_EMPT_T; /* empty */
	if (n <= 2+4*DELTA) return Q_FULL_T; /* full  */
	if (n ==   5*DELTA) return GLOBAL;
	if (n ==   6*DELTA) return TIMEOUT_F;
	if (n ==   7*DELTA) return ALPHA_F;
	Uerror("cannot happen srinc_class");
	return BAD;
}
int
srunc(int n, int m)
{	switch(m) {
	case Q_FULL_F: return n-2;
	case Q_EMPT_F: return n-2-DELTA;
	case Q_EMPT_T: return n-2-2*DELTA;
	case Q_FULL_T: return n-2-3*DELTA;
	case ALPHA_F:
	case TIMEOUT_F: return 257; /* non-zero, and > MAXQ */
	}
	Uerror("cannot happen srunc");
	return 0;
}
#endif
int cnt;
#ifdef HAS_UNLESS
int
isthere(Trans *a, int b)
{	Trans *t;
	for (t = a; t; t = t->nxt)
		if (t->t_id == b)
			return 1;
	return 0;
}
#endif
#ifndef NOREDUCE
int
mark_safety(Trans *t) /* for conditional safety */
{	int g = 0, i, j, k;

	if (!t) return 0;
	if (t->qu[0])
		return (t->qu[1])?2:1;	/* marked */

	for (i = 0; i < 2; i++)
	{	j = srinc_set(t->tpe[i]);
		if (j >= GLOBAL && j != ALPHA_F)
			return -1;
		if (j != LOCAL)
		{	k = srunc(t->tpe[i], j);
			if (g == 0
			||  t->qu[0] != k
			||  t->ty[0] != j)
			{	t->qu[g] = k;
				t->ty[g] = j;
				g++;
	}	}	}
	return g;
}
#endif
void
retrans(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
	/* process n, with m states, is=initial state */
{	Trans *T0, *T1, *T2, *T3;
	Trans *T4, *T5; /* t_reverse or has_unless */
	int i;
#if defined(HAS_UNLESS) || !defined(NOREDUCE)
	int k;
#endif
#ifndef NOREDUCE
	int g, h, j, aa;
#endif
#ifdef HAS_UNLESS
	int p;
#endif
	if (state_tables >= 4)
	{	printf("STEP 1 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
	do {
		for (i = 1, cnt = 0; i < m; i++)
		{	T2 = trans[n][i];
			T1 = T2?T2->nxt:(Trans *)0;
/* prescan: */		for (T0 = T1; T0; T0 = T0->nxt)
/* choice in choice */	{	if (T0->st && trans[n][T0->st]
				&&  trans[n][T0->st]->nxt)
					break;
			}
#if 0
		if (T0)
		printf("\tstate %d / %d: choice in choice\n",
		i, T0->st);
#endif
			if (T0)
			for (T0 = T1; T0; T0 = T0->nxt)
			{	T3 = trans[n][T0->st];
				if (!T3->nxt)
				{	T2->nxt = cpytr(T0);
					T2 = T2->nxt;
					imed(T2, T0->st, n, i);
					continue;
				}
				do {	T3 = T3->nxt;
					T2->nxt = cpytr(T3);
					T2 = T2->nxt;
					imed(T2, T0->st, n, i);
				} while (T3->nxt);
				cnt++;
			}
		}
	} while (cnt);
	if (state_tables >= 3)
	{	printf("STEP 2 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
	for (i = 1; i < m; i++)
	{	if (trans[n][i] && trans[n][i]->nxt) /* optimize */
		{	T1 = trans[n][i]->nxt;
#if 0
			printf("\t\tpull %d (%d) to %d\n",
			T1->st, T1->forw, i);
#endif
			srcln[i] = srcln[T1->st];	/* Oyvind Teig, 5.2.0 */

			if (!trans[n][T1->st]) continue;
			T0 = cpytr(trans[n][T1->st]);
			trans[n][i] = T0;
			reach[T1->st] = 1;
			imed(T0, T1->st, n, i);
			for (T1 = T1->nxt; T1; T1 = T1->nxt)
			{
#if 0
			printf("\t\tpull %d (%d) to %d\n",
				T1->st, T1->forw, i);
#endif
		/*		srcln[i] = srcln[T1->st];  gh: not useful */
				if (!trans[n][T1->st]) continue;
				T0->nxt = cpytr(trans[n][T1->st]);
				T0 = T0->nxt;
				reach[T1->st] = 1;
				imed(T0, T1->st, n, i);
	}	}	}
	if (state_tables >= 2)
	{	printf("STEP 3 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
#ifdef HAS_UNLESS
	for (i = 1; i < m; i++)
	{	if (!trans[n][i]) continue;
		/* check for each state i if an
		 * escape to some state p is defined
		 * if so, copy and mark p's transitions
		 * and prepend them to the transition-
		 * list of state i
		 */
	 if (!like_java) /* the default */
	 {	for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		for (k = HAS_UNLESS-1; k >= 0; k--)
		{	if (p = T0->escp[k])
			for (T1 = trans[n][p]; T1; T1 = T1->nxt)
			{	if (isthere(trans[n][i], T1->t_id))
					continue;
				T2 = cpytr(T1);
				T2->e_trans = p;
				T2->nxt = trans[n][i];
				trans[n][i] = T2;
		}	}
	 } else /* outermost unless checked first */
	 {	T4 = T3 = (Trans *) 0;
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		for (k = HAS_UNLESS-1; k >= 0; k--)
		{	if (p = T0->escp[k])
			for (T1 = trans[n][p]; T1; T1 = T1->nxt)
			{	if (isthere(trans[n][i], T1->t_id))
					continue;
				T2 = cpytr(T1);
				T2->nxt = (Trans *) 0;
				T2->e_trans = p;
				if (T3)	T3->nxt = T2;
				else	T4 = T2;
				T3 = T2;
		}	}
		if (T4)
		{	T3->nxt = trans[n][i];
			trans[n][i] = T4;
		}
	 }
	}
#endif
#ifndef NOREDUCE
	for (i = 1; i < m; i++)
	{	if (a_cycles)
		{ /* moves through these states are visible */
	#if PROG_LAB>0 && defined(HAS_NP)
			if (progstate[n][i])
				goto degrade;
			for (T1 = trans[n][i]; T1; T1 = T1->nxt)
				if (progstate[n][T1->st])
					goto degrade;
	#endif
			if (accpstate[n][i] || visstate[n][i])
				goto degrade;
			for (T1 = trans[n][i]; T1; T1 = T1->nxt)
				if (accpstate[n][T1->st])
					goto degrade;
		}
		T1 = trans[n][i];
		if (!T1) continue;
		g = mark_safety(T1);	/* V3.3.1 */
		if (g < 0) goto degrade; /* global */
		/* check if mixing of guards preserves reduction */
		if (T1->nxt)
		{	k = 0;
			for (T0 = T1; T0; T0 = T0->nxt)
			{	if (!(T0->atom&8))
					goto degrade;
				for (aa = 0; aa < 2; aa++)
				{	j = srinc_set(T0->tpe[aa]);
					if (j >= GLOBAL && j != ALPHA_F)
						goto degrade;
					if (T0->tpe[aa]
					&&  T0->tpe[aa]
					!=  T1->tpe[0])
						k = 1;
			}	}
			/* g = 0;	V3.3.1 */
			if (k)	/* non-uniform selection */
			for (T0 = T1; T0; T0 = T0->nxt)
			for (aa = 0; aa < 2; aa++)
			{	j = srinc_set(T0->tpe[aa]);
				if (j != LOCAL)
				{	k = srunc(T0->tpe[aa], j);
					for (h = 0; h < 6; h++)
						if (T1->qu[h] == k
						&&  T1->ty[h] == j)
							break;
					if (h >= 6)
					{	T1->qu[g%6] = k;
						T1->ty[g%6] = j;
						g++;
			}	}	}
			if (g > 6)
			{	T1->qu[0] = 0;	/* turn it off */
				printf("pan: warning, line %d, ",
					srcln[i]);
			 	printf("too many stmnt types (%d)",
					g);
			  	printf(" in selection\n");
			  goto degrade;
			}
		}
		/* mark all options global if >=1 is global */
		for (T1 = trans[n][i]; T1; T1 = T1->nxt)
			if (!(T1->atom&8)) break;
		if (T1)
degrade:	for (T1 = trans[n][i]; T1; T1 = T1->nxt)
			T1->atom &= ~8;	/* mark as unsafe */
		/* can only mix 'r's or 's's if on same chan */
		/* and not mixed with other local operations */
		T1 = trans[n][i];
		if (!T1 || T1->qu[0]) continue;
		j = T1->tpe[0];
		if (T1->nxt && T1->atom&8)
		{ if (j == 5*DELTA)
		  {	printf("warning: line %d ", srcln[i]);
			printf("mixed condition ");
			printf("(defeats reduction)\n");
			goto degrade;
		  }
		  for (T0 = T1; T0; T0 = T0->nxt)
		  for (aa = 0; aa < 2; aa++)
		  if  (T0->tpe[aa] && T0->tpe[aa] != j)
		  {	printf("warning: line %d ", srcln[i]);
			printf("[%d-%d] mixed %stion ",
				T0->tpe[aa], j, 
				(j==5*DELTA)?"condi":"selec");
			printf("(defeats reduction)\n");
			printf("	'%s' <-> '%s'\n",
				T1->tp, T0->tp);
			goto degrade;
		} }
	}
#endif
	for (i = 1; i < m; i++)
	{	T2 = trans[n][i];
		if (!T2
		||  T2->nxt
		||  strncmp(T2->tp, ".(goto)", 7)
		||  !stopstate[n][i])
			continue;
		stopstate[n][T2->st] = 1;
	}
	if (state_tables && !verbose)
	{	if (dodot)
		{	char buf[256], *q = buf, *p = procname[n];
			while (*p != '\0')
			{	if (*p != ':')
				{	*q++ = *p;
				}
				p++;
			}
			*q = '\0';
			printf("digraph ");
			switch (Btypes[n]) {
			case I_PROC:  printf("init {\n"); break;
			case N_CLAIM: printf("claim_%s {\n", buf); break;
			case E_TRACE: printf("notrace {\n"); break;
			case N_TRACE: printf("trace {\n"); break;
			default:      printf("p_%s {\n", buf); break;
			}
			printf("size=\"8,10\";\n");
			printf("  GT [shape=box,style=dotted,label=\"%s\"];\n", buf);
			printf("  GT -> S%d;\n", is);
		} else
		{	switch (Btypes[n]) {
			case I_PROC:  printf("init\n"); break;
			case N_CLAIM: printf("claim %s\n", procname[n]); break;
			case E_TRACE: printf("notrace assertion\n"); break;
			case N_TRACE: printf("trace assertion\n"); break;
			default:      printf("proctype %s\n", procname[n]); break;
		}	}
		for (i = 1; i < m; i++)
		{	reach[i] = 1;
		}
		tagtable(n, m, is, srcln, reach);
		if (dodot) printf("}\n");
	} else
	for (i = 1; i < m; i++)
	{	int nrelse;
		if (Btypes[n] != N_CLAIM)
		{	for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			{	if (T0->st == i
				&& strcmp(T0->tp, "(1)") == 0)
				{	printf("error: proctype '%s' ",
						procname[n]);
		  			printf("line %d, state %d: has un",
						srcln[i], i);
					printf("conditional self-loop\n");
					pan_exit(1);
		}	}	}
		nrelse = 0;
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		{	if (strcmp(T0->tp, "else") == 0)
				nrelse++;
		}
		if (nrelse > 1)
		{	printf("error: proctype '%s' state",
				procname[n]);
		  	printf(" %d, inherits %d", i, nrelse);
		  	printf(" 'else' stmnts\n");
			pan_exit(1);
	}	}
#if !defined(LOOPSTATE) && !defined(BFS_PAR)
	if (state_tables)
#endif
	do_dfs(n, m, is, srcln, reach, lpstate);

	if (!t_reverse)
	{	return;
	}
	/* process n, with m states, is=initial state -- reverse list */
	if (!state_tables && Btypes[n] != N_CLAIM)
	{	for (i = 1; i < m; i++)
		{	Trans *Tx = (Trans *) 0; /* list of escapes */
			Trans *Ty = (Trans *) 0; /* its tail element */
			T1 = (Trans *) 0; /* reversed list */
			T2 = (Trans *) 0; /* its tail */
			T3 = (Trans *) 0; /* remembers possible 'else' */

			/* find unless-escapes, they should go first */
			T4 = T5 = T0 = trans[n][i];
	#ifdef HAS_UNLESS
			while (T4 && T4->e_trans) /* escapes are first in orig list */
			{	T5 = T4;	  /* remember predecessor */
				T4 = T4->nxt;
			}
	#endif
			/* T4 points to first non-escape, T5 to its parent, T0 to original list */
			if (T4 != T0)		 /* there was at least one escape */
			{	T3 = T5->nxt;		 /* start of non-escapes */
				T5->nxt = (Trans *) 0;	 /* separate */
				Tx = T0;		 /* start of the escapes */
				Ty = T5;		 /* its tail */
				T0 = T3;		 /* the rest, to be reversed */
			}
			/* T0 points to first non-escape, Tx to the list of escapes, Ty to its tail */

			/* first tail-add non-escape transitions, reversed */
			T3 = (Trans *) 0;
			for (T5 = T0; T5; T5 = T4)
			{	T4 = T5->nxt;
	#ifdef HAS_UNLESS
				if (T5->e_trans)
				{	printf("error: cannot happen!\n");
					continue;
				}
	#endif
				if (strcmp(T5->tp, "else") == 0)
				{	T3 = T5;
					T5->nxt = (Trans *) 0;
				} else
				{	T5->nxt = T1;
					if (!T1) { T2 = T5; }
					T1 = T5;
			}	}
			/* T3 points to a possible else, which is removed from the list */
			/* T1 points to the reversed list so far (without escapes) */
			/* T2 points to the tail element -- where the else should go */
			if (T2 && T3)
			{	T2->nxt = T3;	/* add else */
			} else
			{	if (T3) /* there was an else, but there's no tail */
				{	if (!T1)	/* and no reversed list */
					{	T1 = T3; /* odd, but possible */
					} else		/* even stranger */
					{	T1->nxt = T3;
			}	}	}

			/* add in the escapes, to that they appear at the front */
			if (Tx && Ty) { Ty->nxt = T1; T1 = Tx; }

			trans[n][i] = T1;
			/* reversed, with escapes first and else last */
	}	}
	if (state_tables && verbose)
	{	printf("FINAL proctype %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
	}
}
void
imed(Trans *T, int v, int n, int j)	/* set intermediate state */
{	progstate[n][T->st] |= progstate[n][v];
	accpstate[n][T->st] |= accpstate[n][v];
	stopstate[n][T->st] |= stopstate[n][v];
	mapstate[n][j] = T->st;
}
void
tagtable(int n, int m, int is, short srcln[], uchar reach[])
{	Trans *z;

	if (is >= m || !trans[n][is]
	||  is <= 0 || reach[is] == 0)
		return;
	reach[is] = 0;
	if (state_tables)
	for (z = trans[n][is]; z; z = z->nxt)
	{	if (dodot)
			dot_crack(n, is, z);
		else
			crack(n, is, z, srcln);
	}

	for (z = trans[n][is]; z; z = z->nxt)
	{
#ifdef HAS_UNLESS
		int i, j;
#endif
		tagtable(n, m, z->st, srcln, reach);
#ifdef HAS_UNLESS
		for (i = 0; i < HAS_UNLESS; i++)
		{	j = trans[n][is]->escp[i];
			if (!j) break;
			tagtable(n, m, j, srcln, reach);
		}
#endif
	}
}

extern Trans *t_id_lkup[];

void
dfs_table(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
{	Trans *z;

	if (is >= m || is <= 0 || !trans[n][is])
		return;
	if ((reach[is] & (4|8|16)) != 0)
	{	if ((reach[is] & (8|16)) == 16)	/* on stack, not yet recorded */
		{	lpstate[is] = 1;
			reach[is] |= 8; /* recorded */
			if (state_tables && verbose)
			{	printf("state %d line %d is a loopstate\n", is, srcln[is]);
		}	}
		return;
	}
	reach[is] |= (4|16);	/* visited | onstack */
	for (z = trans[n][is]; z; z = z->nxt)
	{	t_id_lkup[z->t_id] = z;
#ifdef HAS_UNLESS
		int i, j;
#endif
		dfs_table(n, m, z->st, srcln, reach, lpstate);
#ifdef HAS_UNLESS
		for (i = 0; i < HAS_UNLESS; i++)
		{	j = trans[n][is]->escp[i];
			if (!j) break;
			dfs_table(n, m, j, srcln, reach, lpstate);
		}
#endif
	}
	reach[is] &= ~16; /* no longer on stack */
}
void
do_dfs(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
{	int i;
	dfs_table(n, m, is, srcln, reach, lpstate);
	for (i = 0; i < m; i++)
		reach[i] &= ~(4|8|16);
}
void
crack(int n, int j, Trans *z, short srcln[])
{	int i;

	if (!z) return;
	printf("	state %3d -(tr %3d)-> state %3d  ",
		j, z->forw, z->st);
	printf("[id %3d tp %3d", z->t_id, z->tpe[0]);
	if (z->tpe[1]) printf(",%d", z->tpe[1]);
#ifdef HAS_UNLESS
	if (z->e_trans)
		printf(" org %3d", z->e_trans);
	else if (state_tables >= 2)
	for (i = 0; i < HAS_UNLESS; i++)
	{	if (!z->escp[i]) break;
		printf(" esc %d", z->escp[i]);
	}
#endif
	printf("]");
	printf(" [%s%s%s%s%s] %s:%d => ",
		z->atom&6?"A":z->atom&32?"D":"-",
		accpstate[n][j]?"a" :"-",
		stopstate[n][j]?"e" : "-",
		progstate[n][j]?"p" : "-",
		z->atom & 8 ?"L":"G",
		PanSource, srcln[j]);
	for (i = 0; z->tp[i]; i++)
		if (z->tp[i] == '\n')
			printf("\\n");
		else
			putchar(z->tp[i]);
	if (verbose && z->qu[0])
	{	printf("\t[");
		for (i = 0; i < 6; i++)
			if (z->qu[i])
				printf("(%d,%d)",
				z->qu[i], z->ty[i]);
		printf("]");
	}
	printf("\n");
	fflush(stdout);
}
/* spin -a m.pml; cc -o pan pan.c; ./pan -D | dot -Tps > foo.ps; ps2pdf foo.ps */
void
dot_crack(int n, int j, Trans *z)
{	int i;

	if (!z) return;
	printf("	S%d -> S%d  [color=black", j, z->st);

	if (z->atom&6) printf(",style=dashed");
	else if (z->atom&32) printf(",style=dotted");
	else if (z->atom&8) printf(",style=solid");
	else printf(",style=bold");

	printf(",label=\"");
	for (i = 0; z->tp[i]; i++)
	{	if (z->tp[i] == '\\'
		&&  z->tp[i+1] == 'n')
		{	i++; printf(" ");
		} else
		{	putchar(z->tp[i]);
	}	}
	printf("\"];\n");
	if (accpstate[n][j]) printf("  S%d [color=red,style=bold];\n", j);
	else if (progstate[n][j]) printf("  S%d [color=green,style=bold];\n", j);
	if (stopstate[n][j]) printf("  S%d [color=blue,style=bold,shape=box];\n", j);
}

#ifdef VAR_RANGES
#define BYTESIZE	32	/* 2^8 : 2^3 = 256:8 = 32 */

typedef struct Vr_Ptr {
	char	*nm;
	uchar	vals[BYTESIZE];
	struct Vr_Ptr *nxt;
} Vr_Ptr;
Vr_Ptr *ranges = (Vr_Ptr *) 0;

void
logval(char *s, int v)
{	Vr_Ptr *tmp;

	if (v<0 || v > 255) return;
	for (tmp = ranges; tmp; tmp = tmp->nxt)
		if (!strcmp(tmp->nm, s))
			goto found;
	tmp = (Vr_Ptr *) emalloc(sizeof(Vr_Ptr));
	tmp->nxt = ranges;
	ranges = tmp;
	tmp->nm = s;
found:
	tmp->vals[(v)/8] |= 1<<((v)%8);
}

void
dumpval(uchar X[], int range)
{	int w, x, i, j = -1;

	for (w = i = 0; w < range; w++)
	for (x = 0; x < 8; x++, i++)
	{
from:		if ((X[w] & (1<<x)))
		{	printf("%d", i);
			j = i;
			goto upto;
	}	}
	return;
	for (w = 0; w < range; w++)
	for (x = 0; x < 8; x++, i++)
	{
upto:		if (!(X[w] & (1<<x)))
		{	if (i-1 == j)
				printf(", ");
			else
				printf("-%d, ", i-1);
			goto from;
	}	}
	if (j >= 0 && j != 255)
		printf("-255");
}

void
dumpranges(void)
{	Vr_Ptr *tmp;
	printf("\nValues assigned within ");
	printf("interval [0..255]:\n");
	for (tmp = ranges; tmp; tmp = tmp->nxt)
	{	printf("\t%s\t: ", tmp->nm);
		dumpval(tmp->vals, BYTESIZE);
		printf("\n");
	}
}
#endif
