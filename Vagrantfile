Vagrant.configure("2") do |cfg|

# The Domain Controller

  cfg.vm.define "rootdomaincontroller" do |config|
    config.vm.box = "rgl/windows-server-2019-standard-amd64"
    config.vm.network "private_network", ip:  "10.10.10.3" 
    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true
    config.winrm.retry_limit = 30
    config.winrm.delay = 10


    config.vm.provider "virtualbox" do |v, override|
      v.name = "RootDC" 
      v.cpus = 2      
      v.memory = 2048 
      v.customize ["modifyvm", :id, "--vram",128] 

    end
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Setting Hostname"
    config.vm.provision "shell", path: "automation_scripts/Change-Hostname.ps1", privileged: true, args: "-password vagrant -user vagrant -hostname RootDC"
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Stopping Windows Updates ; stop-service wuauserv ; set-service wuauserv -startup disabled ; Write-Output Stooped_Updates"
    config.vm.provision "shell", inline: "Remove-WindowsFeature Windows-Defender"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Installing ad-domain-services ; install-windowsfeature -name 'ad-domain-services' -includemanagementtools"
    config.vm.provision "shell", path: "automation_scripts/Install-ADDSForest.ps1", privileged: true, args: " -localAdminpass passlagi -domainName nonocorp.local -domainNetbiosName nonocorp"
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", inline: "Start-Sleep -s 180"

    config.vm.provision "shell", path: "automation_scripts/disable-password-complexity.ps1", privileged: true

    config.vm.provision "shell", path: "automation_scripts/New-ADUser.ps1", privileged: true, args: "-user vmtien -Password Dautien1"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Adding to Domain Admins ;Add-ADGroupMember -Identity 'Domain Admins' -Members vmtien"
    
    config.vm.provision "shell", path: "automation_scripts/New-ADUser.ps1", privileged: true, args: "-user nvphu -Password Long123456"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Adding to Domain Admins ;Add-ADGroupMember -Identity 'Domain Admins' -Members nvphu"

    config.vm.provision "shell", path: "automation_scripts/New-ADUser.ps1", privileged: true, args: "-user tvhiep -Password Qq123456"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Adding to Domain Admins ;Add-ADGroupMember -Identity 'Domain Admins' -Members tvhiep"

    config.vm.provision "shell", path: "automation_scripts/New-ADUser.ps1", privileged: true, args: "-user ddltruong -Password Vungtaumx123"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Adding to Domain Admins ;Add-ADGroupMember -Identity 'Domain Admins' -Members ddltruong"

    config.vm.provision "shell", path: "automation_scripts/New-ADUser.ps1", privileged: true, args: "-user pvngo -Password Vungtaumx123bh"
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Adding to Domain Admins ;Add-ADGroupMember -Identity 'Domain Admins' -Members pvngo"

    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] RootDC Box Creation Over!"
  end

# The workstation 2
  cfg.vm.define "workstation2" do |config| 
    config.vm.box = "rgl/windows-10-1809-enterprise-amd64"
    config.vm.network "private_network", ip:  "10.10.10.102" 
    config.vm.boot_timeout = 18000
    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true
    config.winrm.retry_limit = 30
    config.winrm.delay = 10

    config.vm.provider "virtualbox" do |v, override|
      v.name = "WS02" 
      v.cpus = 2      
      v.memory = 1048 
      v.customize ["modifyvm", :id, "--vram",128] 
    end

    config.vm.provision "shell", path: "automation_scripts/Change-Hostname.ps1", privileged: true, args: "-password vagrant -user vagrant -hostname WS02"
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", inline: "foreach ($c in Get-NetAdapter) { write-host 'Setting DNS for' $c.interfaceName ; Set-DnsClientServerAddress -InterfaceIndex $c.interfaceindex -ServerAddresses ('10.10.10.3', '10.10.10.3') }" 
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green ; Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False" , privileged: true
    config.vm.provision "shell", path: "automation_scripts/join-domain.ps1", privileged: true, args: "-Password passlagi -user Administrator -domain nonocorp.local" 
    config.vm.provision "shell", reboot: true
    config.vm.provision "shell", path: "automation_scripts/Add-Aduser-to-localgroup.ps1", privileged: true, args: "-adduser nvphu -group_add Administrators -domain 'nonocorp.local'"
    config.vm.provision "shell", path: "automation_scripts/Add-LocalUser.ps1", privileged: true, args: "-adduser tqkhang -password anhmajyeuem -group_add Administrators"
    config.vm.provision "shell", path: "automation_scripts/choco-get-apps.ps1", privileged: true, args: "vlc python3" # choco Script with Addidional Argutmet
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] Workstation-02 Box Creation Over!"

  end
