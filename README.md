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
