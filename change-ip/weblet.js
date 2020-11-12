var express = require('express')
var request = require('request')
var url = require('url')
var basicAuth = require('express-basic-auth');
var basicAuthParser = require('basic-auth-parser');

var app = express()
var config = require('./config.json')

const { exec } = require("child_process")

var counter = 0

/** send file back to client */
function sendFile(res, url) {
  var options = { root : __dirname, dotfiles: 'deny' }
  res.sendFile(url, options, function (err) {
    if (err) {
      console.log(err);
      res.status(err.status).end()
    }
  })
}

/** exec shell command */
function shell(cmd, callback) {
  console.log("executing: "+cmd)
  counter++
  exec(cmd, (error, stdout, stderr) => {
      if (error) {
          console.log(`error: ${error.message}`)
          callback(`error ${counter}\n${error.message}`)
          return
      }
      if (stderr) {
          console.log(`stderr: ${stderr}`)
          callback(`stderr ${counter}\n${stdout}`)
          return
      }
      console.log(`stdout: ${stdout}`)
      // callback(`ok ${counter}\n${stdout}`)
      callback(`${stdout}`)
  })
}

/** check if user supplied valid pin for the node or have one assigned (response on error) */
function validPin(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  var usr_pin = config.user_node[user]
  var req_pin = req.query.pin
  var pin = req_pin || usr_pin

  // user has pin assigned, it can only use assigned pin
  if (usr_pin != "*" && req_pin && req_pin != usr_pin) {
    console.log("PIN "+req_pin+" not valid for user '"+user+"'")
    res.status(401)
    res.send("Not valid PIN")
    return ""
  }

  // user may use all pins but did not specify which one
  if (usr_pin == "*" && req_pin == undefined) {
    console.log("PIN not specified for user '"+user+"'")
    res.status(401)
    res.send("No PIN specified")
    return ""
  }

  // console.log("Validated PIN "+pin+" for user '"+user+"'")
  return pin
}

/** auth users only */
app.use(basicAuth({
    challenge: true,
    users: config.user_pwd
}))

/** test if backend can execute commands */
app.use("/api/echo", function(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  shell("echo Seems to be working, "+user, (stdout) => {
    res.send(stdout)
  })
})

/** return current username */
app.use("/api/me", function(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  res.send(user)
})

/** logout (send 401) */
app.use("/api/logout", function(req, res) {
  res.status(401)
  res.send("ok")
})

/** /node?a=on&pin=123 -> forward -> /node-1?a=on&pin=123 */
app.use("/api/node", function(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  var pin = validPin(req, res)
  if (!pin) return

  // find node to forward to by pin
  var forward = ""
  config.nodes.forEach((node) => {
    if (node.pin == pin) forward = node.path
  })

  if (forward) {
    console.log("PIN "+pin+" forwarding to "+forward+" for user '"+user+"'")
    res.redirect(forward+url.parse(req.url, true).search)
  } else {
    console.log("PIN "+pin+" no forward for user '"+user+"'")
    res.status(401)
    res.send("No forward for PIN")
  }
})

/** /node-1?a=on */
config.nodes.forEach((node) => {
  console.log("Adding "+node.path)

  app.use(node.path, function(req, res) {
    var user = basicAuthParser(req.headers.authorization).username
    var pin = validPin(req, res)
    if (!pin) return

    var action = req.query.a

    // check if supplied pin matches node pin
    console.log("Incoming action '"+action+"' on "+node.path+" for user '"+user+"'")
    console.log("PIN "+pin+" ("+(pin == node.pin ? "valid" : "invalid")+")")

    if (pin == node.pin) {

      if (action == "ip") {
        var cmd = config.cmd_get_ip
          .replace("{ip}", node.ip)

        shell(cmd, (stdout) => {
          res.send(stdout)
        })
      } else if (action == "reboot" || action == "reconnect" || action == "status") {
        var cmd = config.cmd_device_control
          .replace("{action}", action)
          .replace("{device}", node.device)
          .replace("{gateway}", node.gateway)
          .replace("{ip}", node.ip)

        shell(cmd, (stdout) => {
          res.send(stdout)
        })
      } else if (action == "proxy") {
        var cmd = config.cmd_proxy_restart
          .replace("{pin}", node.pin)
          .replace("{port}", node.port)

        shell(cmd, (stdout) => {
          res.send(stdout)
        })
      } else {
        res.status(401)
        res.send("Invalid action")
      }

    } else {
      res.status(401)
      res.send("Invalid PIN")
    }
  })

})

/** bootstrap and jquery */
app.use("/node_modules/", function(req, res) {
  var url = req.url.substring(1)
  sendFile(res, 'node_modules/'+url)
})

/** public content */
app.use("/", function(req, res) {
  var url = req.url.substring(1)
  sendFile(res, 'public/'+url)
})

/** start server */
app.listen(config.port, function() {
  console.log('Bound weblet to port '+config.port)
})
