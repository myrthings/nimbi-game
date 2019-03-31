module TABLERO where

--Definción del tipo
type Tablero = [[Int]]

--Crea el tablero inicial
creaTablero :: Int -> Tablero
creaTablero n = replicate n (replicate n 1)

--Avisa si el tablero está vacío
esVacio :: Tablero -> Bool
esVacio tab = foldl1 (&&) (map esFilaVacia tab)

esFilaVacia :: [Int] -> Bool
esFilaVacia xs = (foldl1 (+) xs == 0)

--Transpone el tablero
transpuesta :: [[a]] -> [[a]]
transpuesta [] = []
transpuesta [vector] = map (:[]) vector
transpuesta (v1:vs)  = zipWith (:) v1 (transpuesta vs)

-------------------------------------------- MOSTRAR TABLERO POR PARNTALA
--Estas funciones cambian los números que componen las celdas del tablero por un string que los representa y que se puede imprimir
muestraTablero :: Tablero -> String
muestraTablero tab = (numeracion' (length tab)) ++  unlines (zipWith (++) (numeracion (length tab)) (map (concat.(map cambiaCaracter)) tab))

numeracion :: Int -> [String]
numeracion n = zipWith (++) (map show (take n (iterate (+1) 1))) (replicate n " ")

numeracion' :: Int -> String
numeracion' n = "  " ++ (foldl1 (++) (numeracion n)) ++ "\n"

cambiaCaracter :: Int -> String
cambiaCaracter 0 = "  "
cambiaCaracter 1 = "| "