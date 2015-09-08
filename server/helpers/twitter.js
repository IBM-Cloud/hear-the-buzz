/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
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

var request = require('request');

function Twitter(url, username, password) {
  var self = this;
  
  self.count = function (query, callback) {
    request.get(
      'https://' + url + "/api/v1/messages/count?q=" + encodeURIComponent(query), {
        'auth': {
          'user': username,
          'password': password
        }
      },
      function (error, response, body) {
        callback(error, body);
      });
  };

  self.search = function (query, size, callback) {
    request.get(
      'https://' + url + "/api/v1/messages/search?size=" + size +
      "&q=" + encodeURIComponent(query), {
        'auth': {
          'user': username,
          'password': password
        }
      },
      function (error, response, body) {
        callback(error, body);
      });
  }
}

module.exports = function (url, username, password) {
  return new Twitter(url, username, password);
}
