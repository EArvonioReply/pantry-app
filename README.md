# pantry-app

Questa applicazione ha lo scopo di tenere traccia dei cibi che abbiamo a casa e della loro scadenza.
Durante lo sviluppo di questa applicazione dovranno essere rispettati i seguenti punti:

* Utilizzare i pod [MVVMKit](https://github.com/alfogrillo/MVVMKit) e [SnapKit](https://github.com/SnapKit/SnapKit)
* Utilizzare la [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
* Non dovranno essere usati Storyboard o file Xib
* Dovranno essere usati i Design Patterns: Delegate Pattern, Coordinator, MVVM
* I dati inseriti dall'utente dovranno essere salvati su Firebase
* (Opzionale) Ogni volta che un nuovo cibo viene inserito si può creare una local notification che avvisi l'utente quando quel cibo sta per scadere e che quindi venga inviata un giorno prima della scadenza
* (Opzionale) Suggerire all'utente delle ricette con i cibi che si ha a disposizione, soprattutto con quelli in scadenza. Lo si potrebbe fare con queste API [Spoonacular](https://spoonacular.com/food-api/docs), come mostrato in questo [esempio](https://rapidapi.com/spoonacular/api/recipe-food-nutrition/).
* (Opzionale) Gestire l'account dell'utente con un login e un logout. Provare questo punto dopo aver completato tutti quelli precedenti.


## Grafica

Allego un esempio di grafica che si potrebbe sfruttare:

Di questa immagine si può sfruttare la schermata di dettaglio e i dati che vengono mostrati, per ogni singolo cibo, nella lista.

<img width="925" alt="Screenshot 2023-09-25 at 15 22 14" src="https://github.com/EArvonioReply/pantry-app/assets/68242064/8d1a4d97-470e-47a5-9b9b-b76525646ad2">

La lista, invece, potrebbe essere fatta usando questa UI che è molto più adatta ad una collection view:

<img width="926" alt="Screenshot 2023-09-25 at 15 22 34" src="https://github.com/EArvonioReply/pantry-app/assets/68242064/4f817c55-f50d-4ed7-8a3f-58c943ebe36e">

## Conclusione

Il progetto dovrà essere completo entro Venerdi 29/09/23 alle 18. Verrà discusso Lunedi 01/10/23.
