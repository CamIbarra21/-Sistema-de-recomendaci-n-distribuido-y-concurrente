/*
 * ============================================================================
 *  MODELO PROMELA: exclusión mutua del progreso de un estudiante (RWMutex)
 * ============================================================================
 *
 *  Modela shared.LiveDataset (src/shared/progress.go) para UN estudiante:
 *    - Escritor = MarkApproved: lee el bitmask, le enciende un bit y lo escribe.
 *      Se toma el lock de ESCRITURA (RWMutex.Lock).
 *    - Lector   = Snapshot: lee el bitmask. Se toma el lock de LECTURA (RWMutex.RLock).
 *
 *  Las semánticas del RWMutex que se modelan:
 *    - Dos escritores nunca están dentro a la vez.
 *    - Un escritor y un lector nunca están dentro a la vez.
 *    - Varios lectores SÍ pueden estar dentro a la vez.
 *
 *  La escritura se hace en dos pasos (leer y luego escribir) a propósito, para que
 *  sin lock exista el problema clásico de "actualización perdida".
 *
 *  Compilación con -DSIN_LOCK: se quitan los locks. La verificación DEBE fallar;
 *  sirve de control negativo y demuestra que el lock es necesario.
 *
 *  Comandos: ver promela/README.md y promela/verificar.sh
 * ============================================================================
 */

#define N_ESCRITORES 2   // dos MarkApproved simultáneos sobre el mismo estudiante
#define N_LECTORES   2   // dos Snapshot simultáneos
#define TODOS_LOS_BITS 3 // cursos 0 y 1 aprobados: 0b11

byte completado = 0;      // bitmask de cursos aprobados del estudiante

/* --- estado interno del RWMutex --- */
bool escribiendo = false;    // hay un escritor con el lock
byte lectores_lock = 0;      // cantidad de lectores con el lock de lectura

/* --- observadores para verificar (no forman parte del lock) --- */
byte en_escritura = 0;       // procesos que están realmente dentro de la sección crítica de escritura
byte en_lectura = 0;         // procesos que están realmente dentro de la sección de lectura
byte terminados = 0;
bool fin = false;

#ifdef SIN_LOCK
inline rlock()    { skip }
inline runlock()  { skip }
inline wlock()    { skip }
inline wunlock()  { skip }
#else
inline rlock()    { atomic { !escribiendo -> lectores_lock++ } }
inline runlock()  { atomic { lectores_lock-- } }
inline wlock()    { atomic { (!escribiendo && lectores_lock == 0) -> escribiendo = true } }
inline wunlock()  { escribiendo = false }
#endif

proctype Escritor(byte bit_curso) {
    byte tmp;

    wlock();
    en_escritura++;
    assert(en_escritura == 1 && en_lectura == 0);   // exclusión mutua de escritura

    tmp = completado;                               // leer
    completado = tmp | (1 << bit_curso);            // modificar y escribir (no atómico a propósito)

    en_escritura--;
    wunlock();

    atomic { terminados++ }
}

proctype Lector() {
    byte v1, v2;

    rlock();
    en_lectura++;
    assert(en_escritura == 0);                      // ningún escritor mientras se lee

    v1 = completado;
    v2 = completado;
    assert(v1 == v2);                               // lectura consistente (sin escritura a la mitad)

    en_lectura--;
    runlock();

    atomic { terminados++ }
}

init {
    byte i;

    for (i : 0 .. N_ESCRITORES - 1) { run Escritor(i) }
    for (i : 0 .. N_LECTORES - 1)   { run Lector() }

    (terminados == N_ESCRITORES + N_LECTORES);      // espera tipo WaitGroup

    assert(completado == TODOS_LOS_BITS);           // ninguna actualización se perdió
    fin = true;
}

/* ----------------------------------------------------------------------
 * PROPIEDADES LTL (se elige una con ./pan -a -N nombre)
 * ---------------------------------------------------------------------- */

// Exclusión mutua: nunca dos escritores dentro, y nunca un escritor junto a un lector.
ltl exclusion_mutua {
    [] (en_escritura <= 1 && (en_escritura == 0 || en_lectura == 0))
}

// Sin actualizaciones perdidas: al terminar, los dos cursos quedaron aprobados.
ltl sin_actualizaciones_perdidas {
    [] (fin -> completado == TODOS_LOS_BITS)
}

// CONTROL (se espera que FALLE): los lectores NO son excluyentes entre sí,
// o sea, un RWMutex permite lecturas simultáneas.
ltl lectores_son_exclusivos {
    [] (en_lectura <= 1)
}
