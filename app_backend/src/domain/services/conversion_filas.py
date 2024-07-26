
def conversion_filas_por_conduccion(data) -> list:
    # Crear una lista para almacenar las filas del CSV
    filas = []

    # Recorrer los datos y extraer la información necesaria
    for i in data:
        for j, a in i.items():
            if a is not None:  # Comprobar si 'a' no es None
                for material, cable in a.items():
                    if cable is not None:
                        if material == "corriente_por_capacidad_de_conduccion":
                            pass
                        else:
                            fila = [
                                j,
                                material,
                                cable['numero_de_conductores_por_fase'],
                                cable['awg'],
                                cable['mm'],
                                cable['corriente_maxima'],
                                cable['temperatura'],
                                cable['tabla_nom']
                            ]
                            filas.append(fila)
    return filas


def conversion_filas_por_caida(data) -> list:

    filas = []
    for  i in data:
        
            for j,a in i.items():
                if a is not None: 
                    fila = [
                        a['numero_de_conductores_por_fase'],
                        a['awg'],
                        a['mm']
                    ]
                    filas.append(fila)
 
    return filas