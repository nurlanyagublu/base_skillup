# Use the official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY app.py .

# Set environment variable for version (can be overridden at build time)
ARG APP_VERSION=0.0.1
ENV APP_VERSION=${APP_VERSION}

# Expose Flask port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
