#!/usr/bin/env bash
#
# Script de Instalação Automatizada - Nix e Nix-Darwin
#
# Uso recomendado:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/caiofsr/config-nix-macos/main/install.sh)"
#

set -e

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  Iniciando a instalação do Nix, Flakes e Nix-Darwin  ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

# 1. Instalar o Nix (com suporte nativo a Flakes)
if ! command -v nix &> /dev/null; then
    echo -e "${BLUE}Nix não encontrado. O instalador solicitará sua senha (sudo)...${NC}"
    # Utilizando o instalador da Determinate Systems que já configura Flakes e otimizações
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    
    # Carregar as variáveis de ambiente do Nix na sessão atual
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo -e "${GREEN}✓ Nix já está instalado!${NC}"
fi

# 2. Preparar e clonar o repositório em /private/etc/nix-darwin
REPO_URL="https://github.com/caiofsr/config-nix-macos.git"
TARGET_DIR="/private/etc/nix-darwin"

echo ""
echo -e "${BLUE}Configurando o diretório $TARGET_DIR...${NC}"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${BLUE}Criando diretório e clonando as configurações...${NC}"
    sudo mkdir -p "$TARGET_DIR"
    sudo chown -R $(whoami) "$TARGET_DIR"
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo -e "${GREEN}✓ O diretório $TARGET_DIR já existe.${NC}"
    echo -e "${BLUE}Atualizando o repositório...${NC}"
    sudo chown -R $(whoami) "$TARGET_DIR"
    cd "$TARGET_DIR"
    git pull origin main || git pull origin master || true
fi

# Verificar dependências extras necessárias antes do switch, embora o nix cuide da maioria
# Homebrew já é instalado e ativado via nix-darwin, mas alguns setups precisam que ele exista antes se houver problema de binário. O nix-darwin deve cobrir, conforme seu configuration.nix.

# 3. Executar o nix-darwin switch com flakes
echo ""
echo -e "${BLUE}Aplicando o setup do nix-darwin e home-manager...${NC}"
cd "$TARGET_DIR"

# É prudente atualizar o lock do flake caso seja necessário
# nix flake update

# Executa o switch apontando para o host definido no arquivo flake.nix
# "MacBook-Air-de-Caio" é o nome da configuração exportada em seu flake.nix
nix run nix-darwin -- switch --flake .#MacBook-Air-de-Caio

echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}✓ Instalação concluída com sucesso!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""
echo -e "${BLUE}⚠️  Importante:${NC}"
echo -e "1. Você deve ${GREEN}reiniciar o terminal${NC} para carregar o novo shell (ZSH) e caminhos."
echo -e "2. Talvez o macOS solicite permissões para apps recém-instalados."
echo -e "3. Para atualizar futuramente, use o alias: ${GREEN}nix-update${NC} (conforme no home.nix)."
