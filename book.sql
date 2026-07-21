CREATE DATABASE BookStore;
GO

USE BookStore;
GO

-- ==========================
-- XÓA BẢNG NẾU ĐÃ TỒN TẠI
-- ==========================
IF OBJECT_ID('HoaDonChiTiet','U') IS NOT NULL DROP TABLE HoaDonChiTiet;
IF OBJECT_ID('HoaDon','U') IS NOT NULL DROP TABLE HoaDon;
IF OBJECT_ID('Sach_TacGia','U') IS NOT NULL DROP TABLE Sach_TacGia;
IF OBJECT_ID('SachChiTiet','U') IS NOT NULL DROP TABLE SachChiTiet;
IF OBJECT_ID('Sach','U') IS NOT NULL DROP TABLE Sach;
IF OBJECT_ID('TacGia','U') IS NOT NULL DROP TABLE TacGia;
IF OBJECT_ID('KhachHang','U') IS NOT NULL DROP TABLE KhachHang;
IF OBJECT_ID('NhaXuatBan','U') IS NOT NULL DROP TABLE NhaXuatBan;
IF OBJECT_ID('TheLoai','U') IS NOT NULL DROP TABLE TheLoai;
IF OBJECT_ID('KhuyenMai','U') IS NOT NULL DROP TABLE KhuyenMai;
IF OBJECT_ID('TaiKhoan','U') IS NOT NULL DROP TABLE TaiKhoan;
IF OBJECT_ID('NhanVien','U') IS NOT NULL DROP TABLE NhanVien;
IF OBJECT_ID('TrangThaiNhanVien','U') IS NOT NULL DROP TABLE TrangThaiNhanVien;
IF OBJECT_ID('PhanQuyen','U') IS NOT NULL DROP TABLE PhanQuyen;
GO

-- ==========================
-- PHÂN QUYỀN & TRẠNG THÁI
-- ==========================
CREATE TABLE PhanQuyen (
    MaPhanQuyen INT IDENTITY(1,1) PRIMARY KEY,
    TenQuyen NVARCHAR(50) UNIQUE NOT NULL,
    MoTa NVARCHAR(255)
);

CREATE TABLE TrangThaiNhanVien (
    MaTrangThai INT PRIMARY KEY,
    TenTrangThai NVARCHAR(50)
);

-- ==========================
-- NHÂN VIÊN & TÀI KHOẢN
-- ==========================
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DiaChi NVARCHAR(255),
    MaTrangThai INT,
    CCCD VARCHAR(20) UNIQUE,
    NgayCapCCCD DATE,
    DacDiemNhanDang NVARCHAR(200),
    CONSTRAINT FK_NhanVien_TrangThai FOREIGN KEY (MaTrangThai) REFERENCES TrangThaiNhanVien(MaTrangThai)
);

CREATE TABLE TaiKhoan (
    MaTK INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PASS VARCHAR(255) NOT NULL,
    MaNV INT UNIQUE,
    MaPhanQuyen INT,
    CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_TaiKhoan_PhanQuyen FOREIGN KEY (MaPhanQuyen) REFERENCES PhanQuyen(MaPhanQuyen)
);

-- ==========================
-- THỂ LOẠI, NXB, TÁC GIẢ, KHUYẾN MÃI
-- ==========================
CREATE TABLE TheLoai (
    MaTheLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenTheLoai NVARCHAR(100) UNIQUE,
    MoTa NVARCHAR(255)
);

CREATE TABLE NhaXuatBan (
    MaNXB INT IDENTITY(1,1) PRIMARY KEY,
    TenNXB NVARCHAR(150),
    SDT VARCHAR(15),
    Email VARCHAR(100),
    DiaChi NVARCHAR(255)
);

CREATE TABLE TacGia (
    MaTacGia INT IDENTITY(1,1) PRIMARY KEY,
    TenTacGia NVARCHAR(100) NOT NULL
);

CREATE TABLE KhuyenMai (
    MaKM INT IDENTITY(1,1) PRIMARY KEY,
    TenKM NVARCHAR(100) NOT NULL,
    PhanTramGiam FLOAT NOT NULL, -- 0 - 100
    NgayBatDau DATETIME,
    NgayKetThuc DATETIME,
    TrangThai INT DEFAULT 1 -- 1: Hoạt động, 0: Vô hiệu
);

-- ==========================
-- SÁCH VÀ CHI TIẾT
-- ==========================
CREATE TABLE Sach (
    MaSach INT IDENTITY(1,1) PRIMARY KEY,
    MaISBN VARCHAR(50) UNIQUE NOT NULL,
    TenSach NVARCHAR(200) NOT NULL,
    MaTheLoai INT,
    MaNXB INT,
    GiaNhap FLOAT,
    GiaBan FLOAT,
    SoLuongTon INT DEFAULT 0,
    HinhAnh NVARCHAR(MAX) DEFAULT 'default-book.png',
    TrangThai INT DEFAULT 1,
    CONSTRAINT FK_Sach_TheLoai FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai),
    CONSTRAINT FK_Sach_NhaXuatBan FOREIGN KEY (MaNXB) REFERENCES NhaXuatBan(MaNXB)
);

