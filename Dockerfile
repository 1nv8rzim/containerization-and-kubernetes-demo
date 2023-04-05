# Use the official Python base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Copy the rest of the application code
COPY ./app/. /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command to start the app
CMD ["python", "main.py"]
