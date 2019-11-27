# Workday

> Disclaimer: this project targets a very specific French labor law, so the rest of this document is written in French.

Ce projet permet de remplir les déclarations légales de temps travaillé [au forfait jour](https://www.service-public.fr/particuliers/vosdroits/F19261).

![Screenshot](https://i.imgur.com/V2Vu6ZC.jpg)

Il est écrit en [Elm](https://elm-lang.org/) et utilise [elm-kitchen](https://github.com/allo-media/elm-kitchen) pour l'architecture technique et la structuration des fichiers.

## Installation

NodeJS et npm doivent être installés et opérationnel sur le système.

```
$ npm install
```

## Usage

Pour démarrer le serveur de développement.

```
$ npm start
```

L'application Web sera servie sur [localhost:3000](http://localhost:3000/).

## Tests

```
$ npm test
```

Les tests sont situés dans le répertoire `tests` et sont gérés par [elm-test](https://github.com/elm-community/elm-test).

## Build

```
$ npm run build
```

Le build est généré dans le dossier `build`.

## Deploy

La commande `deploy` permet de publier l'application via [Github Pages](https://pages.github.com/).

```
$ npm run deploy
```

## License

[MIT](https://opensource.org/licenses/MIT)
