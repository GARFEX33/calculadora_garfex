# Función para extraer y formatear la información


def extraer_info(data_list):
    resultados = []
    materiales_interes = ['cobre', 'aluminio']
    
    for data in data_list:
        for tipo_instalacion, materiales in data.items():
            if materiales is None:
                continue  # Si materiales es None, se salta esta iteración
            for material in materiales_interes:
                if material in materiales and isinstance(materiales[material], dict):
                    detalles = materiales[material]
                    awg = detalles['awg']
                    corriente_maxima = detalles['corriente_maxima']
                    temperatura = detalles['temperatura']
                    numero_de_conductores_por_fase = detalles['numero_de_conductores_por_fase']
                    resultado = f"Cable en {tipo_instalacion} de {material} {numero_de_conductores_por_fase}-{awg} awg , amperaje máximo de {corriente_maxima} temperatura {temperatura}"
                    resultados.append(resultado)
    return resultados

