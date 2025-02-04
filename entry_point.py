import subprocess

print('starting ollama test')

# start ollama server
# subprocess.run("ollama serve",shell=True)
# subprocess.run("python -m graphrag",shell=True)

subprocess.run("pwd",shell=True)
subprocess.run("dir",shell=True)
subprocess.run("ls ./graphrag",shell=True)
subprocess.run("docker compose exec ollama ollama serve",shell=True)

subprocess.run('python -m graphrag prompt-tune --root ./graphrag --config ./graphrag/settings.yaml --domain "salt-tolerant microbial species"',shell=True)

subprocess.run('python -m graphrag index --root ./graphrag',shell=True)

subprocess.run('python -m graphrag query --root ./graphrag --method global --query "Please list salt-tolerant microbial species."',shell=True)