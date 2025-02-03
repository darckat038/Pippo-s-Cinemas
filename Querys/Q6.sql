select Film.titolo, Film.trama, Film.rating, t2.prezzoTot as incassitotali from
             (select titolofilm, sum(prezzo) as prezzoTot
               from (select codicebiglietto, codiceproiezione, Parcheggio.prezzo
                     from Biglietto
                              left join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and
                                                        Biglietto.sedeparcheggio = Parcheggio.sede
                     where Parcheggio.prezzo is not null

                     union

                     select codicebiglietto, codiceproiezione, Poltrona.prezzo
                     from Biglietto
                              inner join Poltrona on Biglietto.rigaposto = Poltrona.riga
                         and Biglietto.colonnaposto = Poltrona.colonna
                         and Biglietto.numerosala = Poltrona.numerosala
                         and Biglietto.sedesala = Poltrona.sedesala) as t
                        inner join Proiezione on Proiezione.codiceproiezione = t.codiceproiezione

               group by titolofilm
             ) as t2 inner join Film on t2.titolofilm = Film.titolo
where prezzoTot = (select max(prezzoTot) from (select sum(prezzo) as prezzoTot
               from (select codicebiglietto, codiceproiezione, Parcheggio.prezzo
                     from Biglietto
                              left join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and
                                                        Biglietto.sedeparcheggio = Parcheggio.sede
                     where Parcheggio.prezzo is not null

                     union

                     select codicebiglietto, codiceproiezione, Poltrona.prezzo
                     from Biglietto
                              inner join Poltrona on Biglietto.rigaposto = Poltrona.riga
                         and Biglietto.colonnaposto = Poltrona.colonna
                         and Biglietto.numerosala = Poltrona.numerosala
                         and Biglietto.sedesala = Poltrona.sedesala) as t
                        inner join Proiezione on Proiezione.codiceproiezione = t.codiceproiezione

               group by titolofilm
             ) as t2)