from src.domain.entities.datos_entrada import DatosEntrada
import pandas as pd
from typing import Literal
import math


class SeleccionDeConductor:
    def __init__(self, datos_entrada: DatosEntrada, archivo_csv: str, interruptor: int):
        self.temperatura_seleccionada = datos_entrada.temperatura
        self.numero_de_hilos = datos_entrada.numero_hilos
        self.archivo_csv = archivo_csv
        self.conductores_df = pd.read_csv(self.archivo_csv )
        self.canalizacion = Literal['TUBERIA', 'CHAROLA'],
        self.voltaje = datos_entrada.convertir_voltaje()
        self.interruptor = interruptor
        self.tipo_circuito = datos_entrada.tipo_circuito
        self.datos_entrada = datos_entrada

    def selector_temperatura_conductor(self, corriente_nominal: float) -> str:

        if corriente_nominal <= 100:
            return "temp_60C"
        elif 60 < corriente_nominal > 100:
            return "temp_75C"
        # elif 75 < corriente_nominal <= 90:
        #     return 'temp_90C'
        else:
            return None
    
    def selector_zapatas_de_interruptor(self, interruptor: float) -> int:
        if interruptor <= 250:
            return 1
        elif 250 < interruptor <= 600:
            return 2
        elif 600 < interruptor <= 800:
            return 3
        elif 800 < interruptor <= 1200:
            return 4
        elif 1200 < interruptor <= 2000:
            return 6
        elif 2000 < interruptor <= 6300:
            return 8
        else:
            return 1

    def selector_tabla_de_normas(self, canalizacion: str, voltaje: float, numero_de_hilos: int, bornes: int) -> str:
    
        if voltaje <= 2:
            if canalizacion == 'TUBERIA':
                return "310-15(b)(16)"
            elif canalizacion == 'CHAROLA':
                if numero_de_hilos <= 4 and bornes == 1:
                    return "310-15(b)(17)"
                elif numero_de_hilos > 4 or bornes > 1:
                    return "310-15(b)(20)"
                
            else:
                return "No se encontró una tabla de normas adecuada"

