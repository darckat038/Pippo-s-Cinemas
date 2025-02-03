select codiceSede, indirizzo, Citta.nome as Città, tipo, t.numeroFilm
from Sede inner join Citta on Sede.codiceCitta = Citta.codiceCitta inner join
(select Proiezione.sedesala, Proiezione.sededrivein, count(*) as numeroFilm
from Proiezione inner join Film on Proiezione.titolofilm = Film.titolo
where Film.annoUscita = 2000
group by sededrivein, sedesala) as t
on Sede.codiceSede = t.sedesala

union

select codiceSede, indirizzo, Citta.nome as Città, tipo, t.numeroFilm
from Sede inner join Citta on Sede.codiceCitta = Citta.codiceCitta inner join
(select Proiezione.sedesala, Proiezione.sededrivein, count(*) as numeroFilm
from Proiezione inner join Film on Proiezione.titolofilm = Film.titolo
where Film.annoUscita = 2000
group by sededrivein, sedesala) as t
on Sede.codiceSede = t.sededrivein