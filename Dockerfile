# Parent image
FROM python:3.10-slim

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=600

# Working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Copy requirements first (better Docker layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --default-timeout=600 --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Install local package (requires setup.py or pyproject.toml)
RUN pip install --default-timeout=600 --no-cache-dir -e .

# Expose Flask port
EXPOSE 5000

# Start application
CMD ["python", "app/application.py"]