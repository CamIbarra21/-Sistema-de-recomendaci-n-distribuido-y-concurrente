#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* CLAIM todos_los_workers_terminan */
	case 3: // STATE 1 - _spin_nvr.tmp:3 - [((!(!(productor_termino_de_enviar))&&!((cantidad_workers_finalizados==2))))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported1 = 0;
			if (verbose && !reported1)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported1 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported1 = 0;
			if (verbose && !reported1)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported1 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[3][1] = 1;
		if (!(( !( !(((int)now.productor_termino_de_enviar)))&& !((((int)now.cantidad_workers_finalizados)==2)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 8 - _spin_nvr.tmp:8 - [(!((cantidad_workers_finalizados==2)))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported8 = 0;
			if (verbose && !reported8)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported8 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported8 = 0;
			if (verbose && !reported8)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported8 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[3][8] = 1;
		if (!( !((((int)now.cantidad_workers_finalizados)==2))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 13 - _spin_nvr.tmp:10 - [-end-] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported13 = 0;
			if (verbose && !reported13)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported13 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported13 = 0;
			if (verbose && !reported13)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported13 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[3][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC :init: */
	case 6: // STATE 1 - main.pml:373 - [cursos_aprobados_por_estudiante[0] = 3] (0:0:1 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		(trpt+1)->bup.oval = ((int)now.cursos_aprobados_por_estudiante[0]);
		now.cursos_aprobados_por_estudiante[0] = 3;
#ifdef VAR_RANGES
		logval("cursos_aprobados_por_estudiante[0]", ((int)now.cursos_aprobados_por_estudiante[0]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 2 - main.pml:374 - [cursos_aprobados_por_estudiante[1] = 5] (0:0:1 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		(trpt+1)->bup.oval = ((int)now.cursos_aprobados_por_estudiante[1]);
		now.cursos_aprobados_por_estudiante[1] = 5;
#ifdef VAR_RANGES
		logval("cursos_aprobados_por_estudiante[1]", ((int)now.cursos_aprobados_por_estudiante[1]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 3 - main.pml:375 - [cursos_aprobados_por_estudiante[2] = 7] (0:0:1 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		(trpt+1)->bup.oval = ((int)now.cursos_aprobados_por_estudiante[2]);
		now.cursos_aprobados_por_estudiante[2] = 7;
#ifdef VAR_RANGES
		logval("cursos_aprobados_por_estudiante[2]", ((int)now.cursos_aprobados_por_estudiante[2]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 4 - main.pml:378 - [afinidad_por_nucleo[((0*2)+0)] = 80] (0:0:1 - 1)
		IfNotBlocked
		reached[2][4] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((0*2)+0), 6) ]);
		now.afinidad_por_nucleo[ Index(((0*2)+0), 6) ] = 80;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((0*2)+0)]", ((int)now.afinidad_por_nucleo[ Index(((0*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 5 - main.pml:379 - [afinidad_por_nucleo[((0*2)+1)] = 30] (0:0:1 - 1)
		IfNotBlocked
		reached[2][5] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((0*2)+1), 6) ]);
		now.afinidad_por_nucleo[ Index(((0*2)+1), 6) ] = 30;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((0*2)+1)]", ((int)now.afinidad_por_nucleo[ Index(((0*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 6 - main.pml:380 - [afinidad_por_nucleo[((1*2)+0)] = 20] (0:0:1 - 1)
		IfNotBlocked
		reached[2][6] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((1*2)+0), 6) ]);
		now.afinidad_por_nucleo[ Index(((1*2)+0), 6) ] = 20;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((1*2)+0)]", ((int)now.afinidad_por_nucleo[ Index(((1*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 7 - main.pml:381 - [afinidad_por_nucleo[((1*2)+1)] = 70] (0:0:1 - 1)
		IfNotBlocked
		reached[2][7] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((1*2)+1), 6) ]);
		now.afinidad_por_nucleo[ Index(((1*2)+1), 6) ] = 70;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((1*2)+1)]", ((int)now.afinidad_por_nucleo[ Index(((1*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 8 - main.pml:382 - [afinidad_por_nucleo[((2*2)+0)] = 60] (0:0:1 - 1)
		IfNotBlocked
		reached[2][8] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((2*2)+0), 6) ]);
		now.afinidad_por_nucleo[ Index(((2*2)+0), 6) ] = 60;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((2*2)+0)]", ((int)now.afinidad_por_nucleo[ Index(((2*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 9 - main.pml:383 - [afinidad_por_nucleo[((2*2)+1)] = 60] (0:0:1 - 1)
		IfNotBlocked
		reached[2][9] = 1;
		(trpt+1)->bup.oval = ((int)now.afinidad_por_nucleo[ Index(((2*2)+1), 6) ]);
		now.afinidad_por_nucleo[ Index(((2*2)+1), 6) ] = 60;
#ifdef VAR_RANGES
		logval("afinidad_por_nucleo[((2*2)+1)]", ((int)now.afinidad_por_nucleo[ Index(((2*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 10 - main.pml:386 - [habilidad_por_nucleo[((0*2)+0)] = 70] (0:0:1 - 1)
		IfNotBlocked
		reached[2][10] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((0*2)+0), 6) ]);
		now.habilidad_por_nucleo[ Index(((0*2)+0), 6) ] = 70;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((0*2)+0)]", ((int)now.habilidad_por_nucleo[ Index(((0*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 11 - main.pml:387 - [habilidad_por_nucleo[((0*2)+1)] = 40] (0:0:1 - 1)
		IfNotBlocked
		reached[2][11] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((0*2)+1), 6) ]);
		now.habilidad_por_nucleo[ Index(((0*2)+1), 6) ] = 40;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((0*2)+1)]", ((int)now.habilidad_por_nucleo[ Index(((0*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 12 - main.pml:388 - [habilidad_por_nucleo[((1*2)+0)] = 35] (0:0:1 - 1)
		IfNotBlocked
		reached[2][12] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((1*2)+0), 6) ]);
		now.habilidad_por_nucleo[ Index(((1*2)+0), 6) ] = 35;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((1*2)+0)]", ((int)now.habilidad_por_nucleo[ Index(((1*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 18: // STATE 13 - main.pml:389 - [habilidad_por_nucleo[((1*2)+1)] = 85] (0:0:1 - 1)
		IfNotBlocked
		reached[2][13] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((1*2)+1), 6) ]);
		now.habilidad_por_nucleo[ Index(((1*2)+1), 6) ] = 85;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((1*2)+1)]", ((int)now.habilidad_por_nucleo[ Index(((1*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 19: // STATE 14 - main.pml:390 - [habilidad_por_nucleo[((2*2)+0)] = 55] (0:0:1 - 1)
		IfNotBlocked
		reached[2][14] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((2*2)+0), 6) ]);
		now.habilidad_por_nucleo[ Index(((2*2)+0), 6) ] = 55;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((2*2)+0)]", ((int)now.habilidad_por_nucleo[ Index(((2*2)+0), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 15 - main.pml:391 - [habilidad_por_nucleo[((2*2)+1)] = 50] (0:0:1 - 1)
		IfNotBlocked
		reached[2][15] = 1;
		(trpt+1)->bup.oval = ((int)now.habilidad_por_nucleo[ Index(((2*2)+1), 6) ]);
		now.habilidad_por_nucleo[ Index(((2*2)+1), 6) ] = 50;
