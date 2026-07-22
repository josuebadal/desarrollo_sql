import sys 
if len(sys.argv) == 2:
    numero = int(sys.argv[1])
    if numero < 0 or numero > 9999:
        print("Error numero incorrecto")
        print("Ejemplo descomposicion.py [0 - 9999]")
    else :
        ##logica del programa
        cadena = str(numero)
        longitud = len(cadena)
        
        for i in range(longitud):

else : 
    print("Error numero incorrecto")
    print("Ejemplo descomposicion.oy [0 - 9999]")