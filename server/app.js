/**
 * Copyright 2014, 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

var
  express = require('express'),
  app = express(),
  cfenv = require('cfenv'),
  errorhandler = require('errorhandler'),
  bluemix      = require('./config/bluemix'),
  watson       = require('watson-developer-cloud'),
  extend       = require('util')._extend;

// load local VCAP configuration
var vcapLocal = null
try {
  vcapLocal = require("./vcap-local.json");
  console.log("Loaded local VCAP", vcapLocal);
} catch (e) {
}

var credentials = extend({
  url: 'https://stream.watsonplatform.net/text-to-speech/api',
  version: 'v1',
  username: '<username>',
  password: '<password>',
}, bluemix.getServiceCreds('text_to_speech'));

// Create the service wrappers
var textToSpeech = watson.text_to_speech(credentials);


// get the app environment from Cloud Foundry, defaulting to local VCAP
var appEnvOpts = vcapLocal ? {
  vcap: vcapLocal
} : {}
var appEnv = cfenv.getAppEnv(appEnvOpts);

var twitterCreds = appEnv.getServiceCreds("hear-the-buzz-twitter-insights");
var twitter = require('./helpers/twitter.js')(
  twitterCreds.host,
  twitterCreds.username,
  twitterCreds.password);

app.get("/api/1/messages/count", function (req, res) {
  console.log("Counting with", req.query.q);
  twitter.count(req.query.q, function (error, body) {
    if (error) {
      res.sendStatus(500);
    }
    res.send(body);
  });
});

app.get("/api/1/messages/search", function (req, res) {
  console.log("Searching with", req.query.q);
  twitter.search(req.query.q, 20, function (error, body) {
    if (error) {
      res.sendStatus(500);
    }
    res.send(body);
  });
});

app.get('/synthesize', function(req, res) {
  var transcript = textToSpeech.synthesize(req.query);
  transcript.on('response', function(response) {
    if (req.query.download) {
      response.headers['content-disposition'] = 'attachment; filename=transcript.flac';
    }
  });
  transcript.on('error', function(error) {
    console.log('Synthesize error: ', error)
  });
  transcript.pipe(res);
});

// serve the files out of ./public as our main files
app.use(express.static(__dirname + '/public'));

// start server on the specified port and binding host
app.listen(appEnv.port, "0.0.0.0", function () {
  // print a message when the server starts listening
  console.log("server starting on " + appEnv.url);
});
