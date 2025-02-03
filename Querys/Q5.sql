select tipo, count(*) as numeroBigliettiVenduti
from Biglietto inner join Parcheggio on Biglietto.numeroparcheggio = Parcheggio.numero and Biglietto.sedeparcheggio = Parcheggio.sede
where Biglietto.sedesala = 'SD0002' or Biglietto.sedeparcheggio = 'SD0002'
group by tipo

union

select tipo, count(*) as numeroBigliettiVenduti
from Biglietto inner join Poltrona on Biglietto.rigaposto = Poltrona.riga and Biglietto.colonnaposto = Poltrona.colonna and Biglietto.numerosala = Poltrona.numerosala and Biglietto.sedesala = Poltrona.sedesala
where Biglietto.sedesala = 'SD0002' or Biglietto.sedeparcheggio = 'SD0002'
group by tipo;