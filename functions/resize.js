const stream = require('stream')
const AWS = require('aws-sdk')
const S3 = new AWS.S3({
  signatureVersion: 'v4'
})
const sharp = require('sharp')
const BUCKET = process.env.BUCKET
const URL = `http://${process.env.BUCKET}.s3-website.us-east-1.amazonaws.com`

// create the write stream abstraction for uploading data to S3
const writeStreamToS3 = ({ Bucket, Key }) => {
  const pass = new stream.PassThrough()
  return {
    writeStream: pass,
    uploadFinished: S3.upload({
      Body: pass,
      Bucket,
      ContentType: 'image/png',
      Key
    }).promise()
  }
}

exports.handler = async (event) => {
  const key = event.queryStringParameters.key
  const match = key.match(/(\d+)x(\d+)\/(.*)/)
  const width = parseInt(match[1], 10)
  const height = parseInt(match[2], 10)
  const originalKey = match[3]
  const newKey = '' + width + 'x' + height + '/' + originalKey

  try {
    // location of the resized image
    const resizedImageLocation = `${URL}/${newKey}`

    // sharp resize stream
    const resize = sharp()
      .resize(width, height)
      .toFormat('png')

    // create the read and write streams from and to S3
    const readStream = S3.getObject({ Bucket: BUCKET, Key: originalKey }).createReadStream()
    const { writeStream, uploadFinished } = writeStreamToS3({ Bucket: BUCKET, Key: newKey })

    // trigger the stream
    readStream
      .pipe(resize)
      .pipe(writeStream)

    // wait for the stream to finish
    const uploadedData = await uploadFinished
    console.log({
      ...uploadedData,
      BucketEndpoint: URL,
      ImageURL: resizedImageLocation
    }) // log data to Dashbird

    // return a 301 redirect to the newly created resource in S3
    return {
      statusCode: '301',
      headers: { 'location': resizedImageLocation },
      body: ''
    }
  } catch (err) {
    console.error(err)
    return {
      statusCode: '500',
      body: err.message
    }
  }
}
