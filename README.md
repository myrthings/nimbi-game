### Sobre los juegos
El Nim es un juego antiguo cuyo origen no está muy claro, algunos lo sitúan en Oriente ⛩ y otros en Europa 🏛.
Es un juego de dos jugadores 👫 que consiste en poner varias fichas sobre una superficie y poner unas reglas para ir retirándolas, ganando el que se lleve la última (o perdiendo, según la versión).
Hay muchas versiones de este juego y nosotras hemos decidido programarlo en un tablero nxn, ganado el que se lleva la última ficha 🏆 y retirando fichas por filas.

El Nimbi es una extensión del Nim creada por el filósofo Piet Hein 🤔 después de que el matemático Charles Leornard Bouton hallara una estrategia ganadora 🤓 para el Nim.
La dinámica es la misma, pero en lugar de quitar las fichas únicamente por filas o columnas o montones, lo que se establece es que 
se puedan quitar tantas fichas como se quiera mientras estas sean contiguas 🤲.
Una vez más, la hemos decidido programar en un tablero nxn.

Está implementado para jugar contra la máquina pudiendo elegir el tamaño del tablero.

### Sobre el código
A nivel técnico, hemos dividido el juego en 4 módulos:
 - El principal `juego.hs`, donde se incluyen los menús que inicializan los juegos y las funciones auxiliares que estos menús necesitan.
 - `TABLERO.hs`: donde se encuentra la estructura de la tablero y las funciones relacionadas con él que son comunes a los dos juegos
 - `NIM.hs`: donde se encuentra el desarrollo completo del juego del Nim, aplicando la estrategia ganadora para la máquina.
 - `NIMBI.hs`: donde se encuentra el juego completo del Nimbi, aplicando una estrategia minimax para la máquina.

Además, el juego incluye una carpeta *Docs* donde se incluyen los documentos txt que precisa: las instrucciones de ambos y los archivos donde se guardan las partidas.

Para inicar el juego hay que cargar este archivo en la terminal `juego.hs` y llamar a la función `menu`.

*No se ha implementado control de errores en cuanto a tipos de datos en el menú*


```
  Creado por Laura Ruiz y myrthings
```
