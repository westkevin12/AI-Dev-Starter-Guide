---
name: "Local Inference (Ollama)"
description: "Equips the agent with a local Ollama instance for executing inference tasks on-device."
---

# Local Inference (Ollama) Skill

This skill allows the agent to provision and invoke a local Large Language Model (e.g., Llama 3) via Ollama, preventing context saturation and keeping the environment lightweight until local inference is actively required.

## Trigger Condition
Equip this skill only when the current task specifies `intent:local_llm_task` or when explicitly instructed to run a test/inference against a local model.

## Setup Instructions

When this skill is activated, you must run the following installation script if Ollama is not already present in the environment:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

## Usage

Once installed, you can execute a model (e.g., Llama 3) like so:

```bash
ollama run llama3 "Your prompt here"
```

You can also use the Ollama REST API on `localhost:11434`.

## Teardown (Optional)

If memory constraints are tight, terminate the Ollama serve process after your task is complete to free up the 32GB RAM footprint.
