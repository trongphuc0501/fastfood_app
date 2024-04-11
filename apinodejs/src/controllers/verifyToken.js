// Import thư viện 'jsonwebtoken' vào trong file
const jwt = require('jsonwebtoken');
// Import module 'config' từ một file khác trong dự án
const config = require('../config');

// Khai báo một middleware function có tên là verifyToken
async function verifyToken(req, res, next) {
    // Trích xuất token từ header của request
    const token = req.headers['x-access-token'];
    // Kiểm tra xem token có tồn tại hay không
    if (!token) {
        // Nếu không có token, trả về một response với mã status 401 (Unauthorized) và thông điệp 'No token provided'
        return res.status(401).send({ auth: false, message: 'No token provided' });
    }
    // Giải mã token bằng cách sử dụng phương thức verify từ thư viện jsonwebtoken
    // Đối số đầu tiên là token cần giải mã, đối số thứ hai là secret key được sử dụng để tạo token
    const decoded = await jwt.verify(token, config.secret);
    // Gán id của người dùng từ thông tin được giải mã vào thuộc tính userId của đối tượng req
    req.userId = decoded.id;
    // Gọi hàm next() để chuyển quyền điều khiển tới middleware hoặc route handler tiếp theo trong stack middleware
    next();
}

// Xuất module verifyToken để có thể sử dụng trong các route khác
module.exports = verifyToken;
