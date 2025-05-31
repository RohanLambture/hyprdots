# Prerequisites

## Hyprland 

1. **AUR Helper:**

    ```bash
    pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si # builds with makepkg
    ```

2. **Audio Stack:**

    ```bash
    pacman -S pipewire wireplumber
    ```

3. **Nerd Fonts:**

    ```bash
    pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
    ```

4. **Display Manager:**

    ```bash
    pacman -S sddm
    systemctl enable sddm.service
    ```

5. **Terminal Emulator:**

    ```bash
    pacman -S kitty
    ```

# Waybar

```bash
pacman -S bluez-utils brightnessctl pipewire pipewire-pulse ttf-jetbrains-mono-nerd wireplumber
```

```bash
yay -S bluetui rofi-lbonn-wayland-git
```

```bash
sudo pacman -S wlsunset
```
