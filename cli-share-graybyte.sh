#!/usr/bin/env sh
set -u
set -e
# ────────────────────────────────────────────────────────────
# Graybyt3 - Ex-Blackhat | Ex Super Mod of Team_CC.
# Now securing systems as a Senior Security Expert.
# I hack servers for fun, patch them to torture you.
# "My life is a lie, and i'm living in this only truth.- Graybyt3"
# WARNING: This code is for educational and ethical purposes only.
# I am not responsible for any misuse or illegal activities.
# WARNING: Steal my code, and I'll call you Pappu — there's no worse shame in this world than being called Pappu.
# #FuCk_Pappu
#
# ────────────────────────────────────────────────────────────
# MODIFY THE CONFIG HERE ;
# ────────────────────────────────────────────────────────────
server_url_default="https://rstream.io"
server_url="${SERVER_URL-${server_url_default}}"
# PUT HERE REMOTE URL OF THIS SCRIPT- SO WHILE DOWNLOAD YOU CAN GET THE SAME FEEDBACK AND INFORMATION OUTPUT TOO
script_url_default="https://example.com/share.sh"
script_url="${SCRIPT_URL-${script_url_default}}"

if [ -t 1 ]; then
  R="\033[1;31m"
  G="\033[1;32m"
  Y="\033[1;33m"
  B="\033[1;34m"
  C="\033[1;36m"
  M="\033[1;35m"
  W="\033[1;37m"
  D="\033[2m"
  RST="\033[0m"
  UL="\033[4m"
else
  R="" G="" Y="" B="" C="" M="" W="" D="" RST="" UL=""
fi
abort() {
  printf -- "${R}❌ error: %s${RST}\n" "$*" >&2
  exit 1
}
print_banner() {
  printf -- "\n"
  printf -- "\n"
  printf -- "\n"
  printf -- "${R}  ██████╗ ██████╗  █████╗ ██╗   ██╗██████╗ ██╗   ██╗████████╗███████╗${RST}\n"
  printf -- "${R} ██╔════╝ ██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝${RST}\n"
  printf -- "${R} ██║  ███╗██████╔╝███████║ ╚████╔╝ ██████╔╝ ╚████╔╝    ██║   █████╗  ${RST}\n"
  printf -- "${R} ██║   ██║██╔══██╗██╔══██║  ╚██╔╝  ██╔══██╗  ╚██╔╝     ██║   ██╔══╝  ${RST}\n"
  printf -- "${R} ╚██████╔╝██║  ██║██║  ██║   ██║   ██████╔╝   ██║      ██║   ███████╗${RST}\n"
  printf -- "${R}  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝    ╚═╝      ╚═╝   ╚══════╝${RST}\n"
  printf -- "\n"
  printf -- "\n"
  printf -- "${G}══════════════════════ 𝗚𝗥𝗔𝗬𝗕𝗬𝗧𝗘 𝗖𝗟𝗜-𝗦𝗛𝗔𝗥𝗘 𝗦𝗧𝗔𝗥𝗧𝗘𝗗 ══════════════════════${RST}\n"
  printf -- "\n"
  printf -- "\n"
}

print_footer() {
  printf -- "\n"
  printf -- "${G}══════════════════════════════ 𝗚𝗥𝗔𝗬𝗕𝗬𝗧𝗘 𝗖𝗟𝗜-𝗦𝗛𝗔𝗥𝗘 𝗘𝗡𝗗𝗘𝗗 ══════════════════════════════${RST}\n"
  printf -- "\n"
}
info() { printf -- "${Y}%s\n" "$*"; }
success() { printf -- "${G}%s${RST}\n" "$*"; }
warn() { printf -- "${Y}⚠️ warning: %s${RST}\n" "$*"; }
trace() { printf -- "${W}· %s${RST}\n" "$*"; }
execute() {
  trace "$@"
  if ! "$@"; then
    abort "command $* returned an error"
  fi
}
if ! command -v curl >/dev/null 2>&1; then abort "curl is required"; fi
if ! command -v openssl >/dev/null 2>&1; then abort "openssl is required"; fi
if ! command -v tar >/dev/null 2>&1; then abort "tar is required"; fi
if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
  abort "sha256sum or shasum is required"
fi
if ! command -v xxd >/dev/null 2>&1 && ! command -v hexdump >/dev/null 2>&1; then
  abort "xxd or hexdump is required"
