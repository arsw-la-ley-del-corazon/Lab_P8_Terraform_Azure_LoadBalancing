# Lab 8 – Terraform en Azure con Load Balancer  
**Curso:** Arquitectura de Software — ARSW  
**Estudiantes:**  
- *Jeisson David Sánchez Gómez*  
- *Laura Valentina Gutiérrez Rico*  
- *Alexandra Moreno Latorre*  
- *Alison Geraldine Valderrama Munar*

---


## 📘 1. Descripción General

Este laboratorio implementa una infraestructura completa en **Microsoft Azure**, desplegada mediante **Terraform**, utilizando un **Load Balancer L4 (Azure Standard LB)** para distribuir tráfico entre dos máquinas virtuales Linux configuradas mediante *cloud-init*.

El objetivo del laboratorio es aplicar conceptos de **Infraestructura como Código (IaC)**, modularización, backend remoto, redes virtuales, balanceo de carga y buenas prácticas de despliegue en la nube.

---

## 🏗️ 2. Arquitectura

La arquitectura consiste en:

- **Resource Group principal**
- **Virtual Network** con espacio `10.10.0.0/16`
- **Subred web** (`10.10.1.0/24`)  
- **Subred mgmt** (`10.10.2.0/24`)
- **2 máquinas virtuales Linux**
  - Configuradas con cloud-init  
  - Nginx instalado
- **NICs** asociadas a cada VM
- **Network Security Group** con reglas:
  - HTTP → 80/TCP (abierto al público)
  - SSH → 22/TCP (solo para fines de laboratorio)
- **Azure Standard Load Balancer**
  - Regla 80 → 80
  - Health probe TCP/80
  - Backend pool con ambas VMs
- **Backend remoto en Azure Storage** para `terraform.tfstate`

Flujo de red:

```
Usuario → IP Pública del Load Balancer → Backend Pool → VM0 / VM1
```

---

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
│       └── dev.tfvars (sin información sensible)
│
└── modules/
    ├── vnet/
    ├── compute/
    └── lb/
```

---

## 🧩 4. Módulos

### 🔹 **Módulo VNET**
- Crea la VNet principal.
- Crea subred web y subred mgmt.
- Expone `subnet_web_id`.

### 🔹 **Módulo Compute**
- Crea NICs.
- Crea 2 máquinas virtuales Linux.  
- Ejecuta cloud-init (instala nginx + página HTML básica).

### 🔹 **Módulo Load Balancer**
- Crea el LB con IP pública.
- Crea probe TCP/80.
- Crea regla de balanceo.
- Asocia las NICs al backend pool.

---

## 🔐 5. Backend Remoto (tfstate)

Se usa Azure Storage (configurado en `backend.hcl`):

```hcl
resource_group_name  = "<your-rg>"
storage_account_name = "<your-storage-account>"
container_name       = "tfstate"
key                  = "lab8/terraform.tfstate"
```

⚠ **Ninguna información sensible se incluye en el repositorio.**

---

## 🚀 6. Despliegue Paso a Paso

### 1️⃣ Autenticación en Azure
```bash
az login --tenant <YOUR_TENANT_ID>
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

### 2️⃣ Inicializar Terraform
```bash
terraform init -backend-config="backend.hcl"
```

### 3️⃣ Validar sintaxis
```bash
terraform fmt
terraform validate
```

### 4️⃣ Planificar
```bash
terraform plan -var-file="env/dev.tfvars"
```

### 5️⃣ Aplicar
```bash
terraform apply -var-file="env/dev.tfvars"
```

---

## 🌍 7. Resultado del Despliegue

- **Load Balancer público:**  
  `<public-ip-from-outputs>`

- **VMs generadas:**
  - `lab8-vm-0`
  - `lab8-vm-1`

Acceso:

```
http://<public-ip>
```

El hostname de la VM cambia con cada refresh, confirmando el balanceo Round Robin.

---

## 🛠️ 8. Problemas Encontrados y Soluciones

### ⚠ Terraform no detectaba la suscripción
**Solución:**  
Usar `az login` forzado por tenant y declarar `subscription_id` / `tenant_id` como variables.


---

## 💵 9. Estimación de Costos

| Recurso | Costo aproximado |
|--------|-------------------|
| 2 × VM B1s | 0.024 USD/h |
| Load Balancer | 0.025 USD/h |
| Public IP | 0.003 USD/h |
| Storage Account | 0.002 USD/h |
| **Total aprox** | **0.05 USD/h** |

---

## 🔒 10. Seguridad

- SSH expuesto temporalmente .  
- Para producción:
  - Usar **Azure Bastion**  
  - Restringir SSH por IP  
  - Reemplazar LB L4 por Application Gateway L7  
  - Implementar HTTPS/TLS

---

## 🤔 11. Reflexión Técnica

**1. ¿Por qué un Load Balancer L4?**  
Es más económico, más simple, ideal para tráfico TCP básico sin inspección HTTP.

**2. Riesgos de exponer el puerto 22**  
Fuerza bruta y escaneo masivo.  
Mitigación: `/32`, Bastion, claves SSH, no contraseñas.

**3. Mejoras para producción**  
- VM Scale Sets  
- Application Gateway + HTTPS  
- Alertas y monitoreo  
- Políticas de red  
- Pipelines más avanzados

---

## 🧹 12. Destrucción Segura

```bash
terraform destroy -var-file="env/dev.tfvars"
```

El backend remoto **no se elimina**, por seguridad.

---

