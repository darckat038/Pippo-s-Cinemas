select *
from (select Proiezione.codiceproiezione, Proiezione.data, titolo, rating, t.numeroBigliettiVenduti
      from (select Biglietto.codiceproiezione, count(*) as numeroBigliettiVenduti
            from Biglietto
            group by Biglietto.codiceproiezione) as t
               inner join Proiezione on t.codiceproiezione = Proiezione.codiceproiezione
               inner join Film on Proiezione.titolofilm = Film.titolo) as t2
where numeroBigliettiVenduti = (select max(t3.numeroBigliettiVenduti)
                                from (select count(*) as numeroBigliettiVenduti
                                      from Biglietto
                                      group by Biglietto.codiceproiezione) as t3)