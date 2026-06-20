  # NM Auto Reconnect

  Script para Fedora Linux que reconecta automaticamente a internet quando a conexão cai sem que o cabo
  físico seja desligado — situação em que o NetworkManager normalmente não age sozinho.

  ## O problema

  No Fedora (e outras distros com NetworkManager), quando a internet cai por falha no roteador ou
  provedor mas o cabo ethernet continua plugado, o sistema não percebe que perdeu acesso à rede e não
  tenta reconectar. O usuário precisa desligar e ligar manualmente a conexão pelo painel do GNOME.

  ## Como funciona

  O NetworkManager possui um sistema de *connectivity check* que testa o acesso real à internet a cada 5
  minutos (no Fedora, verifica `fedoraproject.org`). Este script usa o mecanismo de *dispatcher* do
  NetworkManager: sempre que o status de conectividade muda, o script é chamado automaticamente.

  Quando detecta conectividade `none` ou `limited`, ele:
  1. Aguarda 5 segundos (evita falso positivo)
  2. Verifica o status novamente
  3. Se ainda sem internet, desconecta e reconecta a interface ethernet

  ## Instalação

  **1. Crie o script:**

  ```bash
  sudo nano /etc/NetworkManager/dispatcher.d/99-auto-reconnect.sh
  ```

  Cole o conteúdo do arquivo `99-auto-reconnect.sh` deste repositório.

  Salve com **Ctrl+O → Enter → Ctrl+X**.

  **2. Dê permissão de execução:**

  ```bash
  sudo chmod +x /etc/NetworkManager/dispatcher.d/99-auto-reconnect.sh
  ```

  **3. Verifique a sintaxe:**

  ```bash
  bash -n /etc/NetworkManager/dispatcher.d/99-auto-reconnect.sh && echo "OK"
  ```

  Pronto. Nenhum serviço precisa ser reiniciado — o NetworkManager já carrega os scripts do dispatcher
  automaticamente.

  ## Configuração

  
  ```bash
  nmcli device disconnect enp5s0          # substitua enp5s0 pela sua interface
  nmcli connection up "Conexão cabeada 1" # substitua pelo nome da sua conexão
  ```
  
  Para descobrir os valores corretos no seu sistema:
  
  ```bash
  nmcli device status       # lista interfaces (coluna DEVICE)
  nmcli connection show     # lista conexões (coluna NAME)
  ```
  
  ## Monitoramento

  Para ver quando o script agiu:
  
  ```bash
  journalctl -t nm-auto-reconnect
  ```

  Para acompanhar em tempo real:
  
  ```bash
  journalctl -t nm-auto-reconnect -f
  ```

  ## Desinstalação

  ```bash
  sudo rm /etc/NetworkManager/dispatcher.d/99-auto-reconnect.sh
  ```
  
  ## Compatibilidade
  
  Testado no **Fedora 44** com NetworkManager. Deve funcionar em qualquer distro que use NetworkManager
  com connectivity check habilitado (Ubuntu, Debian, Arch, etc.), ajustando o nome da interface e da
  conexão.
  
  ## Requisitos
  
  - NetworkManager com connectivity check ativo
  - `nmcli` disponível (incluído no pacote `NetworkManager`)

  ---