#ifdef VAR_RANGES
		logval("habilidad_por_nucleo[((2*2)+1)]", ((int)now.habilidad_por_nucleo[ Index(((2*2)+1), 6) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 21: // STATE 16 - main.pml:394 - [nucleo_del_curso[0] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][16] = 1;
		(trpt+1)->bup.oval = ((int)now.nucleo_del_curso[0]);
		now.nucleo_del_curso[0] = 0;
#ifdef VAR_RANGES
		logval("nucleo_del_curso[0]", ((int)now.nucleo_del_curso[0]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 22: // STATE 17 - main.pml:395 - [nucleo_del_curso[1] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][17] = 1;
		(trpt+1)->bup.oval = ((int)now.nucleo_del_curso[1]);
		now.nucleo_del_curso[1] = 0;
#ifdef VAR_RANGES
		logval("nucleo_del_curso[1]", ((int)now.nucleo_del_curso[1]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 23: // STATE 18 - main.pml:396 - [nucleo_del_curso[2] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][18] = 1;
		(trpt+1)->bup.oval = ((int)now.nucleo_del_curso[2]);
		now.nucleo_del_curso[2] = 1;
#ifdef VAR_RANGES
		logval("nucleo_del_curso[2]", ((int)now.nucleo_del_curso[2]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 19 - main.pml:397 - [nucleo_del_curso[3] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][19] = 1;
		(trpt+1)->bup.oval = ((int)now.nucleo_del_curso[3]);
		now.nucleo_del_curso[3] = 1;
#ifdef VAR_RANGES
		logval("nucleo_del_curso[3]", ((int)now.nucleo_del_curso[3]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 25: // STATE 20 - main.pml:405 - [prerequisitos_del_curso[((0*2)+0)] = 255] (0:0:1 - 1)
		IfNotBlocked
		reached[2][20] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((0*2)+0), 8) ]);
		now.prerequisitos_del_curso[ Index(((0*2)+0), 8) ] = 255;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((0*2)+0)]", ((int)now.prerequisitos_del_curso[ Index(((0*2)+0), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 26: // STATE 21 - main.pml:406 - [prerequisitos_del_curso[((0*2)+1)] = 255] (0:0:1 - 1)
		IfNotBlocked
		reached[2][21] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((0*2)+1), 8) ]);
		now.prerequisitos_del_curso[ Index(((0*2)+1), 8) ] = 255;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((0*2)+1)]", ((int)now.prerequisitos_del_curso[ Index(((0*2)+1), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 22 - main.pml:408 - [prerequisitos_del_curso[((1*2)+0)] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][22] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((1*2)+0), 8) ]);
		now.prerequisitos_del_curso[ Index(((1*2)+0), 8) ] = 0;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((1*2)+0)]", ((int)now.prerequisitos_del_curso[ Index(((1*2)+0), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 28: // STATE 23 - main.pml:409 - [prerequisitos_del_curso[((1*2)+1)] = 255] (0:0:1 - 1)
		IfNotBlocked
		reached[2][23] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((1*2)+1), 8) ]);
		now.prerequisitos_del_curso[ Index(((1*2)+1), 8) ] = 255;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((1*2)+1)]", ((int)now.prerequisitos_del_curso[ Index(((1*2)+1), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 29: // STATE 24 - main.pml:411 - [prerequisitos_del_curso[((2*2)+0)] = 255] (0:0:1 - 1)
		IfNotBlocked
		reached[2][24] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((2*2)+0), 8) ]);
		now.prerequisitos_del_curso[ Index(((2*2)+0), 8) ] = 255;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((2*2)+0)]", ((int)now.prerequisitos_del_curso[ Index(((2*2)+0), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 30: // STATE 25 - main.pml:412 - [prerequisitos_del_curso[((2*2)+1)] = 255] (0:0:1 - 1)
		IfNotBlocked
		reached[2][25] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((2*2)+1), 8) ]);
		now.prerequisitos_del_curso[ Index(((2*2)+1), 8) ] = 255;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((2*2)+1)]", ((int)now.prerequisitos_del_curso[ Index(((2*2)+1), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 31: // STATE 26 - main.pml:414 - [prerequisitos_del_curso[((3*2)+0)] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][26] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((3*2)+0), 8) ]);
		now.prerequisitos_del_curso[ Index(((3*2)+0), 8) ] = 1;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((3*2)+0)]", ((int)now.prerequisitos_del_curso[ Index(((3*2)+0), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 32: // STATE 27 - main.pml:415 - [prerequisitos_del_curso[((3*2)+1)] = 2] (0:0:1 - 1)
		IfNotBlocked
		reached[2][27] = 1;
		(trpt+1)->bup.oval = ((int)now.prerequisitos_del_curso[ Index(((3*2)+1), 8) ]);
		now.prerequisitos_del_curso[ Index(((3*2)+1), 8) ] = 2;
