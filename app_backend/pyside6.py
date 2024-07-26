import sys
from PySide6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QFormLayout, QLabel, QLineEdit,
    QPushButton, QComboBox, QTableWidget, QTableWidgetItem, QHeaderView, QMessageBox, QGridLayout
)
from PySide6.QtCore import Qt
from main import ejecutar_main

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Calculadora Eléctrica")
        self.setGeometry(100, 100, 800, 800)

        main_widget = QWidget()

        
        main_layout = QVBoxLayout(main_widget)
        self.setCentralWidget(main_widget)

        # Título del formulario
        title = QLabel("Formulario de Datos de Entrada")
        title.setStyleSheet("font-size: 18px; font-weight: bold; text-align: center;")
        title.setAlignment(Qt.AlignCenter)
        main_layout.addWidget(title)

        # Form layout for input fields
        form_layout = QGridLayout()

        # Create input fields with default values
        self.voltaje = QLineEdit("220")
        self.potencia = QLineEdit("100")
        self.fp = QLineEdit("1")
        self.tipo_circuito = QComboBox()
        self.tipo_circuito.addItems(["trifasico", "monofasico", "bifasico"])
        self.temperatura = QLineEdit("30")
        self.numero_hilos = QLineEdit("3")
        self.tipo_voltaje = QComboBox()
        self.tipo_voltaje.addItems(["V", "KV", "MV"])
        self.tipo_potencia = QComboBox()
        self.tipo_potencia.addItems(["KW", "W", "MW"])
        self.factor_ajuste_itm = QComboBox()
        self.factor_ajuste_itm.addItems(["capacitor", "general", "motor", "aire_acondicionado"])
        self.longitud = QLineEdit("25")
        self.circuito = QComboBox()
        self.circuito.addItems(["circuito_alimentadores", "circuitos_derivados", "circuito_alimentadores_secundario", "manual"])

        # Add input fields to grid layout
        form_layout.addWidget(QLabel("Voltaje:"), 0, 0)
        form_layout.addWidget(self.voltaje, 0, 1)
        form_layout.addWidget(QLabel("Tipo de Voltaje:"), 0, 2)
        form_layout.addWidget(self.tipo_voltaje, 0, 3)

        form_layout.addWidget(QLabel("Potencia:"), 1, 0)
        form_layout.addWidget(self.potencia, 1, 1)
        form_layout.addWidget(QLabel("Tipo de Potencia:"), 1, 2)
        form_layout.addWidget(self.tipo_potencia, 1, 3)

        form_layout.addWidget(QLabel("Factor de Potencia:"), 2, 0)
        form_layout.addWidget(self.fp, 2, 1)
        form_layout.addWidget(QLabel("Temperatura:"), 2, 2)
        form_layout.addWidget(self.temperatura, 2, 3)

        form_layout.addWidget(QLabel("Tipo de Circuito:"), 3, 0)
        form_layout.addWidget(self.tipo_circuito, 3, 1)
        form_layout.addWidget(QLabel("Número de Hilos:"), 3, 2)
        form_layout.addWidget(self.numero_hilos, 3, 3)

        form_layout.addWidget(QLabel("Factor de Ajuste ITM:"), 4, 0)
        form_layout.addWidget(self.factor_ajuste_itm, 4, 1)
        form_layout.addWidget(QLabel("Circuito:"), 4, 2)
        form_layout.addWidget(self.circuito, 4, 3)

        form_layout.addWidget(QLabel("Longitud:"), 5, 0)
        form_layout.addWidget(self.longitud, 5, 1)

        # Ejecutar button
        ejecutar_btn = QPushButton("Ejecutar")
        ejecutar_btn.setStyleSheet("background-color: #007BFF; color: white; font-size: 14px;")
        ejecutar_btn.clicked.connect(self.ejecutar_y_mostrar)
        form_layout.addWidget(ejecutar_btn, 6, 0, 1, 4, alignment=Qt.AlignCenter)

        main_layout.addLayout(form_layout)

        # Filter layout
        filter_layout = QGridLayout()
        self.filter_tipo_instalacion = QComboBox()
        self.filter_tipo_instalacion.addItems(["Todos", "tuberia", "charola"])
        self.filter_tipo_instalacion.currentIndexChanged.connect(self.aplicar_filtros)
        filter_layout.addWidget(QLabel("Filtrar por Tipo de Instalación:"), 0, 0)
        filter_layout.addWidget(self.filter_tipo_instalacion, 0, 1)
        
        self.filter_material = QComboBox()
        self.filter_material.addItems(["Todos", "cobre", "aluminio"])
        self.filter_material.currentIndexChanged.connect(self.aplicar_filtros)
        filter_layout.addWidget(QLabel("Filtrar por Material:"), 0, 2)
        filter_layout.addWidget(self.filter_material, 0, 3)
        
        self.filter_numero_fases = QComboBox()
        filter_layout.addWidget(QLabel("Filtrar por Número de Fases:"), 0, 4)
        filter_layout.addWidget(self.filter_numero_fases, 0, 5)
        self.filter_numero_fases.currentIndexChanged.connect(self.aplicar_filtros)
        
        main_layout.addLayout(filter_layout)

        # Results layout
        self.corriente_nominal_label = QLabel("Corriente Nominal: ")
        self.correinte_ajustada_label = QLabel("Corriente Ajustada: ")
        self.interrutor_label = QLabel("Interrutor: ")
        self.icalculada_label = QLabel("Corriente Calculada: ")
        self.interrutor_label.setStyleSheet("font-weight: bold; font-size: 14px;")
        self.corriente_nominal_label.setStyleSheet("font-weight: bold; font-size: 14px;")
        self.correinte_ajustada_label.setStyleSheet("font-weight: bold; font-size: 14px;")
        self.icalculada_label.setStyleSheet("font-weight: bold; font-size: 14px;")
        main_layout.addWidget(self.corriente_nominal_label)
        main_layout.addWidget(self.correinte_ajustada_label)
        main_layout.addWidget(self.interrutor_label)
        main_layout.addWidget(self.icalculada_label)
        

        self.table_capacidad = QTableWidget(0, 8)
        self.table_capacidad.setHorizontalHeaderLabels(["Canalizacion", "Material", "# de Fases", "AWG", "mm", "Ampacidad", "Temp", "Tabla Nom"])
        self.table_capacidad.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        main_layout.addWidget(QLabel("Capacidad de Conducción"))
        main_layout.addWidget(self.table_capacidad)

        self.table_caida_tension = QTableWidget(0, 3)
        self.table_caida_tension.setHorizontalHeaderLabels(["# de Fases", "AWG", "mm"])
        self.table_caida_tension.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        main_layout.addWidget(QLabel("Caída de Tensión"))
        main_layout.addWidget(self.table_caida_tension)

    def ejecutar_y_mostrar(self):
        try:
            voltaje = float(self.voltaje.text())
            potencia = float(self.potencia.text())
            fp = float(self.fp.text())
            tipo_circuito = self.tipo_circuito.currentText()
            temperatura = float(self.temperatura.text())
            numero_hilos = int(self.numero_hilos.text())
            tipo_voltaje = self.tipo_voltaje.currentText()
            tipo_potencia = self.tipo_potencia.currentText()
            factor_ajuste_itm = self.factor_ajuste_itm.currentText()
            longitud = float(self.longitud.text())
            circuito = self.circuito.currentText()

            resultados = ejecutar_main(voltaje, potencia, fp, tipo_circuito, temperatura, numero_hilos, tipo_voltaje, tipo_potencia, factor_ajuste_itm, longitud, circuito)

            self.corriente_nominal_label.setText(resultados["corriente_nominal"])
            self.correinte_ajustada_label.setText(f"Corriente Ajustada para itm: {resultados['corriente_ajustada']}A")
            self.interrutor_label.setText(f"Interrutor: {resultados['interrutor']}")
            for i in range(len(resultados["iCalculada"])):
                fase = i + 1
                self.icalculada_label.setText(f"Corriente Calculada por F: {fase}-{resultados["iCalculada"][i]}A")
            

            self.table_capacidad.setRowCount(0)
            for res in resultados["capacidad_conduccion"]:  
                row_position = self.table_capacidad.rowCount()
                self.table_capacidad.insertRow(row_position)
                for col, data in enumerate(res):
                    self.table_capacidad.setItem(row_position, col, QTableWidgetItem(str(data)))

            self.table_caida_tension.setRowCount(0)
            max_fases = 0
            for res in resultados["caida_tension"]:
                row_position = self.table_caida_tension.rowCount()
                self.table_caida_tension.insertRow(row_position)
                for col, data in enumerate(res):
                    self.table_caida_tension.setItem(row_position, col, QTableWidgetItem(str(data)))
                    if col == 0:
                        max_fases = max(max_fases, int(data))

            self.actualizar_filtro_numero_fases(max_fases)
            self.aplicar_filtros()

        except ValueError as e:
            QMessageBox.critical(self, "Error en los datos de entrada", str(e))

    def aplicar_filtros(self):
        tipo_instalacion_filtro = self.filter_tipo_instalacion.currentText()
        material_filtro = self.filter_material.currentText()
        numero_fases_filtro = self.filter_numero_fases.currentText()
        
        for i in range(self.table_capacidad.rowCount()):
            tipo_instalacion_item = self.table_capacidad.item(i, 0)  # Columna de Tipo de Instalación
            material_item = self.table_capacidad.item(i, 1)  # Columna de Material
            numero_fases_item = self.table_capacidad.item(i, 2)  # Columna de Número de Fases
            
            show_row = True
            if tipo_instalacion_filtro != "Todos" and tipo_instalacion_item.text() != tipo_instalacion_filtro:
                show_row = False
            if material_filtro != "Todos" and material_item.text() != material_filtro:
                show_row = False
            if numero_fases_filtro != "Todos" and numero_fases_item.text() != numero_fases_filtro:
                show_row = False
                
            self.table_capacidad.setRowHidden(i, not show_row)

    def actualizar_filtro_numero_fases(self, max_fases):
        self.filter_numero_fases.clear()
        self.filter_numero_fases.addItems(["Todos"] + [str(i) for i in range(1, max_fases + 1)])

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
