# Hands-On DevOps Lab: Flask Application with SonarQube CI/CD Pipeline

A complete DevOps implementation demonstrating automated code analysis, unit testing, and containerized deployment for a Python/Flask application running on AWS EC2.

---

## 📌 Project Overview

This project showcases a modern CI/CD pipeline integrated with code quality gates using **SonarQube** and **GitHub Actions**. The application and static code analysis server are hosted in **Docker** containers on an **AWS EC2** instance.

### Key Features
* **Automated Testing:** Runs unit tests via `pytest` on every Pull Request.
* **Continuous Inspection:** Analyzes code quality, security vulnerabilities, and code smells using **SonarQube LTS**.
* **Quality Gate Enforcement:** Prevents unverified or buggy code from merging into the `main` branch.
* **Containerized Infrastructure:** Services (SonarQube & PostgreSQL) managed via `docker-compose`.
* **AWS EC2 Deployment:** Configured security groups, swap memory management, and system limits (`vm.max_map_count`) for ElasticSearch stability.

---

## 🛠️ Tech Stack & Tools

* **Language & Framework:** Python 3.11 / Flask
* **Testing:** Pytest
* **CI/CD:** GitHub Actions
* **Static Code Analysis:** SonarQube Community LTS Edition
* **Database:** PostgreSQL 16
* **Containerization:** Docker & Docker Compose
* **Cloud Infrastructure:** AWS EC2 (Ubuntu 24.04 LTS)
* **IaC / Configuration (Optional):** Terraform & Ansible

---

## 🏗️ Pipeline & Infrastructure Architecture

```text
[ Developer ] --( Git Push / PR )--> [ GitHub Repository ]
                                            │
                                            ▼
                                   [ GitHub Actions ]
                                            │
                    ┌───────────────────────┴───────────────────────┐
                    ▼                                               ▼
            [ Step 1: Pytest ]                   [ Step 2: SonarQube Scan ]
             (Unit Testing)                                 │
                                                            ▼
                                                [ AWS EC2 Instance ]
                                            (SonarQube:9000 & PostgreSQL)
                                                            │
                                                            ▼
                                                  [ Quality Gate Check ]
                                                            │
                                                ( Pass ✔️  /  Fail ❌ )
```

---

## 🚀 Environment Setup

### 1. AWS EC2 Server Preparation

Ensure your EC2 instance (e.g., `t3.medium` or `t3.micro` with Swap) is configured:

```bash
# 1. Update sysctl map count for ElasticSearch
sudo sysctl -w vm.max_map_count=262144

# 2. Add 2GB Swap space (Crucial for t2/t3.micro instances)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 3. Clone repository and start SonarQube stack
docker compose -f docker-compose.sonar.yml up -d
```

### 2. AWS Security Group Settings

Configure **Inbound Rules** for your EC2 Security Group:

| Type | Port Range | Protocol | Source | Description |
| :--- | :--- | :--- | :--- | :--- |
| SSH | `22` | TCP | `My IP` | SSH Access |
| Custom TCP | `5000` | TCP | `0.0.0.0/0` | Flask App Port |
| Custom TCP | `9000` | TCP | `0.0.0.0/0` | SonarQube Web UI |

---

## 🔑 GitHub Secrets Configuration

To connect GitHub Actions with your hosted SonarQube instance, navigate to **Settings > Secrets and variables > Actions** in your GitHub repository and add:

| Secret Name | Description / Example Value |
| :--- | :--- |
| `SONAR_TOKEN` | Generated token from SonarQube (`My Account > Security`) |
| `SONAR_HOST_URL` | `http://<YOUR-EC2-PUBLIC-IP>:9000` |

---

## 🧪 CI/CD Workflow & Quality Gate

The pipeline (`.github/workflows/ci.yml`) is triggered on every **Pull Request** to `main`:

1. **Checkout Code:** Retrieves the latest code from the feature branch.
2. **Environment Setup:** Configures Python 3.11 environment.
3. **Run Unit Tests:** Executes `python -m pytest` to ensure code functionality.
4. **SonarQube Scan:** Sends code analysis data to SonarQube on EC2.
5. **Quality Gate Assessment:** Blocks the PR merge if code quality thresholds are not met.

---

## 📊 Local Verification

To run unit tests locally before pushing:

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Execute test suite
pytest
```

---

## 📝 License

This project is open-source and intended for educational and portfolio demonstration purposes.