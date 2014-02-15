# Description:
#   Email from hubot to any address
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot email <user@email.com> -s <subject> -m <message> - Sends email with the <subject> <message> to address <user@email.com>
#
# Author:
#   ch.zju
#
# Additional Requirements
#   mail client installed on the system and smtp server is properly configed

util = require 'util'
child_process = require 'child_process'

module.exports = (robot) ->
  emailTime = null
  sendEmail = (recipients, subject, msg, from) ->
    mailArgs = ['-s', subject]
    mailArgs = mailArgs.concat recipients
    p = child_process.execFile 'mail', mailArgs, {}, (error, stdout, stderr) ->
      util.print 'stdout: ' + stdout if (stdout? and stdout.length!=0)
      util.print 'stderr: ' + stderr if (stderr? and stderr.length!=0)
    p.stdin.write "#{msg}\n"
    p.stdin.end()

  robot.respond /email (.*) -s (.*) -m (.*)/i, (msg) ->
    sendEmail msg.match[1].split(" "), msg.match[2], msg.match[3], msg.message.user.id
    msg.send "email sent to #{msg.match[1]}"
