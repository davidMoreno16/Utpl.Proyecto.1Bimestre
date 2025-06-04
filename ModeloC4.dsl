workspace "Gestión de Pedidos e Inventario - Mega Mayorista" {
    description "Sistema para la gestión de pedidos mayoristas e inventario de Mega Mayorista"

    model {
        // Personas
        pClienteMayorista = person "Cliente Mayorista" {
            description "Realiza pedidos y consulta disponibilidad"
        }
        pAdministrativo = person "Personal Administrativo" {
            description "Gestiona el sistema y supervisa pedidos"
        }
        pBodeguero = person "Bodeguero" {
            description "Actualiza el estado del inventario y gestiona el stock"
        }

        // Sistema externo (Proveedor de logística)
        sLogistica = softwareSystem "Sistema de Logística" {
            tags "Externo"
            description "Maneja la entrega de pedidos a los clientes"
        }

        // Sistema Principal
        sGestionPedidos = softwareSystem "Sistema de Gestión de Pedidos e Inventario" {
            tags "SistemaGestion"
            description "Centraliza la gestión de pedidos y control de inventario"

            // Aplicación Cliente
            portalCliente = container "Portal del Cliente Mayorista" {
                tags "AppWeb"
                description "Interfaz para que los clientes realicen pedidos"
                pClienteMayorista -> this "Realiza pedidos y consulta disponibilidad"
            }

            // Aplicación Administrativa
            portalAdmin = container "Panel Administrativo" {
                tags "AppWeb"
                description "Interfaz para la gestión de pedidos e inventario"
                pAdministrativo -> this "Gestiona solicitudes y supervisa operaciones"
                pBodeguero -> this "Actualiza el estado del inventario"
            }

            // API Central
            api = container "API de Pedidos e Inventario" {
                tags "API"
                description "Provee funcionalidades para gestionar pedidos y stock"
                portalAdmin -> this "CRUD para pedidos e inventario"
                portalCliente -> this "Consulta disponibilidad y crea pedidos"
                this -> sLogistica "Envía órdenes de entrega"

                // Componentes internos
                compPedido = component "Controlador de Pedidos" {
                    description "Gestiona la creación, edición y consulta de pedidos"
                }
                compInventario = component "Gestor de Inventario" {
                    description "Monitorea stock disponible y actualiza cantidades"
                }
                compNotificaciones = component "Módulo de Notificaciones" {
                    description "Envía confirmaciones por correo y WhatsApp"
                }

                // Flujo interno
                compPedido -> compInventario "Verifica disponibilidad de stock"
                compPedido -> compNotificaciones "Envía confirmación de pedido"
                compInventario -> compNotificaciones "Notifica reabastecimiento"
            }

            // Base de Datos
            basedatos = container "Base de Datos" {
                tags "Database"
                description "Almacena información de pedidos e inventario"
                api -> this "Consulta y actualiza datos"
            }
        }
    }

    views {
        systemContext sGestionPedidos {
            include *
            autolayout lr
        }

        container sGestionPedidos {
            include *
            autolayout lr
        }

        component api componentes_api { 
            include *
            autolayout lr
        }

        styles {
            element "SistemaGestion" {
                shape Hexagon
                background #4287f5
                color #ffffff
            }

            element "API" {
                shape RoundedBox
                background #00a878
                color #ffffff
            }

            element "Database" {
                shape Cylinder
                background #ffcc00
            }

            element "Externo" {
                shape Person
                background #888888
            }
        }

        theme "https://srv-si-001.utpl.edu.ec/REST_PRO_ERP/Recursos/Imagenes/themeAZ_2023.json"
    }
}
