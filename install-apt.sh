#!/usr/bin/env bash
APT_URL=https://lasa.secureobs.com/apt
APT_FINGERPRINT=93C97405D749DF2D46D803DD5A6DF1D212A34CA4
# shellcheck shell=bash
# This body is prefixed with the repository URL and expected public fingerprint.
set -euo pipefail
umask 022
trap 'printf "LASA APT installation failed at line %s (%s). See the command output above for the cause.\n" "$LINENO" "$BASH_COMMAND" >&2' ERR
[[ $(uname -s) == Linux ]] || { echo 'LASA runs on Linux. This installer cannot scan a Mac or native Windows.' >&2; exit 1; }
command -v apt-get >/dev/null || { echo 'This installer needs Debian/Ubuntu apt-get. Use the Linux Homebrew tap or binary archive on other distributions.' >&2; exit 1; }
arch=$(dpkg --print-architecture)
case "$arch" in amd64|arm64) ;; *) echo "Unsupported architecture: $arch (supported: amd64, arm64)" >&2; exit 1;; esac
sudo_cmd=()
if [ "$(id -u)" != 0 ]; then
  command -v sudo >/dev/null || { echo 'Installing APT packages requires root or sudo.' >&2; exit 1; }
  sudo_cmd=(sudo)
fi
# Existing clients may need a new signing subkey before APT can refresh LASA.
# Use their installed prerequisites to refresh the pinned keyring first.
if ! command -v curl >/dev/null || ! command -v gpg >/dev/null || [ ! -s /etc/ssl/certs/ca-certificates.crt ]; then
  "${sudo_cmd[@]}" apt-get update -o APT::Update::Error-Mode=any
  "${sudo_cmd[@]}" apt-get install -y ca-certificates curl gnupg
fi
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
chmod 0700 "$temp"
curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location "$APT_URL/lasa-signing-key.asc" -o "$temp/key.asc"
# Reject additional keys as well as an unexpected primary fingerprint.
fingerprints=$(gpg --batch --homedir "$temp" --show-keys --with-colons "$temp/key.asc" | awk -F: '$1=="pub"{primary=1;next} primary && $1=="fpr"{print $10;primary=0}')
[[ $fingerprints == "$APT_FINGERPRINT" ]] || { echo 'Repository signing key does not match the installer fingerprint; nothing was trusted.' >&2; exit 1; }
gpg --batch --yes --homedir "$temp" --dearmor --output "$temp/lasa.gpg" "$temp/key.asc"
"${sudo_cmd[@]}" install -d -m 0755 /usr/share/keyrings
"${sudo_cmd[@]}" install -m 0644 "$temp/lasa.gpg" /usr/share/keyrings/lasa-archive-keyring.gpg
printf 'deb [arch=%s signed-by=/usr/share/keyrings/lasa-archive-keyring.gpg] %s stable main\n' "$arch" "$APT_URL" > "$temp/lasa.list"
"${sudo_cmd[@]}" install -m 0644 "$temp/lasa.list" /etc/apt/sources.list.d/lasa.list
"${sudo_cmd[@]}" apt-get update -o APT::Update::Error-Mode=any
"${sudo_cmd[@]}" apt-get install -y lasa
lasa version
echo 'LASA installed. Run lasa doctor, then lasa scan as your ordinary user.'
