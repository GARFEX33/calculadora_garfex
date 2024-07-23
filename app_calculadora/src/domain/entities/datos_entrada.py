from typing import Literal, Optional

class DatosEntrada:
    def __init__(self, 
                 voltaje: float, 
                 potencia: float, 
                 fp: float, 
                 tipo_circuito: Literal['monofasico', 'bifasico', 'trifasico'], 
                 temperatura: float, 
                 numero_hilos: int, 
                 tipo_de_voltaje: Literal['V', 'KV', 'MV'], 
                 tipo_de_potencia: Literal['W', 'KW', 'MW'],
                 factor_ajuste_itm: Literal['general', 'motor', 'aire_acondicionado', 'capacitor'],
                 corriente: Optional[float] = None):
        self.voltaje = voltaje
        self.corriente = corriente
        self.potencia = potencia
        self.fp = fp
        self.tipo_circuito = tipo_circuito
        self.temperatura = temperatura
        self.numero_hilos = numero_hilos
        self.tipo_de_voltaje = tipo_de_voltaje
        self.tipo_de_potencia = tipo_de_potencia
        self.factor_ajuste_itm = factor_ajuste_itm

    def validar_datos(self) -> bool:
        if self.voltaje <= 0:
            raise ValueError("El voltaje debe ser mayor que cero.")
        if self.corriente is not None and self.corriente <= 0:
            raise ValueError("La corriente debe ser mayor que cero.")
        if self.fp <= 0 or self.fp > 1:
            raise ValueError("El factor de potencia debe estar entre 0 y 1.")
        if self.tipo_circuito not in ['monofasico', 'bifasico', 'trifasico']:
            raise ValueError("Tipo de circuito inválido.")
        if self.numero_hilos <= 0:
            raise ValueError("El número de hilos debe ser mayor que cero.")
        if self.tipo_de_voltaje not in ['V', 'KV', 'MV']:
            raise ValueError("Tipo de voltaje inválido. Debe ser uno de: 'V', 'KV', 'MV'.")
        if self.tipo_de_potencia not in ['W', 'KW', 'MW']:
            raise ValueError("Tipo de potencia inválido. Debe ser uno de: 'W', 'KW', 'MW'.")
        if self.factor_ajuste_itm not in ['general', 'motor', 'aire_acondicionado', 'capacitor']:
            raise ValueError("Tipo de carga inválido. Debe ser uno de: 'general', 'motor', 'aire_acondicionado', 'capacitor'.")
        return True

    def convertir_voltaje(self) -> float:
        conversiones_voltaje = {
            'V': self.voltaje / 1000,
            'KV': self.voltaje,
            'MV': self.voltaje * 1000
        }
        return conversiones_voltaje[self.tipo_de_voltaje]

    def convertir_potencia(self) -> float:
        conversiones_potencia = {
            'W': self.potencia / 1000,
            'KW': self.potencia,
            'MW': self.potencia * 1000
        }
        return conversiones_potencia[self.tipo_de_potencia]
    
    def factor_ajuste_proteccion_magnetica(self) -> float:
        factor_ajuste_itm = {
            'general': 1.25,
            'motor': 2.25,
            'aire_acondicionado': 1.75,
            'capacitor': 1.35
        }
        return factor_ajuste_itm[self.factor_ajuste_itm]
    
    def mapeo_tipo_circuito(self) -> int:
        mapeo_tipo_circuito = {
            'monofasico': 1,
            'bifasico': 2,
            'trifasico': 3
        }
        return mapeo_tipo_circuito[self.tipo_circuito]
