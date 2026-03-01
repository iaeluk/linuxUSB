#!/usr/bin/env bash

echo "=== Instalador QEMU Direto no Pendrive (Modo UEFI) ==="
echo

# 1. Verificação do Firmware UEFI (OVMF)
OVMF_PATH="/usr/share/edk2/ovmf/OVMF_CODE.fd"
if [ ! -f "$OVMF_PATH" ]; then
    echo "⚠️ ERRO: Firmware UEFI (OVMF) não encontrado."
    echo "O arquivo esperado não está em: $OVMF_PATH"
    echo "Como resolver:"
    echo " - Fedora/Bluefin: rpm-ostree install edk2-ovmf"
    echo " - Ubuntu/Debian: sudo apt install ovmf"
    echo " - Arch Linux: sudo pacman -S edk2-ovmf"
    exit 1
fi
echo "[OK] Firmware UEFI encontrado."
echo

# 2. Busca os discos físicos disponíveis (ignorando loops/flatpaks com -e 7)
echo "Buscando pendrives/discos disponíveis..."
echo "    NOME        TAMANHO MODELO"

# Lê a saída do lsblk ignorando o cabeçalho e salva em um array
mapfile -t drives < <(lsblk -d -p -o NAME,SIZE,MODEL -e 7 | tail -n +2)

if [ ${#drives[@]} -eq 0 ]; then
    echo "Nenhum disco físico encontrado."
    exit 1
fi

# Exibe o menu numerado
for i in "${!drives[@]}"; do
    echo "[$i] ${drives[$i]}"
done

echo
read -p "Digite o número correspondente ao seu PENDRIVE: " choice

# Valida se a escolha é um número e se está no alcance do array
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#drives[@]}" ] || [ "$choice" -lt 0 ]; then
    echo "Opção inválida. Operação abortada."
    exit 1
fi

# Extrai o caminho do disco (primeira coluna)
TARGET_DRIVE=$(echo "${drives[$choice]}" | awk '{print $1}')

echo "=> Destino selecionado: $TARGET_DRIVE"
echo "⚠️  CUIDADO: Confirme que este NÃO é o seu SSD interno."
echo

# 3. Solicitar o caminho da ISO
read -p "Digite o caminho completo para a ISO (ex: /var/home/lucas/Downloads/bluefin.iso): " ISO_PATH

# Remove aspas se o usuário arrastar o arquivo para o terminal
ISO_PATH=$(echo "$ISO_PATH" | tr -d "'\"")

if [ ! -f "$ISO_PATH" ]; then
    echo "Erro: Arquivo ISO não encontrado em '$ISO_PATH'."
    exit 1
fi
echo "=> ISO confirmada."
echo

# 4. Monta e executa o comando QEMU com UEFI
CMD="sudo qemu-system-x86_64 -enable-kvm -m 4096 -bios $OVMF_PATH -cdrom \"$ISO_PATH\" -drive file=$TARGET_DRIVE,format=raw -boot d"

echo "Comando pronto para execução:"
echo "--------------------------------------------------------"
echo "$CMD"
echo "--------------------------------------------------------"
echo

read -p "ATENÇÃO: A VM vai abrir. Lembre-se de mandar o instalador apagar TUDO no pendrive. Prosseguir? (s/n): " CONFIRM

if [[ "$CONFIRM" =~ ^[Ss]$ ]]; then
    echo "Iniciando a máquina virtual..."
    eval $CMD
    
    echo "Aguardando a sincronização dos dados no pendrive (isso pode levar alguns segundos)..."
    sync
    echo "🎉 Operação finalizada com sucesso! O pendrive já pode ser ejetado."
else
    echo "Operação cancelada pelo usuário."
fi
