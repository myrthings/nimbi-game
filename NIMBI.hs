module NIMBI where

import TABLERO

----------------------------------------------------- FUNCIÓN AUXILIAR PARA VER SI SON CONTIGUAS
--Esta función recibe un vector fila concreta del tablero, la posición inicial y la final de las fichas que se quieren quitar
--Devuelve un bool si esa jugada se puede realizar, es decir, si hay fichas entre esas dos posiciones sin huecos en medio
contigua :: [Int] -> Int -> Int -> Bool
contigua xs ini fin = (foldl1 (+) bueno) == (fin-ini+1)
    where (trozo1,trozo2) = splitAt (fin+1) xs
          (trozo3,bueno) = splitAt ini trozo1


------------------------------------------------------ FUNCIONES PARA EXPANDIR EL TABLERO
--Esta función evalúa el Tablero para la tirada de la máquina.
evaluarTablero :: Tablero -> Int
evaluarTablero tab
    |(esVacio tab) = 1
    |otherwise = 0


--Esta función evalúa el Tablero para la tirada de la persona.
evaluarTablero' :: Tablero -> Int
evaluarTablero' tab
    |(esVacio tab) = -1
    |otherwise = 0


--Dado un tablero nos devuelve todas las posibles jugadas siguientes
--Dividimos la expansión en filas, columnas y fichas sueltas para no contar estas últimas dos veces
expandirTablero :: Tablero -> [Tablero] 
expandirTablero tab = tablerosfilas ++ tableroscolumnas ++ tablerosfichassueltas
    where tablerosfilas = map (movimiento tab) (expandirTablero' tab expandirVector)
          tableroscolumnas1 = map (movimiento (transpuesta tab)) (expandirTablero' (transpuesta tab) expandirVector)
          tableroscolumnas = map transpuesta tableroscolumnas1
          tablerosfichassueltas = map (movimiento tab) (expandirTablero' tab fichasSueltas)


--La tupla (Int,Int,Int) representa una tirada del nimbi, la primera coordenada es la fila de la que se quitan, la segunda y la tercera las posiciones inicial y final
--Dado un tablero y una función que evalúa los movimientos por cada fila, nos devuelve todas las tiradas siguientes posibles
expandirTablero' :: Tablero -> ([Int] -> Int -> [(Int,Int,Int)]) -> [(Int,Int,Int)] 
expandirTablero' tab func = resul
    where tuplas = zipWith func tab (take dim (iterate (+1) 0))
          resul = foldl1 (++) tuplas
          dim = length tab

--Dada una fila y el número de fila te la lista de posibles movimientos excepto las fichas sueltas
--Inicializa expandirVector' que utiliza expandir contiguas desde la dim2 hasta la total
expandirVector :: [Int] -> Int -> [(Int,Int,Int)]
expandirVector xs n = expandirVector' xs n 2

expandirVector' :: [Int] -> Int -> Int -> [(Int,Int,Int)] 
expandirVector' xs n acum
    |(acum == (length xs+1)) = []
    |otherwise = (expandirContiguas xs n acum 0) ++ expandirVector' xs n (acum+1)

--Dada una fila y el número de fila te la lista de posibles movimientos solo con las fichas sueltas
--Utiliza expandir contiguas con dimension 1
fichasSueltas :: [Int] -> Int -> [(Int,Int,Int)]
fichasSueltas xs n = expandirContiguas xs n 1 0

--Dada una fila, el número de la fila (es necesario para la salida), la cantidad que se quieren quitar contiguas y la posición inicial (auxiliar)
--Te la los posibles movimientos de ese tamaño
expandirContiguas :: [Int] -> Int -> Int -> Int -> [(Int,Int,Int)] 
expandirContiguas xs n siz ini
    |(ini+siz-2) == ((length xs)-1) = []
    |(contigua xs ini fin) = [(n,ini,fin)] ++ (expandirContiguas xs n siz (ini+1))
    |otherwise = [] ++ (expandirContiguas xs n siz (ini+1))
        where fin=ini+siz-1


------------------------------------------------------- MODIFICAR EL TABLERO
--Dado un tablero y unos movimientos te calcula el tablero final
movimiento :: Tablero -> (Int,Int,Int) -> Tablero --los datos van en el sentido bueno fila 0 a la 2
movimiento tab (a,b,c) = modificarTableroNimbi tab a b c


modificarTableroNimbi :: Tablero -> Int -> Int -> Int -> Tablero
modificarTableroNimbi tab fila ini fin = principio ++ [cambiada] ++ (tail final)
    where (principio,final) = splitAt fila tab
          bueno = head final
          cambiada = trozo1 ++ ceros ++ trozo2
          trozo1 = take ini bueno
          trozo2 = drop (fin + 1) bueno
          n = (length bueno) - (length trozo1) - (length trozo2)
          ceros = replicate n 0


-------------------------------------------------------- MINIMAX
--Esta función recibe un tablero y la profundidad y devuelve el tablero tras la jugada de la máquina
minimaxMainNimbi :: Tablero -> Int -> Tablero
minimaxMainNimbi tab prof
    |(esVacio tab) = tab 
    |otherwise = mayor sigsYvals
        where sigs = expandirTablero tab
              vals = map (minimax prof expandirTablero evaluarTablero evaluarTablero' maximum minimum) sigs 
              sigsYvals = zip vals sigs


--Esta función ejecuta la estrategia minimax
minimax :: Int -> (a->[a]) -> (a->b) -> (a->b) -> ([b]->b) -> ([b]->b) -> a -> b
minimax prof expandir evaluar1 evaluar2 peor mejor prob
    |(prof==0) || null sigs = evaluar1 prob
    |otherwise = mejor (map (minimax (prof-1) expandir evaluar2 evaluar1 mejor peor) sigs)
        where sigs = expandir prob


--Dada una tupla valor,tablero te devuelve el tablero cuyo valor es mayor
mayor :: Ord b => [(b,a)] -> a 
mayor [x] = snd x
mayor (x:y:xs) 
    |fst x > fst y = mayor (x:xs)
    |otherwise = mayor (y:xs)