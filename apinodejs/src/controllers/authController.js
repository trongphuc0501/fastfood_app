const { Router } = require('express');
const router = Router();

const User = require('../models/userModel');
const verifyToken = require('./verifyToken');
const jwt = require('jsonwebtoken');
const config = require('../config');
const productController = require('../controllers/productController');

// Định nghĩa endpoint POST '/signup' để đăng ký người dùng mới
router.post('/signup', async (req, res) => {
    try {
        // Nhận dữ liệu từ yêu cầu
        const { username, email, password, diachi, chucvu } = req.body;

        // Kiểm tra xem email đã tồn tại trong cơ sở dữ liệu hay chưa
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(409).send('Email đã tồn tại');
        }

        // Tạo một người dùng mới
        const newUser = new User({
            username,
            email,
            password,
            diachi,
            chucvu,
        });

        // Mã hóa mật khẩu người dùng
        newUser.password = await newUser.encryptPassword(password);

        // Lưu người dùng vào cơ sở dữ liệu
        await newUser.save();

        // Tạo mã token
        const token = jwt.sign({ id: newUser.id }, config.secret, {
            expiresIn: 60 * 60 * 24 // Hết hạn sau 24 giờ
        });

        // Trả về token trong phản hồi
        res.json({ auth: true, token });

    } catch (error) {
        console.error(error);
        res.status(500).send('Có vấn đề trong quá trình đăng ký người dùng');
    }
});

// Endpoint cho các hoạt động liên quan đến sản phẩm
router.route('/products')
    .get(productController.index) // Lấy danh sách sản phẩm
    .post(productController.new); // Tạo sản phẩm mới

// Endpoint cho một sản phẩm cụ thể dựa trên id
router.route('/product/:id')
    .get(productController.view) // Xem thông tin sản phẩm
    .put(productController.update) // Cập nhật thông tin sản phẩm
    .delete(productController.delete); // Xóa sản phẩm

// Định nghĩa endpoint POST '/signin' để xác thực người dùng
router.post('/signin', async(req, res) => {
    try {
        // Tìm người dùng trong cơ sở dữ liệu dựa trên email
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            return res.status(404).send("Email không tồn tại")
        }
        // Xác minh mật khẩu
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword) {
            return res.status(401).send({ auth: false, token: null });
        }
        // Tạo mã token
        const token = jwt.sign({ id: user._id }, config.secret, {
            expiresIn: '24h'
        });
        // Trả về token trong phản hồi
        res.status(200).json({ auth: true, token });
    } catch (e) {
        console.log(e)
        res.status(500).send('Có vấn đề trong quá trình đăng nhập');
    }
});

// Định nghĩa endpoint POST '/products' để tạo sản phẩm mới
/*
router.post('/products', async (req, res) => {
    try {
        // Nhận dữ liệu từ yêu cầu
        const { name, price, stock, gt } = req.body;

        // Tạo một sản phẩm mới
        const product = new Product({
            name,
            price,
            stock,
            gt,
        });

        // Lưu sản phẩm vào cơ sở dữ liệu
        await product.save();

        // Trả về sản phẩm đã được tạo trong phản hồi
        res.json(product);
    } catch (e) {
        console.log(e);
        res.status(500).send('Có vấn đề trong quá trình tạo sản phẩm');
    }
});
*/
// Định nghĩa endpoint GET '/dashboard' để hiển thị trang dashboard
router.get('/dashboard', (req, res) => {
    res.json('dashboard');
});

// Định nghĩa endpoint GET '/logout' để đăng xuất người dùng
router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});
//
router.get('/users', async (req, res) => {
    try {
        // Lấy danh sách người dùng từ cơ sở dữ liệu
        const users = await User.find();
        res.json(users); // Trả về danh sách người dùng dưới dạng JSON
    } catch (e) {
        console.log(e);
        res.status(500).send('Có vấn đề trong quá trình lấy danh sách người dùng');
    }
});

// Xuất router để sử dụng trong các module khác của ứng dụng
module.exports = router;
