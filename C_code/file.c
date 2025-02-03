#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dependencies/include/libpq-fe.h"

#define PG_HOST    "localhost" //indirizzo-nome database server
#define PG_USER    "fbellon"  //inserire user corretto
#define PG_DB      "provabella"  //inserire db corretto 
#define PG_PASS    "itRxZi,Xwi9e" 	// inserire password corretta
#define PG_PORT    15432

void checkCommand(PGresult *res, const PGconn *conn) {
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Comando fallito %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(1);
    }
}

void checkResults(PGresult *res, const PGconn *conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Risultati inconsistenti %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(1);
    }
}

char* getCurrentPath(char **argv) {
    static char path[1024];
    strcpy(path, argv[0]);
    char *pos = strrchr(path, '/');
    if (pos != NULL) {
        *(pos + 1) = '\0';
    } else {
        path[0] = '\0';
    }
    return path;
}

void printResults(PGresult *res) {

    // Dichiaro le variabili per le tuple e i campi risultanti
    int tuple = PQntuples(res);
    int campi = PQnfields(res);

    // Calcolo la larghezza massima di ciascuna colonna
    int maxL[campi];

    for (int i = 0; i < campi; ++i) {
        maxL[i] = strlen(PQfname(res, i));  // Lunghezza dell'intestazione
    }

    for (int i = 0; i < tuple; ++i) {
        for (int j = 0; j < campi; ++j) {
            int len = strlen(PQgetvalue(res, i, j));
            if (len > maxL[j]) {            // Confronto tra lunghezza intestazione e lunghezza valore
                maxL[j] = len;              // Tengo il maggiore
            }
        }
    }

    // Stampo le intestazioni delle colonne con la larghezza massima
    for (int i = 0; i < campi; ++i) {
        printf("%-*s ", maxL[i], PQfname(res, i));
    }
    printf("\n");

    // Stampo una linea di separazione
    for (int i = 0; i < campi; ++i) {
        for (int j = 0; j < maxL[i]; j++) {
            printf("-");
        }
        printf(" ");
    }
    printf("\n");

    // Stampo i valori selezionati
    for (int i = 0; i < tuple; ++i) {
        for (int j = 0; j < campi; j++) {
            printf("%-*s ", maxL[j], PQgetvalue(res, i, j));
        }
        printf("\n");
    }
}