# TODO: implementar el caso para voltajes mayores a 2kV la tabla vienen por cobre y aluminio separados
        elif voltaje >= 2:
            if canalizacion == 'TUBERIA':
                return "310-60(69)"
            elif canalizacion == 'CHAROLA':
                if numero_de_hilos <= 4:
                    return "310-60(69)"
                else:  
                    return "310-60(C)(67)"
            else:
                return "No se encontró una tabla de normas adecuada"
        
        return "No se encontró una tabla de normas adecuada"   
    
    def obtener_factor_ajuste_por_agrupamiento(self, numero_conductores: int) -> float:
        # Definimos los rangos y porcentajes en una lista de tuplas
        rangos_porcentajes = [
            ((1, 3), 100),
            ((4, 6), 80),
            ((7, 9), 70),
            ((10, 20), 50),
            ((21, 30), 45),
            ((31, 40), 40),
            ((41, float('inf')), 35)
        ]
    
        # Recorremos la lista para encontrar el rango correspondiente
        for (rango, porcentaje) in rangos_porcentajes:
            if rango[0] <= numero_conductores <= rango[1]:
                return porcentaje / 100
        # Si el número de conductores no cae en ningún rango, devolvemos None o un mensaje de error
        return None

    def obtener_factor_ajuste_por_temperatura(self, temperatura, cable_temp) -> float:
        # Definir los rangos y factores de ajuste en una lista de tuplas
        rangos_factores = [
            ((-float('inf'), 10), [1.29, 1.20, 1.15]),
            ((11, 15), [1.22, 1.15, 1.12]),
            ((16, 20), [1.15, 1.11, 1.08]),
            ((21, 25), [1.08, 1.05, 1.04]),
            ((26, 30), [1.00, 1.00, 1.00]),
            ((31, 35), [0.91, 0.94, 0.96]),
            ((36, 40), [0.82, 0.88, 0.91]),
            ((41, 45), [0.71, 0.82, 0.87]),
            ((46, 50), [0.58, 0.75, 0.82]),
            ((51, 55), [0.41, 0.67, 0.76]),
            ((56, 60), [0.00, 0.00, 0.58]),
            ((61, 65), [0.00, 0.00, 0.47]),
            ((66, 70), [0.00, 0.00, 0.33]),
            ((71, 75), [0.00, 0.00, 0.00]),
            ((76, 80), [0.00, 0.00, 0.00]),
            ((81, 85), [0.00, 0.00, 0.00])
        ]
        # Mapeo de columnas a índices
        columna_a_indice = {
            "temp_60C": 0,
            "temp_75C": 1,
            "temp_90C": 2
        }
        
        # Recorrer los rangos para encontrar el rango correspondiente
        for (min_temp, max_temp), factores in rangos_factores:
            if min_temp <= temperatura <= max_temp:
                return factores[columna_a_indice[cable_temp]]
        
        # Si la temperatura no cae en ningún rango, devolver None o un mensaje de error
        return None

    def seleccionar_conductor_por_corriente(self, corriente_por_capacidad_de_conduccion, bornes, material, cable_temp, tabla_nom) -> dict:
       
        corriente_por_cable = corriente_por_capacidad_de_conduccion/bornes
        
        material_col = f"{material.lower()}_{cable_temp[-3:].lower()}"
      
        df = self.conductores_df
            # Filtrar el DataFrame por la tabla de normas
        df_filtrado = df[df['tabla_nom'] == tabla_nom]
        if df_filtrado.empty:
            return None
            # Filtrar por el material y la temperatura del cable, y seleccionar el cable con amperaje superior inmediato
        df_filtrado = df_filtrado[df_filtrado[material_col] >= corriente_por_cable]
       
        if df_filtrado.empty:
            return None
        cable_seleccionado = df_filtrado.iloc[0]
        awg = cable_seleccionado["awg"]
        mm = round(float(cable_seleccionado["mm"]),2)
        corriente_maxima = round(float(cable_seleccionado[material_col]),2)
        return {
            "numero_de_conductores_por_fase": bornes,
            "awg": awg,
            "mm": mm,
            "corriente_maxima": corriente_maxima,
            "temperatura": cable_temp,
            "tabla_nom": tabla_nom
        }

    def seleccionar_conductor_por_seccion(self,  seccion ,bornes) -> dict:
       
        mm_cable = seccion/bornes
        df = self.conductores_df

        # Filtrar el DataFrame
        df_filtrado = df[df["mm"] >= mm_cable]
        

        if df_filtrado.empty:
            resultado = None
        else:
            # Obtener la fila con el menor valor de "mm" en el DataFrame filtrado
            resultado = df_filtrado.loc[df_filtrado["mm"].idxmin()]

        if resultado is None:
            return None
        
        awg = resultado["awg"]
        mm = round(float(resultado["mm"]),2)

        return {
            "numero_de_conductores_por_fase": bornes,
            "awg": awg,
            "mm": mm,
        }

    def seleccion_cable_por_tipo_de_canalizacion(self, canalizacion, corriente_calculada, bornes, temperatura_cable) -> dict:
        selector_tabla_de_normas = self.selector_tabla_de_normas( canalizacion = canalizacion, voltaje = self.voltaje , numero_de_hilos = self.numero_de_hilos, bornes = bornes)
        conductor_cobre = self.seleccionar_conductor_por_corriente(
            corriente_por_capacidad_de_conduccion=corriente_calculada, bornes=bornes, material='cobre', cable_temp=temperatura_cable, tabla_nom=selector_tabla_de_normas)
        conductor_aluminio = self.seleccionar_conductor_por_corriente(
            corriente_por_capacidad_de_conduccion=corriente_calculada, bornes=bornes, material='aluminio', cable_temp=temperatura_cable, tabla_nom=selector_tabla_de_normas)
        if conductor_cobre is None and conductor_aluminio is None:
            return None
        else:
            return{
                    "cobre": conductor_cobre,
                    "aluminio": conductor_aluminio,
                    "corriente_por_capacidad_de_conduccion": round(corriente_calculada,2),
                }
    
    def seleccionar_por_capacidad_conduccion(self, corriente_nominal) -> list[dict]:
        
        temperatura_cable = self.selector_temperatura_conductor(corriente_nominal)
        fa = self.obtener_factor_ajuste_por_agrupamiento(self.numero_de_hilos)
        ft = self.obtener_factor_ajuste_por_temperatura(self.temperatura_seleccionada, temperatura_cable)
        corriente_calculada = corriente_nominal / (fa * ft)
        bornes = self.selector_zapatas_de_interruptor(self.interruptor)
        resultados = []
        for i in range(bornes):
            fase = i + 1
            tuberia = self.seleccion_cable_por_tipo_de_canalizacion(canalizacion='TUBERIA', corriente_calculada=corriente_calculada, bornes=fase, temperatura_cable=temperatura_cable) 
            charola = self.seleccion_cable_por_tipo_de_canalizacion(canalizacion='CHAROLA', corriente_calculada=corriente_calculada, bornes=fase, temperatura_cable=temperatura_cable)
            if tuberia is None and charola is None:
                pass

            elif tuberia is None:
                resultados.append({
                    "charola": charola
                })  
            elif charola is None:
                resultados.append({
                    "tuberia": tuberia,
                   
                })  

            else:
                resultados.append({
                    "tuberia": tuberia,
                    "charola": charola
                })       
        return resultados

    def seleccionar_por_caida_tension(self, corriente_nominal) -> str:
        resultados = []
        bornes = self.selector_zapatas_de_interruptor(self.interruptor)

        if self.tipo_circuito == 'monofasico':
            return "No se encontró un conductor adecuado por caída de tensión"
        elif self.tipo_circuito == 'bifasico':
            return "No se encontró un conductor adecuado por caída de tensión"
        elif self.tipo_circuito == 'trifasico':
            caida_tension = self.datos_entrada.mapeo_circuito()
            longitud = self.datos_entrada.longitud
            voltaje_volts = self.voltaje*1000
            seccion = (2*(math.sqrt(3))*longitud*corriente_nominal)/(voltaje_volts*caida_tension)
            
        for i in range(bornes):
            fase = i + 1
            
            cable_seleccionado = self.seleccionar_conductor_por_seccion(seccion, bornes=fase)
            if cable_seleccionado == None:
                pass
            else:
                resultados.append({
                    "cable_seleccionado": cable_seleccionado,
                })       
        return resultados


    def seleccionar_por_capacidad_de_itm(self) -> list[dict]:
        corriente_nominal = self.interruptor 
        temperatura_cable = self.selector_temperatura_conductor(corriente_nominal)
        fa = self.obtener_factor_ajuste_por_agrupamiento(self.numero_de_hilos)
        ft = self.obtener_factor_ajuste_por_temperatura(self.temperatura_seleccionada, temperatura_cable)
        corriente_calculada = corriente_nominal / (fa * ft)
        bornes = self.selector_zapatas_de_interruptor(self.interruptor)
        resultados = []
        for i in range(bornes):
            fase = i + 1
            tuberia = self.seleccion_cable_por_tipo_de_canalizacion(canalizacion='TUBERIA', corriente_calculada=corriente_calculada, bornes=fase, temperatura_cable=temperatura_cable) 
            charola = self.seleccion_cable_por_tipo_de_canalizacion(canalizacion='CHAROLA', corriente_calculada=corriente_calculada, bornes=fase, temperatura_cable=temperatura_cable)
            if tuberia is None and charola is None:
                pass
            else:
                resultados.append({
                    "tuberia": tuberia,
                    "charola": charola
                })       
        return resultados
    
    