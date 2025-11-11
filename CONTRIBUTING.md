# Contributing to K8S_Test

Grazie per il tuo interesse nel contribuire al progetto K8S_Test! Apprezziamo il tuo tempo e il tuo sforzo.

## Come contribuire

### Segnalazione di bug

Se trovi un bug, apri un issue con:
- Descrizione chiara del problema
- Passi per riprodurre il bug
- Comportamento atteso vs comportamento attuale
- Informazioni sull'ambiente (OS, Java version, etc.)

### Richiesta di nuove funzionalità

Per proporre nuove funzionalità:
1. Controlla se non esista già un issue simile
2. Apri un nuovo issue con label "enhancement"
3. Descrivi chiaramente la funzionalità proposta
4. Spiega perché sarebbe utile

### Pull Requests

1. **Fork** del repository
2. **Crea un branch** per la tua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** delle tue modifiche (`git commit -m 'Add some AmazingFeature'`)
4. **Push** del branch (`git push origin feature/AmazingFeature`)
5. **Apri una Pull Request**

#### Linee guida per le PR

- Assicurati che tutti i test passino
- Aggiungi test per le nuove funzionalità
- Mantieni lo stile di codifica esistente
- Aggiorna la documentazione se necessario
- Descrivi chiaramente cosa fa la tua PR

### Stile di codifica

- Usa Java 17+ features quando appropriato
- Segui le convenzioni Spring Boot
- Mantieni metodi e classi piccoli e focalizzati
- Aggiungi commenti Javadoc per API pubbliche
- Usa nomi significativi per variabili e metodi

### Test

- Scrivi test unitari per nuove funzionalità
- Mantieni una copertura di test superiore al 80%
- Usa @ActiveProfiles("test") per i test
- Mockito per i mock objects

### Commit Messages

Usa il formato:
```
type(scope): description

[optional body]

[optional footer]
```

Tipi:
- `feat`: nuova funzionalità
- `fix`: correzione di bug
- `docs`: documentazione
- `style`: formattazione
- `refactor`: refactoring del codice
- `test`: aggiunta o modifica di test
- `chore`: task di manutenzione

Esempi:
```
feat(controller): add new endpoint for health check
fix(config): resolve ConfigMap loading issue
docs(readme): update deployment instructions
```

### Ambiente di sviluppo

#### Prerequisiti
- Java 17+
- Maven 3.6+
- Docker (per i test di integrazione)
- kubectl (per i test K8s)

#### Setup
```bash
git clone https://github.com/alfdagos/K8S_Test.git
cd K8S_Test
./mvnw clean install
```

#### Test
```bash
# Test unitari
./mvnw test

# Test di integrazione
./mvnw verify

# Test con profilo specifico
./mvnw test -Dspring.profiles.active=test
```

## Processo di review

1. Le PR vengono revisionate da un maintainer
2. Possono essere richieste modifiche
3. Una volta approvate, vengono merge nel branch main
4. CI/CD automatico costruisce e testa le modifiche

## Domande?

Se hai domande, apri un issue con label "question" o contatta i maintainer.

Grazie per aver contribuito! 🎉