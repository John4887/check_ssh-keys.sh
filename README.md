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
