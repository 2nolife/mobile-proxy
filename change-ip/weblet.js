var express = require('express')
var request = require('request')
var url = require('url')
var basicAuth = require('express-basic-auth');
var basicAuthParser = require('basic-auth-parser');
var fs = require('fs');

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
          fs.writeFile("output/last.txt", `error ${counter}\n${error.message}`, function (err) {})
          callback(`error ${counter}\n${error.message}`)
          return
      }
      if (stderr) {
          console.log(`stderr: ${stderr}`)
          fs.writeFile("output/last.txt", `stderr ${counter}\n${stdout}`, function (err) {})
          callback(`stderr ${counter}\n${stdout}`)
          return
      }
      console.log(`stdout: ${stdout}`)
      fs.writeFile("output/last.txt", `ok ${counter}\n${stdout}`, function (err) {})
      callback(`ok ${counter}\n${stdout}`)
  })
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

/** test if backend can execute commands */
app.use("/api/last", function(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  fs.readFile("output/last.txt", function (err,data) {
    res.send(data)
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

/** /modem?a=on */
app.use("/api/modem", function(req, res) {
  var user = basicAuthParser(req.headers.authorization).username
  var action = req.query.a
  var modem = config.modem

  console.log("Incoming action '"+action+"' on "+modem.gateway+" for user '"+user+"'")

  if (action == "ip") {
    var cmd = config.cmd_get_ip
      .replace("{ip}", modem.ip)

    shell(cmd, (stdout) => {
      res.send(stdout)
    })
  } else if (action == "reboot" || action == "reconnect" || action == "status") {
    var cmd = config.cmd_modem_control
      .replace("{action}", action)
      .replace("{device}", modem.device)
      .replace("{gateway}", modem.gateway)
      .replace("{ip}", modem.ip)

    shell(cmd, (stdout) => {
      res.send(stdout)
    })
  } else {
    res.status(401)
    res.send("Invalid action")
  }
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
