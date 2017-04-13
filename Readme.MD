BS Project
=======

## Membri:

- *Daniele Stefano Ferru - 65036*
- *Federico Ibba - 65065*
- *Lodovica Marchesi - 65046*
- *Simone Cusimano - 65042*
- *Giancarlo Lelli - 65045*
- *Zineb Bilil - 65070*

## Scopo del progetto:
Lo scopo del progetto è quello di effettuare la segmentazione dell'iride in input una serie di immagini raffiguranti occhi umani.

## Metodi utilizzati per la realizzazione
Per la realizzazione del progetto è stato necessario passare per diverse fasi:

- Preprocessing (due metodi differenti per pupilla e iride);
- Edge Detection (utilizzato per la zona della pupilla);
- Trasformata circolare di Hough;
- Crop zona pupilla e iride .

### Preprocessing
#### Iride
Per la zona dell'iride ci è bastato convertire l'immagine in grayscale; eseguire un'equalizzazione dell'istogramma e convertire l'immagine in bianco e nero, imponendo come threshold il valore 0.5 (in una scala in cui il bianco è rappresentato come 1, e il nero come 0).
#### Pupilla
Per la pupilla è stato necessario eseguire un crop preventivo dell'immagine, per evidenziare solo la zona dell'iride. In questo modo è stato possibile eliminare i match di pattern circolari non voluti, presenti al di fuori della suddetta zona.
Dopodichè abbiamo effettuato un hole filling, per eliminare i riflessi dovuti al flash della fotocamera.
Successivamente è stato applicato un filtro gaussiano, ed è stato seguito un edge
