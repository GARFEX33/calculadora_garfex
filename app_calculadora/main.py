
from src.domain.entities.extraer_informacion import extraer_info
from src.domain.entities.seleccion_conductor import SeleccionDeConductor
from src.domain.entities.interruptor_termomagnetico import InterruptorTermomagnetico
from src.domain.entities.corriente_nominal import CorrienteNominal
from src.domain.entities.datos_entrada import DatosEntrada
import pandas as pd
import os


def main():
    # Paso 1: Crear una instancia de DatosEntrada con los datos de entrada
    datos_entrada = DatosEntrada(
        voltaje=220, 
        potencia=300,
        fp=0.9, 
        tipo_circuito='trifasico', 
        temperatura=29, 
        numero_hilos=4,
        tipo_de_voltaje='V', 
        tipo_de_potencia='KW',
        factor_ajuste_itm = 'general',
        longitud=20,
        circuito= "manual"
    )
    # Obtén el directorio actual donde se está ejecutando el script
    current_dir = os.path.dirname(__file__)
    # Construye la ruta al archivo usando la ruta relativa
    file_path = os.path.join(current_dir, 'data', 'tabla_cables.csv')

    try:
        # Paso 2: Validar los datos
        if datos_entrada.validar_datos():
            # Paso 3: Calcular la corriente nominal
            corriente_nominal = CorrienteNominal(datos_entrada).corriente_nominal
            print(f"La corriente nominal es: {corriente_nominal} A")  
            # Paso 4: Calcular el interruptor termomagnético
            itm = InterruptorTermomagnetico(corriente_nominal,datos_entrada.factor_ajuste_proteccion_magnetica(), datos_entrada.mapeo_tipo_circuito() ).seleccionar_interruptor()
            print("Interrutor :",itm["tipo_circuito"],"X",itm["interruptor"],"A")
            # Paso 5: Calcular el conductor
            conductor = SeleccionDeConductor(datos_entrada, file_path,itm["interruptor"]).seleccionar_por_capacidad_conduccion(corriente_nominal)
            
            resultados = extraer_info(conductor)
            for resultado in resultados:
                print(resultado)
               
            conductor_caida_tension = SeleccionDeConductor(datos_entrada, file_path,itm["interruptor"]).seleccionar_por_caida_tension(corriente_nominal)
            print(conductor_caida_tension)
            
    except ValueError as e:
        print(f"Error en los datos de entrada: {e}")

if __name__ == "__main__":
    main()
