const mongoose = require('mongoose')

mongoose.connect('mongodb+srv://dtphuc2k2:Phuc1990@@cluster0.ug8nifz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0/api', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true
}).then(db => console.log('kết nối thành công'))