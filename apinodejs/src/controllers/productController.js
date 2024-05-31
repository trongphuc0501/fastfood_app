Product = require('../models/ProductsModels');

exports.index = (req, res) => {
    Product.get((err, product) => {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            });
        }

        res.json(product)
    })
}

//create fucntion view products
exports.new = function(req, res) {
    // Kiểm tra xem có sản phẩm nào đã có cùng tên chưa
    Product.findOne({ name: req.body.name }, function(err, existingProduct) {
        if (err) {
            return res.status(500).json({
                status: 'error',
                code: 500,
                message: err
            });
        }

        if (existingProduct) {
            return res.status(409).json({
                status: 'error',
                code: 409,
                message: 'Tên sản phẩm đã tồn tại'
            });
        }

        // Nếu không có sản phẩm nào trùng tên, tiến hành tạo sản phẩm mới
        let product = new Product();
        product.name = req.body.name;
        product.price = req.body.price;
        product.stock = req.body.stock;
        product.img = req.body.img;
        product.type = req.body.type;

        product.save(function(err) {
            if (err) {
                return res.status(500).json({
                    status: 'error',
                    code: 500,
                    message: err
                });
            }

            res.status(200).json({
                status: 'success',
                code: 200,
                message: 'Đã lưu',
                data: product
            });
        });
    });
};

exports.view = function(req, res) {
    Product.findById(req.params.id, function(err, product) {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status: 'success',
            code: 200,
            message: 'Registros encontrado',
            data: product
        })
    })
}

exports.update = function(req, res) {
    const name = req.params.name;

    Product.findOne({ name: name }, function(err, product) {
        if (err)
            res.status(500).json({
                status: 'error',
                code: 500,
                message: err
            });
        if (!product) {
            return res.status(404).json({
                status: 'error',
                code: 404,
                message: 'Không tìm thấy sản phẩm'
            });
        }

        // Cập nhật thông tin sản phẩm
        product.name = req.body.name;
        product.price = req.body.price;
        product.stock = req.body.stock;

        // Lưu sản phẩm đã cập nhật vào cơ sở dữ liệu
        product.save(function(err, updatedProduct) {
            if (err)
                res.status(500).json({
                    status: 'error',
                    code: 500,
                    message: err
                });
            res.status(200).json({
                status: 'success',
                code: 200,
                message: 'Sản phẩm đã được cập nhật',
                data: updatedProduct
            });
        });
    });
};



exports.delete = function(req, res) {
    const name = req.params.name;

    Product.deleteOne({
        name: name
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
                message: 'Sản phẩm đã được xóa'
            });
    });
};
