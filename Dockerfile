# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser

# Switch to the non-privileged user to run the application.
# USER appuser

# build based on Ollama image
FROM ollama/ollama AS base

WORKDIR /app

RUN ollama serve &

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN <<EOF
apt-get update
apt-get install -y python3
apt-get install -y python3-pip
EOF

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=./graphrag/requirements.txt,target=./graphrag/requirements.txt \
    python3 -m pip install -r ./graphrag/requirements.txt

# Copy the source code into the container.
COPY . .
COPY ./entry_point.sh /entry_point.sh
RUN chmod +x /entry_point.sh

# Expose the port that the application listens on.
EXPOSE 11434

# Run the application.
# CMD ["/prep_model.sh","python","entry_point.py"]
ENTRYPOINT ["/entry_point.sh"]