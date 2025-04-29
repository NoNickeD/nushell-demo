# 🚀 kubenu - Nushell-Powered Kubernetes SRE CLI

**`kubenu`** is a structured, modular Kubernetes CLI written in [Nushell](https://www.nushell.sh/) — built for SREs and DevOps engineers who want better data pipelines, safer scripting, and more expressive Kubernetes automation.

> 🎯 **Why kubenu?** No more `awk`, `jq`, or fragile Bash. `kubenu` lets you **query, filter, transform, and automate** Kubernetes tasks using structured data and clean, readable pipelines.

## ✨ Key Features

### 📊 Cluster Management

- **Cluster Info**: Get detailed cluster version and node information
- **Health Checks**: Monitor node health and readiness status
- **Resource Overview**: View cluster resources and utilization

### 🛠 Pod Operations

- **Pod Listing**: View pods with status, restarts, and age
- **Crash Detection**: Identify and troubleshoot crashlooping pods
- **Log Management**: Stream and filter pod logs
- **Image Tracking**: List and manage container images

### 🚀 Deployment Control

- **Status Monitoring**: Check deployment rollout status
- **Scaling**: Scale deployments up/down with ease
- **Restart Management**: Trigger deployment restarts

### 🧹 Resource Cleanup

- **Evicted Pods**: Automatically clean up evicted pods
- **Job Management**: Remove completed jobs based on age
- **Resource Optimization**: Maintain cluster health

### ⚡ Technical Advantages

- **Structured Data**: Pure Nushell pipelines for reliable data processing
- **JSON/YAML Handling**: Native support for structured data formats
- **Extensible Design**: Easy to add new commands and features
- **Error Handling**: Robust error management and user feedback

## 🛠 Installation

### Prerequisites

- [Nushell](https://www.nushell.sh/) (install via `brew install nushell` or [see docs](https://www.nushell.sh/book/installation.html))
- `kubectl` installed and configured
- Access to a Kubernetes cluster

### Quick Start

```bash
# Clone the repository
git clone https://github.com/NoNickeD/nushell-demo.git
cd nushell-demo

# Make the script executable
chmod +x kubenu.nu

# Create a symlink for easy access
sudo ln -s $(pwd)/kubenu.nu /usr/local/bin/kubenu
```

## 📚 Usage Guide

### Cluster Operations

```bash
# View cluster information
kubenu cluster info

# Check cluster health
kubenu cluster health
```

### Pod Management

```bash
# List all pods with detailed status
kubenu pods list

# Find crashlooping pods
kubenu pods crashes

# View pod logs (auto-detects namespace)
kubenu pods logs my-pod

# List container images
kubenu pods images my-deploy
```

### Deployment Control

```bash
# Check deployment status
kubenu deploy status my-deployment

# Scale a deployment
kubenu deploy scale my-deployment 3

# Restart a deployment
kubenu deploy restart my-deployment
```

### Cleanup Operations

```bash
# Clean up evicted pods
kubenu cleanup evicted

# Remove old completed jobs
kubenu cleanup jobs --older-than 7
```

## 🏗 Project Structure

```plaintext
kubenu/
├── README.md
├── kubenu.nu         # Main entrypoint script
├── lib/
│   └── util.nu       # Common helper functions
├── commands/
│   ├── cluster.nu    # Cluster management
│   ├── pods.nu       # Pod operations
│   ├── deploy.nu     # Deployment control
│   └── cleanup.nu    # Resource cleanup
```

## 🧪 Development

### Local Development Setup

```bash
# Create a local Kubernetes cluster
task full-deploy-local

# Verify
task verify-deployment
```

### Adding New Commands

1. Create a new file in the `commands/` directory
2. Implement your command using Nushell
3. Add the command to the main script
4. Update the README with documentation

## 🗑 Cleanup

To delete the local Kubernetes cluster:

```bash
task delete-local-cluster
```

---

> 💡 **Pro Tip**: Need to do something that would take 10 lines of Bash? Try `kubenu` instead! 😎
