# Scrappy Project: Change IP #

### Pre ###

Create `output` folder for files to be stored.

### Start ###

* Install [Node](http://www.scala-sbt.org)
* From the project's `weblet` directory do `npm install` and then `npm start`

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
