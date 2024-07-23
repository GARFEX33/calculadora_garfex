

class InterruptorTermomagnetico:
    def __init__(self, corriente_nominal: float, factor_ajuste_itm: float, tipo_circuito: str):
        self.corriente_nominal = corriente_nominal
        self.factor_ajuste_itm = factor_ajuste_itm
        self.tipo_circuito = tipo_circuito

    def calculo_interruptor(self) -> float:
        return self.corriente_nominal * self.factor_ajuste_itm
    
    def seleccionar_interruptor(self) -> dict:
        lista_de_interruptores = [10,15,20,30,40,50,60,70,80,90,100,125,150,175,200,225,250,300,400,500,600,700,800,1000,1200,1600,2000,2500,3200, 4000, 5000 , 6300]
        corriente_ajustada = self.calculo_interruptor()
        print("Corriente ajustada: ", corriente_ajustada)
        
        for interruptor in lista_de_interruptores:
            if interruptor >= corriente_ajustada:
                return {"interruptor": interruptor,
                "corriente_ajustada": corriente_ajustada,
                "tipo_circuito": self.tipo_circuito}
        
        return {"interruptor": "No se encontró un interruptor adecuado",
                "corriente_ajustada": corriente_ajustada,
                "tipo_circuito": self.tipo_circuito}
    