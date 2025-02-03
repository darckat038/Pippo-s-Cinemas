select Cliente.nome, Cliente.cognome, t.minutiTotali
from
(select cfcliente, sum(durata) as minutiTotali
from Biglietto
inner join Proiezione on Biglietto.codiceproiezione = Proiezione.codiceproiezione
inner join Film on Proiezione.titolofilm = Film.titolo
group by cfcliente
having sum(durata) >= 500) as t
inner join Cliente on t.cfcliente = Cliente.cf