# The workstation 1
  cfg.vm.define "workstation1" do |config| 
      config.vm.box = "rgl/windows-10-1809-enterprise-amd64"
      config.vm.network "private_network", ip:  "10.10.10.101"  
      config.vm.boot_timeout = 1800
      config.winrm.transport = :plaintext
      config.winrm.basic_auth_only = true
      config.winrm.retry_limit = 30
      config.winrm.delay = 10

      config.vm.provider "virtualbox" do |v, override|
        v.name = "WS01" 
        v.cpus = 2       
        v.memory = 1048 
        v.customize ["modifyvm", :id, "--vram",128] 
      end

      config.vm.provision "shell", inline: "echo -----------sysprep-things-----------------"
      config.vm.provision "shell", inline: <<-EOS
      $windowsCurrentVersion = Get-ItemProperty 'HKLM:/SOFTWARE/Microsoft/Windows NT/CurrentVersion'
      Write-Output "Windows name: $($windowsCurrentVersion.ProductName) $($windowsCurrentVersion.ReleaseId)"
      Write-Output "Windows version: $($windowsCurrentVersion.CurrentMajorVersionNumber).$($windowsCurrentVersion.CurrentMinorVersionNumber).$($windowsCurrentVersion.CurrentBuildNumber).$($windowsCurrentVersion.UBR)"
      Write-Output "Windows BuildLabEx version: $($windowsCurrentVersion.BuildLabEx)"
      EOS
      config.vm.provision "shell", inline: "Write-Output \"%COMPUTERNAME% before sysprep: $env:COMPUTERNAME\""
      config.vm.provision "shell", inline: "Get-WmiObject win32_useraccount | Select domain,name,sid"
      config.vm.provision "windows-sysprep"
      config.vm.provision "shell", inline: "Write-Output \"%COMPUTERNAME% after sysprep: $env:COMPUTERNAME\""
      config.vm.provision "shell", inline: "Get-WmiObject win32_useraccount | Select domain,name,sid"
      config.vm.provision "shell", inline: "echo -------------------Sysprep-Ends----------------------"


      config.vm.provision "shell", path: "automation_scripts/Change-Hostname.ps1", privileged: true, args: "-password vagrant -user vagrant -hostname WS01"
      config.vm.provision "shell", reboot: true
      config.vm.provision "shell", inline: "foreach ($c in Get-NetAdapter) { write-host 'Setting DNS for' $c.interfaceName ; Set-DnsClientServerAddress -InterfaceIndex $c.interfaceindex -ServerAddresses ('10.10.10.3', '10.10.10.3') }"
      config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green Turn of Firewall ; Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False" , privileged: true
      config.vm.provision "shell", path: "automation_scripts/join-domain.ps1", privileged: true, args: "-Password passlagi -user Administrator -domain nonocorp.local" 
      config.vm.provision "shell", reboot: true
      config.vm.provision "shell", path: "automation_scripts/Add-LocalUser.ps1", privileged: true, args: "-adduser vmduc -password anhlaso1 -group_add Administrators"
      config.vm.provision "shell", reboot: true
      config.vm.provision "shell", path: "automation_scripts/Add-Aduser-to-localgroup.ps1", privileged: true, args: "-adduser nvphu -group_add Administrators -domain 'nonocorp.local'"
      config.vm.provision "shell", path: "automation_scripts/choco-get-apps.ps1", privileged: true, args: "netcat"
      config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] Workstation-01 Box Creation Over!"

    end

# The Web server 
  cfg.vm.define "WebServer" do |config| 
    config.vm.box = "chrislentz/trusty64-lamp"
    config.vm.network "private_network", ip:  "10.10.10.5" 
    config.vm.network "private_network", ip:  "172.16.0.10" 
    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true
    config.winrm.retry_limit = 30
    config.winrm.delay = 10

    config.vm.provider "virtualbox" do |v, override|
      v.name = "WEB01" 
      v.cpus = 2      
      v.memory = 1048 
      v.customize ["modifyvm", :id, "--vram",64] 
    end

    config.vm.provision "shell", inline: <<-SHELL
    echo "Changing the hostname"
    hostnamectl set-hostname WEB01
    echo "Adding user"
    useradd -m -c 'web Admin' -p longdaica dxlong -s /bin/bash
    usermod -aG sudo dxlong
    # apt install nmap -y > /dev/null
    SHELL
    config.vm.provision "shell", path: "automation_scripts/webserver.sh", privileged: true
    config.vm.provision "shell", inline: "echo [+] WebServer Box Creation Over!"
  end


# Running Final Commands

  cfg.vm.define "rootdomaincontroller" do |config| 
      config.vm.provision "shell", inline: "Write-Host -ForegroundColor Cyan [*] Final Commands [*]"
      config.vm.provision "shell", path: "automation_scripts/choco-get-apps.ps1", privileged: true
      config.vm.provision "shell", path: "automation_scripts/Final-touch.ps1", privileged: true
      config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] ROOTDC Box Cleaning OVER!!"
  end

  cfg.vm.define "workstation1" do |config| 
    
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Cyan [*] Final Commands [*]"
    config.vm.provision "shell", path: "automation_scripts/Final-touch.ps1", privileged: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] Workstation-01 Box Cleaning OVER!!"
  end

  cfg.vm.define "workstation2" do |config| 
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Cyan [*] Final Commands [*]"
    config.vm.provision "shell", path: "automation_scripts/Final-touch.ps1", privileged: true
    config.vm.provision "shell", inline: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f'
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] Workstation-02 Box Cleaning OVER!!"
    config.vm.provision "shell", path: "automation_scripts/ntlm_relay.ps1", privileged: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [+] NTLM Relay Box Cleaning OVER!!"
  end



# Mini CTF Section 

  cfg.vm.define "rootdomaincontroller" do |config| 
    config.vm.provision "shell", path: "CoolScripts/flag0.ps1", privileged: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [CTF] rootdomaincontroller Box Added!"
  end

  cfg.vm.define "workstation1" do |config| 
    config.vm.provision "shell", path: "CoolScripts/flag1.ps1", privileged: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [CTF] Workstation-01 Box Added!"
  end
  cfg.vm.define "workstation2" do |config| 
    config.vm.provision "shell", path: "CoolScripts/flag2.ps1", privileged: true
    config.vm.provision "shell", inline: "Write-Host -ForegroundColor Green [CTF] Workstation-02 Box Added!"
  end
  cfg.vm.define "WebServer" do |config| 
    config.vm.provision "shell", path: "CoolScripts/flag3.sh", privileged: true
    config.vm.provision "shell", inline: "echo [CTF] WebServer Box Added!"
  end

end
