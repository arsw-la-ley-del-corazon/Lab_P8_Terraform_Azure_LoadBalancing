# 🧩 Lab 8 – Terraform en Azure con Load Balancer, Bastion y Monitoring
### Curso: Arquitectura de Software — ARSW
### Estudiantes:
- Jeisson David Sánchez Gómez
- Laura Valentina Gutiérrez Rico
- Alexandra Moreno Latorre
- Alison Geraldine Valderrama Munar

---

## 📘 1. Descripción General

Este laboratorio implementa una infraestructura completa en Microsoft Azure usando Terraform, aplicando principios de IaC, modularización, redes, compute, balanceo de carga, backend remoto y monitoreo en la nube.

Incluye:

- Load Balancer L4 (Azure Standard LB)
- 2 máquinas virtuales Linux con cloud-init
- Azure Bastion
- Log Analytics Workspace
- Action Group
- Alerta por CPU
- NSG, NICs, subredes y VNet
- Backend remoto en Azure Storage

---

## 🏗️ 2. Arquitectura General



## 📂 3. Estructura del Repositorio

```
Lab8-Terraform-Azure/
│
├── infra/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.hcl
│   ├── cloud-init.yaml
│   └── env/
│       └── dev.tfvars
│
└── modules/
    ├── vnet/
    ├── compute/
    ├── lb/
    └── monitoring/
```

---

## 🧩 4. Módulos Implementados

### 🔹 Módulo VNET
Crea VNet, subred web y subred mgmt.

### 🔹 Módulo Compute
Crea NIC + VM con cloud-init y Nginx.

### 🔹 Módulo Load Balancer
Carga L4 con probe TCP y regla 80.

### 🔹 Módulo Monitoring
Log Analytics, Action Group y alerta de CPU.

---

## 🔐 5. Backend Remoto

```
resource_group_name  = "lab8-tfstate"
storage_account_name = "tfstatelab8azure"
container_name       = "tfstate"
key                  = "lab8/terraform.tfstate"
```

---

## 🚀 6. Despliegue

```
az login --tenant <TENANT>
terraform init -backend-config="backend.hcl"
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"
```

---

## 🌍 7. Resultado

- Load Balancer funcionando
- Acceso a http://<public-ip>
- Round Robin entre VM0 y VM1
- Bastion operativo
- Alertas activas en Azure

---


## 💵 8. Costos Aproximados

| Recurso | Costo |
|--------|--------|
| 2 × VM B1s | 0.024 USD/h |
| Load Balancer | 0.025 USD/h |
| Bastion | 0.19 USD/h |
| Total | ≈ 0.24 USD/h |

---

## 🔒 9. Seguridad

- SSH solo para lab
- Bastion para acceso interno
- No passwords, solo SSH key
- Backend remoto seguro

---

## 📈 10. Monitoring

- Workspace recolecta métricas
- Alerta CPU > 80%
- Notificación por correo

---

## 🧹 11. Destrucción

```
terraform destroy -var-file="env/dev.tfvars"
```

---

## 🧠 Preguntas de Reflexión 

### 1. ¿Por qué usar un Load Balancer L4 en lugar de Application Gateway (L7)?
El LB L4 es suficiente para balancear tráfico básico (puertos y protocolos) y es más económico.  
Un Gateway L7 sería necesario si se requiere inspección HTTP, rutas por URL, HTTPS o un firewall (WAF).

### 2. ¿Qué riesgos tiene exponer SSH (22/TCP) a Internet?
Exponer SSH permite ataques de fuerza bruta y escaneo por bots.  
Se mitiga usando Azure Bastion, claves SSH, restringiendo IPs (/32) o deshabilitando acceso público.

### 3. ¿Qué mejorarías si esto fuera producción?.  
- Monitoreo y alertas más robustas (CPU, fallos, latencia).  
- Usar HTTPS con Application Gateway + WAF.  
- Autoescalado para manejar carga variable
- Colocar las VMs en subred privada y usar Bastion.  

---

## 🏁 13. Conclusiones

- Terraform permite modularidad y reproducibilidad  
- LB distribuye carga de forma eficiente  
- Bastion mejora la seguridad  
- Monitoring brinda observabilidad profesional  
