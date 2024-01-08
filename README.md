Steam Deck Tools
================
* * *

## Last Update
2024-01-08

## Installation
1. Copy dir to `/home/deck/.config/DeckTools`

2. Set sudo password, if not already, by executing in **Konsole**
    ```bash
    passwd
    ```

3. Allow starting/stopping SSH File Transfer without `sudo`, by executing in **Konsole**
    ```bash
    echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl * sshd.service" | sudo tee /etc/sudoers.d/wheel > /dev/null
    ```

    After execution, `/etc/sudoers.d/wheel` file contents looks like this:

    ```
    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL) NOPASSWD: /usr/bin/systemctl * sshd.service
    ```
