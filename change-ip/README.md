# Scrappy Project: Change IP #

### Pre ###

* Install [Node](http://www.scala-sbt.org)
* Install [Python 3](https://www.python.org)
* `pip install huawei-modem-api-client`

### Start ###

* `mkdir output`
* `npm install` 
* `npm start`

```
$ npm start
Bound weblet to port 8080
```

Open http://localhost:8080

### Running in the background ###

`npm install forever -g`

Start:
```
  forever start -l weblet.log --append weblet.js
  tail -f  ~/.forever/weblet.log
```

Stop:
```
  forever list
  forever stop #process
```
