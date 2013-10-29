vagrant-bamboo
=============

Instant provisioning of [Atlassian's Bamboo (version 5.2)][1] with the help of [Vagrant][2] & [Puppet][3] 

What will it do?
----------------

1. Download Ubuntu 12.04
1. Create a new virtual machine, install Ubuntu and forward port 8085
1. Inside the virtual machine 
  1. Download & Install [Java][6]
  1. Download & Install & Start [Bamboo][1]
 
Do it!
------

1. Install [VirtualBox][4] and [Vagrant][2] and make sure you have [git][5] available.
1. Open your favorite terminal (mine is [iTerm2][7]) and clone the github repository 

```
git clone --recursive https://github.com/tstangenberg/vagrant-bamboo.git
cd vagrant-bamboo
```

1. Start up and provision automatically all dependencies in the vm

```
vagrant up --provision
```

1. *** You're almost DONE! *** --> open the [bamboo setup page][8] (http://localhost:8085) & configure it



[1]: https://www.atlassian.com/software/bamboo/overview
[2]: http://www.vagrantup.com/
[3]: http://puppetlabs.com/
[4]: https://www.virtualbox.org 
[5]: http://git-scm.com
[6]: http://openjdk.java.net/
[7]: http://www.iterm2.com
[8]: http://localhost:8085