#ifdef VAR_RANGES
		logval("prerequisitos_del_curso[((3*2)+1)]", ((int)now.prerequisitos_del_curso[ Index(((3*2)+1), 8) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 33: // STATE 28 - main.pml:418 - [(run Productor())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][28] = 1;
		if (!(addproc(II, 1, 0, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 34: // STATE 29 - main.pml:419 - [(run WorkerRecomendador(0))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][29] = 1;
		if (!(addproc(II, 1, 1, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 35: // STATE 30 - main.pml:420 - [(run WorkerRecomendador(1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][30] = 1;
		if (!(addproc(II, 1, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 36: // STATE 31 - main.pml:425 - [(((cantidad_workers_finalizados<2)||(len(canal_recomendaciones_calculadas)>0)))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][31] = 1;
		if (!(((((int)now.cantidad_workers_finalizados)<2)||(q_len(now.canal_recomendaciones_calculadas)>0))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 37: // STATE 32 - main.pml:427 - [canal_recomendaciones_calculadas?estudiante_resultado,curso_uno_resultado,curso_dos_resultado] (0:0:3 - 1)
		reached[2][32] = 1;
		if (q_len(now.canal_recomendaciones_calculadas) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((int)((P2 *)_this)->estudiante_resultado);
		(trpt+1)->bup.ovals[1] = ((int)((P2 *)_this)->curso_uno_resultado);
		(trpt+1)->bup.ovals[2] = ((int)((P2 *)_this)->curso_dos_resultado);
		;
		((P2 *)_this)->estudiante_resultado = qrecv(now.canal_recomendaciones_calculadas, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval(":init::estudiante_resultado", ((int)((P2 *)_this)->estudiante_resultado));
#endif
		;
		((P2 *)_this)->curso_uno_resultado = qrecv(now.canal_recomendaciones_calculadas, XX-1, 1, 0);
#ifdef VAR_RANGES
		logval(":init::curso_uno_resultado", ((int)((P2 *)_this)->curso_uno_resultado));
#endif
		;
		((P2 *)_this)->curso_dos_resultado = qrecv(now.canal_recomendaciones_calculadas, XX-1, 2, 1);
#ifdef VAR_RANGES
		logval(":init::curso_dos_resultado", ((int)((P2 *)_this)->curso_dos_resultado));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.canal_recomendaciones_calculadas);
		sprintf(simtmp, "%d", ((int)((P2 *)_this)->estudiante_resultado)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P2 *)_this)->curso_uno_resultado)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P2 *)_this)->curso_dos_resultado)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 38: // STATE 33 - main.pml:429 - [printf('Recolector: estudiante %d recomendado con cursos %d y %d\\n',estudiante_resultado,curso_uno_resultado,curso_dos_resultado)] (0:0:0 - 1)
		IfNotBlocked
		reached[2][33] = 1;
		Printf("Recolector: estudiante %d recomendado con cursos %d y %d\n", ((int)((P2 *)_this)->estudiante_resultado), ((int)((P2 *)_this)->curso_uno_resultado), ((int)((P2 *)_this)->curso_dos_resultado));
		_m = 3; goto P999; /* 0 */
	case 39: // STATE 34 - main.pml:432 - [canal_aviso_worker_finalizado?id_worker_que_aviso] (0:0:1 - 1)
		reached[2][34] = 1;
		if (q_len(now.canal_aviso_worker_finalizado) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->id_worker_que_aviso);
		;
		((P2 *)_this)->id_worker_que_aviso = qrecv(now.canal_aviso_worker_finalizado, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval(":init::id_worker_que_aviso", ((int)((P2 *)_this)->id_worker_que_aviso));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.canal_aviso_worker_finalizado);
		sprintf(simtmp, "%d", ((int)((P2 *)_this)->id_worker_que_aviso)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 40: // STATE 35 - main.pml:433 - [cantidad_workers_finalizados = (cantidad_workers_finalizados+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][35] = 1;
		(trpt+1)->bup.oval = ((int)now.cantidad_workers_finalizados);
		now.cantidad_workers_finalizados = (((int)now.cantidad_workers_finalizados)+1);
#ifdef VAR_RANGES
		logval("cantidad_workers_finalizados", ((int)now.cantidad_workers_finalizados));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 41: // STATE 36 - main.pml:434 - [printf('Recolector: worker %d finalizó (%d/%d)\\n',id_worker_que_aviso,cantidad_workers_finalizados,2)] (0:0:0 - 1)
		IfNotBlocked
		reached[2][36] = 1;
		Printf("Recolector: worker %d finalizó (%d/%d)\n", ((int)((P2 *)_this)->id_worker_que_aviso), ((int)now.cantidad_workers_finalizados), 2);
		_m = 3; goto P999; /* 0 */
	case 42: // STATE 44 - main.pml:440 - [printf('Sistema finalizado correctamente.\\n')] (0:45:0 - 3)
		IfNotBlocked
		reached[2][44] = 1;
		Printf("Sistema finalizado correctamente.\n");
		_m = 3; goto P999; /* 0 */
	case 43: // STATE 45 - main.pml:441 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][45] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC WorkerRecomendador */
	case 44: // STATE 1 - main.pml:235 - [(!(trabajo_terminado))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		if (!( !(((int)((P1 *)_this)->trabajo_terminado))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 45: // STATE 2 - main.pml:236 - [canal_estudiantes_pendientes?id_estudiante_recibido] (0:0:1 - 1)
		reached[1][2] = 1;
		if (q_len(now.canal_estudiantes_pendientes) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_estudiante_recibido);
		;
		((P1 *)_this)->id_estudiante_recibido = qrecv(now.canal_estudiantes_pendientes, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_estudiante_recibido", ((int)((P1 *)_this)->id_estudiante_recibido));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.canal_estudiantes_pendientes);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->id_estudiante_recibido)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 46: // STATE 3 - main.pml:239 - [((id_estudiante_recibido==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][3] = 1;
		if (!((((int)((P1 *)_this)->id_estudiante_recibido)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: id_estudiante_recibido */  (trpt+1)->bup.oval = ((P1 *)_this)->id_estudiante_recibido;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->id_estudiante_recibido = 0;
		_m = 3; goto P999; /* 0 */
	case 47: // STATE 4 - main.pml:240 - [canal_estudiantes_pendientes!255] (0:0:0 - 1)
		IfNotBlocked
		reached[1][4] = 1;
		if (q_full(now.canal_estudiantes_pendientes))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.canal_estudiantes_pendientes);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.canal_estudiantes_pendientes, 0, 255, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 48: // STATE 5 - main.pml:241 - [trabajo_terminado = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->trabajo_terminado);
		((P1 *)_this)->trabajo_terminado = 1;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:trabajo_terminado", ((int)((P1 *)_this)->trabajo_terminado));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 49: // STATE 7 - main.pml:245 - [mejor_vecino_1 = 255] (0:71:5 - 1)
		IfNotBlocked
		reached[1][7] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->mejor_vecino_1);
		((P1 *)_this)->mejor_vecino_1 = 255;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_vecino_1", ((int)((P1 *)_this)->mejor_vecino_1));
#endif
		;
		/* merge: mejor_similitud_1 = 0(71, 8, 71) */
		reached[1][8] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_similitud_1);
		((P1 *)_this)->mejor_similitud_1 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_similitud_1", ((int)((P1 *)_this)->mejor_similitud_1));
#endif
		;
		/* merge: mejor_vecino_2 = 255(71, 9, 71) */
		reached[1][9] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_vecino_2);
		((P1 *)_this)->mejor_vecino_2 = 255;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_vecino_2", ((int)((P1 *)_this)->mejor_vecino_2));
#endif
		;
		/* merge: mejor_similitud_2 = 0(71, 10, 71) */
		reached[1][10] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->mejor_similitud_2);
		((P1 *)_this)->mejor_similitud_2 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_similitud_2", ((int)((P1 *)_this)->mejor_similitud_2));
#endif
		;
		/* merge: id_vecino_actual = 0(71, 11, 71) */
		reached[1][11] = 1;
		(trpt+1)->bup.ovals[4] = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 5 */
	case 50: // STATE 12 - main.pml:248 - [((id_vecino_actual<=(3-1)))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][12] = 1;
		if (!((((int)((P1 *)_this)->id_vecino_actual)<=(3-1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 51: // STATE 13 - main.pml:250 - [((id_vecino_actual!=id_estudiante_recibido))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][13] = 1;
		if (!((((int)((P1 *)_this)->id_vecino_actual)!=((int)((P1 *)_this)->id_estudiante_recibido))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 52: // STATE 14 - main.pml:94 - [interseccion = 0] (0:42:8 - 1)
		IfNotBlocked
		reached[1][14] = 1;
		(trpt+1)->bup.ovals = grab_ints(8);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->_5_2_1_interseccion);
		((P1 *)_this)->_5_2_1_interseccion = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:interseccion", ((int)((P1 *)_this)->_5_2_1_interseccion));
#endif
		;
		/* merge: union_total = 0(42, 15, 42) */
		reached[1][15] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->_5_2_1_union_total);
		((P1 *)_this)->_5_2_1_union_total = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:union_total", ((int)((P1 *)_this)->_5_2_1_union_total));
#endif
		;
		/* merge: indice_bit = 0(42, 16, 42) */
		reached[1][16] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->_5_2_1_indice_bit);
		((P1 *)_this)->_5_2_1_indice_bit = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:indice_bit", ((int)((P1 *)_this)->_5_2_1_indice_bit));
#endif
		;
		/* merge: bit_a = 0(42, 17, 42) */
		reached[1][17] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->_5_2_1_bit_a);
		((P1 *)_this)->_5_2_1_bit_a = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_a", ((int)((P1 *)_this)->_5_2_1_bit_a));
#endif
		;
		/* merge: bit_b = 0(42, 18, 42) */
		reached[1][18] = 1;
		(trpt+1)->bup.ovals[4] = ((int)((P1 *)_this)->_5_2_1_bit_b);
		((P1 *)_this)->_5_2_1_bit_b = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_b", ((int)((P1 *)_this)->_5_2_1_bit_b));
#endif
		;
		/* merge: interseccion = 0(42, 19, 42) */
		reached[1][19] = 1;
		(trpt+1)->bup.ovals[5] = ((int)((P1 *)_this)->_5_2_1_interseccion);
		((P1 *)_this)->_5_2_1_interseccion = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:interseccion", ((int)((P1 *)_this)->_5_2_1_interseccion));
#endif
		;
		/* merge: union_total = 0(42, 20, 42) */
		reached[1][20] = 1;
		(trpt+1)->bup.ovals[6] = ((int)((P1 *)_this)->_5_2_1_union_total);
		((P1 *)_this)->_5_2_1_union_total = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:union_total", ((int)((P1 *)_this)->_5_2_1_union_total));
#endif
		;
		/* merge: indice_bit = 0(42, 21, 42) */
		reached[1][21] = 1;
		(trpt+1)->bup.ovals[7] = ((int)((P1 *)_this)->_5_2_1_indice_bit);
		((P1 *)_this)->_5_2_1_indice_bit = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:indice_bit", ((int)((P1 *)_this)->_5_2_1_indice_bit));
#endif
		;
		/* merge: .(goto)(0, 43, 42) */
		reached[1][43] = 1;
		;
		_m = 3; goto P999; /* 8 */
	case 53: // STATE 22 - main.pml:102 - [((indice_bit<=(4-1)))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][22] = 1;
		if (!((((int)((P1 *)_this)->_5_2_1_indice_bit)<=(4-1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 54: // STATE 23 - main.pml:86 - [bit_a = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>indice_bit)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][23] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_2_1_bit_a);
		((P1 *)_this)->_5_2_1_bit_a = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->id_estudiante_recibido), 3) ])>>((int)((P1 *)_this)->_5_2_1_indice_bit))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_a", ((int)((P1 *)_this)->_5_2_1_bit_a));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 55: // STATE 25 - main.pml:86 - [bit_b = ((cursos_aprobados_por_estudiante[id_vecino_actual]>>indice_bit)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][25] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_2_1_bit_b);
		((P1 *)_this)->_5_2_1_bit_b = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->id_vecino_actual), 3) ])>>((int)((P1 *)_this)->_5_2_1_indice_bit))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_b", ((int)((P1 *)_this)->_5_2_1_bit_b));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 56: // STATE 27 - main.pml:107 - [(((bit_a==1)&&(bit_b==1)))] (37:0:1 - 1)
		IfNotBlocked
		reached[1][27] = 1;
		if (!(((((int)((P1 *)_this)->_5_2_1_bit_a)==1)&&(((int)((P1 *)_this)->_5_2_1_bit_b)==1))))
			continue;
		/* merge: interseccion = (interseccion+1)(0, 28, 37) */
		reached[1][28] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_2_1_interseccion);
		((P1 *)_this)->_5_2_1_interseccion = (((int)((P1 *)_this)->_5_2_1_interseccion)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:interseccion", ((int)((P1 *)_this)->_5_2_1_interseccion));
#endif
		;
		/* merge: .(goto)(0, 32, 37) */
		reached[1][32] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 57: // STATE 33 - main.pml:112 - [(((bit_a==1)||(bit_b==1)))] (42:0:4 - 1)
		IfNotBlocked
		reached[1][33] = 1;
		if (!(((((int)((P1 *)_this)->_5_2_1_bit_a)==1)||(((int)((P1 *)_this)->_5_2_1_bit_b)==1))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: _5_2_1_bit_a */  (trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->_5_2_1_bit_a;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->_5_2_1_bit_a = 0;
		if (TstOnly) return 1; /* TT */
		/* dead 1: _5_2_1_bit_b */  (trpt+1)->bup.ovals[1] = ((P1 *)_this)->_5_2_1_bit_b;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->_5_2_1_bit_b = 0;
		/* merge: union_total = (union_total+1)(42, 34, 42) */
		reached[1][34] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->_5_2_1_union_total);
		((P1 *)_this)->_5_2_1_union_total = (((int)((P1 *)_this)->_5_2_1_union_total)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:union_total", ((int)((P1 *)_this)->_5_2_1_union_total));
#endif
		;
		/* merge: .(goto)(42, 38, 42) */
		reached[1][38] = 1;
		;
		/* merge: indice_bit = (indice_bit+1)(42, 39, 42) */
		reached[1][39] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->_5_2_1_indice_bit);
		((P1 *)_this)->_5_2_1_indice_bit = (((int)((P1 *)_this)->_5_2_1_indice_bit)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:indice_bit", ((int)((P1 *)_this)->_5_2_1_indice_bit));
#endif
		;
		/* merge: .(goto)(0, 43, 42) */
		reached[1][43] = 1;
		;
		_m = 3; goto P999; /* 4 */
	case 58: // STATE 36 - main.pml:113 - [(1)] (42:0:1 - 1)
		IfNotBlocked
		reached[1][36] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(42, 38, 42) */
		reached[1][38] = 1;
		;
		/* merge: indice_bit = (indice_bit+1)(42, 39, 42) */
		reached[1][39] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_2_1_indice_bit);
		((P1 *)_this)->_5_2_1_indice_bit = (((int)((P1 *)_this)->_5_2_1_indice_bit)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:indice_bit", ((int)((P1 *)_this)->_5_2_1_indice_bit));
#endif
		;
		/* merge: .(goto)(0, 43, 42) */
		reached[1][43] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 59: // STATE 39 - main.pml:102 - [indice_bit = (indice_bit+1)] (0:42:1 - 3)
		IfNotBlocked
		reached[1][39] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_2_1_indice_bit);
		((P1 *)_this)->_5_2_1_indice_bit = (((int)((P1 *)_this)->_5_2_1_indice_bit)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:indice_bit", ((int)((P1 *)_this)->_5_2_1_indice_bit));
#endif
		;
		/* merge: .(goto)(0, 43, 42) */
		reached[1][43] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 60: // STATE 45 - main.pml:118 - [((union_total==0))] (62:0:2 - 1)
		IfNotBlocked
		reached[1][45] = 1;
		if (!((((int)((P1 *)_this)->_5_2_1_union_total)==0)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: _5_2_1_union_total */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->_5_2_1_union_total;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->_5_2_1_union_total = 0;
		/* merge: similitud_actual = 0(0, 46, 62) */
		reached[1][46] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->similitud_actual);
		((P1 *)_this)->similitud_actual = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:similitud_actual", ((int)((P1 *)_this)->similitud_actual));
#endif
		;
		/* merge: .(goto)(0, 50, 62) */
		reached[1][50] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 61: // STATE 48 - main.pml:119 - [similitud_actual = ((interseccion*100)/union_total)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][48] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->similitud_actual);
		((P1 *)_this)->similitud_actual = ((((int)((P1 *)_this)->_5_2_1_interseccion)*100)/((int)((P1 *)_this)->_5_2_1_union_total));
#ifdef VAR_RANGES
		logval("WorkerRecomendador:similitud_actual", ((int)((P1 *)_this)->similitud_actual));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 62: // STATE 52 - main.pml:257 - [((similitud_actual>mejor_similitud_1))] (71:0:5 - 1)
		IfNotBlocked
		reached[1][52] = 1;
		if (!((((int)((P1 *)_this)->similitud_actual)>((int)((P1 *)_this)->mejor_similitud_1))))
			continue;
		/* merge: mejor_similitud_2 = mejor_similitud_1(71, 53, 71) */
		reached[1][53] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->mejor_similitud_2);
		((P1 *)_this)->mejor_similitud_2 = ((int)((P1 *)_this)->mejor_similitud_1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_similitud_2", ((int)((P1 *)_this)->mejor_similitud_2));
#endif
		;
		/* merge: mejor_vecino_2 = mejor_vecino_1(71, 54, 71) */
		reached[1][54] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_vecino_2);
		((P1 *)_this)->mejor_vecino_2 = ((int)((P1 *)_this)->mejor_vecino_1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_vecino_2", ((int)((P1 *)_this)->mejor_vecino_2));
#endif
		;
		/* merge: mejor_similitud_1 = similitud_actual(71, 55, 71) */
		reached[1][55] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_similitud_1);
		((P1 *)_this)->mejor_similitud_1 = ((int)((P1 *)_this)->similitud_actual);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_similitud_1", ((int)((P1 *)_this)->mejor_similitud_1));
#endif
		;
		/* merge: mejor_vecino_1 = id_vecino_actual(71, 56, 71) */
		reached[1][56] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->mejor_vecino_1);
		((P1 *)_this)->mejor_vecino_1 = ((int)((P1 *)_this)->id_vecino_actual);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_vecino_1", ((int)((P1 *)_this)->mejor_vecino_1));
#endif
		;
		/* merge: .(goto)(71, 63, 71) */
		reached[1][63] = 1;
		;
		/* merge: .(goto)(71, 67, 71) */
		reached[1][67] = 1;
		;
		/* merge: id_vecino_actual = (id_vecino_actual+1)(71, 68, 71) */
		reached[1][68] = 1;
		(trpt+1)->bup.ovals[4] = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = (((int)((P1 *)_this)->id_vecino_actual)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 8 */
	case 63: // STATE 57 - main.pml:260 - [((similitud_actual>mejor_similitud_2))] (71:0:4 - 1)
		IfNotBlocked
		reached[1][57] = 1;
		if (!((((int)((P1 *)_this)->similitud_actual)>((int)((P1 *)_this)->mejor_similitud_2))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: mejor_similitud_2 */  (trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->mejor_similitud_2;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->mejor_similitud_2 = 0;
		/* merge: mejor_similitud_2 = similitud_actual(71, 58, 71) */
		reached[1][58] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_similitud_2);
		((P1 *)_this)->mejor_similitud_2 = ((int)((P1 *)_this)->similitud_actual);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_similitud_2", ((int)((P1 *)_this)->mejor_similitud_2));
#endif
		;
		/* merge: mejor_vecino_2 = id_vecino_actual(71, 59, 71) */
		reached[1][59] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_vecino_2);
		((P1 *)_this)->mejor_vecino_2 = ((int)((P1 *)_this)->id_vecino_actual);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_vecino_2", ((int)((P1 *)_this)->mejor_vecino_2));
#endif
		;
		/* merge: .(goto)(71, 63, 71) */
		reached[1][63] = 1;
		;
		/* merge: .(goto)(71, 67, 71) */
		reached[1][67] = 1;
		;
		/* merge: id_vecino_actual = (id_vecino_actual+1)(71, 68, 71) */
		reached[1][68] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = (((int)((P1 *)_this)->id_vecino_actual)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 6 */
	case 64: // STATE 61 - main.pml:262 - [(1)] (71:0:1 - 1)
		IfNotBlocked
		reached[1][61] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(71, 63, 71) */
		reached[1][63] = 1;
		;
		/* merge: .(goto)(71, 67, 71) */
		reached[1][67] = 1;
		;
		/* merge: id_vecino_actual = (id_vecino_actual+1)(71, 68, 71) */
		reached[1][68] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = (((int)((P1 *)_this)->id_vecino_actual)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 4 */
	case 65: // STATE 65 - main.pml:264 - [(1)] (71:0:1 - 1)
		IfNotBlocked
		reached[1][65] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(71, 67, 71) */
		reached[1][67] = 1;
		;
		/* merge: id_vecino_actual = (id_vecino_actual+1)(71, 68, 71) */
		reached[1][68] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = (((int)((P1 *)_this)->id_vecino_actual)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 66: // STATE 68 - main.pml:248 - [id_vecino_actual = (id_vecino_actual+1)] (0:71:1 - 6)
		IfNotBlocked
		reached[1][68] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_vecino_actual);
		((P1 *)_this)->id_vecino_actual = (((int)((P1 *)_this)->id_vecino_actual)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_vecino_actual", ((int)((P1 *)_this)->id_vecino_actual));
#endif
		;
		/* merge: .(goto)(0, 72, 71) */
		reached[1][72] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 67: // STATE 74 - main.pml:269 - [mejor_curso_1 = 255] (0:178:5 - 3)
		IfNotBlocked
		reached[1][74] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->mejor_curso_1);
		((P1 *)_this)->mejor_curso_1 = 255;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_curso_1", ((int)((P1 *)_this)->mejor_curso_1));
#endif
		;
		/* merge: mejor_puntaje_1 = 0(178, 75, 178) */
		reached[1][75] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_puntaje_1);
		((P1 *)_this)->mejor_puntaje_1 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_puntaje_1", ((int)((P1 *)_this)->mejor_puntaje_1));
#endif
		;
		/* merge: mejor_curso_2 = 255(178, 76, 178) */
		reached[1][76] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_curso_2);
		((P1 *)_this)->mejor_curso_2 = 255;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_curso_2", ((int)((P1 *)_this)->mejor_curso_2));
#endif
		;
		/* merge: mejor_puntaje_2 = 0(178, 77, 178) */
		reached[1][77] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->mejor_puntaje_2);
		((P1 *)_this)->mejor_puntaje_2 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_puntaje_2", ((int)((P1 *)_this)->mejor_puntaje_2));
#endif
		;
		/* merge: id_curso_candidato = 0(178, 78, 178) */
		reached[1][78] = 1;
		(trpt+1)->bup.ovals[4] = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 5 */
	case 68: // STATE 79 - main.pml:272 - [((id_curso_candidato<=(4-1)))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][79] = 1;
		if (!((((int)((P1 *)_this)->id_curso_candidato)<=(4-1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 69: // STATE 80 - main.pml:86 - [bit_ya_aprobado = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_curso_candidato)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][80] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->bit_ya_aprobado);
		((P1 *)_this)->bit_ya_aprobado = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->id_estudiante_recibido), 3) ])>>((int)((P1 *)_this)->id_curso_candidato))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_ya_aprobado", ((int)((P1 *)_this)->bit_ya_aprobado));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 70: // STATE 82 - main.pml:277 - [((bit_ya_aprobado==1))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][82] = 1;
		if (!((((int)((P1 *)_this)->bit_ya_aprobado)==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: bit_ya_aprobado */  (trpt+1)->bup.oval = ((P1 *)_this)->bit_ya_aprobado;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->bit_ya_aprobado = 0;
		_m = 3; goto P999; /* 0 */
	case 71: // STATE 83 - main.pml:277 - [(1)] (178:0:1 - 1)
		IfNotBlocked
		reached[1][83] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(178, 174, 178) */
		reached[1][174] = 1;
		;
		/* merge: id_curso_candidato = (id_curso_candidato+1)(178, 175, 178) */
		reached[1][175] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 72: // STATE 85 - main.pml:127 - [id_prerequisito_0 = 0] (0:89:3 - 1)
		IfNotBlocked
		reached[1][85] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->_5_3_3_id_prerequisito_0);
		((P1 *)_this)->_5_3_3_id_prerequisito_0 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_prerequisito_0", ((int)((P1 *)_this)->_5_3_3_id_prerequisito_0));
#endif
		;
		/* merge: id_prerequisito_1 = 0(89, 86, 89) */
		reached[1][86] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->_5_3_3_id_prerequisito_1);
		((P1 *)_this)->_5_3_3_id_prerequisito_1 = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_prerequisito_1", ((int)((P1 *)_this)->_5_3_3_id_prerequisito_1));
#endif
		;
		/* merge: bit_prerequisito = 0(89, 87, 89) */
		reached[1][87] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->_5_3_3_bit_prerequisito);
		((P1 *)_this)->_5_3_3_bit_prerequisito = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_prerequisito", ((int)((P1 *)_this)->_5_3_3_bit_prerequisito));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 73: // STATE 88 - main.pml:80 - [id_prerequisito_0 = prerequisitos_del_curso[((id_curso_candidato*2)+0)]] (0:0:1 - 1)
		IfNotBlocked
		reached[1][88] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_3_3_id_prerequisito_0);
		((P1 *)_this)->_5_3_3_id_prerequisito_0 = ((int)now.prerequisitos_del_curso[ Index(((((int)((P1 *)_this)->id_curso_candidato)*2)+0), 8) ]);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_prerequisito_0", ((int)((P1 *)_this)->_5_3_3_id_prerequisito_0));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 74: // STATE 90 - main.pml:80 - [id_prerequisito_1 = prerequisitos_del_curso[((id_curso_candidato*2)+1)]] (0:0:1 - 1)
		IfNotBlocked
		reached[1][90] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_3_3_id_prerequisito_1);
		((P1 *)_this)->_5_3_3_id_prerequisito_1 = ((int)now.prerequisitos_del_curso[ Index(((((int)((P1 *)_this)->id_curso_candidato)*2)+1), 8) ]);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_prerequisito_1", ((int)((P1 *)_this)->_5_3_3_id_prerequisito_1));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 75: // STATE 92 - main.pml:133 - [curso_cumple_prerequisitos = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[1][92] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->curso_cumple_prerequisitos);
		((P1 *)_this)->curso_cumple_prerequisitos = 1;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:curso_cumple_prerequisitos", ((int)((P1 *)_this)->curso_cumple_prerequisitos));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 76: // STATE 93 - main.pml:136 - [((id_prerequisito_0!=255))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][93] = 1;
		if (!((((int)((P1 *)_this)->_5_3_3_id_prerequisito_0)!=255)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 77: // STATE 94 - main.pml:86 - [bit_prerequisito = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_prerequisito_0)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][94] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_3_3_bit_prerequisito);
		((P1 *)_this)->_5_3_3_bit_prerequisito = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->id_estudiante_recibido), 3) ])>>((int)((P1 *)_this)->_5_3_3_id_prerequisito_0))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_prerequisito", ((int)((P1 *)_this)->_5_3_3_bit_prerequisito));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 78: // STATE 96 - main.pml:140 - [((bit_prerequisito==0))] (117:0:2 - 1)
		IfNotBlocked
		reached[1][96] = 1;
		if (!((((int)((P1 *)_this)->_5_3_3_bit_prerequisito)==0)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: _5_3_3_bit_prerequisito */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->_5_3_3_bit_prerequisito;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->_5_3_3_bit_prerequisito = 0;
		/* merge: curso_cumple_prerequisitos = 0(0, 97, 117) */
		reached[1][97] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->curso_cumple_prerequisitos);
		((P1 *)_this)->curso_cumple_prerequisitos = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:curso_cumple_prerequisitos", ((int)((P1 *)_this)->curso_cumple_prerequisitos));
#endif
		;
		/* merge: .(goto)(0, 101, 117) */
		reached[1][101] = 1;
		;
		/* merge: .(goto)(0, 105, 117) */
		reached[1][105] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 79: // STATE 106 - main.pml:147 - [((id_prerequisito_1!=255))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][106] = 1;
		if (!((((int)((P1 *)_this)->_5_3_3_id_prerequisito_1)!=255)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 80: // STATE 107 - main.pml:86 - [bit_prerequisito = ((cursos_aprobados_por_estudiante[id_estudiante_recibido]>>id_prerequisito_1)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][107] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->_5_3_3_bit_prerequisito);
		((P1 *)_this)->_5_3_3_bit_prerequisito = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->id_estudiante_recibido), 3) ])>>((int)((P1 *)_this)->_5_3_3_id_prerequisito_1))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_prerequisito", ((int)((P1 *)_this)->_5_3_3_bit_prerequisito));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 81: // STATE 109 - main.pml:151 - [((bit_prerequisito==0))] (171:0:2 - 1)
		IfNotBlocked
		reached[1][109] = 1;
		if (!((((int)((P1 *)_this)->_5_3_3_bit_prerequisito)==0)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: _5_3_3_bit_prerequisito */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->_5_3_3_bit_prerequisito;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->_5_3_3_bit_prerequisito = 0;
		/* merge: curso_cumple_prerequisitos = 0(0, 110, 171) */
		reached[1][110] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->curso_cumple_prerequisitos);
		((P1 *)_this)->curso_cumple_prerequisitos = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:curso_cumple_prerequisitos", ((int)((P1 *)_this)->curso_cumple_prerequisitos));
#endif
		;
		/* merge: .(goto)(0, 114, 171) */
		reached[1][114] = 1;
		;
		/* merge: .(goto)(0, 118, 171) */
		reached[1][118] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 82: // STATE 120 - main.pml:282 - [((curso_cumple_prerequisitos==1))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][120] = 1;
		if (!((((int)((P1 *)_this)->curso_cumple_prerequisitos)==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: curso_cumple_prerequisitos */  (trpt+1)->bup.oval = ((P1 *)_this)->curso_cumple_prerequisitos;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->curso_cumple_prerequisitos = 0;
		_m = 3; goto P999; /* 0 */
	case 83: // STATE 121 - main.pml:283 - [id_nucleo_del_curso = nucleo_del_curso[id_curso_candidato]] (0:0:1 - 1)
		IfNotBlocked
		reached[1][121] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_nucleo_del_curso);
		((P1 *)_this)->id_nucleo_del_curso = ((int)now.nucleo_del_curso[ Index(((int)((P1 *)_this)->id_curso_candidato), 4) ]);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_nucleo_del_curso", ((int)((P1 *)_this)->id_nucleo_del_curso));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 84: // STATE 122 - main.pml:70 - [valor_afinidad = afinidad_por_nucleo[((id_estudiante_recibido*2)+id_nucleo_del_curso)]] (0:0:1 - 1)
		IfNotBlocked
		reached[1][122] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->valor_afinidad);
		((P1 *)_this)->valor_afinidad = ((int)now.afinidad_por_nucleo[ Index(((((int)((P1 *)_this)->id_estudiante_recibido)*2)+((int)((P1 *)_this)->id_nucleo_del_curso)), 6) ]);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:valor_afinidad", ((int)((P1 *)_this)->valor_afinidad));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 85: // STATE 124 - main.pml:288 - [aporte_afinidad = ((valor_afinidad*25)/100)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][124] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->aporte_afinidad);
		((P1 *)_this)->aporte_afinidad = ((((int)((P1 *)_this)->valor_afinidad)*25)/100);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_afinidad", ((int)((P1 *)_this)->aporte_afinidad));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 86: // STATE 125 - main.pml:75 - [valor_habilidad = habilidad_por_nucleo[((id_estudiante_recibido*2)+id_nucleo_del_curso)]] (0:0:1 - 1)
		IfNotBlocked
		reached[1][125] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->valor_habilidad);
		((P1 *)_this)->valor_habilidad = ((int)now.habilidad_por_nucleo[ Index(((((int)((P1 *)_this)->id_estudiante_recibido)*2)+((int)((P1 *)_this)->id_nucleo_del_curso)), 6) ]);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:valor_habilidad", ((int)((P1 *)_this)->valor_habilidad));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 87: // STATE 127 - main.pml:293 - [aporte_habilidad = ((valor_habilidad*25)/100)] (0:140:2 - 1)
		IfNotBlocked
		reached[1][127] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->aporte_habilidad);
		((P1 *)_this)->aporte_habilidad = ((((int)((P1 *)_this)->valor_habilidad)*25)/100);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_habilidad", ((int)((P1 *)_this)->aporte_habilidad));
#endif
		;
		/* merge: cantidad_vecinos_que_aprobaron = 0(140, 128, 140) */
		reached[1][128] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron);
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = 0;
#ifdef VAR_RANGES
		logval("WorkerRecomendador:cantidad_vecinos_que_aprobaron", ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 88: // STATE 129 - main.pml:299 - [((mejor_vecino_1!=255))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][129] = 1;
		if (!((((int)((P1 *)_this)->mejor_vecino_1)!=255)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 89: // STATE 130 - main.pml:86 - [bit_vecino_aprobo = ((cursos_aprobados_por_estudiante[mejor_vecino_1]>>id_curso_candidato)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][130] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->bit_vecino_aprobo);
		((P1 *)_this)->bit_vecino_aprobo = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->mejor_vecino_1), 3) ])>>((int)((P1 *)_this)->id_curso_candidato))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_vecino_aprobo", ((int)((P1 *)_this)->bit_vecino_aprobo));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 90: // STATE 132 - main.pml:304 - [((bit_vecino_aprobo==1))] (153:0:2 - 1)
		IfNotBlocked
		reached[1][132] = 1;
		if (!((((int)((P1 *)_this)->bit_vecino_aprobo)==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: bit_vecino_aprobo */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->bit_vecino_aprobo;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->bit_vecino_aprobo = 0;
		/* merge: cantidad_vecinos_que_aprobaron = (cantidad_vecinos_que_aprobaron+1)(0, 133, 153) */
		reached[1][133] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron);
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = (((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:cantidad_vecinos_que_aprobaron", ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron));
#endif
		;
		/* merge: .(goto)(0, 137, 153) */
		reached[1][137] = 1;
		;
		/* merge: .(goto)(0, 141, 153) */
		reached[1][141] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 91: // STATE 142 - main.pml:311 - [((mejor_vecino_2!=255))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][142] = 1;
		if (!((((int)((P1 *)_this)->mejor_vecino_2)!=255)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 92: // STATE 143 - main.pml:86 - [bit_vecino_aprobo = ((cursos_aprobados_por_estudiante[mejor_vecino_2]>>id_curso_candidato)&1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][143] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->bit_vecino_aprobo);
		((P1 *)_this)->bit_vecino_aprobo = ((((int)now.cursos_aprobados_por_estudiante[ Index(((int)((P1 *)_this)->mejor_vecino_2), 3) ])>>((int)((P1 *)_this)->id_curso_candidato))&1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:bit_vecino_aprobo", ((int)((P1 *)_this)->bit_vecino_aprobo));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 93: // STATE 145 - main.pml:316 - [((bit_vecino_aprobo==1))] (167:0:4 - 1)
		IfNotBlocked
		reached[1][145] = 1;
		if (!((((int)((P1 *)_this)->bit_vecino_aprobo)==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: bit_vecino_aprobo */  (trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->bit_vecino_aprobo;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->bit_vecino_aprobo = 0;
		/* merge: cantidad_vecinos_que_aprobaron = (cantidad_vecinos_que_aprobaron+1)(167, 146, 167) */
		reached[1][146] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron);
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = (((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:cantidad_vecinos_que_aprobaron", ((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron));
#endif
		;
		/* merge: .(goto)(167, 150, 167) */
		reached[1][150] = 1;
		;
		/* merge: .(goto)(167, 154, 167) */
		reached[1][154] = 1;
		;
		/* merge: aporte_colaborativo = ((cantidad_vecinos_que_aprobaron*50)/2)(167, 155, 167) */
		reached[1][155] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->aporte_colaborativo);
		((P1 *)_this)->aporte_colaborativo = ((((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)*50)/2);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_colaborativo", ((int)((P1 *)_this)->aporte_colaborativo));
#endif
		;
		/* merge: puntaje_curso = ((aporte_afinidad+aporte_habilidad)+aporte_colaborativo)(167, 156, 167) */
		reached[1][156] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->puntaje_curso);
		((P1 *)_this)->puntaje_curso = ((((int)((P1 *)_this)->aporte_afinidad)+((int)((P1 *)_this)->aporte_habilidad))+((int)((P1 *)_this)->aporte_colaborativo));
#ifdef VAR_RANGES
		logval("WorkerRecomendador:puntaje_curso", ((int)((P1 *)_this)->puntaje_curso));
#endif
		;
		_m = 3; goto P999; /* 5 */
	case 94: // STATE 148 - main.pml:317 - [(1)] (167:0:2 - 1)
		IfNotBlocked
		reached[1][148] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(167, 150, 167) */
		reached[1][150] = 1;
		;
		/* merge: .(goto)(167, 154, 167) */
		reached[1][154] = 1;
		;
		/* merge: aporte_colaborativo = ((cantidad_vecinos_que_aprobaron*50)/2)(167, 155, 167) */
		reached[1][155] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->aporte_colaborativo);
		((P1 *)_this)->aporte_colaborativo = ((((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)*50)/2);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_colaborativo", ((int)((P1 *)_this)->aporte_colaborativo));
#endif
		;
		/* merge: puntaje_curso = ((aporte_afinidad+aporte_habilidad)+aporte_colaborativo)(167, 156, 167) */
		reached[1][156] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->puntaje_curso);
		((P1 *)_this)->puntaje_curso = ((((int)((P1 *)_this)->aporte_afinidad)+((int)((P1 *)_this)->aporte_habilidad))+((int)((P1 *)_this)->aporte_colaborativo));
#ifdef VAR_RANGES
		logval("WorkerRecomendador:puntaje_curso", ((int)((P1 *)_this)->puntaje_curso));
#endif
		;
		_m = 3; goto P999; /* 4 */
	case 95: // STATE 152 - main.pml:319 - [(1)] (167:0:2 - 1)
		IfNotBlocked
		reached[1][152] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(167, 154, 167) */
		reached[1][154] = 1;
		;
		/* merge: aporte_colaborativo = ((cantidad_vecinos_que_aprobaron*50)/2)(167, 155, 167) */
		reached[1][155] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->aporte_colaborativo);
		((P1 *)_this)->aporte_colaborativo = ((((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)*50)/2);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_colaborativo", ((int)((P1 *)_this)->aporte_colaborativo));
#endif
		;
		/* merge: puntaje_curso = ((aporte_afinidad+aporte_habilidad)+aporte_colaborativo)(167, 156, 167) */
		reached[1][156] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->puntaje_curso);
		((P1 *)_this)->puntaje_curso = ((((int)((P1 *)_this)->aporte_afinidad)+((int)((P1 *)_this)->aporte_habilidad))+((int)((P1 *)_this)->aporte_colaborativo));
#ifdef VAR_RANGES
		logval("WorkerRecomendador:puntaje_curso", ((int)((P1 *)_this)->puntaje_curso));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 96: // STATE 155 - main.pml:322 - [aporte_colaborativo = ((cantidad_vecinos_que_aprobaron*50)/2)] (0:167:2 - 5)
		IfNotBlocked
		reached[1][155] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->aporte_colaborativo);
		((P1 *)_this)->aporte_colaborativo = ((((int)((P1 *)_this)->cantidad_vecinos_que_aprobaron)*50)/2);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:aporte_colaborativo", ((int)((P1 *)_this)->aporte_colaborativo));
#endif
		;
		/* merge: puntaje_curso = ((aporte_afinidad+aporte_habilidad)+aporte_colaborativo)(167, 156, 167) */
		reached[1][156] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->puntaje_curso);
		((P1 *)_this)->puntaje_curso = ((((int)((P1 *)_this)->aporte_afinidad)+((int)((P1 *)_this)->aporte_habilidad))+((int)((P1 *)_this)->aporte_colaborativo));
#ifdef VAR_RANGES
		logval("WorkerRecomendador:puntaje_curso", ((int)((P1 *)_this)->puntaje_curso));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 97: // STATE 157 - main.pml:329 - [((puntaje_curso>mejor_puntaje_1))] (178:0:5 - 1)
		IfNotBlocked
		reached[1][157] = 1;
		if (!((((int)((P1 *)_this)->puntaje_curso)>((int)((P1 *)_this)->mejor_puntaje_1))))
			continue;
		/* merge: mejor_puntaje_2 = mejor_puntaje_1(178, 158, 178) */
		reached[1][158] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->mejor_puntaje_2);
		((P1 *)_this)->mejor_puntaje_2 = ((int)((P1 *)_this)->mejor_puntaje_1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_puntaje_2", ((int)((P1 *)_this)->mejor_puntaje_2));
#endif
		;
		/* merge: mejor_curso_2 = mejor_curso_1(178, 159, 178) */
		reached[1][159] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_curso_2);
		((P1 *)_this)->mejor_curso_2 = ((int)((P1 *)_this)->mejor_curso_1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_curso_2", ((int)((P1 *)_this)->mejor_curso_2));
#endif
		;
		/* merge: mejor_puntaje_1 = puntaje_curso(178, 160, 178) */
		reached[1][160] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_puntaje_1);
		((P1 *)_this)->mejor_puntaje_1 = ((int)((P1 *)_this)->puntaje_curso);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_puntaje_1", ((int)((P1 *)_this)->mejor_puntaje_1));
#endif
		;
		/* merge: mejor_curso_1 = id_curso_candidato(178, 161, 178) */
		reached[1][161] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->mejor_curso_1);
		((P1 *)_this)->mejor_curso_1 = ((int)((P1 *)_this)->id_curso_candidato);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_curso_1", ((int)((P1 *)_this)->mejor_curso_1));
#endif
		;
		/* merge: .(goto)(178, 168, 178) */
		reached[1][168] = 1;
		;
		/* merge: .(goto)(178, 172, 178) */
		reached[1][172] = 1;
		;
		/* merge: .(goto)(178, 174, 178) */
		reached[1][174] = 1;
		;
		/* merge: id_curso_candidato = (id_curso_candidato+1)(178, 175, 178) */
		reached[1][175] = 1;
		(trpt+1)->bup.ovals[4] = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 9 */
	case 98: // STATE 162 - main.pml:332 - [((puntaje_curso>mejor_puntaje_2))] (178:0:4 - 1)
		IfNotBlocked
		reached[1][162] = 1;
		if (!((((int)((P1 *)_this)->puntaje_curso)>((int)((P1 *)_this)->mejor_puntaje_2))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: mejor_puntaje_2 */  (trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->mejor_puntaje_2;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->mejor_puntaje_2 = 0;
		/* merge: mejor_puntaje_2 = puntaje_curso(178, 163, 178) */
		reached[1][163] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->mejor_puntaje_2);
		((P1 *)_this)->mejor_puntaje_2 = ((int)((P1 *)_this)->puntaje_curso);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_puntaje_2", ((int)((P1 *)_this)->mejor_puntaje_2));
#endif
		;
		/* merge: mejor_curso_2 = id_curso_candidato(178, 164, 178) */
		reached[1][164] = 1;
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->mejor_curso_2);
		((P1 *)_this)->mejor_curso_2 = ((int)((P1 *)_this)->id_curso_candidato);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:mejor_curso_2", ((int)((P1 *)_this)->mejor_curso_2));
#endif
		;
		/* merge: .(goto)(178, 168, 178) */
		reached[1][168] = 1;
		;
		/* merge: .(goto)(178, 172, 178) */
		reached[1][172] = 1;
		;
		/* merge: .(goto)(178, 174, 178) */
		reached[1][174] = 1;
		;
		/* merge: id_curso_candidato = (id_curso_candidato+1)(178, 175, 178) */
		reached[1][175] = 1;
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 7 */
	case 99: // STATE 166 - main.pml:334 - [(1)] (178:0:1 - 1)
		IfNotBlocked
		reached[1][166] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(178, 168, 178) */
		reached[1][168] = 1;
		;
		/* merge: .(goto)(178, 172, 178) */
		reached[1][172] = 1;
		;
		/* merge: .(goto)(178, 174, 178) */
		reached[1][174] = 1;
		;
		/* merge: id_curso_candidato = (id_curso_candidato+1)(178, 175, 178) */
		reached[1][175] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 5 */
	case 100: // STATE 170 - main.pml:336 - [(1)] (178:0:1 - 1)
		IfNotBlocked
		reached[1][170] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(178, 172, 178) */
		reached[1][172] = 1;
		;
		/* merge: .(goto)(178, 174, 178) */
		reached[1][174] = 1;
		;
		/* merge: id_curso_candidato = (id_curso_candidato+1)(178, 175, 178) */
		reached[1][175] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 4 */
	case 101: // STATE 175 - main.pml:272 - [id_curso_candidato = (id_curso_candidato+1)] (0:178:1 - 8)
		IfNotBlocked
		reached[1][175] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)_this)->id_curso_candidato);
		((P1 *)_this)->id_curso_candidato = (((int)((P1 *)_this)->id_curso_candidato)+1);
#ifdef VAR_RANGES
		logval("WorkerRecomendador:id_curso_candidato", ((int)((P1 *)_this)->id_curso_candidato));
#endif
		;
		/* merge: .(goto)(0, 179, 178) */
		reached[1][179] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 102: // STATE 181 - main.pml:341 - [canal_recomendaciones_calculadas!id_estudiante_recibido,mejor_curso_1,mejor_curso_2] (0:0:0 - 3)
		IfNotBlocked
		reached[1][181] = 1;
		if (q_full(now.canal_recomendaciones_calculadas))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.canal_recomendaciones_calculadas);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->id_estudiante_recibido)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->mejor_curso_1)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->mejor_curso_2)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.canal_recomendaciones_calculadas, 0, ((int)((P1 *)_this)->id_estudiante_recibido), ((int)((P1 *)_this)->mejor_curso_1), ((int)((P1 *)_this)->mejor_curso_2), 3);
		_m = 2; goto P999; /* 0 */
	case 103: // STATE 182 - main.pml:344 - [printf('Worker %d: estudiante %d -> cursos [%d, %d] (puntajes %d, %d)\\n',identificador_worker,id_estudiante_recibido,mejor_curso_1,mejor_curso_2,mejor_puntaje_1,mejor_puntaje_2)] (0:0:0 - 1)
		IfNotBlocked
		reached[1][182] = 1;
		Printf("Worker %d: estudiante %d -> cursos [%d, %d] (puntajes %d, %d)\n", ((int)((P1 *)_this)->identificador_worker), ((int)((P1 *)_this)->id_estudiante_recibido), ((int)((P1 *)_this)->mejor_curso_1), ((int)((P1 *)_this)->mejor_curso_2), ((int)((P1 *)_this)->mejor_puntaje_1), ((int)((P1 *)_this)->mejor_puntaje_2));
		_m = 3; goto P999; /* 0 */
	case 104: // STATE 188 - main.pml:350 - [canal_aviso_worker_finalizado!identificador_worker] (0:0:0 - 1)
		IfNotBlocked
		reached[1][188] = 1;
		if (q_full(now.canal_aviso_worker_finalizado))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.canal_aviso_worker_finalizado);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->identificador_worker)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.canal_aviso_worker_finalizado, 0, ((int)((P1 *)_this)->identificador_worker), 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 105: // STATE 189 - main.pml:351 - [printf('Worker %d: terminado\\n',identificador_worker)] (0:0:0 - 1)
		IfNotBlocked
		reached[1][189] = 1;
		Printf("Worker %d: terminado\n", ((int)((P1 *)_this)->identificador_worker));
		_m = 3; goto P999; /* 0 */
	case 106: // STATE 190 - main.pml:352 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][190] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Productor */
	case 107: // STATE 1 - main.pml:190 - [indice_estudiante_actual = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)_this)->indice_estudiante_actual);
		((P0 *)_this)->indice_estudiante_actual = 0;
