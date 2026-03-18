# Meu Setup Nix-Darwin & Home Manager para macOS 🍏❄️

Este repositório contém de forma declarativa e reprodutível todas as configurações do meu ambiente macOS, gerenciamento de pacotes via [Nix](https://nixos.org/), ajustes do sistema operacional via [nix-darwin](https://github.com/LnL7/nix-darwin) e configurações de usuário usando [Home Manager](https://github.com/nix-community/home-manager).

---

## 🚀 Instalação em Uma Linha (Mac Novo)

Para configurar todo o ambiente em uma máquina recém-instalada do zero, basta rodar o seguinte comando em seu terminal de preferência:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/caiofsr/config-nix-macos/main/install.sh)"
```

### O que o script acima faz?
1. Instala o gerenciador de pacotes **Nix** (com suporte nativo a Flakes) pedindo sua senha raiz (`sudo`).
2. Clona este repositório para o diretório canônico padrão do sistema: `/private/etc/nix-darwin`.
3. Executa o build de sua configuração e instala tudo o que está listado nos arquivos de infraestrutura (Zsh, CLI Tools, Homebrew Casks/Apps, NeoVim, etc.).

---

## 🛠️ Arquitetura e O Que Está Configurado

* **`flake.nix`**: O ponto de entrada (entrypoint). Define os *inputs* (as versões do nixpkgs e dependências) e define a máquina alvo (`MacBook-Air-de-Caio`).
* **`configuration.nix`**: Configurações relativas à **máquina e sistema operacional**:
  * Touch ID no `sudo` ativado no terminal nativamente!
  * Preferências de sistema do macOS configuradas via código (Dock automático, Finder, trackpad, velocidade do teclado).
  * Gerenciamento de software via **Homebrew** (Casks como Zed, VSCode, Slack, Whatsapp, Ghostty, Docker). O Brew é acoplado dentro do ambiente do Nix!
* **`home.nix`**: Configuração do **Usuário** (Dotfiles, CLI):
  * Pacotes de uso diário (Neovim, git, NodeJS, Bun, asdf, fd, fzf, ripgrep, AWS CLI).
  * ZSH customizado usando `oh-my-posh` e `zoxide`.
  * Configuração básica e global do `git` a seu nome e e-mail.

---

## 🔄 Dia-a-Dia (Atualizando e Gerenciando)

Para não precisar lembrar os comandos gigantes do Nix-Darwin, existem **aliases** de ZSH já configurados para sua conta em `home.nix`:

### Atualizar todo o sistema localmente (após fazer edições os módulos)
```bash
nix-rebuild
```

### Atualizar o arquivo lock das dependências (puxar versões mais recentes) e rebuildar
```bash
nix-update
```

### Limpar arquivos e versões antigas (liberar espaço em disco limpo pelo Nix)
```bash
nix-cleanup
```

---

## 💡 Informações Locais e Dicas

- Lembre-se que **você não deve** gerenciar manualmente o Homebrew. Adicione os pacotes desejados em `configuration.nix` nas listas de `brews` e `casks`, depois rode `nix-rebuild`.
- Se quiser pacotes apenas para a linha de comando do usuário que funcionam entre distribuições (independente do macOS), adicione-os na sessão `home.packages` do arquivo `home.nix`.
