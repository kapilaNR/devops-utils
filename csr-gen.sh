#!/bin/bash

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is not installed. Please install OpenSSL."
    exit 1
fi

# Function to generate CSR for each DNS name
generate_csr() {
    local dns_name="$1"
    local key_file="private-key-${dns_name}.pem"
    local csr_file="csr-${dns_name}.pem"

    # Generate private key
    openssl genrsa -out "${key_file}" 2048

    # Generate CSR
    openssl req -new -key "${key_file}" -out "${csr_file}" -subj "/CN=${dns_name}"
}

# Check if DNS names are provided as arguments
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <dns_name1> [<dns_name2> ...]"
    exit 1
fi

# Iterate over each DNS name provided as argument
for dns in "$@"; do
    echo "Generating CSR for DNS: ${dns}"
    generate_csr "${dns}"
    echo "CSR generated: csr-${dns}.pem"
    echo "Private key generated: private-key-${dns}.pem"
    echo "------------------------"
done

echo "CSR generation complete."