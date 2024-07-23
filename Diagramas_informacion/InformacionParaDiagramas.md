## Calculadora Electrica

Pasos
1. Usuario ingresa Voltaje, Corriente, FP, Tipo de circuito, Temperatura y numero de Hilos.
2. Calculadora calcula CALCULO DE LA CORRIENTE NOMINAL.
3. Con la Corriente Nominal se calcula CÁLCULO DEL INTERRUPTOR TERMOMAGNETICO.
4. Con corriente nominal y factores de ajuste se realiza la capacidad de conducción
5. Se caída de tensión
6. Se selecciona conductor 
7. Se Selecciona la canalizacion
8. Se da informacion completa obtenida 
9. Se realiza memoria de calculo

```mermaid
graph TB
    %% Definición de Actores
    Cliente
    Administrador
    
    %% Definición de Casos de Uso para Cliente
    Cliente -->|Interacción| UC1[Navegar productos]
    Cliente -->|Interacción| UC2[Buscar productos]
    Cliente -->|Interacción| UC3[Agregar productos al carrito]
    Cliente -->|Interacción| UC4[Revisar carrito]
    Cliente -->|Interacción| UC5[Realizar pago]
    Cliente -->|Interacción| UC6[Registrarse/Iniciar sesión]
    Cliente -->|Interacción| UC7[Ver historial de pedidos]
    Cliente -->|Interacción| UC8[Ver detalles del producto]
    
    %% Definición de Casos de Uso para Administrador
    Administrador -->|Interacción| UC9[Gestionar productos]
    Administrador -->|Interacción| UC10[Gestionar inventario]
    Administrador -->|Interacción| UC11[Gestionar pedidos]
    Administrador -->|Interacción| UC12[Gestionar usuarios]
    
    %% Relaciones entre Casos de Uso
    UC6 --> UC7
    UC3 --> UC4
    UC4 --> UC5


  
```
