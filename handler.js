'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3({
  signatureVersion: 'v4',
});
const Sharp = require('sharp');

const BUCKET = process.env.BUCKET;
const URL = process.env.URL;
// http://YOUR_BUCKET_WEBSITE_HOSTNAME_HERE/300×300/blue_marble.jpg 

module.exports.resize = function (event, context, callback) {

  const key = event.queryStringParameters.key;
  const match = key.match(/(\d+)x(\d+)\/(.*)/);
  const width = parseInt(match[1], 10);
  const height = parseInt(match[2], 10);

  const originalKey = match[3];
  const newKey = '' + width + 'x' + height + '/' + originalKey;

  S3.getObject({ Bucket: BUCKET, Key: originalKey }).promise()
    .then(data => Sharp(data.Body)
      .resize(width, height)
      .toFormat('png')
      .toBuffer()
    )
    .then(buffer => S3.putObject({
      Body: buffer,
      Bucket: BUCKET,
      ContentType: 'image/png',
      Key: newKey,
    }).promise()
    )
    .then(() => callback(null, {
        statusCode: '301',
        headers: {'location': `${URL}/${newKey}`},
        body: '',
      })
    )
    .catch(err => callback(err))
}
