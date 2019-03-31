import TABLERO
import NIM
import NIMBI

{-

    PRÁCTICA HASKELL - LAURA Y MYRIAM

La práctica consiste en el desarrollo de dos juegos: el Nim y el Nimbi.
El Nim es un juego antiguo cuyo origen no está muy claro, algunos lo datan en oriente y otros en Europa.
Es un juego de dos jugadores que consiste en poner varias fichas sobre una superficie y poner unas reglas para ir retirándolas, ganando el que se lleve la última (o perdiendo, según la versión).
Hay muchas versiones de este juego y nosotras hemos decidido programarlo en un tablero nxn, ganado el que se lleva la última ficha y retirando fichas por filas.

El Nimbi es una extensión del Nim creada por el filósofo Danés Piet Hein después de que el matemático Charles Leornard Bouton hallara una estrategia ganadora.
La dinámica es la misma, pero en lugar de quitar las fichas únicamente por filas o columnas o montones, lo que se establece es que 
se puedan quitar tantas fichas como se quiera mientras estas sean contiguas.
Una vez más, la hemos decidido programar en un tablero nxn.

A nivel técnico, hemos dividido el juego en 4 módulos:
 - El principal (en el que nos encontramos), donde se incluyen los menús que inicializan los juegos y las funciones auxiliares que estos menús necesitan.
 - TABLERO: donde se encuentra la estructura de la tablero y las funciones relacionadas con él que son comunes a los dos juegos
 - NIM: donde se encuentra el desarrollo completo del juego del Nim
 - NIMBI: donde se encuentra el juego completo del Nimbi

 Además, el juego incluye una carpeta "Docs" donde se incluyen los documentos txt que precisa el juego: las instrucciones de ambos y los archivos donde se guardan las partidas.

Para inicar el juego hay que cargar este archivo "juego.hs" y llamar a la función "menu".

-}

-------------------------------------------- LEER ENTRADA Y COMPROBACIONES DE ENTRADA
--Estas funciones pasan la entrada a enteros
leeEntero :: IO Int
leeEntero = do n <- getLine
               return (read n)

leeEntEnRango :: Int -> Int -> IO Int
leeEntEnRango inf sup = do n <- leeEntero
                           if (n>=inf)&&(n<=sup) then return n
                            else do putStr "Opción no válida. Inserte otra: "
                                    leeEntEnRango inf sup

--Esta función recibe la fila que se quiere modificar y el número de fichas y te devuelve verdadero si hay suficientes
esCorrecto :: [Int] -> Int -> Bool
esCorrecto xs n = (n>0) && (numFichas >= n)
    where numFichas = foldl1 (+) xs

--Esta función recibe el tablero, si es fila o columna (0,1), el número de fila/columna, la posición inicial y la final
esCorrectoNimbi :: Tablero -> Int -> Int -> Int -> Int -> Bool
esCorrectoNimbi tab 0 numFila inicial final = contigua (tab!!numFila) inicial final
esCorrectoNimbi tab 1 numCol inicial final = contigua ((transpuesta tab)!!numCol) inicial final


-------------------------------------------- MENÚS
-------------------------------------------- Menú Principal
menu:: IO ()
menu = do putStrLn "1.Jugar al NIM"
          putStrLn "2.Jugar al NIMBI"
          putStrLn "3.Salir"
          opcion <- leeEntEnRango 1 3
          case opcion of
            1 -> do menuNim 
                    menu
            2 -> do menuNimbi 
                    menu
            3 -> do putStrLn "¡Hasta luego!"


-------------------------------------------- Juego Nim
menuNim :: IO ()
menuNim = do putStrLn "1.Instrucciones"
             putStrLn "2.Jugar"
             putStrLn "3.Reanudar Partida"
             opcion <- leeEntEnRango 1 3
             case opcion of
                1 -> do contenido <- readFile "Docs/instruccionesNim.txt"
                        putStrLn contenido
                        menuNim
                2 -> do nim 
                3 -> do tablero <- readFile "Docs/partidasNim.txt"
                        let tab = read tablero
                        if (tab /= []) 
                          then do putStrLn "Este fue tu último tablero"
                                  putStrLn (muestraTablero tab)
                                  personaNim tab
                          else do putStrLn "No hay partidas guardadas"
                                  menuNim

                      
--Esta función establece el tamaño del tablero e inicializa el juego en sí
nim :: IO ()
nim = do putStrLn "Empezamos."
         putStr "Introduce el tamaño del tablero (2 a 9): "
         tamanio <- leeEntEnRango 2 9
         let tablero = creaTablero tamanio
         putStrLn (muestraTablero tablero)
         personaNim tablero


--Esta función representa la interacción del juego de la persona con entrada y salida
personaNim :: Tablero -> IO ()
personaNim tab = do putStrLn "Es tu turno. (Introduce -1 para salir y guardar partida)."
                    putStr "Dime de qué fila quieres quitar: "
                    fila <- leeEntero
                    if (fila == -1) then do let escribir = show tab 
                                            writeFile "Docs/partidasNim.txt" escribir
                                            putStrLn "Partida guardada"
                        else do putStr "Dime cuántas fichas quieres quitar: "
                                fichas <- leeEntero
                                if (not)(esCorrecto (tab!!(fila-1)) fichas) then personaNim tab 
                                    else do let nuevoTablero = modificarTablero tab (fila-1) fichas
                                            putStrLn (muestraTablero nuevoTablero)
                                            if esVacio nuevoTablero
                                               then do putStrLn "¡Has ganado!"
                                                       let escribir = "[]"
                                                       writeFile "Docs/partidasNim.txt" escribir
                                                else maquinaNim nuevoTablero