fi
file_size() {
  if stat -f "%s" "$1" >/dev/null 2>&1; then
    file_size=$(stat -f "%s" "$1")
  elif stat -f "%z" "$1" >/dev/null 2>&1; then
    file_size=$(stat -f "%z" "$1")
  elif stat -c "%s" "$1" >/dev/null 2>&1; then
    file_size=$(stat -c "%s" "$1")
  else
    abort "unsupported stat version"
  fi
  printf -- "%s" "${file_size}"
}
hex_encode() {
  if command -v xxd >/dev/null 2>&1; then
    xxd -p -c 256
  else
    hexdump -v -e '/1 "%02x"'
  fi
}
checksum() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$@" | awk '{ print $1 }'
  else
    shasum -a 256 "$@" | awk '{ print $1 }'
  fi
}
header_value() {
  awk -v name="$1" '
    {
      line = $0
      sub(/\r$/, "", line)
      prefix = substr(line, 1, length(name) + 1)
      if (tolower(prefix) == tolower(name ":")) {
        sub(/^[^:]*:[[:space:]]*/, "", line)
        value = line
      }
    }
    END { print value }
  ' "$2"
}
encrypt_archive() {
  {
    printf -- "%s\n" "${iv_base64}" | openssl base64 -d
    {
      openssl dgst -sha256 -binary "${archive}"
      cat "${archive}"
    } | openssl enc -aes-256-ctr -K "${encryption_key_hex}" -iv "${iv_hex}"
  } >"${encrypted}"
}
upload_challenge() {
  epoch_hex="$1"
  checksum_hex="$2"
  nonce=0
  while :; do
    nonce_hex=$(printf -- "%016x" "${nonce}")
    digest_hex=$(printf -- "%s" "${epoch_hex}${checksum_hex}${nonce_hex}" | checksum)
    case "${digest_hex}" in
      00*)
        printf -- "%s%s%s" "${epoch_hex}" "${nonce_hex}" "${digest_hex}"
        return
        ;;
    esac
    nonce=$((nonce + 1))
  done
}
unique_filename() {
  name="$1"
  base="${name%%.*}"
  ext="${name#"$base"}"
  i=1
  while [ -e "${base}_${i}${ext}" ]; do
    i=$((i + 1))
  done
  printf -- "%s_%d%s" "${base}" "${i}" "${ext}"
}
copy_to_clipboard() {
  text="$1"
  if command -v wl-copy >/dev/null 2>&1; then
    printf -- "%s" "${text}" | wl-copy >/dev/null 2>&1 && return 0
  fi
  if command -v xclip >/dev/null 2>&1; then
    printf -- "%s" "${text}" | xclip -selection clipboard >/dev/null 2>&1 && return 0
  fi
  if command -v pbcopy >/dev/null 2>&1; then
    printf -- "%s" "${text}" | pbcopy >/dev/null 2>&1 && return 0
  fi
  return 1
}
append_history() {
  hist_file="${HOME}/.file-sharing-history"
  {
    printf -- "%s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
    printf -- "FILE: %s\n" "$1"
    printf -- "ID: %s\n" "$2"
    printf -- "URL: %s\n" "$3"
    printf -- "----------------\n"
  } >>"${hist_file}"
}
if [ -n "${ID-}" ] && [ -n "${KEY-}" ]; then
  (
    print_banner
    if ! temporary_directory=$(mktemp -d); then
      abort "cannot create temporary directory"
    fi
    trap 'rm -rf "${temporary_directory}"' EXIT
    encrypted="${temporary_directory}/encrypted"
    decrypted="${temporary_directory}/decrypted"
    headers="${temporary_directory}/headers"
    file_id="${ID}"
    encryption_key_base64="${KEY}"
    encryption_key_hex=$(echo "${encryption_key_base64}" | openssl base64 -d | hex_encode)
    if [ "${#encryption_key_hex}" -ne 64 ]; then
      abort "invalid encryption key"
    fi
    checksum_encryption_key_hex=$(printf -- "%s" "${encryption_key_hex}" | checksum)
    epoch_time=$(($(date +%s) * 1000))
    epoch_time_hex=$(printf -- "%016x" "${epoch_time}")
    challenge_hex="${epoch_time_hex}$(printf -- "%s" "${epoch_time_hex}${checksum_encryption_key_hex}" | checksum)"
    url="${server_url}/api/tools/file-sharing/${file_id}/download?challenge=${challenge_hex}"
    info "⬇️ DOWNLOADING FILE WITH ID '${file_id}'"
    printf -- "\n"
    if command -v pv >/dev/null 2>&1; then
      if ! curl --fail -s -S -L -D "${headers}" "${url}" | pv -f -p -t -e -r -b -N "Download" > "${encrypted}"; then
        abort "download failed"
      fi
    else
      if ! curl --fail -S -L -D "${headers}" --progress-bar -o "${encrypted}" "${url}"; then
        abort "download failed"
      fi
    fi
    encrypted_size=$(file_size "${encrypted}")
    if [ "${encrypted_size}" -lt 49 ]; then
      abort "downloaded file is too small"
    fi
    content_disposition=$(header_value "Content-Disposition" "${headers}")
    filename=$(printf -- "%s" "${content_disposition}" | sed -nE 's/.*filename="?([^\";]+)"?.*/\1/p')
    filename=$(printf -- "%s" "${filename}" | sed 's|\\|/|g')
    filename=${filename##*/}
    iv_hex=$(dd if="${encrypted}" bs=1 count=16 2>/dev/null | hex_encode)
    printf -- "\n"
    info "🔓 DECRYPTING FILE PLEASE WAIT............."
    if ! tail -c +17 "${encrypted}" | openssl enc -d -aes-256-ctr -K "${encryption_key_hex}" -iv "${iv_hex}" -out "${decrypted}"; then
      abort "failed to decrypt file"
    fi
    checksum_archive_hex=$(dd if="${decrypted}" bs=1 count=32 2>/dev/null | hex_encode)
    case "${filename}" in
      ""|"."|"..") archive_name="archive.tar.gz" ;;
      *) archive_name="${filename}" ;;
    esac
    if [ -e "${archive_name}" ]; then
      archive_name=$(unique_filename "${archive_name}")
    fi
    if ! tail -c +33 "${decrypted}" >"${archive_name}"; then
      abort "failed to write decrypted archive"
    fi
    computed_checksum=$(checksum "${archive_name}")
    if [ "${computed_checksum}" != "${checksum_archive_hex}" ]; then
      abort "checksum mismatch, file may be corrupted"
    fi
    success "✅ FILE DOWNLOADED AND VERIFIED SUCCESSFULLY (ARCHIVE SIZE: $(file_size "${archive_name}") bytes)"
    if [ "${AUTO_EXTRACT-}" = "1" ]; then
      info "📦 EXTRACTING ARCHIVE PLEASE WAIT............."
      if tar -xzf "${archive_name}"; then
        success "✅ EXTRACTION COMPLETED"
      else
        warn "Extraction failed – archive left intact"
      fi
    fi
    print_footer
    exit 0
  ) || exit 1
