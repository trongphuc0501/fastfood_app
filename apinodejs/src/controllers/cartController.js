Cart = require('../models/cartModels');

exports.index = (req, res) => {
    Cart.get((err, cart) => {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            });
        }

        res.json(cart)
    })
}

//create fucntion view products
exports.new = function(req, res) {
    // Kiểm tra và xác thực dữ liệu đầu vào
    if (!req.body.price || !req.body.name_user || !req.body.quantity || !req.body.name_product) {
        return res.status(400).json({
            status: 'error',
            code: 400,
            message: 'Dữ liệu đầu vào không hợp lệ.'
        });
    }

    // Nếu không có sản phẩm nào trùng tên, tiến hành tạo sản phẩm mới
    let cart = new Cart({
        name_user: req.body.name_user,
        quantity: req.body.quantity,
        price: req.body.price,
        name_product: req.body.name_product,
        note:req.body.note
    });

    // Lưu giỏ hàng vào cơ sở dữ liệu
    cart.save(function(err) {
        if (err) {
            // Xử lý lỗi khi lưu giỏ hàng mới
            return res.status(500).json({
                status: 'error',
                code: 500,
                message: err
            });
        }

        // Trả về thông báo thành công nếu không có lỗi
        res.status(200).json({
            status: 'success',
            code: 200,
            message: 'Đã thêm vào giỏ hàng.',
            data: cart
        });
    });
};

exports.view = function(req, res) {
    Cart.findById(req.params.id, function(err, cart) {
        if (err) {
            // Xử lý lỗi
            return res.status(500).json({
                status: 'error',
                code: 500,
                message: 'Lỗi không xác định.'
            });
        }
        if (!cart) {
            // Không tìm thấy giỏ hàng
            return res.status(404).json({
                status: 'error',
                code: 404,
                message: 'Không tìm thấy giỏ hàng.'
            });
        }
        // Trả về dữ liệu giỏ hàng nếu tìm thấy
        res.json({
            status: 'success',
            code: 200,
            message: 'Giỏ hàng được tìm thấy.',
            data: cart
        });
    });
}
exports.delete = function(req, res) {
    const id = req.params._id;
    const nameUser = req.params.name_user;
    Cart.deleteOne({
        _id: id,
        name_user: nameUser
    }, function(err) {
        if (err)
            res.status(500).json({
                status: 'error',
                code: 500,
                message: err
            });
        else
            res.status(200).json({
                status: 'success',
                code: 200,
                message: 'Sản phẩm đã được xóa123'
            });
    });
};

exports.update = function(req, res) {
    const id = req.params._id;
    const nameUser = req.params.name_user;

    Cart.findOne({_id: id, name_user: nameUser }, function(err, updatedProduct) {
        if (err) {
            return res.status(500).json({
                status: 'error1',
                code: 500,
                message: err
            });
        }
        if (!updatedProduct) {
            return res.status(404).json({
                status: 'error',
                code: 404,
                message: 'Không tìm thấy sản phẩm trong giỏ hàng'
            });
        }

        // Cập nhật số lượng sản phẩm
        updatedProduct.quantity = req.body.quantity;

        // Lưu sản phẩm đã cập nhật vào cơ sở dữ liệu
        updatedProduct.save(function(err, updatedProduct) {
            if (err) {
                return res.status(500).json({
                    status: 'error2',
                    code: 500,
                    message: err
                });
            }
            res.status(200).json({
                status: 'success',
                code: 200,
                message: 'Số lượng sản phẩm trong giỏ hàng đã được cập nhật',
                data: updatedProduct
            });
        });
    });
};





