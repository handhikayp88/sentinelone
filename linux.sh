#!/bin/bash

# --- KONFIGURASI ---
S1_URL="https://github.com/handhikayp88/sentinelone/raw/refs/heads/main/linux.deb"
S1_TOKEN="eyJ1cmwiOiAiaHR0cHM6Ly9hcHNlMS0yMDAyLnNlbnRpbmVsb25lLm5ldCIsICJzaXRlX2tleSI6ICJlZThkNmIzZWJmN2U4OWU0NjkzMTc3NTk3YjlkYjE4MmQ0ZTYxZTU2YzVlZjA0ZThlODFhNjZiMmNjNTQyNzU5In0="

echo "==============================================="
echo "   SENTINELONE INSTALLATION AGENT"
echo "==============================================="

echo -n "1. Memulai download... "
# Kita download dengan nama file yang lebih sederhana saja
curl -L -# -o SentinelAgent_linux_x86_64_v25_4_2_21.deb "$S1_URL"

if [ $? -eq 0 ]; then
    echo "   [OK] Download selesai."
else
    echo "   [ERROR] Download gagal!"
    exit 1
fi

echo "2. Menginstal paket .deb..."
# Hapus > /dev/null supaya kalau error kelihatan kenapa
sudo dpkg -i SentinelAgent_linux_x86_64_v25_4_2_21.deb || {
    echo "   [!] Ada masalah dependency, mencoba memperbaiki..."
    sudo apt-get install -f -y
    sudo dpkg -i SentinelAgent_linux_x86_64_v25_4_2_21.deb
}

# Cek apakah folder sentinelone benar-benar ada setelah install
if [ ! -f "/opt/sentinelone/bin/sentinelctl" ]; then
    echo "   [ERROR] File sentinelctl tidak ditemukan! Instalasi GAGAL."
    exit 1
fi

echo "3. Konfigurasi Site Token..."
sudo /opt/sentinelone/bin/sentinelctl management token set "$S1_TOKEN"

echo "4. Menjalankan Agent..."
sudo /opt/sentinelone/bin/sentinelctl control start

echo "5. Membersihkan file installer..."
rm SentinelAgent_linux_x86_64_v25_4_2_21.deb

echo "==============================================="
echo "INSTALASI SELESAI!"
echo "Status Agent Saat Ini:"
sudo /opt/sentinelone/bin/sentinelctl control status
echo "==============================================="