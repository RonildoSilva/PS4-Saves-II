#!/usr/bin/env bash
# Regenera README.md e index.json a partir do conteudo real de PS4/SAVEDATA.
# Rode a partir da raiz do repositorio:  bash tools/build_index.sh
set -euo pipefail
cd "$(dirname "$0")/.."

REPO=$(basename "$PWD")
TITLES=tools/titles.tsv
ACCT=$(ls PS4/SAVEDATA | head -1)
[ -f "$TITLES" ] || { echo "faltando $TITLES" >&2; exit 1; }

cusa_de() { echo "${1%%_*}"; }   # CUSA09209_ZIP -> CUSA09209
nome_de() { grep -P "^$(cusa_de "$1")\t" "$TITLES" | cut -f2 | head -1; }
# capas vem em .webp (orbispatches) ou .jpg (CDN da Sony)
icone_de() { local k=$(cusa_de "$1"); for e in webp jpg; do [ -f "assets/icons/$k.$e" ] && { echo "assets/icons/$k.$e"; return; }; done; }

# ---------- index.json ----------
{
  echo '{'
  echo "  \"repositorio\": \"$REPO\","
  echo "  \"conta\": \"$ACCT\","
  echo '  "titulos": ['
  first=1
  for d in PS4/SAVEDATA/$ACCT/*/; do
    cusa=$(basename "$d")
    nome=$(nome_de "$cusa"); [ -z "$nome" ] && nome="(desconhecido)"
    slots=$(find "$d" -maxdepth 1 -type f -not -name '*.bin' | wc -l)
    bytes=$(find "$d" -maxdepth 1 -type f -printf '%s\n' | awk '{s+=$1} END{print s+0}')
    icone=$(icone_de "$cusa")
    [ $first -eq 0 ] && echo ','
    first=0
    printf '    {"cusa": "%s", "nome": %s, "slots": %s, "bytes": %s, "icone": "%s"}' \
      "$cusa" "$(printf '%s' "$nome" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
      "$slots" "$bytes" "$icone"
  done
  echo; echo '  ]'
  echo '}'
} > index.json

# ---------- README.md ----------
total=$(ls -d PS4/SAVEDATA/$ACCT/*/ | wc -l)
peso=$(du -sh --exclude=.git PS4 | cut -f1)
{
  echo "# $REPO"
  echo
  echo "Saves de PlayStation 4 — **$total títulos**, $peso."
  echo
  echo "Estrutura no padrão do console: \`PS4/SAVEDATA/$ACCT/<CUSA>/\`."
  echo "Para restaurar, copie a pasta \`PS4\` para a raiz de um pendrive formatado em exFAT"
  echo "e use *Configurações → Gerenciamento de dados salvos → Armazenamento USB*."
  echo
  echo "> Os saves são vinculados à conta \`$ACCT\`. Em outra conta exigem"
  echo "> re-assinatura (Save Wizard, Apollo ou similar)."
  echo
  echo "Títulos marcados com ⚠️ têm arquivos divididos em partes de 90 MB, porque o"
  echo "GitHub rejeita arquivos acima de 100 MB. Para restaurar, junte as partes:"
  echo
  echo '```bash'
  echo "cd PS4/SAVEDATA/$ACCT/<CUSA>"
  echo 'for f in $(ls *.part00 | sed "s/\.part00$//"); do'
  echo '  cat "$f".part* > "$f" && rm "$f".part*'
  echo 'done'
  echo 'sha256sum -c SHA256SUMS   # confere a integridade'
  echo '```'
  echo
  echo "| | Título | CUSA | Slots | Tamanho |"
  echo "|---|---|---|---:|---:|"
  for d in PS4/SAVEDATA/$ACCT/*/; do
    cusa=$(basename "$d")
    nome=$(nome_de "$cusa"); [ -z "$nome" ] && nome="(desconhecido)"
    slots=$(find "$d" -maxdepth 1 -type f -not -name '*.bin' -not -name '*.part[0-9][0-9]' -not -name 'SHA256SUMS' | wc -l)
    # partes divididas contam como 1 slot cada arquivo original
    slots=$((slots + $(find "$d" -maxdepth 1 -name '*.part00' | wc -l)))
    mb=$(find "$d" -maxdepth 1 -type f -printf '%s\n' | awk '{s+=$1} END{printf "%.1f", s/1048576}')
    ic=$(icone_de "$cusa")
    if [ -n "$ic" ]; then img="<img src=\"$ic\" width=\"60\">"; else img=""; fi
    [ -f "$d/SHA256SUMS" ] && nome="$nome ⚠️ arquivos divididos"
    echo "| $img | $nome | \`$cusa\` | $slots | ${mb} MB |"
  done
  echo
  echo '<sub>Gerado por `tools/build_index.sh` — não edite esta tabela à mão.</sub>'
} > README.md

echo "ok: $total titulos -> README.md + index.json"
