const express = require('express')
var cors = require('cors')
const app = express()

let cors_origin = (process.env.FRONTEND_ADDRESS.substring(process.env.FRONTEND_ADDRESS.lastIndexOf(':')+1) == '80' ? process.env.FRONTEND_ADDRESS.substring(0, process.env.FRONTEND_ADDRESS.lastIndexOf(':')) : process.env.FRONTEND_ADDRESS)

app.options('*', cors({
  credentials: true,
  methods: '*',
  origin: cors_origin
}))

app.use(cors({
  allowedHeaders: '*',
  credentials: true,
  methods: '*',
  origin: cors_origin
}))

app.get('/', function (req, res) {
  res.send('Hello World')
})

app.get('/someData', function (req, res) {
	res.send('i send you back some data')
})

app.listen(3000)