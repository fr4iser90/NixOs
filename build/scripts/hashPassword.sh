#!/bin/bash

set -e

# Funktion zum Hashen des Passworts
hash_password() {
    local password="$1"
    echo "$password" | mkpasswd -m sha-512 -s
}

# Überprüfen, ob mkpasswd installiert ist
if ! command -v mkpasswd &> /dev/null; then
    echo "mkpasswd wird installiert..."
    nix-env -iA nixpkgs.whois
fi

# Passwort abfragen und sicherstellen, dass es nicht leer ist
while true; do
    read -sp "Bitte Passwort eingeben: " password
    echo
    if [[ -z "$password" ]]; then
        echo "Passwort darf nicht leer sein. Bitte erneut eingeben."
        continue
    fi

    read -sp "Bitte Passwort bestätigen: " password_confirm
    echo

    # Überprüfen, ob die Passwörter übereinstimmen
    if [[ "$password" != "$password_confirm" ]]; then
        echo "Passwörter stimmen nicht überein. Bitte erneut eingeben."
    else
        break
    fi
done

# Zielverzeichnis definieren
OUTPUT_DIR="./nixos/secrets/passwords"
OUTPUT_FILE="$OUTPUT_DIR/.hashedLoginPassword"

# Lösche die bestehende Passwortdatei, falls sie existiert
if [[ -f "$OUTPUT_FILE" ]]; then
    rm "$OUTPUT_FILE"
fi

# Verzeichnis erstellen, falls es nicht existiert
mkdir -p "$OUTPUT_DIR"

# Passwort hashen
hashed_password=$(hash_password "$password")

# Gehashtes Passwort in Datei speichern
printf "%s\n" "$hashed_password" > "$OUTPUT_FILE"

printf "Das Passwort wurde erfolgreich gehasht und in %s gespeichert.\n" "$OUTPUT_FILE"
