//
// Bot Service で自動生成されたデプロイスクリプト（少し改変済み）
//

var zipFolder = require('zip-folder');
var path = require('path');
var fs = require('fs');
var request = require('request');

const { AZURE_PROJECT_NAME, AZURE_PROJECT_PASSWORD } = require('./env');
if (!(AZURE_PROJECT_NAME && AZURE_PROJECT_PASSWORD)) {
  console.error("[Error] environment variables 'AZURE_PROJECT_NAME' and 'AZURE_PROJECT_PASSWORD' are required.");
  return;
}

var rootFolder = path.resolve('.');
var zipPath = path.resolve(rootFolder, `../${AZURE_PROJECT_NAME}.zip`);
var kuduApi = `https://${AZURE_PROJECT_NAME}.scm.azurewebsites.net/api/zip/site/wwwroot`;
var userName = `$${AZURE_PROJECT_NAME}`;
var password = AZURE_PROJECT_PASSWORD;


function uploadZip(callback) {
  fs.createReadStream(zipPath).pipe(request.put(kuduApi, {
    auth: {
      username: userName,
      password: password,
      sendImmediately: true
    },
    headers: {
      "Content-Type": "applicaton/zip"
    }
  }))
  .on('response', function(resp){
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      fs.unlink(zipPath);
      callback(null);
    } else if (resp.statusCode >= 400) {
      callback(resp);
    }
  })
  .on('error', function(err) {
    callback(err)
  });
}

function publish(callback) {
  zipFolder(rootFolder, zipPath, function(err) {
    if (!err) {
      uploadZip(callback);
    } else {
      callback(err);
    }
  })
}

publish(function(err) {
  if (!err) {
    console.log(`${AZURE_PROJECT_NAME} successfully published`);
  } else {
    console.error(`failed to publish ${AZURE_PROJECT_NAME}`, err);
  }
});
