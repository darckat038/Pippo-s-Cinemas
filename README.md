![Static Badge](https://img.shields.io/badge/PostgreSQL-green?label=SQL)
![Static Badge](https://img.shields.io/badge/C-blue?label=language)

# Pippo's Cinemas
Progetto per il corso di Basi di Dati 2023-2024.

- Bellon Filippo 2076432
- Diviesti Filippo 2079240

# Specifiche di progetto
## Il progetto
La Base di dati riguarderà una organizzazione a scelta dello studente, in questo caso la creazione di un database per una catena di cinema multisala.
- Analisi dei requisiti
- Progettazione
  - Progettazione concettuale
  - Progettazione logica:
    sforzatevi a pensare ad uno schema che necessiti di molte delle seguenti operazioni (sarete valutati anche su questo!).\
    Giustificare ogni operazione:
     - Analisi delle ridondanze (almeno una significativa)
     - Eliminazione delle generalizzazioni
     - Partizionamento/accorpamento di entità e relazioni
     - Scelta degli identificatori primari
     - Diagramma schema ristrutturato- Schema relazionale
     - Descrizione Schema relazionale
     - Eventuali vincoli di integrità referenziale
  - Progettazione fisica (indici)
- Realizzazione
  - (PostgreSQL and software in C)

## Schema logico
Riportare su file SQL separato l’implementazione della base di dati
- Nel file SQL deve essere presente tutto il codice per:
  - Creazione tabelle
  - Popolamento
  - Query e Indici
- Consegnare il file SQL insieme alla relazione
  - Per la parte dello schema, occorre scrivere “a mano” le istruzioni CREATE TABLE
  - Per la parte relativa ai dati, si può fare il Dump via pgAdmin

## Query e indici
Il Progetto deve includere:
- Almeno 5 query significative per rispondere a domande interessanti sulla base di dati
 - Una query è significativa se coinvolge almeno due “relations” (cioè tabelle)
 - Almeno3 query devono utilizzare il “group by” e/o gli operatori aggregati
 - Almeno1 query deve utilizzare il “group by” e “having”
- Almeno un indice significativo: scegliere una delle query e creare un indice significativo, motivando la scelta.

Per ogni query si deve produrre:
- Descrizione testuale
- Codice SQL
- Screenshots dell’output delle query relativo a uno stato della base di dati anche non corrispondente a quello nel momento della consegna
- Codice C cheesegue e stampa a video le query\

 Introdurre almeno un indice:
 . Selezionare almeno una delle query definite
 - Definire un indice significativo per tale query, motivando la scelta.
 - Implementare l’indice (inserire codice anche all’interno della relazione)

## Vincoli
 Per essere accettabile un progetto deve possedere i seguenti requisiti minimi.
 - Il diagramma E-R del progetto deve contenere un numero adeguato di entità (≥ 5) escluse quelle coinvolte da una gerarchia (conta solo l’entità padre)
 - Almeno una gerarchia significativa
 - Un esempio di relazione per ogni tipo di cardinalità (1:N, 1:1, N:M)

## Criteri di valutazione
Gli elementi che verranno presi in considerazione ai fini della valutazione finale saranno:
- Correttezza dei risultati
- Complessità del problema affrontato
- Appropriatezza della metodologia seguita
- Chiarezza espositiva

# Valutazione
**23.5**/30

<table>
   <tbody>
      <tr>
         <td>Descrizione testuale dei requisiti e operazioni tipiche + Qualità della relazione</td>
         <td>
            <table><td>1 Imperfezione<br>2 su 3 punti</td></table>
         </td>
        <td></td>
      </tr>
      <tr>
         <td>Progettazione Concettuale</td>
         <td>
            <table><td>1 Errore<br>6 su 7.5 punti</td></table>
         </td>
         <td>
           Il CAP implica la provincia, perciò risulta essere sovrabbondante in fase di progettazione concettuale.
         </td>
      </tr>
      <tr>
         <td>Ristrutturazione dello schema concettuale</td>
         <td>
            <table><td>1 Errore<br>1 su 2 punti</td></table>
         </td>
         <td>
           La scelta di inserire CodiceCittà, giustificata con il fatto che esistono città italiane con lo stesso nome è errata: infatti, avendo sia il campo "CAP" che il campo "Provincia", si è già sicuri che due città nella stessa provincia non abbiamo contemporaneamente lo stesso nome e lo stesso CAP.
         </td>
      </tr>
      <tr>
         <td>Schema Relazionale</td>
         <td>
            <table><td>1 Errore<br>3 su 4 punti</td></table>
         </td>
         <td>
           L'entità "Abbonamento" non deve avere il CF cliente in quanto non è nè un attributo nella tabella, nè serve a rappresentare una relazione.
         </td>
      </tr>
      <tr>
         <td>Implementazione in SQL</td>
         <td>
            <table><td>Nessun Errore<br>2 su 2 punti</td></table>
         </td>
         <td></td>
      </tr>
      <tr>
         <td>Query</td>
         <td>
            <table><td>Nessun Errore<br>7.5 su 7.5 punti</td></table>
         </td>
         <td></td>
      </tr>
      <tr  >
         <td>Indici</td>
         <td>
            <table><td>Soluzione non buona e/o non sufficientemente motivata<br>0 su 2 punti</td></table>
         </td>
         <td>
           Il concetto di indice è sbagliato. Per la tabella "Cliente" ad esempio, il numero di scrittura sarà circa o pari a quello delle letture, questo rende l'indicizzazione non sensata. Inoltre, le motivazioni di inserimenti risultato essere poco giustificate e mancano dei riferimenti alle query proposte.
         </td>
      </tr>
      <tr  >
         <td>Accesso a DB da SQL</td>
         <td>
            <table><tr>Codice della giusta complessità<br>2 su 2 punti</td></table>
         </td>
         <td></td>
      </tr>
   </tbody>
</table>
