# Nim and Nimbi games for the terminal
These games are built using functional programming. It was a project from Math Degree with Computer Science minor at UCM.

*The game is in Spanish. Léeme after readme.*

----

## Readme

### Context 🗺️
Nim is a game without a clear origin. Some people said it was first played in the East ⛩ and others that it was in Europe 🏛.
It's a game of two players 👫 which consists in leaving a number of pieces on a surface and set some rules to remove them. The one that picks the last piece wins 🏆 the game (or she loses, it depends on the version)

Nimbi is an extension of Nim created by philosofer Piet Hein 🤔 after mathematician Charles Leonard Bouton 🤓 found a wining strategy for Nim. The dynamic of the game is the same but, instead of picking pieces by columns or rows or groups, players can pick as much adjacent pieces  🤲 as they want.

### Games 🧩
There's a lot of versions of Nim. We've programmed a nxn board in which the one that picks the last game piece wins. The rule is picking pieces by rows. For Nimbi there's also an nxn board and the player choose between which coordenates she wants to pick pieces. In both games it's possible to choose the size of the board and is played against the machine.

### Development :gear:
The game is built in Haskell and it uses 4 modules:
 - Main `juego.hs`: it includes the menus for using the games an the auxiliar functions they need.
 - `TABLERO.hs`: *Tablero* means board. It's the structure of the board and the functions used to operate on it that both games need.
 - `NIM.hs`: the functions of the game Nim. It uses the wining strategy for the machine (the player always start, so depending on the size there's a chance to win for her).
 - `NIMBI.hs`: the functions of the game Nimbi. It uses a minimax algorithm for the machine. The deph of the tree changes depending on the dificulty chosen by the player.

There's also a `Docs` folder used for storing the instructions and the games if the player interrupts the game to play later.

:warning: *There's no control of types (don't write strings on numbers)*

### How to play 🤹‍♀️
- Download the whole repository and get into the folder.
- Install ghci compiler for Haskell if don't have it.
- To start the compiler type:
```
ghci
```
- Load the game with:
```
:l juego.hs
```
- Type menu to start playing.
```
Main>: menu
```
- Play!
- To close the game click 3.Salir on the menu and then type:
```
Main> :quit
```
 
-----
## Léeme
### Contexto 🗺️
El Nim es un juego antiguo cuyo origen no está muy claro, algunos lo sitúan en Oriente ⛩ y otros en Europa 🏛.
Es un juego de dos jugadores 👫 que consiste en poner varias fichas sobre una superficie y poner unas reglas para ir retirándolas, ganando 🏆 el que se lleve la última (o perdiendo, según la versión).

El Nimbi es una extensión del Nim creada por el filósofo Piet Hein 🤔 después de que el matemático Charles Leornard Bouton hallara una estrategia ganadora 🤓 para el Nim. La dinámica es la misma, pero en lugar de quitar las fichas únicamente por filas o columnas o montones, lo que se establece es que se puedan quitar tantas fichas como se quiera mientras estas sean contiguas 🤲.

### Juegos 🧩
Hay muchas versiones para jugar al Nim y nosotras hemos decidido programarlo en un tablero nxn, ganado el que se lleva la última ficha y retirando fichas por filas. Para el Nimbi también hemos decidido programar en un tablero nxn. Está implementado para jugar contra la máquina pudiendo elegir el tamaño del tablero.


### Desarrollo :gear:
A nivel técnico, hemos dividido el juego en 4 módulos:
 - El principal `juego.hs`, donde se incluyen los menús que inicializan los juegos y las funciones auxiliares que estos menús necesitan.
 - `TABLERO.hs`: donde se encuentra la estructura de la tablero y las funciones relacionadas con él que son comunes a los dos juegos
 - `NIM.hs`: donde se encuentra el desarrollo completo del juego del Nim, aplicando la estrategia ganadora para la máquina.
 - `NIMBI.hs`: donde se encuentra el juego completo del Nimbi, aplicando una estrategia minimax para la máquina.

Además, el juego incluye una carpeta *Docs* donde se incluyen los documentos txt que precisa: las instrucciones de ambos y los archivos donde se guardan las partidas.

:warning: *No se ha implementado control de errores en cuanto a tipos de datos en el menú*

### Cómo jugar 🤹‍♀️
- Descarga todo el respositorio y entra en la carpeta
- Instala ghci para compilar Haskell si no lo tienes.
- Inicializa el compilador:
```
ghci
```
- Carga el juego:
```
:l juego.hs
```
- Escribe "menu" para empezar a jugar
```
Main> menu
```
- Juega!
- Para cerrar pulsa 3.Salir en el menú y para cerrar definitivamente añade:
```
Main> :quit
```

----
## Authors

Creado por Laura Ruiz y myrthings

