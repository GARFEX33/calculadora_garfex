from src.domain.services.conversion_filas import conversion_filas_por_conduccion, conversion_filas_por_caida
from src.domain.entities.seleccion_conductor import SeleccionDeConductor
from src.domain.entities.interruptor_termomagnetico import InterruptorTermomagnetico
from src.domain.entities.corriente_nominal import CorrienteNominal
from src.domain.entities.datos_entrada import DatosEntrada
import os

def ejecutar_main(voltaje, potencia, fp, tipo_circuito, temperatura, numero_hilos, tipo_de_voltaje, tipo_de_potencia, factor_ajuste_itm, longitud, circuito):
    datos_entrada = DatosEntrada(
        voltaje=voltaje,
        potencia=potencia,
        fp=fp,
        tipo_circuito=tipo_circuito,
        temperatura=temperatura,
        numero_hilos=numero_hilos,
        tipo_de_voltaje=tipo_de_voltaje,
        tipo_de_potencia=tipo_de_potencia,
        factor_ajuste_itm=factor_ajuste_itm,
        longitud=longitud,
        circuito=circuito
    )

    current_dir = os.path.dirname(__file__)
    file_path = os.path.join(current_dir, 'data', 'tabla_cables.csv')

    resultados = {"interrutor": "", "capacidad_conduccion": [], "caida_tension": []}

    try:
        if datos_entrada.validar_datos():
            corriente_nominal = CorrienteNominal(datos_entrada).corriente_nominal
            resultados["corriente_nominal"] = f"Corriente Nominal: {round(corriente_nominal,2)}A"
            itm = InterruptorTermomagnetico(corriente_nominal, datos_entrada.factor_ajuste_proteccion_magnetica(), datos_entrada.mapeo_tipo_circuito()).seleccionar_interruptor()
            resultados["interrutor"] = f"{itm['tipo_circuito']} X {itm['interruptor']}A"
            resultados["corriente_ajustada"] = f"{round(itm['corriente_ajustada'],2)}A"

            conductor = SeleccionDeConductor(datos_entrada, file_path, itm["interruptor"]).seleccionar_por_capacidad_conduccion(corriente_nominal)
           
            resultados["capacidad_conduccion"] = conversion_filas_por_conduccion(conductor)
            
            conductor_caida_tension = SeleccionDeConductor(datos_entrada, file_path, itm["interruptor"]).seleccionar_por_caida_tension(corriente_nominal)
            resultados["caida_tension"] = conversion_filas_por_caida(conductor_caida_tension)
    
    except ValueError as e:
        resultados["interrutor"] = f"Error en los datos de entrada: {e}"

    return resultados

if __name__ == "__main__":
    # Para pruebas independientes, puedes poner una llamada a ejecutar_main con datos de prueba aquí.
    pass


