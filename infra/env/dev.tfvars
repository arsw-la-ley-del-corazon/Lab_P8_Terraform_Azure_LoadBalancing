prefix              = "lab8"
location            = "eastus"
vm_count            = 2
admin_username      = "student"
admin_password = "Arsw2025."
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9vAFFFolFBBFyR4VHYT1uWziYZ7S7MexHD3gQ89piF jeisson@terraform"
allow_ssh_from_cidr = "0.0.0.0/0" # Cambia a tu IP/32
tags                = { owner = "alias", course = "ARSW", env = "dev", expires = "2025-12-31" }
subscription_id = "cfed6052-94ce-4e99-8327-a8d4b455f746"
tenant_id       = "50640584-2a40-4216-a84b-9b3ee0f3f6cf"
alert_email = "jeisson.sanchez-g@mail.escuelaing.edu.co"

