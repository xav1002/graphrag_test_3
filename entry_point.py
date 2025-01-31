import subprocess

# start ollama server
subprocess.run("ollama serve",shell=True)

subprocess.run('python -m graphrag prompt-tune --root . --config ./settings.yaml --domain "salt-tolerant microbial species"',shell=True)

subprocess.run('python -m graphrag index --root .',shell=True)

subprocess.run('python -m graphrag query --root . --method global --query "Please list salt-tolerant microbial species."',shell=True)