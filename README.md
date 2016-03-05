# Beautiful and scannable provisioning output with Vagrant Provisioning Shell Function Helper

Simply include the `exe ()` function from `provision.sh` to enjoy beautiful and scannable output from your Vagrant
bash shell provisioning script.

## The problem

Vagrant treats provisioning script output to `stdout` as **good**, shown in green. Ouput to `stderr` is treated as
**bad**, shown in red. It a useful convention to help us see where a provisioning script may be failing.

However, many commands follow the convention of outputting informational messages to stderr. By convention, any output
the user would not expect to be piped to another command is sent to `stderr`. Not all commands follow this convention,
but enough do. The result is that some of your vagrant provisioning commands output red lines when they have not failed.

This script function aims to address that issue, making your provisioning script very easy to scan for errors.

Here is the default output from executing commands directly, no actual errors. Seen here, the OpenSSL command and PHP's
composer command both output status messages to `stderr` when there is no failure:
[![Default output from executing commands directly, no actual errors][1]][1]

## The solution

The `exe ()` function contained in `provisioning.sh` aims to solve the issue by suppressing the output of a provisioning
shell script command unless a command returns a non zero exit status. In the case that a command returns an error code,
the captured output of the command is output to `stderr`, showing red in vagrant.

The function adds a number of visual improvements to output during provisioning, including a description of the command
executed and a progress indicator for longer running commands.

The effect for a fully working provisioning script shows green:
[![Example output using exe function, with no errors][2]][2]

Output with a failing command. Clearly visible red lines amongst the green:
[![Example output using exe function, with error][3]][3]

## Usage

    exe '[Command Description]' \
        [command] [paramters]

For example, to run `apt-get update`:

    exe "Update apt indexes"
        sudo apt-get update

The function accepts more complex commands:

    exe 'Create self-signed certificate' \
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out \
        /etc/apache2/ssl/apache.crt -subj \
        '/C=GB/ST=Location/L=Location/O=Company/OU=IT Department/CN=example.tld'

If you find an edge case that does not work with the function, please feel free to submit a pull request with a fix.

# Compatibility

Tested with bash, may be POSIX compliant but remains untested. Pull requests welcome to fix any issues.

[1]: http://i.stack.imgur.com/F3I6X.png
[2]: http://i.stack.imgur.com/uyBrl.png
[3]: http://i.stack.imgur.com/66Ed0.png
