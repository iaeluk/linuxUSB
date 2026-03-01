# 🚀 QEMU USB Direct Installer

Uma ferramenta de linha de comando (CLI) simples e poderosa escrita em Bash para instalar sistemas operacionais Linux **completos e com persistência** diretamente em um pendrive, sem precisar reiniciar o computador ou usar dois pendrives diferentes.

Perfeito para criar instalações portáteis de distribuições atômicas/imutáveis (como **Project Bluefin**, **Fedora Silverblue**, **Vanilla OS**) ou qualquer outra distro que você queira levar no bolso.

## 💡 O Problema que Resolvemos
Normalmente, para ter uma instalação Linux *real* (não um Live USB com overlay, mas um sistema com `/home`, `/var` e persistência nativa) em um pendrive, você precisa:
1. Gravar a ISO no Pendrive A.
2. Reiniciar o PC e dar boot pelo Pendrive A.
3. Conectar o Pendrive B.
4. Fazer a instalação apontando para o Pendrive B.

**O QEMU USB Direct Installer elimina tudo isso.** Ele usa o motor de virtualização nativo do Linux (KVM/QEMU) para rodar a ISO e mapear o seu pendrive físico (`/dev/sdX`) como um disco rígido virtual *raw*. Você faz a instalação inteira rodando em uma janela no seu sistema atual. Quando termina, o pendrive está pronto para dar boot em qualquer máquina.

## ✨ Features
* 🛡️ **Proteção contra Acidentes:** Lista os discos físicos de forma clara, ignorando partições de loop (Flatpaks/Snaps), para evitar que você formate seu SSD por engano.
* 🖥️ **Suporte a UEFI Nativo:** Injeta o firmware OVMF no QEMU, garantindo que o instalador crie a partição `/boot/efi` correta. O pendrive funcionará em placas-mãe modernas.
* ⚡ **Zero Complicação:** Sem dependências pesadas, sem interfaces gráficas quebradas. Apenas Bash puro e ferramentas nativas do sistema.

## 🛠️ Pré-requisitos

Para que o script funcione, você precisa ter o **QEMU** e o **Firmware UEFI virtual (OVMF)** instalados no seu sistema hospedeiro.

**Fedora / Bluefin / Sistemas baseados em rpm-ostree:**
```bash
rpm-ostree install qemu edk2-ovmf
# Reinicie o sistema após a instalação
```

**Ubuntu / Debian / Linux Mint:**
```bash
sudo apt update
sudo apt install qemu-system-x86 ovmf
```

**Arch Linux / Manjaro:**
```bash
sudo pacman -S qemu-desktop edk2-ovmf
```

## 🚀 Como usar

1. Clone este repositório ou baixe o script `qemu_installer.sh`.
2. Dê permissão de execução:
   ```bash
   chmod +x qemu_installer.sh
   ```
3. Execute o script no terminal:
   ```bash
   ./qemu_installer.sh
   ```
4. O script pedirá para você selecionar o número do pendrive de destino.
5. Arraste a sua imagem `.iso` para o terminal ou digite o caminho completo dela.
6. A janela da Máquina Virtual abrirá. Siga o processo de instalação normal do sistema operacional escolhendo o pendrive (que aparecerá como um HD virtual) e mandando "Excluir tudo/Apagar disco".
7. Quando a instalação terminar, desligue a Máquina Virtual. O pendrive está pronto!

## ⚠️ Avisos Importantes

* **Use um bom hardware:** Rodar um sistema operacional completo via USB exige muita leitura e escrita. Evite pendrives simples de plástico. Para uma experiência fluida, use um **SSD NVMe em um case USB** ou um pendrive de alta performance.
* **Cuidado com o Destino:** Preste muita atenção na hora de escolher o número do disco no terminal. O script não se responsabiliza por formatações acidentais no seu disco principal.

## 🤝 Contribuição
Sinta-se à vontade para abrir *Issues* ou enviar *Pull Requests*. Toda ajuda para melhorar a detecção de discos ou a compatibilidade com distros diferentes é bem-vinda!

## 📄 Licença
Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.
