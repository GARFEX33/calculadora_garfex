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
                
                    resultados.append(detalles)
    return resultados


def extraer_info_caida_de_tension(data_list):
    resultados = []
    
    for data in data_list:
        cable_seleccionado = data.get('cable_seleccionado', {})
        if cable_seleccionado:
            resultado = cable_seleccionado
            resultados.append(resultado)
    
    return resultados