#ifdef VAR_RANGES
		logval("Productor:indice_estudiante_actual", ((int)((P0 *)_this)->indice_estudiante_actual));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 108: // STATE 2 - main.pml:190 - [((indice_estudiante_actual<=(3-1)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (!((((int)((P0 *)_this)->indice_estudiante_actual)<=(3-1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 109: // STATE 3 - main.pml:191 - [canal_estudiantes_pendientes!indice_estudiante_actual] (0:0:0 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		if (q_full(now.canal_estudiantes_pendientes))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.canal_estudiantes_pendientes);
		sprintf(simtmp, "%d", ((int)((P0 *)_this)->indice_estudiante_actual)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.canal_estudiantes_pendientes, 0, ((int)((P0 *)_this)->indice_estudiante_actual), 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 110: // STATE 4 - main.pml:192 - [printf('Productor: enviado estudiante %d\\n',indice_estudiante_actual)] (0:8:1 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		Printf("Productor: enviado estudiante %d\n", ((int)((P0 *)_this)->indice_estudiante_actual));
		/* merge: indice_estudiante_actual = (indice_estudiante_actual+1)(8, 5, 8) */
		reached[0][5] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)_this)->indice_estudiante_actual);
		((P0 *)_this)->indice_estudiante_actual = (((int)((P0 *)_this)->indice_estudiante_actual)+1);
#ifdef VAR_RANGES
		logval("Productor:indice_estudiante_actual", ((int)((P0 *)_this)->indice_estudiante_actual));
#endif
		;
		/* merge: .(goto)(0, 9, 8) */
		reached[0][9] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 111: // STATE 11 - main.pml:195 - [canal_estudiantes_pendientes!255] (0:0:0 - 3)
		IfNotBlocked
		reached[0][11] = 1;
		if (q_full(now.canal_estudiantes_pendientes))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.canal_estudiantes_pendientes);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.canal_estudiantes_pendientes, 0, 255, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 112: // STATE 12 - main.pml:196 - [productor_termino_de_enviar = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[0][12] = 1;
		(trpt+1)->bup.oval = ((int)now.productor_termino_de_enviar);
		now.productor_termino_de_enviar = 1;
#ifdef VAR_RANGES
		logval("productor_termino_de_enviar", ((int)now.productor_termino_de_enviar));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 113: // STATE 13 - main.pml:197 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

