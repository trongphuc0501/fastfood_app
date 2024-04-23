let mongoose = require('mongoose')

let cartSchema = mongoose.Schema({
    name_user: String,
    quantity: Number,
    price: Number,
    name_product: String
});


let Cart = module.exports = mongoose.model('cart', cartSchema);

//cada vez que hagamos una peticion get se ejecuta esto
module.exports.get = function(callback, limit) {
    Cart.find(callback).limit(limit);
}