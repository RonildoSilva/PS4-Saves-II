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
  echo "Títulos marcados com ⚠️ estão em zip dividido em volumes de 90 MB, porque o"
  echo "GitHub rejeita arquivos acima de 100 MB. Para restaurar, junte os volumes antes:"
  echo
  echo '```bash'
  echo "zip -s 0 CUSA09209.zip --out completo.zip   # junta .z01, .z02... + .zip"
  echo "unzip completo.zip -d CUSA09209"
  echo '```'
  echo
  echo "| | Título | CUSA | Slots | Tamanho |"
  echo "|---|---|---|---:|---:|"
  for d in PS4/SAVEDATA/$ACCT/*/; do
    cusa=$(basename "$d")
    nome=$(nome_de "$cusa"); [ -z "$nome" ] && nome="(desconhecido)"
    slots=$(find "$d" -maxdepth 1 -type f -not -name '*.bin' | wc -l)
    mb=$(find "$d" -maxdepth 1 -type f -printf '%s\n' | awk '{s+=$1} END{printf "%.1f", s/1048576}')
    ic=$(icone_de "$cusa")
    if [ -n "$ic" ]; then img="<img src=\"$ic\" width=\"60\">"; else img=""; fi
    case "$cusa" in *_ZIP) nome="$nome ⚠️ zip dividido"; cusa=$(cusa_de "$cusa");; esac
    echo "| $img | $nome | \`$cusa\` | $slots | ${mb} MB |"
  done
  echo
  echo '<sub>Gerado por `tools/build_index.sh` — não edite esta tabela à mão.</sub>'
} > README.md

echo "ok: $total titulos -> README.md + index.json"
