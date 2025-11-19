# Refactor & Differentiation Plan

## Objectives
1. Preserve the educational goal: provision two web servers automatically via Ansible.
2. Produce an original implementation with distinct naming, structure, and extra capabilities.
3. Add meaningful improvements (templated page, health checks, idempotent handlers, smoke tests).

## Planned Changes

### Container Layer
- Rename services to `quasar-app` and `nebula-app` to avoid upstream naming.
- Base images on `debian:bookworm-slim` with unattended security updates.
- Install `fail2ban`, `curl`, and `vim-tiny` for added functionality.
- Configure SSH to use key-based auth plus randomized password stored via Docker secrets.
- Serve a placeholder HTML that references dynamic facts from Ansible.

### Docker Compose
- Add explicit networks (`edge_net`) and healthcheck blocks per service.
- Mount a shared volume for Apache logs to demonstrate post-provision analysis.
- Expose ports 8085/8095 for HTTP and 2225/2235 for SSH.

### Ansible Layout
- Introduce `ansible.cfg` with custom retry/ssh settings.
- Split inventory into groups with host vars (`inventories/dev/hosts.ini`).
- Replace monolithic playbook with role `webstack` (tasks for packages, config, templated HTML, service handlers, verification).
- Add `templates/index.j2` and `files/motd` for extra assets.
- Include pre-task to assert connectivity and gather facts, post-task to run `uri` checks.

### Enhancements
- Parameterize site title and accent color via group vars.
- Implement smoke test (`scripts/check_site.sh`) that curls both endpoints and validates checksum.
- Add GitHub-friendly `README.md` with new instructions, architecture diagram, and attribution.
- Document your author info (Bernardo Gomera, matrícula 2020-9643) in README and generated HTML footer.
