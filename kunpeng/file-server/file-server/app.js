const express = require('express');
const multer = require('multer');
const app = express();
const path = require('path');
const { v4 } = require('uuid');

app.use(express.static(path.join(__dirname,'./file')));

app.all('*', function (req, res, next) {
	res.header("Access-Control-Allow-Origin", "*");
	res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
	res.header('Access-Control-Allow-Headers', ["Content-Type", "Upgrade", "Origin", "Connection", "Accept-Encoding", "Accept-Language", "Host", "x-requested-with"]);
	next();
});

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './file/');
    },
    filename: function(req, file, cb) {
        cb(null, `${v4()}.${file.originalname.split('.')[1]}`);
    }
});

const upload = multer({storage});

app.post('/api/upload', upload.array('file', 5), (req, res) => {
    // console.log(req);
    res.send(req.files);    
})


app.listen(process.env.FILE_SERVER_PORT, () => {
    console.log('server running!');
})
