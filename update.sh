#!/bin/bash
# elke zondag om 7 uur laten installeren: crontab -e = 0 7 * * 0 /opt/update.sh
# hij maakt een log file met wat hij heeft gedaan in /var/log/system_update_$TIMESTAMP.log

# Definieer de logbestandsnaam met een tijdstempel
TIMESTAMP=$(date +"%G-week%V")
LOGFILE="/var/log/system_update_$TIMESTAMP.log" # Aangepaste naam om relevanter te zijn

# Functie om te loggen
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOGFILE"
}

log "Start systeemupdate en upgrade..."

# Controleer of apt bestaat
if command -v apt &> /dev/null
then
    log "Apt-gebaseerd systeem gedetecteerd. Updaten met apt..."
    sudo apt update >> "$LOGFILE" 2>&1
    sudo apt upgrade -y >> "$LOGFILE" 2>&1
    sudo apt autoremove -y >> "$LOGFILE" 2>&1
    log "Apt update en upgrade voltooid."
elif command -v yum &> /dev/null
then
    log "Yum-gebaseerd systeem gedetecteerd. Updaten met yum..."
    sudo yum check-update >> "$LOGFILE" 2>&1 # Optioneel: controleert op updates zonder ze te installeren
    sudo yum update -y >> "$LOGFILE" 2>&1
    log "Yum update en upgrade voltooid."
elif command -v dnf &> /dev/null
then
    log "DNF-gebaseerd systeem gedetecteerd (moderne Fedora/RHEL). Updaten met dnf..."
    sudo dnf check-update >> "$LOGFILE" 2>&1 # Optioneel
    sudo dnf upgrade -y >> "$LOGFILE" 2>&1
    log "DNF update en upgrade voltooid."
else
    log "Geen ondersteund pakketbeheersysteem (apt, yum, dnf) gevonden."
    log "Controleer handmatig uw systeem."
    exit 1
fi

# Stap 2: Pi-hole updates
log "Controleer op Pi-hole installatie en update..."
if command -v pihole &> /dev/null
then
    log "Pi-hole installatie gedetecteerd. Start Pi-hole update..."
    # De -y flag (of --yes) automatiseert de bevestiging
    # De output van pihole -up wordt ook naar het logbestand gestuurd
    sudo pihole -up -y >> "$LOGFILE" 2>&1
    log "Pi-hole update voltooid."
else
    log "Pi-hole niet gedetecteerd of de 'pihole' command is niet beschikbaar in PATH."
fi

log "Systeemupdate en upgrade proces voltooid."

exit 0
