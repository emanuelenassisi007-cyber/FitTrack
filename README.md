# FitTrack 

FitTrack è un'applicazione mobile sviluppata in **Flutter** progettata per aiutare gli utenti a monitorare le proprie attività fisiche e l'andamento del proprio peso corporeo. L'applicazione adotta un design elegante e pulito ispirato allo stile **Apple Cupertino**, offrendo un'esperienza utente fluida e nativa.

I dati vengono sincronizzati in tempo reale grazie all'integrazione con **Firebase Firestore**, mentre la gestione dello stato globale dell'applicazione è affidata a **Provider**.

---

##  Caratteristiche Principali

*   **Riepilogo Attività in Tempo Reale:** Visualizzazione cronologica degli allenamenti (Corsa, Palestra, ecc.) recuperati direttamente da Cloud Firestore tramite `StreamBuilder`.
*   **Dettagli dell'Allenamento:** Per ogni sessione vengono tracciati la data, il tipo di attività, le calorie bruciate e la durata precisa (ore, minuti e secondi).
*   **Monitoraggio del Peso Corporeo:** Possibilità di registrare il proprio peso quotidianamente.
*   **Grafici Intuitivi:** Visualizzazione dell'andamento del peso nel tempo tramite grafici a linee interattivi e sfumati, implementati con la libreria `fl_chart`.
*   **Storico delle Misurazioni:** Un'interfaccia a griglia (Grid View) mostra in modo chiaro tutte le pesate storiche memorizzate nel database.

---

##  Tecnologie Utilizzate

*   **Framework:** [Flutter](https://flutter.dev/) (SDK basato su Dart)
*   **UI Style:** Cupertino Widgets (iOS look & feel)
*   **Database & Backend:** [Firebase Core](https://firebase.google.com/docs/flutter/setup) & [Cloud Firestore](https://firebase.google.com/docs/firestore) (Sincronizzazione e persistenza Cloud)
*   **State Management:** [Provider](https://pub.dev/packages/provider) (`ChangeNotifier` per la gestione reattiva dei dati locali)
*   **Grafici:** [fl_chart](https://pub.dev/packages/fl_chart) (Per il rendering del grafico del peso)

---

##  Struttura dei File Principali

*   `main.dart`: Punto di ingresso dell'applicazione. Inizializza Firebase e configura il `ChangeNotifierProvider` globale.
*   `attivita.dart`: Schermata dedicata al riepilogo delle attività fisiche ed allenamenti, strutturata con un layout a schede ed aggiornamenti live.
*   `grafici.dart`: Schermata per l'inserimento del peso, la visualizzazione del grafico temporale e la griglia dello storico dei progressi.
*   `attivita_provider.dart`: Provider per la gestione dello stato locale della lista dei dati dell'attività.
*   `firebase_options.dart`: Configurazione automatica dei parametri di connessione per le piattaforme Android e iOS (generata tramite FlutterFire CLI).

---

##  Configurazione e Installazione

Per avviare il progetto sul tuo computer locale, segui questi passaggi:

### Prerequisiti
Assicurati di avere Flutter installato sul tuo sistema. In caso contrario, segui la [guida ufficiale di Flutter](https://docs.flutter.dev/get-started/install).

### 1. Clonare la repository
```bash
git clone [https://github.com/emanuelenassisi007-cyber/FitTrack.git](https://github.com/emanuelenassisi007-cyber/FitTrack.git)
cd FitTrack
```
### 2. Installare le dipendenze

Esegui il comando nel terminale per scaricare tutti i pacchetti necessari definiti nel file `pubspec.yaml`:

```bash
flutter pub get
```

### 3. Configurazione di Firebase

L'applicazione è configurata per interfacciarsi con Firebase. Se desideri utilizzare il tuo database personale, segui questi passaggi:

1. Crea un nuovo progetto sulla [Firebase Console](https://google.com).
2. Abilita **Cloud Firestore** all'interno del progetto.
3. Installa la **FlutterFire CLI** sul tuo computer ed esegui il comando:

```bash
flutterfire configure
```

>  **Nota:** Questo comando sovrascriverà automaticamente il file `lib/firebase_options.dart` con le credenziali del tuo database personale.

### 4. Avviare l'applicazione

Collega un emulatore o un dispositivo fisico e lancia il progetto con il seguente comando:

```bash
flutter run
```

---

## ⚠️ Note sulla Sicurezza

> [!IMPORTANT]
> Il file `firebase_options.dart` contiene le chiavi di configurazione del backend. 

Se decidi di rendere pubblica questa repository, assicurati di proteggere adeguatamente le regole di scrittura e lettura del tuo database su **Cloud Firestore (Firestore Rules)**. Questo passaggio è fondamentale per evitare accessi non autorizzati o utilizzi impropri delle tue risorse.