int main(int argc, char **argv) {

    char conninfo [250];
    sprintf ( conninfo , " user=%s password=%s dbname=%s host=%s port=%d " , PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT ) ;

    printf("\nConnessione: ");

    // Eseguo la connessione al database
    PGconn *conn;
    conn = PQconnectdb(conninfo);

    printf("OK\n");

    printf("Verifica stato connessione: ");

    // Verifico lo stato di connessione
    if (PQstatus(conn) != CONNECTION_OK) {
        printf("Errore di connessione: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }

    printf("OK\n\n");

    // Dichiaro la variabile dei risultati
    PGresult *res;

    // Query 1: Selezionare il codice sede, l’indirizzo, la città, il tipo della sede e il numero di film di un certo anno proiettati per ogni sede

    printf("Query 1: Selezionare il codice sede, l'indirizzo, la città, il tipo della sede e il numero di film di un certo anno proiettati per ogni sede\n\n");

    // Definisco la query parametrica
    char *query1 = "select codiceSede, indirizzo, Citta.nome as Citta, tipo, t.numeroFilm "
                    "from Sede inner join Citta on Sede.codiceCitta = Citta.codiceCitta "
                        "inner join (select Proiezione.sedesala, Proiezione.sededrivein, count(*) as numeroFilm "
                                    "from Proiezione inner join Film on Proiezione.titolofilm = Film.titolo "
                                    "where Film.annoUscita = $1::decimal group by sededrivein, sedesala) as t on Sede.codiceSede = t.sedesala "
                    "union "

                    "select codiceSede, indirizzo, Citta.nome as Citta, tipo, t.numeroFilm "
                    "from Sede inner join Citta on Sede.codiceCitta = Citta.codiceCitta "
                        "inner join (select Proiezione.sedesala, Proiezione.sededrivein, count(*) as numeroFilm "
                                    "from Proiezione "
                                        "inner join Film on Proiezione.titolofilm = Film.titolo "
                                    "where Film.annoUscita = $1::decimal group by sededrivein, sedesala) as t on Sede.codiceSede = t.sededrivein ";

    // Preparo la query prima che venga eseguita
    res = PQprepare(conn, "stmt1", query1, 1, NULL);

    checkCommand(res, conn);

    // Definisco le variabili che mi servono,
    // una per ogni variabile templetizzata
    char annoFilm[4] = "";

    // Faccio inserire dati all'utente
    printf("Inserisci anno: ");
    scanf("%s", annoFilm);
    printf("\n");

    //Mi ricavo i parametri necessari
    const char *parameter1 = annoFilm;

    // Eseguo lo statement query1 passando come parametro l'anno del film da cercare
    res = PQexecPrepared(conn, "stmt1", 1, &parameter1, NULL, 0, 0);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    // Query 2: Per ogni film, di cui sono stati venduti dei biglietti, indicare il titolo, la trama, il rating e gli incassi totali relativi a quel determinato film

    printf("Query 2: Per ogni film, di cui sono stati venduti dei biglietti, indicare il titolo, la trama, il rating e gli incassi totali relativi a quel determinato film\n\n");

    // Definisco la query
    char *query2 = "select Film.titolo, Film.trama, Film.rating, t2.prezzoTot "
                    "from (select titolofilm, sum(prezzo) as prezzoTot "
                        "from (select codicebiglietto, codiceproiezione, Parcheggio.prezzo "
                            "from Biglietto "
                                "left join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and Biglietto.sedeparcheggio = Parcheggio.sede "
                            "where Parcheggio.prezzo is not null "
                    "union "
                    "select codicebiglietto, codiceproiezione, Poltrona.prezzo "
                            "from Biglietto "
                                "inner join Poltrona on Biglietto.rigaposto = Poltrona.riga and Biglietto.colonnaposto = Poltrona.colonna and Biglietto.numerosala = Poltrona.numerosala and Biglietto.sedesala = Poltrona.sedesala) as t "
                                    "inner join Proiezione on Proiezione.codiceproiezione = t.codiceproiezione "
                    "group by titolofilm) as t2 "
                        "inner join Film on t2.titolofilm = Film.titolo ";

    // Eseguo la query
    res = PQexec(conn, query2);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    // Query 3: Nome e cognome e minuti totali dei clienti che hanno visionato dei film per una durata totale complessiva di almeno tot minuti

    printf("Query 3: Nome e cognome e minuti totali dei clienti che hanno visionato dei film per una durata totale complessiva di almeno tot minuti\n\n");

    // Definisco la query parametrica
    char *query3 = "select Cliente.nome, Cliente.cognome, t.minutiTotali "
                    "from ( "
                        "select cfcliente, sum(durata) as minutiTotali "
                        "from Biglietto "
                            "inner join Proiezione on Biglietto.codiceproiezione = Proiezione.codiceproiezione "
                                "inner join Film on Proiezione.titolofilm = Film.titolo "
                        "group by cfcliente "
                        "having sum(durata) >= $1::decimal) as t "
                            "inner join Cliente on t.cfcliente = Cliente.cf ";

    // Preparo la query prima che venga eseguita
    res = PQprepare(conn, "stmt3", query3, 1, NULL);

    checkCommand(res, conn);

    // Definisco le variabili che mi servono,
    // una per ogni variabile templetizzata
    char totMinuti[10] = "";

    // Faccio inserire dati all'utente
    printf("Inserisci minuti totali: ");
    scanf("%s", totMinuti);
    printf("\n");

    //Mi ricavo i parametri necessari
    const char *parameter1_3 = totMinuti;

    // Eseguo lo statement passando il parametro richiesto
    res = PQexecPrepared(conn, "stmt3", 1, &parameter1_3, NULL, 0, 0);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    // Query 4: Il codice proiezione, film, rating del film e data della proiezione con il maggior numero di biglietti venduti

    printf("Query 4: Il codice proiezione, film, rating del film e data della proiezione con il maggior numero di biglietti venduti\n\n");

    // Definisco la query
    char *query4 = "select * "
                    "from (select Proiezione.codiceproiezione, Proiezione.data, titolo, rating, t.numeroBigliettiVenduti "
                        "from (select Biglietto.codiceproiezione, count(*) as numeroBigliettiVenduti "
                                "from Biglietto "
                                "group by Biglietto.codiceproiezione) as t "
                                "inner join Proiezione on t.codiceproiezione = Proiezione.codiceproiezione "
                                "inner join Film on Proiezione.titolofilm = Film.titolo) as t2 "
                    "where numeroBigliettiVenduti = (select max(t3.numeroBigliettiVenduti) "
                                                    "from (select count(*) as numeroBigliettiVenduti "
                                                        "from Biglietto "
                                                        "group by Biglietto.codiceproiezione) as t3) ";

    // Eseguo la query
    res = PQexec(conn, query4);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    // Query 5: In una determinata sede stampare per ogni tipo di posto il numero totale di biglietti venduti

    printf("Query 5: In una determinata sede stampare per ogni tipo di posto il numero totale di biglietti venduti\n\n");

    // Definisco le query
    char *pre_query5 = "select codiceSede, tipo from Sede ";

    char *query5 = "select tipo, count(*) as numeroBigliettiVenduti "
                    "from Biglietto inner join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero "
                                                            "and Biglietto.sedeparcheggio = Parcheggio.sede "
                    "where Biglietto.sedesala = $1::varchar or Biglietto.sedeparcheggio = $1::varchar "
                    "group by tipo "
                    "union "
                    "select tipo, count(*) as numeroBigliettiVenduti "
                    "from Biglietto inner join Poltrona on Biglietto.rigaposto = Poltrona.riga "
                        "and Biglietto.colonnaposto = Poltrona.colonna "
                            "and Biglietto.numerosala = Poltrona.numerosala "
                                "and Biglietto.sedesala = Poltrona.sedesala "
                    "where Biglietto.sedesala = $1::varchar or Biglietto.sedeparcheggio = $1::varchar "
                    "group by tipo ";

    // Preparo la query prima che venga eseguita
    res = PQprepare(conn, "stmt5", query5, 1, NULL);

    checkCommand(res, conn);

    // Definisco le variabili che mi servono,
    // una per ogni variabile templetizzata
    char codiceSede[6] = "";

    // Faccio inserire dati all'utente
    res = PQexec(conn, pre_query5);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    printf("Inserisci codice sede da tabella soprastante: ");
    scanf("%s", codiceSede);
    printf("\n");

    //Mi ricavo i parametri necessari
    const char *parameter1_5 = codiceSede;

    // Eseguo lo statement passando il parametro richiesto
    res = PQexecPrepared(conn, "stmt5", 1, &parameter1_5, NULL, 0, 0);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");

    // Query 6: Titolo, trama, rating e incassi totali del film con maggiori incassi

    printf("Query 6: Titolo, trama, rating e incassi totali del film con maggiori incassi\n\n");

    // Definisco la query
    char *query6 = "select Film.titolo, Film.trama, Film.rating, t2.prezzoTot as incassitotali from "
                                "(select titolofilm, sum(prezzo) as prezzoTot "
                                "from (select codicebiglietto, codiceproiezione, Parcheggio.prezzo "
                                        "from Biglietto "
                                                "left join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and "
                                                                            "Biglietto.sedeparcheggio = Parcheggio.sede "
                                        "where Parcheggio.prezzo is not null "
                                        "union "
                                        "select codicebiglietto, codiceproiezione, Poltrona.prezzo "
                                        "from Biglietto "
                                                "inner join Poltrona on Biglietto.rigaposto = Poltrona.riga "
                                            "and Biglietto.colonnaposto = Poltrona.colonna "
                                            "and Biglietto.numerosala = Poltrona.numerosala "
                                            "and Biglietto.sedesala = Poltrona.sedesala) as t "
                                            "inner join Proiezione on Proiezione.codiceproiezione = t.codiceproiezione "
                                "group by titolofilm "
                                ") as t2 inner join Film on t2.titolofilm = Film.titolo "
                    "where prezzoTot = (select max(prezzoTot) from (select sum(prezzo) as prezzoTot "
                                "from (select codicebiglietto, codiceproiezione, Parcheggio.prezzo "
                                        "from Biglietto "
                                                "left join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and "
                                                                            "Biglietto.sedeparcheggio = Parcheggio.sede "
                                        "where Parcheggio.prezzo is not null "
                                        "union "
                                        "select codicebiglietto, codiceproiezione, Poltrona.prezzo "
                                        "from Biglietto "
                                                "inner join Poltrona on Biglietto.rigaposto = Poltrona.riga "
                                            "and Biglietto.colonnaposto = Poltrona.colonna "
                                            "and Biglietto.numerosala = Poltrona.numerosala "
                                            "and Biglietto.sedesala = Poltrona.sedesala) as t "
                                            "inner join Proiezione on Proiezione.codiceproiezione = t.codiceproiezione "
                                "group by titolofilm "
                                ") as t2) ";

    // Eseguo la query
    res = PQexec(conn, query6);

    checkResults(res, conn);

    printResults(res);

    PQclear(res);

    printf("\n");
}