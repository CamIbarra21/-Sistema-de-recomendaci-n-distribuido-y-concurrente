	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* CLAIM todos_los_workers_terminan */
;
		;
		;
		;
		
	case 5: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC :init: */

	case 6: // STATE 1
		;
		now.cursos_aprobados_por_estudiante[0] = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 2
		;
		now.cursos_aprobados_por_estudiante[1] = trpt->bup.oval;
		;
		goto R999;

	case 8: // STATE 3
		;
		now.cursos_aprobados_por_estudiante[2] = trpt->bup.oval;
		;
		goto R999;

	case 9: // STATE 4
		;
		now.afinidad_por_nucleo[ Index(((0*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 10: // STATE 5
		;
		now.afinidad_por_nucleo[ Index(((0*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 11: // STATE 6
		;
		now.afinidad_por_nucleo[ Index(((1*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 7
		;
		now.afinidad_por_nucleo[ Index(((1*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 13: // STATE 8
		;
		now.afinidad_por_nucleo[ Index(((2*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 14: // STATE 9
		;
		now.afinidad_por_nucleo[ Index(((2*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 15: // STATE 10
		;
		now.habilidad_por_nucleo[ Index(((0*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 16: // STATE 11
		;
		now.habilidad_por_nucleo[ Index(((0*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 17: // STATE 12
		;
		now.habilidad_por_nucleo[ Index(((1*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 18: // STATE 13
		;
		now.habilidad_por_nucleo[ Index(((1*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 19: // STATE 14
		;
		now.habilidad_por_nucleo[ Index(((2*2)+0), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 20: // STATE 15
		;
		now.habilidad_por_nucleo[ Index(((2*2)+1), 6) ] = trpt->bup.oval;
		;
		goto R999;

	case 21: // STATE 16
		;
		now.nucleo_del_curso[0] = trpt->bup.oval;
		;
		goto R999;

	case 22: // STATE 17
		;
		now.nucleo_del_curso[1] = trpt->bup.oval;
		;
		goto R999;

	case 23: // STATE 18
		;
		now.nucleo_del_curso[2] = trpt->bup.oval;
		;
		goto R999;

	case 24: // STATE 19
		;
		now.nucleo_del_curso[3] = trpt->bup.oval;
		;
		goto R999;

	case 25: // STATE 20
		;
		now.prerequisitos_del_curso[ Index(((0*2)+0), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 26: // STATE 21
		;
		now.prerequisitos_del_curso[ Index(((0*2)+1), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 27: // STATE 22
		;
		now.prerequisitos_del_curso[ Index(((1*2)+0), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 28: // STATE 23
		;
		now.prerequisitos_del_curso[ Index(((1*2)+1), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 29: // STATE 24
		;
		now.prerequisitos_del_curso[ Index(((2*2)+0), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 30: // STATE 25
		;
		now.prerequisitos_del_curso[ Index(((2*2)+1), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 31: // STATE 26
		;
		now.prerequisitos_del_curso[ Index(((3*2)+0), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 32: // STATE 27
		;
		now.prerequisitos_del_curso[ Index(((3*2)+1), 8) ] = trpt->bup.oval;
		;
		goto R999;

	case 33: // STATE 28
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 34: // STATE 29
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 35: // STATE 30
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;
;
		;
		
	case 37: // STATE 32
		;
		XX = 1;
		unrecv(now.canal_recomendaciones_calculadas, XX-1, 0, ((int)((P2 *)_this)->estudiante_resultado), 1);
		unrecv(now.canal_recomendaciones_calculadas, XX-1, 1, ((int)((P2 *)_this)->curso_uno_resultado), 0);
		unrecv(now.canal_recomendaciones_calculadas, XX-1, 2, ((int)((P2 *)_this)->curso_dos_resultado), 0);
		((P2 *)_this)->estudiante_resultado = trpt->bup.ovals[0];
		((P2 *)_this)->curso_uno_resultado = trpt->bup.ovals[1];
		((P2 *)_this)->curso_dos_resultado = trpt->bup.ovals[2];
		;
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;
;
		;
		
	case 39: // STATE 34
		;
		XX = 1;
		unrecv(now.canal_aviso_worker_finalizado, XX-1, 0, ((int)((P2 *)_this)->id_worker_que_aviso), 1);
		((P2 *)_this)->id_worker_que_aviso = trpt->bup.oval;
		;
		;
		goto R999;

	case 40: // STATE 35
		;
		now.cantidad_workers_finalizados = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		
	case 42: // STATE 44
		goto R999;

	case 43: // STATE 45
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC WorkerRecomendador */
;
		;
		
	case 45: // STATE 2
		;
		XX = 1;
		unrecv(now.canal_estudiantes_pendientes, XX-1, 0, ((int)((P1 *)_this)->id_estudiante_recibido), 1);
		((P1 *)_this)->id_estudiante_recibido = trpt->bup.oval;
		;
		;
		goto R999;

	case 46: // STATE 3
		;
	/* 0 */	((P1 *)_this)->id_estudiante_recibido = trpt->bup.oval;
		;
		;
		goto R999;

	case 47: // STATE 4
		;
		_m = unsend(now.canal_estudiantes_pendientes);
		;
		goto R999;

	case 48: // STATE 5
		;
		((P1 *)_this)->trabajo_terminado = trpt->bup.oval;
		;
		goto R999;

	case 49: // STATE 11
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.ovals[4];
		((P1 *)_this)->mejor_similitud_2 = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_vecino_2 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_similitud_1 = trpt->bup.ovals[1];
		((P1 *)_this)->mejor_vecino_1 = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		;
		;
		
	case 52: // STATE 21
		;
		((P1 *)_this)->_5_2_1_indice_bit = trpt->bup.ovals[7];
		((P1 *)_this)->_5_2_1_union_total = trpt->bup.ovals[6];
		((P1 *)_this)->_5_2_1_interseccion = trpt->bup.ovals[5];
		((P1 *)_this)->_5_2_1_bit_b = trpt->bup.ovals[4];
		((P1 *)_this)->_5_2_1_bit_a = trpt->bup.ovals[3];
		((P1 *)_this)->_5_2_1_indice_bit = trpt->bup.ovals[2];
		((P1 *)_this)->_5_2_1_union_total = trpt->bup.ovals[1];
		((P1 *)_this)->_5_2_1_interseccion = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 8);
		goto R999;
;
		;
		
	case 54: // STATE 23
		;
		((P1 *)_this)->_5_2_1_bit_a = trpt->bup.oval;
		;
		goto R999;

	case 55: // STATE 25
		;
		((P1 *)_this)->_5_2_1_bit_b = trpt->bup.oval;
		;
		goto R999;

	case 56: // STATE 28
		;
		((P1 *)_this)->_5_2_1_interseccion = trpt->bup.oval;
		;
		goto R999;

	case 57: // STATE 39
		;
		((P1 *)_this)->_5_2_1_indice_bit = trpt->bup.ovals[3];
		((P1 *)_this)->_5_2_1_union_total = trpt->bup.ovals[2];
	/* 1 */	((P1 *)_this)->_5_2_1_bit_b = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->_5_2_1_bit_a = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 58: // STATE 39
		;
		((P1 *)_this)->_5_2_1_indice_bit = trpt->bup.oval;
		;
		goto R999;

	case 59: // STATE 39
		;
		((P1 *)_this)->_5_2_1_indice_bit = trpt->bup.oval;
		;
		goto R999;

	case 60: // STATE 46
		;
		((P1 *)_this)->similitud_actual = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->_5_2_1_union_total = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 61: // STATE 48
		;
		((P1 *)_this)->similitud_actual = trpt->bup.oval;
		;
		goto R999;

	case 62: // STATE 68
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.ovals[4];
		((P1 *)_this)->mejor_vecino_1 = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_similitud_1 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_vecino_2 = trpt->bup.ovals[1];
		((P1 *)_this)->mejor_similitud_2 = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;

	case 63: // STATE 68
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_vecino_2 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_similitud_2 = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->mejor_similitud_2 = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 64: // STATE 68
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.oval;
		;
		goto R999;

	case 65: // STATE 68
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.oval;
		;
		goto R999;

	case 66: // STATE 68
		;
		((P1 *)_this)->id_vecino_actual = trpt->bup.oval;
		;
		goto R999;

	case 67: // STATE 78
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.ovals[4];
		((P1 *)_this)->mejor_puntaje_2 = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_curso_2 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_puntaje_1 = trpt->bup.ovals[1];
		((P1 *)_this)->mejor_curso_1 = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 69: // STATE 80
		;
		((P1 *)_this)->bit_ya_aprobado = trpt->bup.oval;
		;
		goto R999;

	case 70: // STATE 82
		;
	/* 0 */	((P1 *)_this)->bit_ya_aprobado = trpt->bup.oval;
		;
		;
		goto R999;

	case 71: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.oval;
		;
		goto R999;

	case 72: // STATE 87
		;
		((P1 *)_this)->_5_3_3_bit_prerequisito = trpt->bup.ovals[2];
		((P1 *)_this)->_5_3_3_id_prerequisito_1 = trpt->bup.ovals[1];
		((P1 *)_this)->_5_3_3_id_prerequisito_0 = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 73: // STATE 88
		;
		((P1 *)_this)->_5_3_3_id_prerequisito_0 = trpt->bup.oval;
		;
		goto R999;

	case 74: // STATE 90
		;
		((P1 *)_this)->_5_3_3_id_prerequisito_1 = trpt->bup.oval;
		;
		goto R999;

	case 75: // STATE 92
		;
		((P1 *)_this)->curso_cumple_prerequisitos = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 77: // STATE 94
		;
		((P1 *)_this)->_5_3_3_bit_prerequisito = trpt->bup.oval;
		;
		goto R999;

	case 78: // STATE 97
		;
		((P1 *)_this)->curso_cumple_prerequisitos = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->_5_3_3_bit_prerequisito = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 80: // STATE 107
		;
		((P1 *)_this)->_5_3_3_bit_prerequisito = trpt->bup.oval;
		;
		goto R999;

	case 81: // STATE 110
		;
		((P1 *)_this)->curso_cumple_prerequisitos = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->_5_3_3_bit_prerequisito = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 82: // STATE 120
		;
	/* 0 */	((P1 *)_this)->curso_cumple_prerequisitos = trpt->bup.oval;
		;
		;
		goto R999;

	case 83: // STATE 121
		;
		((P1 *)_this)->id_nucleo_del_curso = trpt->bup.oval;
		;
		goto R999;

	case 84: // STATE 122
		;
		((P1 *)_this)->valor_afinidad = trpt->bup.oval;
		;
		goto R999;

	case 85: // STATE 124
		;
		((P1 *)_this)->aporte_afinidad = trpt->bup.oval;
		;
		goto R999;

	case 86: // STATE 125
		;
		((P1 *)_this)->valor_habilidad = trpt->bup.oval;
		;
		goto R999;

	case 87: // STATE 128
		;
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = trpt->bup.ovals[1];
		((P1 *)_this)->aporte_habilidad = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 89: // STATE 130
		;
		((P1 *)_this)->bit_vecino_aprobo = trpt->bup.oval;
		;
		goto R999;

	case 90: // STATE 133
		;
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->bit_vecino_aprobo = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 92: // STATE 143
		;
		((P1 *)_this)->bit_vecino_aprobo = trpt->bup.oval;
		;
		goto R999;

	case 93: // STATE 156
		;
		((P1 *)_this)->puntaje_curso = trpt->bup.ovals[3];
		((P1 *)_this)->aporte_colaborativo = trpt->bup.ovals[2];
		((P1 *)_this)->cantidad_vecinos_que_aprobaron = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->bit_vecino_aprobo = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 94: // STATE 156
		;
		((P1 *)_this)->puntaje_curso = trpt->bup.ovals[1];
		((P1 *)_this)->aporte_colaborativo = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 95: // STATE 156
		;
		((P1 *)_this)->puntaje_curso = trpt->bup.ovals[1];
		((P1 *)_this)->aporte_colaborativo = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 96: // STATE 156
		;
		((P1 *)_this)->puntaje_curso = trpt->bup.ovals[1];
		((P1 *)_this)->aporte_colaborativo = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 97: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.ovals[4];
		((P1 *)_this)->mejor_curso_1 = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_puntaje_1 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_curso_2 = trpt->bup.ovals[1];
		((P1 *)_this)->mejor_puntaje_2 = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;

	case 98: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.ovals[3];
		((P1 *)_this)->mejor_curso_2 = trpt->bup.ovals[2];
		((P1 *)_this)->mejor_puntaje_2 = trpt->bup.ovals[1];
	/* 0 */	((P1 *)_this)->mejor_puntaje_2 = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 99: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.oval;
		;
		goto R999;

	case 100: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.oval;
		;
		goto R999;

	case 101: // STATE 175
		;
		((P1 *)_this)->id_curso_candidato = trpt->bup.oval;
		;
		goto R999;

	case 102: // STATE 181
		;
		_m = unsend(now.canal_recomendaciones_calculadas);
		;
		goto R999;
;
		;
		
	case 104: // STATE 188
		;
		_m = unsend(now.canal_aviso_worker_finalizado);
		;
		goto R999;
;
		;
		
	case 106: // STATE 190
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Productor */

	case 107: // STATE 1
		;
		((P0 *)_this)->indice_estudiante_actual = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 109: // STATE 3
		;
		_m = unsend(now.canal_estudiantes_pendientes);
		;
		goto R999;

	case 110: // STATE 5
		;
		((P0 *)_this)->indice_estudiante_actual = trpt->bup.oval;
		;
		goto R999;

	case 111: // STATE 11
		;
		_m = unsend(now.canal_estudiantes_pendientes);
		;
		goto R999;

	case 112: // STATE 12
		;
		now.productor_termino_de_enviar = trpt->bup.oval;
		;
		goto R999;

	case 113: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;
	}

