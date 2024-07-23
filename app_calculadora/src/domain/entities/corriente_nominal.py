
import math

from src.domain.entities.datos_entrada import DatosEntrada


class CorrienteNominal:
    def __init__(self, datos_entrada: DatosEntrada ):
        self.datos_entrada = datos_entrada
        self.corriente_nominal = self.seleccionar_calculo()

    def calcular_monofasico(self):
        # La fórmula para el cálculo de la corriente nominal en un sistema monofásico
        # es I = P / (V * FP)
        voltaje = self.datos_entrada.convertir_voltaje()
        potencia = self.datos_entrada.convertir_potencia()
        fp = self.datos_entrada.fp
        return  potencia / (voltaje * fp)

    def calcular_bifasico(self):
        # La fórmula para el cálculo de la corriente nominal en un sistema bifásico
        # puede variar dependiendo del país y el estándar, pero aquí usamos
        # I = P / (2* (V/sqrt(3)) * FP ) como una aproximación.
        voltaje = self.datos_entrada.convertir_voltaje()
        potencia = self.datos_entrada.convertir_potencia()
        fp = self.datos_entrada.fp
        return potencia / (2 * (voltaje/ math.sqrt(3))  * fp )

    def calcular_trifasico(self):
        # La fórmula para el cálculo de la corriente nominal en un sistema trifásico
        # es I = P / (V * FP * sqrt(3))
        voltaje = self.datos_entrada.convertir_voltaje()
        potencia = self.datos_entrada.convertir_potencia()
        fp = self.datos_entrada.fp
        return potencia / (math.sqrt(3)* voltaje * fp )

    def seleccionar_calculo(self):
        if self.datos_entrada.tipo_circuito == 'monofasico':
            return self.calcular_monofasico()
        elif self.datos_entrada.tipo_circuito == 'bifasico':
            return self.calcular_bifasico()
        elif self.datos_entrada.tipo_circuito == 'trifasico':
            return self.calcular_trifasico()
        else:
            raise ValueError("Tipo de circuito no válido")
    
