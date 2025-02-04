#!/bin/bash

for entry in "/app"/*
do
  echo "$entry"
done

echo "Starting Ollama server..."
ollama serve &

echo "Waiting for Ollama server to be active..."
while [ "$(ollama list | grep 'NAME')" == "" ]; do
  sleep 1
done

ollama pull llama3.1

python3 -m graphrag prompt-tune --root /app/graphrag --config /app/graphrag/settings.yaml --domain "salt-tolerant microbial species"

python3 -m graphrag index --root /app/graphrag

python3 -m graphrag query --root /app/graphrag --method global --query "Please list salt-tolerant microbial species."