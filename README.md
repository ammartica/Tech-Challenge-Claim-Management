# Tech-Challenge-Claim-Management

## Description:

This repository has my solution to the **HAIPRIORI Technical Challenge**.

The goal is to design, implement, and deliver a small Medical Center Claim Management system.

It is a very simple, three page app that has:

- Authentication
- CSV file import of medical claims (following a particular structure)
- Backend generated CSV export file
- Visualization of correctly imported claims

The app is simple and focuses on the requires use cases.

---

## Tech Stack

**Backend**
- Docker
- Ruby on Rails
- Docker & Docker Compose

**Frontend**
- React (Vite)

**UI**
- Ant Design (AntD)

**DB**
- PostgreSQL

## Local Setup

### Prerequisites
- Docker & Docker Compose
- Node.js

### 1. Clone the repository

```bash
git clone https://github.com/ammartica/Tech-Challenge-Claim-Management.git
cd tech-challenge
```
---

### 2. Start the backend (Rails + PostgreSQL)

```bash
docker compose up --build
```

In a separate terminal, seed a default user:

```bash
docker compose exec backend bundle exec rails db:seed
```

---

### 3. Start the frontend

```bash
cd frontend
npm install
npm run dev
```
## Login Credentials (Development Only)

Use the seeded user:

- **Email:** `staff@test.com`
- **Password:** `password`

---

## Importing Claims

1. Log in to the application
2. Navigate to **Import Claims**
3. Upload a CSV file by clicking the button

An example CSV file is provided at:

```
backend/sample_claims.csv
backend/verify_import.csv
```
⚠️ verify_import has a mixture of good and bad data

---

## Exporting Claims

1. Navigate to the **Claims** page
2. Click **Export CSV**
3. A CSV file containing processed claims will be downloaded

## Final Notes

- The UI is intentionally simple and focused on usability
- In order to ensure connection between ClaimImports and Claims models, I added claims_import_id column on Claims model to connect them