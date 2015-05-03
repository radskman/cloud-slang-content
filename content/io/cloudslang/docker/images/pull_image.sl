#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pulls a Docker image.
#
# Inputs:
#   - imageName - image name to be pulled
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine; Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete - Default: 30000000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - return_result - response of the operation
#   - error_message - error message
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.docker.images

operation:
  name: pull_image
  inputs:
    - imageName
    - host
    - port:
        default: "'22'"
        required: false
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - command:
        default: "'docker pull ' + imageName"
        overridable: false
    - arguments:
        required: false
    - characterSet:
        default: "'UTF-8'"
        required: false
    - pty:
        default: "'false'"
        required: false
    - timeout:
        default: "'30000000'"
        required: false
    - closeSession:
        default: "'false'"
        required: false
    - agentForwarding:
        required: false
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
      - return_result: returnResult
      - error_message: "'' if 'STDERR' not in locals() else STDERR if returnCode == '0' else returnResult"
  results:
      - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
      - FAILURE