CREATE TABLE SachChiTiet (
    MaSach INT PRIMARY KEY,
    SoTrang INT,
    KichThuoc NVARCHAR(50),
    TrongLuong INT,
    NgonNgu NVARCHAR(50),
    MoTa NVARCHAR(MAX),
    CONSTRAINT FK_SachChiTiet_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE CASCADE
);

CREATE TABLE Sach_TacGia (
    MaSach INT,
    MaTacGia INT,
    PRIMARY KEY (MaSach, MaTacGia),
    CONSTRAINT FK_SachTacGia_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE CASCADE,
    CONSTRAINT FK_SachTacGia_TacGia FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE
);


-- KHÁCH HÀNG & BÁN HÀNG
-- ==========================
CREATE TABLE KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100),
    SDT VARCHAR(15) UNIQUE,
    Email VARCHAR(100),
    DiaChi NVARCHAR(255)
);

CREATE TABLE HoaDon (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    NgayTao DATETIME DEFAULT GETDATE(),
    MaNV INT,
    MaKH INT,
    TongTien FLOAT,
    TrangThai INT DEFAULT 0, -- 1: Đã TT, 0: Chờ TT, 2: Hủy
    GiamGia FLOAT DEFAULT 0,
    MaKM INT, -- Mới: Khóa ngoại liên kết KhuyenMai
    PhuongThucTT NVARCHAR(50),
    CONSTRAINT FK_HoaDon_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_HoaDon_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_HoaDon_KhuyenMai FOREIGN KEY (MaKM) REFERENCES KhuyenMai(MaKM)
);

CREATE TABLE HoaDonChiTiet (
    MaHDCT INT IDENTITY(1,1) PRIMARY KEY,
    MaHD INT,
    MaSach INT,
    SoLuong INT,
    DonGia FLOAT,
    CONSTRAINT FK_HoaDonChiTiet_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    CONSTRAINT FK_HoaDonChiTiet_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
);
GO

-- ==========================
-- DỮ LIỆU MẪU BAN ĐẦU
-- ==========================
INSERT INTO PhanQuyen(TenQuyen, MoTa) VALUES 
(N'admin', N'Quản trị hệ thống'),
(N'nhanvien', N'Nhân viên bán hàng');

INSERT INTO TrangThaiNhanVien(MaTrangThai, TenTrangThai) VALUES 
(1, N'Đang làm việc'),
(2, N'Nghỉ việc');

INSERT INTO NhanVien (MaNV, HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, MaTrangThai, CCCD, NgayCapCCCD, DacDiemNhanDang) VALUES
(1, N'Nguyễn Văn Quản', '1995-05-20', N'Nam', '0901234567', 'admin@gmail.com', N'Hà Nội', 1, '001122334455', '2020-01-01', N'Không'),
(2, N'Trần Văn A', '1998-08-12', N'Nam', '0908888888', 'nv@gmail.com', N'Hải Phòng', 1, '009988776655', '2020-01-01', N'Không');

INSERT INTO TaiKhoan (Username, PASS, MaNV, MaPhanQuyen) VALUES
('admin', '123', 1, 1),
('nhanvien', '123', 2, 2);

INSERT INTO TheLoai(TenTheLoai, MoTa) VALUES
(N'Công nghệ', N'Sách CNTT'),
(N'Văn học', N'Truyện');

INSERT INTO NhaXuatBan (TenNXB, SDT, Email, DiaChi) VALUES
(N'NXB Trẻ', '028123456', 'tre@gmail.com', N'TP Hồ Chí Minh'),
(N'NXB Kim Đồng', '024123456', 'kimdong@gmail.com', N'Hà Nội');

INSERT INTO TacGia(TenTacGia) VALUES
(N'John Doe'), (N'Nam Cao'), (N'Vũ Trọng Phụng');

INSERT INTO KhuyenMai(TenKM, PhanTramGiam, NgayBatDau, NgayKetThuc, TrangThai) VALUES
(N'Khai trương', 10, '2020-01-01', '2030-12-31', 1),
(N'Lễ Tết', 20, '2020-01-01', '2030-12-31', 1);

INSERT INTO Sach (MaISBN, TenSach, MaTheLoai, MaNXB, GiaNhap, GiaBan, SoLuongTon, HinhAnh, TrangThai) VALUES
('9786041234567', N'Lập trình Java', 1, 1, 120000, 180000, 50, 'default-book.png', 1),
('9786048888888', N'Java Web JSP Servlet', 1, 2, 150000, 220000, 40, 'default-book.png', 1);

INSERT INTO SachChiTiet(MaSach, SoTrang, KichThuoc, TrongLuong, NgonNgu, MoTa) VALUES
(1, 650, '14x20 cm', 500, N'Tiếng Việt', N'Sách Java cơ bản'),
(2, 720, '15x21 cm', 600, N'Tiếng Việt', N'Hướng dẫn JSP Servlet');

INSERT INTO Sach_TacGia(MaSach, MaTacGia) VALUES
(1, 1), (2, 1);

INSERT INTO KhachHang (HoTen, SDT, Email, DiaChi) VALUES
(N'Khách lẻ', '0000000000', '', N'Tại cửa hàng'),
(N'Nguyễn Văn B', '0911222333', 'b@gmail.com', N'Hà Nội');
GO

ALTER LOGIN sa WITH PASSWORD = '123';
GO
ALTER LOGIN sa ENABLE;
GO
