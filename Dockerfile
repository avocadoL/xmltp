FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    libxml2-utils \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /xml

# Copy XML files and scripts
COPY transport/ /xml/transport/
COPY marketplace/ /xml/marketplace/
COPY test.sh /xml/

# Make the test script executable
RUN chmod +x /xml/test.sh

# Set the default command
CMD ["./test.sh"] 