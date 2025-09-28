# My Development Environment Setup

## System Information
- **OS**: macOS (Apple Silicon)
- **Terminal**: iTerm2 with Zsh
- **Node Manager**: Volta
- **Package Manager**: npm
- **Version Control**: Git
- **Editor**: VS Code

## Project Structure
~/code/
├── work/
│   ├── cdp-ui/              # Frontend React application
│   └── cdp-behind-service/  # Backend Node.js service
├── personal/                # Personal projects
└── experiments/             # Learning and experimental code

## Development Stack
- **Frontend**: React + Vite, TypeScript
- **Backend**: Node.js, Express
- **Database**: PostgreSQL (local + remote stage)
- **Cache**: Redis
- **Message Queue**: Kafka
- **Authentication**: Okta
- **Deployment**: AWS (dev/stage environments)

## Available Development Services
- **Local Database**: PostgreSQL on localhost:5432
- **Local Cache**: Redis on localhost:6379
- **Local Kafka**: Full ecosystem on localhost:9092
- **Backend API**: localhost:3001
- **Frontend**: localhost:3000

## Environment Management
I have automated alias functions for switching between environments:

**Frontend Environment Control:**
- frontend-local - Points to localhost:3001 backend
- frontend-dev - Points to dev.platform.aws.chgit.com backend  
- frontend-stage - Points to stage.platform.aws.chgit.com backend
- frontend-branch <name> - Points to feature branch deployment
- frontend-status - Shows current configuration

**Service Management:**
- dev-services-up/down - Start/stop all local services
- redis-up/down, postgres-up/down, kafka-up/down - Individual service control

**Navigation Shortcuts:**
- work - Jump to ~/code/work/
- cdpui - Jump to frontend project
- cdpbe - Jump to backend project
- dotfiles - Jump to dotfiles directory

**Development Workflow:**
- dev-status - Check environment health (with -v for verbose)
- update-shortcuts - Auto-update documentation and push to git
- add-alias <name> <command> - Add new aliases with auto-documentation
- remove-alias <name> - Remove aliases with auto-documentation

## Key Configuration Files
- **Frontend .env**: Controls backend API URL via VITE_BEHIND_SERVICE_API_URL
- **Backend .env**: Controls database, external services, environment settings
- **Dotfiles**: Managed in ~/dotfiles/ with automatic git sync

## Token Management
- NPM tokens managed via token-local/dev/stage/prod commands
- Automatic token injection into .npmrc
- Environment-specific authentication handling

## Current Project Context
Working on CDP (Clinical Decision Platform) with:
- Frontend: React-based clinical workflow application
- Backend: Node.js service handling clinical data and integrations
- Integration with multiple external services (EDM, Employee Service, DMS, etc.)
- Multi-environment deployment pipeline (local → dev → stage → prod)

## Automation Features
- Self-updating shortcuts documentation
- Automatic git commits for configuration changes
- Environment switching without manual .env editing
- Centralized alias management system
