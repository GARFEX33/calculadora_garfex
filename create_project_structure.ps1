# Crear estructura de carpetas
New-Item -Path "app\src\domain\entities" -ItemType Directory -Force
New-Item -Path "app\src\domain\services" -ItemType Directory -Force
New-Item -Path "app\src\application\use_cases" -ItemType Directory -Force
New-Item -Path "app\src\adapters\input" -ItemType Directory -Force
New-Item -Path "app\src\adapters\output" -ItemType Directory -Force
New-Item -Path "app\src\config" -ItemType Directory -Force
New-Item -Path "app\tests\domain" -ItemType Directory -Force
New-Item -Path "app\tests\application" -ItemType Directory -Force
New-Item -Path "app\tests\adapters" -ItemType Directory -Force
New-Item -Path "app\tests\config" -ItemType Directory -Force

# Crear archivos en domain/entities
New-Item -Path "app\src\domain\entities\datos_entrada.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\corriente_nominal.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\interruptor_termomagnetico.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\conduccion.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\caida_tension.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\conductor.py" -ItemType File -Force
New-Item -Path "app\src\domain\entities\canalizacion.py" -ItemType File -Force

# Crear archivos en domain/services
New-Item -Path "app\src\domain\services\calculadora_electrica.py" -ItemType File -Force

# Crear archivos en application/use_cases
New-Item -Path "app\src\application\use_cases\calcular_corriente_nominal.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\seleccionar_interruptor.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\calcular_capacidad_conduccion.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\calcular_caida_tension.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\seleccionar_conductor.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\seleccionar_canalizacion.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\mostrar_informacion_completa.py" -ItemType File -Force
New-Item -Path "app\src\application\use_cases\generar_memoria_calculo.py" -ItemType File -Force

# Crear archivos en adapters/input
New-Item -Path "app\src\adapters\input\entrada_console.py" -ItemType File -Force
New-Item -Path "app\src\adapters\input\entrada_api.py" -ItemType File -Force

# Crear archivos en adapters/output
New-Item -Path "app\src\adapters\output\salida_console.py" -ItemType File -Force
New-Item -Path "app\src\adapters\output\salida_api.py" -ItemType File -Force

# Crear archivos en config
New-Item -Path "app\src\config\app_config.py" -ItemType File -Force

# Crear archivo main.py
New-Item -Path "app\main.py" -ItemType File -Force

# Crear archivos de pruebas
New-Item -Path "app\tests\domain\test_datos_entrada.py" -ItemType File -Force
New-Item -Path "app\tests\domain\test_corriente_nominal.py" -ItemType File -Force
New-Item -Path "app\tests\application\test_calcular_corriente_nominal.py" -ItemType File -Force
New-Item -Path "app\tests\adapters\test_entrada_console.py" -ItemType File -Force
New-Item -Path "app\tests\adapters\test_salida_console.py" -ItemType File -Force

Write-Host "Estructura de carpetas y archivos creada exitosamente."
