This NCPA plugin is made to monitor changes on SSH keys and/or associated fingerprints of a host. It's important especially when you have SFTP servers to monitor these changes to be proactive and inform your collaborators and partners that they have to accept a new key or fingerpint for their automatic jobs for example and inform them also that the change is approved and safe.


### Setup

To install this script, you just have to execute the install.sh file with admin rights. It will setup the script and all necessaries actions needed to get the plugin working.
Please keep in mind the NCPA agent is needed of course (see here for installation: https://www.nagios.org/ncpa/#downloads).

> If you want to adapt the script to your own monitoring solution or to a cron job (very easy), I will not explain it but it's totally possible. This plugin is published with a public license (as all other plugins and scripts here), so feel free to fork or use it in your own scripts or programs!

### Usage

Create a command and an associated service in Nagios like this example:

```text
# Command
define command {
    command_name check_ssh-keys
    command_line $USER1$/check_ncpa.py -H $HOSTADDRESS$ -t 'your_token' -M 'plugins/check_ssh-keys.sh'
}
```

```text
define service {
    use                     generic-service
    hostname                your-server ;(or hostgroup_name          servers-group for a group of servers !)
    service_description     SSH keys status
    check_command           check_ssh-keys
    contacts                mailadmin
    max_check_attempts      3
    check_interval          5
    retry_interval          1
    notification_interval   0
}
```
As always, check your nagios configuration:

```shell
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```
Then restart Nagios service and that's all!

### What to do if a change happend?

If there is a ssh key and/or a fingerprint detected, the status will go to WARNING in Nagios and it will not go again to OK status until you have validated the change manually! Why? Because otherwise, it's a non-sense. If the script inform there is a change, you HAVE to see it. Without manual control, there would be no way to return to an OK state unless the script overwrites the status itself, which is of course completely illogical.

But relax, it's simple. You have the choice. Log on to the relevant server and run the following command from the directory where the script is located:

```shell
sudo -u nagios ./check_ssh_keys.sh --update
```

This command will update the state file with the current situation and the status will go back to OK on your Nagios console.

You can also do it in the web interface of the NCPA agent. Just go to https://your-server-fqdn:5693/ and login with your token. Go to the API tab select in the API Endpoint on the left "Plugins" and the plugin "check-ssh_keys.sh".

In the "Plugin Arguments" field, just type : --update and click reload. This will update the status file and the status will go back to OK also.

Again, you are free to adapt the script if you want to avoid this and for example set a time condition to automatically regenerate base state file if you want to have to all the process in a full automatic way. I do not personally recommend it.
