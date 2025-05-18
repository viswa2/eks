FROM python:3.11-slim

# Create app directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Run as non-root user
RUN adduser --disabled-password appuser
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