else
  (
    print_banner
    if [ $# -lt 1 ]; then
      printf -- "${C}📂 ENTER FILE/FOLDER PATH: ${RST}"
      read -r input_path
      input_path=$(printf -- "%s" "${input_path}" | sed "s/^['\"]//;s/['\"]$//")
      if [ -z "${input_path}" ]; then
        abort "no path provided"
      fi
    else
      input_path="$1"
    fi
    case "${input_path}" in
      /*) target_path="${input_path}" ;;
      *) target_path="$(pwd)/${input_path}" ;;
    esac
    if [ ! -e "${target_path}" ]; then
      abort "file or directory '${target_path}' does not exist"
    fi
    printf -- "${Y}📂 SELECTED FILE: ${G}${target_path}${RST}\n"
    encryption_key_base64=${KEY-}
    if [ -z "${encryption_key_base64}" ]; then
      encryption_key_base64=$(openssl rand -base64 32)
    fi
    iv_base64=${IV-}
    if [ -z "${iv_base64}" ]; then
      iv_base64=$(openssl rand -base64 16)
    fi
    encryption_key_hex=$(echo "${encryption_key_base64}" | openssl base64 -d | hex_encode)
    iv_hex=$(echo "${iv_base64}" | openssl base64 -d | hex_encode)
    if [ "${#iv_hex}" -ne 32 ]; then
      abort "invalid initialization vector"
    fi
    checksum_encryption_key_hex=$(printf -- "%s" "${encryption_key_hex}" | checksum)
    if ! temporary_directory=$(mktemp -d); then
      abort "cannot create temporary directory"
    fi
    trap 'rm -rf "${temporary_directory}"' EXIT
    archive="${temporary_directory}/archive"
    encrypted="${temporary_directory}/encrypted"
    response_headers="${temporary_directory}/response-headers"
    printf -- "${C}📦 COMPRESSING PLEASE WAIT.............${RST}\n"
    target_dir=$(dirname "${target_path}")
    target_base=$(basename "${target_path}")
    execute tar -czf "${archive}" -C "${target_dir}" "${target_base}"
    archive_size=$(file_size "${archive}")
    if [ "${archive_size}" -gt 1073741776 ]; then
      abort "compressed file size is larger than 1 GB"
    fi
    epoch_time=$(($(date +%s) * 1000))
    epoch_time_hex=$(printf -- "%016x" "${epoch_time}")
    upload_challenge_hex=$(upload_challenge "${epoch_time_hex}" "${checksum_encryption_key_hex}")
printf -- "${M}🔐 ENCRYPTING PLEASE WAIT.............${RST}\n"

if command -v pv >/dev/null 2>&1; then
  {
    printf -- "%s\n" "${iv_base64}" | openssl base64 -d
    {
      openssl dgst -sha256 -binary "${archive}"
      cat "${archive}"
    } | pv -f -p -t -e -r -b -N "🔐 Encrypt" | \
      openssl enc -aes-256-ctr \
        -K "${encryption_key_hex}" \
        -iv "${iv_hex}"
  } > "${encrypted}"
else
  execute encrypt_archive
fi

encrypted_size=$(file_size "${encrypted}")

if [ "${encrypted_size}" -gt 1073741824 ]; then
  abort "encrypted file size is larger than 1 GB"
fi

printf -- "\n"
printf -- "${B}☁️ UPLOADING PLEASE WAIT.............${RST}\n"
printf -- "\n"
url="${server_url}/api/tools/file-sharing?size=${encrypted_size}&checksum=${checksum_encryption_key_hex}&filetype=tar.gz&challenge=${upload_challenge_hex}"

if ! curl --fail -s -S -D "${response_headers}" -o /dev/null -X PUT "${url}"; then
  abort "failed to create file sharing request"
fi

file_id=$(header_value "X-File-ID" "${response_headers}")

case "${file_id}" in
  ""|*[!A-Za-z0-9_-]*)
    abort "invalid X-File-ID header"
    ;;
esac

signed_url=$(header_value "Location" "${response_headers}")

case "${signed_url}" in
  http://*|https://*)
    ;;
  *)
    abort "invalid Location header"
    ;;
esac

if command -v pv >/dev/null 2>&1; then
  if ! pv -f -p -t -e -r -b -N "☁️ Upload" "${encrypted}" | \
       curl --fail -s -S \
         -H "Content-Type: application/octet-stream" \
         -X PUT \
         --data-binary @- \
         "${signed_url}" >/dev/null; then
    abort "upload failed"
  fi
else
  if ! curl \
        --progress-bar \
        --upload-file "${encrypted}" \
        --fail \
        -H "Content-Type: application/octet-stream" \
        -X PUT \
        "${signed_url}" >/dev/null; then
    abort "upload failed"
  fi
fi

download_url="${server_url}/tools/file-sharing/${file_id}#${encryption_key_base64}"

auto_extract_delete_cmd=$(printf \
'ID="%s" KEY="%s" /usr/bin/env sh -c "$(curl -k -fsSL '\''%s'\'')" && tar -xzf archive.tar.gz && rm -f archive.tar.gz' \
"${file_id}" \
"${encryption_key_base64}" \
"${script_url}")

printf -- "\n"

success "✅ UPLOAD COMPLETE"

if copy_to_clipboard "${auto_extract_delete_cmd}"; then
  success "📋 AUTO DOWNLOAD + EXTRACT + DELETE COMMAND COPIED TO CLIPBOARD"
fi

append_history "${target_path}" "${file_id}" "${download_url}"

success "📜 HISTORY SAVED → ${HOME}/.file-sharing-history"

printf -- "\n"

printf -- "${Y}🔗 BROWSER BASED DOWNLOAD URL :${RST}\n"
printf -- "${G}%s${RST}\n" "${download_url}"

printf -- "\n"

printf -- "${Y}🚀 AUTOMATED DOWNLOAD + EXTRACTION :${RST}\n"
printf -- "\n"

printf -- "${G}ID=\"%s\" KEY=\"%s\" /usr/bin/env sh -c \"\$(curl -fsSL '%s')\" && tar -xzf archive.tar.gz${RST}\n" \
  "${file_id}" \
  "${encryption_key_base64}" \
  "${script_url}"

printf -- "\n"

printf -- "${Y}📥 AUTOMATED DOWNLOAD + EXTRACTION + DELETE ARCHIVE :${RST}\n"
printf -- "\n"

printf -- "${G}%s${RST}\n" "${auto_extract_delete_cmd}"

print_footer

exit 0
  ) || exit 1
fi
