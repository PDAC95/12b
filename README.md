# Bippi - Smart Grocery Tracker

Multi-retailer grocery scanner app for Canadian shoppers. Scan products in real-time, track spending across stores, and stay within budget.

## Project Status

**Sprint 1** - Foundation Setup (Oct 28 - Nov 10, 2025)
**Target Launch:** December 8, 2025 (Beta)

## Tech Stack

### Mobile (React Native + Expo)
- **Framework:** React Native 0.81.5 + Expo SDK ~54.0
- **Language:** TypeScript 5.9+
- **State:** Zustand 5.x
- **Navigation:** React Navigation 7.x
- **Features:** Barcode scanner, Camera access

### Backend (FastAPI)
- **Framework:** FastAPI 0.120+
- **Language:** Python 3.13+
- **Database:** PostgreSQL 15 (Supabase)
- **ORM:** SQLAlchemy 2.0 (async)
- **Auth:** Supabase Auth (JWT)

### Infrastructure
- **Database:** Supabase (PostgreSQL + Auth)
- **Mobile Deployment:** Expo (TestFlight → App Store)
- **Backend Hosting:** Railway / Render
- **CI/CD:** GitHub Actions

---

## Getting Started

### Prerequisites

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **Python** 3.11+ ([Download](https://www.python.org/downloads/))
- **Git** ([Download](https://git-scm.com/))
- **Supabase Account** (Free tier: [supabase.com](https://supabase.com))
- **Expo CLI:** Installed via npx (no global install needed)

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/PDAC95/12b.git
cd 12b
```

### 2. Setup Mobile (React Native + Expo)

```bash
cd bippi-mobile

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.development

# Edit .env.development with your Supabase credentials
# EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
# EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### 3. Setup Backend (FastAPI)

```bash
cd ../bippi-backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements-dev.txt

# Copy environment variables
cp .env.example .env.development

# Edit .env.development with your Supabase credentials
# DATABASE_URL=postgresql://postgres:password@db.xxx.supabase.co:5432/postgres
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_SERVICE_KEY=your-service-key
```

### 4. Setup Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Name: `bippi-dev`
3. Database Password: **Save this securely**
4. Region: Choose closest to you (e.g., `us-east-1`)
5. Once created, get credentials from **Project Settings → API**:
   - `SUPABASE_URL`: Project URL
   - `SUPABASE_ANON_KEY`: anon/public key
   - `SUPABASE_SERVICE_KEY`: service_role key (keep secret!)
6. Get database connection string from **Project Settings → Database**:
   - Copy the URI connection string
   - Replace `[YOUR-PASSWORD]` with your database password

---

## Running the Project

### Start Mobile App

```bash
cd bippi-mobile

# Start Expo development server
npm start

# Options:
# - Press 'a' for Android emulator
# - Press 'i' for iOS simulator (Mac only)
# - Press 'w' for web browser
# - Scan QR with Expo Go app for physical device
```

### Start Backend API

```bash
cd bippi-backend
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Start FastAPI server
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# API will be available at:
# - http://localhost:8000
# - Interactive docs: http://localhost:8000/docs
```

---

## Development Commands

### Mobile

```bash
cd bippi-mobile

npm run lint          # Run ESLint
npm run lint:fix      # Fix ESLint errors
npm run format        # Format with Prettier
npm run format:check  # Check Prettier formatting
npm run type-check    # TypeScript check
npm start             # Start Expo dev server
```

### Backend

```bash
cd bippi-backend
source venv/bin/activate

black src/ tests/          # Format code
black --check src/ tests/  # Check formatting
ruff check src/ tests/     # Lint code
ruff check --fix src/      # Fix lint errors
mypy src/                  # Type checking
pytest tests/ -v           # Run tests
```

---

## Project Structure

```
12b/
├── bippi-mobile/          # React Native + Expo app
│   ├── src/
│   │   ├── features/      # Feature-based modules
│   │   │   ├── auth/
│   │   │   ├── scanner/
│   │   │   ├── dashboard/
│   │   │   ├── history/
│   │   │   └── products/
│   │   ├── shared/        # Shared components/hooks/utils
│   │   ├── core/          # Core services (API, storage, config)
│   │   ├── navigation/    # React Navigation setup
│   │   └── store/         # Zustand stores
│   ├── assets/            # Images, fonts, icons
│   └── app.json           # Expo configuration
│
├── bippi-backend/         # FastAPI backend
│   ├── src/
│   │   ├── api/v1/routes/ # API endpoints
│   │   ├── core/          # Config, security, database
│   │   ├── models/        # SQLAlchemy models
│   │   ├── schemas/       # Pydantic schemas
│   │   ├── services/      # Business logic
│   │   └── middleware/    # Custom middleware
│   ├── tests/             # Pytest tests
│   └── requirements.txt   # Python dependencies
│
├── docs/                  # Project documentation
│   ├── 1.prd.md          # Product Requirements
│   ├── 2.architecture.md # Architecture docs
│   ├── 3. Backlog.md     # Product backlog
│   ├── 4. sprint 1.md    # Sprint planning
│   └── 5. Tasks s1.md    # Sprint 1 tasks
│
└── .github/workflows/     # CI/CD pipelines
    ├── mobile-ci.yml
    └── backend-ci.yml
```

---

## Environment Variables

### Mobile (.env.development)

```bash
EXPO_PUBLIC_API_URL=http://localhost:8000/api/v1
EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
EXPO_PUBLIC_ENVIRONMENT=development
```

### Backend (.env.development)

```bash
DATABASE_URL=postgresql://postgres:your-password@db.xxx.supabase.co:5432/postgres
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-key-here
JWT_SECRET=dev-secret-key-change-me
ENVIRONMENT=development
```

---

## Troubleshooting

### Mobile Issues

**"Metro bundler won't start"**
```bash
cd bippi-mobile
rm -rf node_modules
npm install
npx expo start --clear
```

**"Module not found errors"**
```bash
# Clear Expo cache
npx expo start --clear

# Clear Metro cache
rm -rf .expo
```

### Backend Issues

**"ModuleNotFoundError"**
```bash
# Ensure venv is activated
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows

# Reinstall dependencies
pip install -r requirements-dev.txt
```

**"Cannot connect to database"**
- Verify DATABASE_URL in .env.development
- Check Supabase project is running
- Verify firewall/network allows connection

---

## CI/CD

GitHub Actions workflows run automatically on push to `main`:

- **Mobile CI:** ESLint, Prettier, TypeScript check, Build verification
- **Backend CI:** Black, Ruff, mypy, pytest

View status: [GitHub Actions](https://github.com/PDAC95/12b/actions)

---

## Contributing

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: your feature description"

# Push and create PR
git push origin feature/your-feature-name
```

### Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `refactor:` Code refactoring
- `test:` Tests
- `chore:` Maintenance

---

## Documentation

- **PRD:** [docs/1.prd.md](docs/1.prd.md)
- **Architecture:** [docs/2.architecture.md](docs/2.architecture.md)
- **Product Backlog:** [docs/3. Backlog.md](docs/3.%20Backlog.md)
- **Sprint 1 Planning:** [docs/4. sprint 1.md](docs/4.%20sprint%201.md)
- **Sprint 1 Tasks:** [docs/5. Tasks s1.md](docs/5.%20Tasks%20s1.md)

---

## License

Private project - All rights reserved

---

## Contact

**Team:** Development Team
**Repository:** [github.com/PDAC95/12b](https://github.com/PDAC95/12b)

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
