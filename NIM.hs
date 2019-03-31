module NIM where

import TABLERO

----------------------------------------------------- MODIFICAR EL TABLERO
--Esta función modifica el tablero dad una jugada, recibe el tablero, la fila y el número de fichas, y devuelve el tablero cambiado.
modificarTablero :: Tablero -> Int -> Int -> Tablero
modificarTablero tab fila fichas = principio ++ [cambiada] ++ (tail final)
    where (principio,final) = splitAt fila tab
          bueno = head final
          numfichas = foldl1 (+) bueno
          n = numfichas-fichas
          cambiada = (replicate ((length bueno)- n) 0) ++ (replicate n 1)


----------------------------------------------------- FUNCIONES AUXILIARES
----------------------------------------------------- Pasar a binario el tablero
tableroABinario :: Tablero -> [[Int]]
tableroABinario xss = map (aBinario digitos) unosPorFila
    where unosPorFila = map (foldl1 (+)) xss
          digitos = ((maximum unosPorFila) `div` 2 + 1)

--Recibe dos Int. El primer Int es el número de dígitos. El segundo Int el número a transformar a binario.
aBinario :: Int -> Int -> [Int]
aBinario digitos 0 = replicate digitos 0
aBinario digitos n = ceros ++ [1] ++ vector
    where vector = reverse (aBinario' n)
          numCeros = digitos - (length vector) -1
          ceros = replicate numCeros 0

aBinario' :: Int -> [Int]
aBinario' 1 = []
aBinario' n = mod n 2 : aBinario' (div n 2)

--Dado un número en binario te devuelve el número natural
desdeBinario :: [Int] -> Int
desdeBinario xs = foldl1 (+) (zipWith (*) (reverse (take n (iterate (*2) 1))) xs)
    where n = length xs


----------------------------------------------------- Paridad 
--Dada una matriz de enteros en binario, devuelve un vector de bools que indica si el número de unos de cada columna es par o impar
sonPares::[[Int]] -> [Bool]
sonPares m = map even unosPorColumna
    where unosPorColumna = (map (foldl1 (+)) (transpuesta m))


----------------------------------------------------- Posiciones False
--En el juego nos devuelve las posiciones que tenemos que modificar de una fila concreta
--Dado un vector de booleanos te devuelve un vector con la posición en la que están los valores impares
posiciones :: [Bool] -> [Int]
posiciones xs = posiciones' xs 0

posiciones' :: [Bool] -> Int -> [Int]
posiciones' [] n = []
posiciones' (x:xs) n 
    |(not)x = n:posiciones' xs (n+1)
    |otherwise = posiciones' xs (n+1)


----------------------------------------------------- Posición Primer1
--En el juego lo que debe recibir es una columna completa y devuelve un número fila
--Esta función recibe un vector (numero en binario) y el tamaño y devuelve en qué posicion está el primer 1
--El número obtenido es la fila (o montón) que vamos a modificar
primer1 :: [Int] -> Int
primer1 xs = primer1' xs 0

primer1' :: [Int] -> Int -> Int
primer1' (x:xs) n 
    |x==1 = n 
    |otherwise = primer1' xs (n+1)

----------------------------------------------------- Número de fichas a quitar
--Esta función recibe por un lado la fila concreta que vamos a modificar, por otro el vector de posiciones que tenemos que cambiar y devuelve el número de fichas
numFichas :: [Int] -> [Int] -> Int
numFichas xs ps = (desdeBinario xs) - desdeBinario (numFichas' xs ps)

--Esta función recibe por un lado la fila concreta que vamos a modificar, por otro el vector de posiciones que tenemos que cambiar y devuelve la cantidad de fichas que tienen que quedar
numFichas' :: [Int] -> [Int] -> [Int]
numFichas' xs [] = xs
numFichas' xs (p:ps) = principio ++ valorModificado ++ restoAModificar
    where (principio,final) = splitAt p xs --Cogemos los primeros valores que no hay que modificar
          valorModificado = [((xs !! p) + 1) `mod` 2] --Modificamos el valor en la posición
          restoAModificar
            |final==[] =  []--Seguimos recursivamente con los datos que nos queden
            |otherwise = numFichas' (tail final) nuevasPosiciones
                where nuevasPosiciones = map (0-) (map ((p+1)-) ps)


----------------------------------------------------- JUGADA MÁQUINA
--Esta función recibe un tablero, pasa el tablero a binario, implementa una de las dos jugadas y devuelve (la fila/montón, el número de fichas que se quieren quitar)
jugadaMaquina:: Tablero -> (Int,Int) 
jugadaMaquina tab 
    |todosPares = opcionSiPerdedora xss
    |otherwise = opcionSiGanadora xss
        where xss = tableroABinario tab
              todosPares = foldl1 (&&) (sonPares xss)

----------------------------------------------------- Jugada Si Tablero Perdedor
--Esta función busca la primera fila quita una sola pieza si estamos en posición perdedora
opcionSiPerdedora :: [[Int]] -> (Int, Int)
opcionSiPerdedora (x:xs) = opcionSiPerdedora' (x:xs) 1

opcionSiPerdedora' :: [[Int]] -> Int -> (Int, Int)
opcionSiPerdedora' (x:xs) n
    |foldl1 (+) x == 0 =  opcionSiPerdedora' xs (n+1)
    |otherwise = (n,1)
 

----------------------------------------------------- Jugada Si Tablero Ganador
opcionSiGanadora :: [[Int]] -> (Int, Int)
opcionSiGanadora xss = (numFila,fichas)
    where numFila = primer1 (matrizColumnas !! primeraColumna) --La posición de la fila (+1 para que haga el cambio bien)
          posModificar = posiciones (sonPares xss) --Creamos el vector de posiciones
          primeraColumna = posModificar !! 0 --Elegimos la primera columna que cumple cuya posición hemos guardado
          matrizColumnas = transpuesta xss
          fichas = numFichas fila posModificar 
          fila = xss !! numFila --La posición de la fila es el número de la fila -1 (que se lo hemos sumado antes)
