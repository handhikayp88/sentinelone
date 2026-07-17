#!/bin/bash

# --- KONFIGURASI ---
# Pastikan URL mengarah ke versi RPM yang sesuai untuk CentOS
S1_URL="https://github.com/handhikayp88/sentinelone/raw/refs/heads/main/linux.rpm"
S1_TOKEN="eyJ1cmwiOiAiaHR0cHM6Ly9hcHNlMS0yMDAyLnNlbnRpbmVsb25lLm5ldCIsICJzaXRlX2tleSI6ICJlZThkNmIzZWJmN2U4OWU0NjkzMTc3NTk3YjlkYjE4MmQ0ZTYxZTU2YzVlZjA0ZThlODFhNjZiMmNjNTQyNzU5In0="
INSTALLER_FILE="linux.rpm"

# --- PROSES INSTALASI ---
echo "==============================================="
echo "   SENTINELONE INSTALLATION AGENT (CENTOS)"
echo "==============================================="

# Cek apakah user menjalankan sebagai root/sudo
if [ "$EUID" -ne 0 ]; then 
  echo "[ERROR] Harap jalankan script ini dengan sudo atau sebagai root."
  exit 1
fi

echo -n "1. Memulai download... "
curl -L -# -o "$INSTALLER_FILE" "$S1_URL"

if [ $? -eq 0 ]; then
    echo "   [OK] Download selesai."
else
    echo "   [ERROR] Download gagal!"
    exit 1
fi

echo "2. Menginstal paket .rpm..."
# Menggunakan yum/dnf lebih baik daripada 'rpm -i' karena menangani dependensi otomatis
yum localinstall -y "$INSTALLER_FILE" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   [OK] Instalasi berhasil."
else
    echo "   [ERROR] Instalasi gagal!"
    exit 1
fi

echo "3. Konfigurasi Site Token..."
/opt/sentinelone/bin/sentinelctl management token set "$S1_TOKEN"

echo "4. Menjalankan Agent..."
/opt/sentinelone/bin/sentinelctl control start

echo "5. Membersihkan file installer..."
rm -f "$INSTALLER_FILE"

echo "==============================================="
echo "INSTALASI SELESAI!"
echo "Status Agent Saat Ini:"
/opt/sentinelone/bin/sentinelctl control status
echo "==============================================="