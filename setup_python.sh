#!/bin/bash

# Step 1: Ask for project name
read -p "📁 What is your project name? " PROJECT_NAME
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit
echo "✅ Created and moved into $PROJECT_NAME"

# Step 2: Detect working Python command
if command -v python3 &>/dev/null && python3 -c "print(123)" &>/dev/null; then
  PY_CMD="python3"
elif command -v python &>/dev/null && python -c "print(123)" &>/dev/null; then
  PY_CMD="python"
else
  echo "❌ No valid Python command found (python3 or python). Please install Python."
  exit 1
fi

echo "🐍 Using Python command: $PY_CMD"

# Defaults
INIT_GIT="n"
INSTALL_PILLOW="n"
INSTALL_REQUESTS="n"

# Step 3: Ask user questions unless -y flag
if [[ "$1" == "-y" || "$1" == "--yes" ]]; then
  echo "✅ Running with defaults: no git, no Pillow, no Requests"
else
  read -p "Do you want to run 'git init'? [y/N]: " USER_INIT_GIT
  INIT_GIT=$(echo "$USER_INIT_GIT" | tr '[:upper:]' '[:lower:]')

  read -p "Do you want to install Pillow? [y/N]: " USER_INSTALL_PILLOW
  INSTALL_PILLOW=$(echo "$USER_INSTALL_PILLOW" | tr '[:upper:]' '[:lower:]')

  read -p "Do you want to install Requests? [y/N]: " USER_INSTALL_REQUESTS
  INSTALL_REQUESTS=$(echo "$USER_INSTALL_REQUESTS" | tr '[:upper:]' '[:lower:]')
fi

# Step 4: Create venv
$PY_CMD -m venv .venv
echo "✅ Created .venv"

# Step 5: Activate it
source .venv/bin/activate
echo "✅ Activated .venv"

# Step 6: Optionally init git
if [[ "$INIT_GIT" == "y" || "$INIT_GIT" == "yes" ]]; then
  git init
  echo "✅ Git initialized"
fi

# Step 7: .gitignore
cat <<EOL > .gitignore
# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd
.Python
.env
.venv/
*.sqlite3

# VS Code
.vscode/

# macOS
.DS_Store

# Env files
.env
EOL
echo "✅ .gitignore created"

# Step 8: Optional installs
ANY_PACKAGES=false

if [[ "$INSTALL_PILLOW" == "y" || "$INSTALL_PILLOW" == "yes" ]]; then
  pip install Pillow
  ANY_PACKAGES=true
fi

if [[ "$INSTALL_REQUESTS" == "y" || "$INSTALL_REQUESTS" == "yes" ]]; then
  pip install requests
  ANY_PACKAGES=true
fi

# Step 9: Freeze if packages installed
if [ "$ANY_PACKAGES" = true ]; then
  pip freeze > requirements.txt
  echo "✅ requirements.txt created"
fi

# Step 10: main.py
cat <<EOL > main.py
def main():
    print("Hello from main!")

if __name__ == "__main__":
    main()
EOL
echo "✅ main.py created"

# Step 11: README.md
cat <<EOL > README.md
# Python Quick Setup Workspace
by Nick Golebiewski
https://github.com/ngolebiewski/py_starter

## 📦 Virtual Environment
Activate:
\`\`\`bash
source .venv/bin/activate
\`\`\`

Deactivate:
\`\`\`bash
deactivate
\`\`\`
EOL

echo "✅ README.md added"

# Final tip
echo ""
echo "🚀 Project setup complete!"
echo "👏 Now go to your new directory: cd $PROJECT_NAME"