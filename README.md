# 🇦🇷 Pedidos App Frontend

**Pedidos App** es una aplicación Flutter desarrollada como interfaz gráfica del proyecto **Pedidos API (Backend en Java Spring Boot)**.  
Permite a los usuarios explorar negocios, ver productos por categoría, agregar items al carrito y realizar compras en línea.

![App Preview](https://raw.githubusercontent.com/matiaswisner/pedidos-api-front/main/assets/app_preview.png)


---

## 🚀 Tecnologías Utilizadas

- **Flutter 3.9.x**
- **Dart SDK 3.9.x**
- **Material Design 3**
- **Animaciones suaves (Fade + Slide)**
- **Arquitectura escalable**  
- **Integración con API REST (Spring Boot)**

---

## 🖥️ Características Principales

✅ Pantalla de **Login** con opción de autenticación con Google  
✅ Lista de **categorías de negocios** (almacén, kiosco, panadería, verdulería, etc.)  
✅ Vista de **productos por categoría** con diseño moderno  
✅ Sistema de **carrito dinámico**:
   - Si el usuario agrega productos de otro negocio, se muestra un diálogo:
     > “Tu carrito es de *Farmacia Central*. ¿Querés vaciarlo y comenzar uno nuevo con *Panadería La Paz*?”
✅ Pantalla de **pago** con integración futura a **Mercado Pago**  
✅ Estilo visual basado en los **colores de la bandera argentina**  
   - Celeste `#6EC1E4`  
   - Blanco `#FFFFFF`  
   - Dorado `#FFD700`  
   - Rojo Federal `#CC2222`

---

## 📁 Estructura del Proyecto

lib/
├── main.dart
├── screens/
│ ├── login_screen.dart
│ ├── orders_screen.dart
│ ├── products_screen.dart
│ ├── cart_screen.dart
│ └── payment_screen.dart
├── assets/
│ └── google_logo.png


---

## ⚙️ Configuración del Proyecto

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/matiaswisner/pedidos-api-front.git
   cd pedidos-api-front

💡 Se recomienda usar Visual Studio Code o Android Studio con Flutter SDK configurado.

---

🔗 Integración con Backend

Este frontend se comunica con el proyecto backend:
➡️ Pedidos API (Java Spring Boot)

La conexión se realiza mediante peticiones REST (JSON), permitiendo:

Login con Google (OAuth2)

Listado de negocios y productos

Creación de pedidos y pagos

👨‍💻 Autor

Matías Wisner
Profesor Técnico | Desarrollador Full Stack | Gestor de Proyectos
📍 Hurlingham, BsAs, Argentina.
📧 matiaswisner@gmail.com

🌐 github.com/matiaswisner

🏁 Estado del Proyecto

🔧 En desarrollo — versión inicial con interfaz funcional.
Próximamente se conectará con la API real de Pedidos API (Backend).

---

Desarrollado con ❤️ por Matías Wisner — Integrando tecnología, diseño y educación técnica.



