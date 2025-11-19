docker-compose up -d
## Práctica: Web Farm Automation con Ansible

Proyecto final de Bernardo Gomera (matrícula 2020-9643).

Objetivo: levantar una pequeña granja de servidores web idénticos dentro de contenedores Docker y configurarlos automáticamente con Ansible. Además, se agregaron verificaciones de salud, plantillas dinámicas y un script de smoke tests para demostrar la autoría.

```
docker-compose ──> quasar-app (Apache/SSH)
					 └─> nebula-app (Apache/SSH)
								 ↓
						ansible site.yml
								 ↓
	  HTML templado + MOTD + healthchecks
```

---

### Componentes principales
- `docker/` : imagen Debian personalizada con Apache, SSH, usuario adicional y health probe inicial.
- `docker-compose.yml` : define los servicios `quasar-app` y `nebula-app`, redes, puertos (8085/8095) y healthchecks nativos.
- `ansible/roles/webstack` : rol que instala paquetes extra, configura MOTD, despliega una página HTML templada con datos dinámicos y reinicia Apache mediante handlers.
- `ansible/site.yml` : playbook principal con pre/post tasks (espera por SSH, validación HTTP y aserciones de autoría).
- `scripts/check_site.sh` : smoke test rápido para validar que ambos sitios exponen la matrícula.
- `docs/ORIGIN.md` : deja constancia del repositorio público usado como referencia inicial.

---

### Requisitos
- Docker y Docker Compose.
- Python 3 + Ansible 9+ (instalable vía `pip install --user ansible`).
- Exportar la variable `ANSIBLE_CONFIG` mientras se ejecute Ansible desde este workspace (el directorio es world-writable en Codespaces):

```bash
export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
```

---

### Pasos de ejecución
1. **Iniciar infraestructura base**
	```bash
	docker compose up -d --build
	```

2. **Verificar acceso SSH manual (opcional)**
	```bash
	ssh root@127.0.0.1 -p 2225 # contraseña: OrbitPass!2025
	```

3. **Aplicar configuración con Ansible**
	```bash
	ansible-playbook ansible/site.yml
	```
	(o bien `ansible-playbook -i inventory.ini setup.yml` si prefieres usar el wrapper del root).

4. **Ejecutar smoke test**
	```bash
	./scripts/check_site.sh
	```

5. **Abrir los sitios**
	- http://localhost:8085
	- http://localhost:8095

La página mostrará el hostname del contenedor, la fecha exacta de aprovisionamiento y el pie de página con la matrícula 2020-9643.

---

### Personalización rápida
- Edita `ansible/inventories/dev/group_vars/web.yml` para cambiar colores, textos y paquetes.
- Ajusta los puertos o los nombres de los servicios en `docker-compose.yml` según tus necesidades.
- Modifica `scripts/check_site.sh` para incluir pruebas adicionales (por ejemplo, validar headers o checksums).

---

### Créditos y licencias
- Basado conceptualmente en la práctica pública de [Diana Tejeda](https://github.com/Diana-hub23/practica10-ansible); se reescribió la estructura completa para esta entrega.
- Apache 2 y Debian se distribuyen bajo sus licencias respectivas.
- Todo el material adicional en este repositorio está disponible bajo la licencia MIT (puedes reutilizarlo mencionando la autoría de Bernardo Gomera – 2020-9643).
