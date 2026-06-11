# TPASZI-lab-works
Лабораторные работы включают в себя FastAPI-сервис, Docker-образ, Docker Compose с мониторингом, k8s-манифесты, terraform-манифесты
## Описание содержимого папок и файлов проекта
- `app/` - FastAPI-приложение.
- `tests/` - pytest.
- `.github/workflows/ci.yml` - GitHub Actions pipeline.
- `Dockerfile` - сборка контейнера приложения.
- `docker-compose.yml` - приложение, Prometheus и Grafana.
- `monitoring/` - конфигурация Prometheus и Grafana datasource.
- `k8s/` - k8s-манифесты.
- `terraform/` - terraform-манифесты.
## Системные требования
- Python 3.11+
- Docker Desktop
- Git
- Terraform (1.6+)
- Yandex Cloud CLI или переменная окружения `YC_TOKEN`
## GitHub, SAST, линтеры и тесты

В проекте настроены:

- SAST: `bandit`
- Линтеры и форматеры: `ruff`, `pylint`
- Тесты: `pytest`
- CI: GitHub Actions - выполняет автоматическую проверку и сборку при push и pull запросах.
## FastAPI-сервис

Локальный запуск:

```powershell
.\.venv\Scripts\uvicorn app.main:app --reload
```

Проверка:
```powershell
curl http://127.0.0.1:8000/
curl http://127.0.0.1:8000/health
curl http://127.0.0.1:8000/metrics
```

Описание функций:

- `/` - информация о сервисе
- `/health` - проверка работоспособности
- `/metrics` - Prometheus metrics
## Docker

Сборка локального образа:

```powershell
docker build -t solseracc-fastapi:local .
```

Запуск контейнера:

```powershell
docker run --rm -p 8000:8000 solseracc-fastapi:local
```

Проверка:

```powershell
curl http://127.0.0.1:8000/health
```
## Docker Hub
В проекте не удалось подключиться к Docker Hub, поэтому далее будут лишь описаны действия, если бы проет был подключен.

Публикуемый образ:

```text
solseracc/solseracc-fastapi:latest
```

Команды сборки и публикации:

```powershell
docker build -t solseracc/solseracc-fastapi:latest .
docker push solseracc/solseracc-fastapi:latest
```

Проверка загрузки:

```powershell
docker pull solseracc/solseracc-fastapi:latest
```
## Docker Compose, Prometheus и Grafana

Запуск:

```powershell
docker compose up --build
```

Сервисы:

- FastAPI: <http://localhost:8000>
- Prometheus: <http://localhost:9090>
- Grafana: <http://localhost:3000>
## Kubernetes-манифесты
Манифесты, находящиеся папке в `k8s/`:

- `namespace.yaml`
- `deployment.yaml`
- `service.yaml`
- `ingress.yaml`

## Terraform-манифесты
Манифесты, находящиеся папке в `terraform/`:

- `main.tf`
- `terraform.tfvars.example`
- `variables.tf`

Подготовьте переменные в файле перед запуском в `terraform/terraform.tfvars`:

Запуск:

```powershell
cd terraform
terraform init
terraform plan
terraform apply
```
