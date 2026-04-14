#!/bin/bash

set -e

detect_package_manager() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
    debian | ubuntu | linuxmint | pop)
      echo "apt"
      ;;
    fedora | rhel | centos)
      echo "dnf"
      ;;
    arch | manjaro | endeavouros)
      echo "pacman"
      ;;
    opensuse | sles)
      echo "zypper"
      ;;
    *)
      echo "unknown"
      ;;
    esac
  else
    echo "unknown"
  fi
}

install_via_apt() {
  local packages=(zoxide zsh git fzf tmux fd-find ripgrep neovim)
  sudo apt update
  sudo apt install -y "${packages[@]}"
}

install_via_dnf() {
  local packages=(zoxide zsh git fzf tmux fd-find ripgrep neovim)
  sudo dnf install -y "${packages[@]}"
}

install_via_pacman() {
  local packages=(zoxide zsh git fzf tmux fd ripgrep neovim)
  sudo pacman -Sy --noconfirm "${packages[@]}"
}

install_via_zypper() {
  local packages=(zoxide zsh git fzf tmux fd ripgrep neovim)
  sudo zypper install -y "${packages[@]}"
}

install_oh_my_posh() {
  local version
  version=$(curl -s https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v')

  local arch
  arch=$(uname -m)
  case "$arch" in
  x86_64) arch="amd64" ;;
  aarch64) arch="arm64" ;;
  armv7l) arch="arm" ;;
  esac

  local tmpdir
  tmpdir=$(mktemp -d)
  curl -sL "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-${arch}" -o "${tmpdir}/oh-my-posh"

  mkdir -p "${HOME}/.local/bin"
  mv "${tmpdir}/oh-my-posh" "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/oh-my-posh"

  rm -rf "${tmpdir}"

  echo "oh-my-posh installed to ~/.local/bin/oh-my-posh"
  echo "Add ~/.local/bin to your PATH to use it"
}

install_packages() {
  local pm
  pm=$(detect_package_manager)

  echo "Detected package manager: $pm"

  case "$pm" in
  apt)
    install_via_apt
    ;;
  dnf)
    install_via_dnf
    ;;
  pacman)
    install_via_pacman
    ;;
  zypper)
    install_via_zypper
    ;;
  *)
    echo "Unsupported distribution. Please install packages manually."
    exit 1
    ;;
  esac
}

main() {
  echo "Installing user space programs..."

  echo "=== Installing packages ==="
  install_packages

  echo "=== Installing oh-my-posh ==="
  install_oh_my_posh

  echo "=== Done ==="
  echo "Programs installed: zoxide, zsh, git, fzf, tmux, fd, ripgrep, neovim, oh-my-posh"
  echo "Add ~/.local/bin to your PATH for oh-my-posh"
}

main "$@"