--Esta función representa la interacción del juego de la máquina con la entrada y salida
maquinaNim :: Tablero -> IO ()
maquinaNim tab = do putStrLn "Turno de la máquina"
                    let nuevoTablero = modificarTablero tab fila fichas
                        (fila,fichas) = jugadaMaquina tab
                    putStrLn (muestraTablero nuevoTablero)
                    if esVacio nuevoTablero
                         then do putStrLn "¡Has perdido!"
                                 let escribir = "[]"
                                 writeFile "Docs/partidasNim.txt" escribir
                           else personaNim nuevoTablero
        

-------------------------------------------- Juego Nimbi
menuNimbi :: IO ()
menuNimbi = do putStrLn "1.Instrucciones"
               putStrLn "2.Jugar"
               putStrLn "3.Reanudar Partida"
               opcion <- leeEntEnRango 1 3
               case opcion of
                  1 -> do contenido <- readFile "Docs/instruccionesNimbi.txt"
                          putStrLn contenido
                          menuNimbi
                  2 -> do nimbi 
                  3 -> do tablero <- readFile "Docs/partidasNimbi.txt"
                          let tab = read tablero
                          if (tab /= []) 
                             then do putStrLn "Este fue tu último tablero"
                                     putStrLn (muestraTablero tab)
                                     profundidad  <- readFile "Docs/partidasNimbiprof.txt"
                                     let prof = read profundidad
                                     personaNimbi tab prof
                             else do putStrLn "No hay partidas guardadas"
                                     menuNimbi


--Esta función establece el tamaño del tablero, la dificultad e inicializa el juego en sí
nimbi :: IO ()
nimbi = do putStrLn "Empezamos."
           putStr "Elige dificultad: 0 para modo fácil, 1 medio, 2 difícil: "
           dificultad <- leeEntEnRango 0 2
           let tablero = (creaTablero 3)
           putStrLn (muestraTablero tablero)
           if (dificultad == 0)  then personaNimbi tablero 3
                                 else if (dificultad == 1)
                                           then personaNimbi tablero 4
                                           else personaNimbi tablero 5

--Esta función representa la interacción del juego de la persona con entrada y salida
personaNimbi :: Tablero -> Int-> IO ()
personaNimbi tab prof = do putStrLn "Es tu turno."
                           putStr "Presiona 0 para jugar por filas o presiona 1 para jugar por columnas (-1 para salir): "
                           op <- leeEntEnRango (-1) 1
                           if (op/=(-1))
                              then do putStr "Dime el número de fila/columna: "
                                      filcol <- leeEntero
                                      putStr "Dime la posición inicial: "
                                      ini <- leeEntero
                                      putStr "Dime la posición final: "
                                      fin <- leeEntero
                                      if (not) (esCorrectoNimbi tab op (filcol-1) (ini-1) (fin-1))
                                        then do putStrLn "Movimiento no válido."
                                                personaNimbi tab prof
                                         else do let nuevoTablero = jugadaNimbi tab op filcol ini fin
                                                 putStrLn (muestraTablero nuevoTablero)
                                                 if esVacio nuevoTablero
                                                    then do putStrLn "¡Has ganado!"
                                                            let escribir = "[]"
                                                            writeFile "Docs/partidasNimbi.txt" escribir
                                                    else maquinaNimbi nuevoTablero prof
                               else do let escribir = show tab
                                       let escribirprof = show prof 
                                       writeFile "Docs/partidasNimbi.txt" escribir
                                       writeFile "Docs/partidasNimbiprof.txt" escribirprof
                                       putStrLn "Partida guardada"

--Esta función es auxiliar e inicializa el juego dada la opción de fila o de columna
jugadaNimbi :: Tablero -> Int -> Int -> Int -> Int -> Tablero --Dado un tablero (0 o 1) el numero de fila y las posiciones ini y fin
jugadaNimbi tab 0 num ini fin = modificarTableroNimbi tab (num-1) (ini-1) (fin-1)
jugadaNimbi tab 1 num ini fin = transpuesta (modificarTableroNimbi (transpuesta tab) (num-1) (ini-1) (fin-1))

--Esta función representa la interacción del juego de la máquina con entrada y salida
maquinaNimbi :: Tablero->Int-> IO ()
maquinaNimbi tab prof = do putStrLn "Turno de la máquina"
                           let nuevoTablero = minimaxMainNimbi tab prof
                           putStrLn (muestraTablero nuevoTablero)
                           if esVacio nuevoTablero
                                then do putStrLn "¡Has perdido!"
                                        let escribir = "[]"
                                        writeFile "Docs/partidasNimbi.txt" escribir
                                else personaNimbi nuevoTablero prof
        






