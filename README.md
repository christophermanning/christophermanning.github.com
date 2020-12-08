christophermanning.github.io
============================

## Install
```
git clone git@github.com:christophermanning/christophermanning.github.io.git
vagrant up
```
http://0.0.0.0:4000/

## Deploy
Ensure ssh-agent has the host identity.
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

```
vagrant up
vagrant ssh
cd /vagrant
rake deploy
```
