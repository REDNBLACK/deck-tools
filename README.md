Steam Deck Tools
================
* * *
![GitHub Latest Release)](https://img.shields.io/github/v/release/REDNBLACK/deck-tools?logo=github&style=for-the-badge) |
![GitHub Release Date](https://img.shields.io/github/release-date/REDNBLACK/deck-tools?style=for-the-badge)
 | ![GitHub Commits Since Latest Release](https://img.shields.io/github/commits-since/REDNBLACK/deck-tools/latest?label=commits%20since&style=for-the-badge)

## Installation
1. Clone repository to `/home/deck/.config/DeckTools`, by executing in **Konsole**

    ```bash
    cd /home/deck/.config && git clone https://github.com/REDNBLACK/deck-tools.git DeckTools
    ```

2. Set sudo password, (if not already!!!), by executing in **Konsole**
    ```bash
    passwd
    ```

3. (Optional) Allow starting/stopping SSH File Transfer without `sudo`, by executing in **Konsole**
    ```bash
    echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl * sshd.service" | sudo tee /etc/sudoers.d/wheel > /dev/null
    ```

    After execution, `/etc/sudoers.d/wheel` file contents looks like this:

    ```
    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl * sshd.service
    ```

4. Add privelegies and run initialization, by executing in **Konsole**
    ```bash
    chmod +x /home/deck/.config/DeckTools/bin/gui && . $_
    ```
