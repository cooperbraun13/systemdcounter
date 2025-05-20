FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Create directory
WORKDIR /app

# Copy counter app
COPY bin/counter.py /app/counter.py

# Make script executable
RUN chmod +x /app/counter.py

# Command to run counter
CMD ["/app/counter.py"]
