## gitmonitor service

A Linux ```systemd``` service to monitor for changes in git repositories accessible via the file system and run commands whenever the repository has changed.  Developed and tested on Ubuntu Zesty 17.04 only.



Files

- /usr/lib/systemd/system/gitmonitor.service
- ~/bin/gitmonitor   
- /etc/gitmonitor.conf



To install:

1. copy files to respective locations
2. edit configuration file to point to the repository ```repo.git``` directories where the  repository information is stored on the fit server.  Specify name of branch to monitor.  Create command to be run when code is pushed into the branch.
3. run ```sudo systemctl daemon-reload``` to allow system to find new service
4. run ```sudo systemctl start gitmonitor``` to start the service.