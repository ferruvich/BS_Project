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
Successivamente è stato applicato un filtro gaussiano, per effettuare uno smoothing al fine di rimuovere lievi differenze e mantenere intatte quelle più evidenti.

### Edge Detection
La fase di edge detection è stata utile per il rilevamento della pupilla.
Essa è utile per evidenziare i contorni, i segmenti e le proprietà intrinseche che caratterizzano l'immagine.
Abbiamo scelto di applicare il Canny edge detector poiché è uno dei più robusti ed efficienti per l'edge detection. Questo algoritmo evidenzia contorni sopprimendo i non-massimi mentre evidenzia i massimi reali che appartengono al vero contorno.
L'algoritmo di edge detection restituisce un'immagine binaria, contenente gli edge trovati.

### Trasformata circolare di Hough
La trasformata circolare di Hough viene utilizzata per evidenziare forme circolari presenti nell'immagine. Questa trasformata si è rilevata essenziale per il riconoscimento di forme prettamente circolari come iridi e pupille umane.  
Per effettuare questa trasformata è stata utilizzata la funzione predefinita di matlab ***imfindcircles***.
Essa prende in ingresso, oltre all'immagine ovviamente, il range dei raggi dei cerchi da evidenziare, e ulteriori parametri come:
- *Sensitivity*: un valore compreso nel range [0 1]. Un valore maggiore corrisponde ad un maggior numero di cerchi trovati. Sia per pupilla che per iride è stato usato un valore di sensitivity pari a 0.99.
- *ObjectPolarity*: valore che può essere *bright* per la localizzazione di oggetti circolari di tonalità chiara (alto valore in gray scale) oppure *dark*, per la localizzazione di oggetti circolari di tonalità scura (basso valore in grayscale).
Per quanto riguarda la pupilla, alcune immagini tendevano a trovare numerosi oggetti circolari all'interno dell'iride. Per risolvere questa situazione, è bastato controllare il centro di ogni cerchio, e prendere il primo le cui coordinate sono entro un range di distanza rispetto al centro dell'iride.
Questo viene fatto perché, nel caso medio, pupilla e iride hanno più o meno lo stesso centro.
Si è scelto di prendere il primo cerchio che fosse abbastanza vicino e non il più vicino in assoluto perchè, dopo uno studio su numerose immagini, si è notato che i cerchi trovati attraverso imfindcircles si trovavano tutti distanti rispetto al centro dell'iride, tranne uno, che rappresentava per l'appunto la pupilla.

### Crop immagine
Per il crop dell'immagine è bastato sfruttare il centro di iride e pupilla. Sono state preparate delle maschere specifiche per entrambe.
Il crop dell'immagine è stato di due tipologie:
- Crop dell'immagine in formato binario;
- Crop dell'immagine in RGB.
All'interno della cartella *examples* sono presenti numerosi esempi della serie (immagine originale, crop binaria, crop RGB).
