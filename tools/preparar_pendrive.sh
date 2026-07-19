#!/usr/bin/env bash
# Monta no pendrive a estrutura que o PS4 espera, a partir dos dois repositorios.
# Uso: preparar_pendrive.sh /media/usuario/PENDRIVE [caminho-repo-I] [caminho-repo-II]
#
# O que faz:
#  - junta os dois repos numa unica arvore PS4/SAVEDATA/<conta>/
#  - remonta os arquivos divididos (.partNN) e confere o SHA256SUMS
#  - ignora README, assets, tools, index.json e .git (nao vao pro console)
#
# Sem os caminhos, assume que este script esta em tools/ dentro de um dos
# repositorios e procura o outro como pasta irma.
set -euo pipefail

DEST="${1:?uso: preparar_pendrive.sh <ponto-de-montagem> [repo-I] [repo-II]}"

AQUI=$(cd "$(dirname "$0")" && pwd)
RAIZ=$(dirname "$AQUI")          # tools/ -> raiz do repositorio
VIZINHA=$(dirname "$RAIZ")

if [ $# -ge 3 ]; then
  R1="$2"; R2="$3"
else
  R1="$RAIZ"
  case "$(basename "$RAIZ")" in
    *-I)  R2="$VIZINHA/$(basename "$RAIZ" | sed 's/-I$/-II/')" ;;
    *-II) R2="$VIZINHA/$(basename "$RAIZ" | sed 's/-II$/-I/')" ;;
    *)    R2="" ;;
  esac
fi

[ -d "${R1:-}/PS4" ] || { echo "nao achei PS4/ em '$R1'. Passe os caminhos: preparar_pendrive.sh <destino> <repo-I> <repo-II>" >&2; exit 1; }
if [ -z "${R2:-}" ] || [ ! -d "$R2/PS4" ]; then
  echo "AVISO: o segundo repositorio nao foi encontrado em '${R2:-<nao definido>}'."
  echo "       Serao copiados apenas os titulos de $(basename "$R1")."
  echo "       Para o acervo completo, clone os dois e passe os caminhos."
  R2=""
fi

[ -d "$DEST" ] || { echo "destino nao existe: $DEST" >&2; exit 1; }

fs=$(df -T "$DEST" | awk 'NR==2{print $2}')
livre=$(df -B1 "$DEST" | awk 'NR==2{print $4}')
preciso=0
for r in "$R1" ${R2:+"$R2"}; do
  preciso=$((preciso + $(du -sb --exclude=.git "$r/PS4" 2>/dev/null | cut -f1)))
done

echo "destino: $DEST  (sistema de arquivos: $fs)"
awk -v l=$livre -v p=$preciso 'BEGIN{printf "espaco: %.2f GB livres, %.2f GB necessarios\n", l/1073741824, p/1073741824}'

case "$fs" in
  exfat|fuseblk) ;;
  vfat|msdos) echo "AVISO: FAT32 nao aceita arquivos acima de 4 GB. Aqui todos sao menores, entao funciona." ;;
  *) echo "AVISO: o PS4 so le pendrive em exFAT ou FAT32. '$fs' provavelmente nao sera reconhecido." ;;
esac
[ "$livre" -lt "$preciso" ] && { echo "ERRO: espaco insuficiente no pendrive." >&2; exit 1; }

for r in "$R1" ${R2:+"$R2"}; do
  acct=$(ls "$r/PS4/SAVEDATA" | head -1)
  mkdir -p "$DEST/PS4/SAVEDATA/$acct"
  for t in "$r/PS4/SAVEDATA/$acct"/*/; do
    nome=$(basename "$t")
    alvo="$DEST/PS4/SAVEDATA/$acct/$nome"
    echo "  copiando $nome..."
    cp -r "$t" "$DEST/PS4/SAVEDATA/$acct/"
    if [ -f "$alvo/SHA256SUMS" ]; then
      echo "    remontando arquivos divididos..."
      ( cd "$alvo"
        for f in $(ls *.part00 2>/dev/null | sed 's/\.part00$//'); do
          cat "$f".part* > "$f" && rm "$f".part*
        done
        if LC_ALL=C sha256sum -c SHA256SUMS >/dev/null 2>&1; then
          echo "    integridade conferida"
        else
          echo "    !! ERRO: checksum nao confere em $nome" >&2
          exit 1
        fi
        rm -f SHA256SUMS )
    fi
  done
done

sync
acct=$(ls "$DEST/PS4/SAVEDATA" | head -1)
echo
echo "concluido: $(ls "$DEST/PS4/SAVEDATA/$acct" | wc -l) titulos em $DEST/PS4"
echo
echo "No console: Configuracoes -> Gerenciamento de dados salvos do aplicativo"
echo "         -> Dados salvos no armazenamento USB -> Copiar para o armazenamento do sistema"
echo
echo "Lembre-se: os saves sao da conta $acct. Em outra conta exigem re-assinatura."
