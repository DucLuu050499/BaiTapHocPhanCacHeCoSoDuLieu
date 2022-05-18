CREATE DATABASE QLDDH_LuuAnhDuc
GO
USE QLDDH_LuuAnhDuc
GO
CREATE TABLE HangHoa
(
	MaHH  CHAR(5),
	TenHH NVARCHAR(50),
	DVT   NVARCHAR(20),
	SLCon smallint,
	DonGiaHH int, 
	Constraint pk_HH Primary Key (MaHH)
)
GO
CREATE TABLE DonDatHang
(
	MaDat char(10),
	NgayDat smalldatetime,
	MaKH CHAR(5),
	TinhTrang bit,
	Constraint pk_DDH Primary Key (MaDat)
)
GO
CREATE TABLE ChiTietDatHang
(	MaDat char(10),
	MaHH  CHAR(5),
	SLDat smallint,
	Constraint pk_CTDH Primary Key (MaDat,MaHH)
)
GO
CREATE TABLE KhachHang
(
	MaKH CHAR(5),
	TenKH NVARCHAR(50),
	DiaChi NVARCHAR(100),
	DienTHoai VARCHAR(12),
	Constraint pk_KH Primary Key (MaKH)
)
GO
CREATE TABLE PhieuGiaoHang
(
	MaGiao char(4),
	NgayGiao smalldatetime,
	MaDat char(10),
	Constraint pk_PGH Primary Key (MaGiao)
)
GO
CREATE TABLE ChiTietGiaoHang
(
	MaGiao char(4),
	MaHH  CHAR(5),
	SLGiao smallint,
	DonGiaGiao int,
	Constraint pk_CTGH Primary Key (MaGiao,MaHH)
)
GO
CREATE TABLE LichSuGia
(
	MaHH  CHAR(5),
	NgayHL smalldatetime,
	DonGia int,
	Constraint pk_LSG Primary Key (MaHH,NgayHL)
)
GO
ALTER TABLE ChiTietDatHang
ADD Constraint fk_CTDH_MaDat Foreign Key (MaDat) references DonDatHang (MaDat)
									on update cascade on delete cascade,
	Constraint fk_CTDH_MaHH Foreign Key (MaHH) references HangHoa (MaHH)
									on update cascade on delete cascade
ALTER TABLE ChiTietGiaoHang
ADD Constraint fk_CTGH_MaGiao Foreign Key (MaGiao) references PhieuGiaoHang (MaGiao)
									on update cascade on delete cascade,
	Constraint fk_CTGH_MaHH Foreign Key (MaHH) references HangHoa (MaHH)
									on update cascade on delete cascade
ALTER TABLE DonDatHang
ADD Constraint fk_DDH_MaKH Foreign Key (MaKH) references KhachHang (MaKH)
									on update cascade on delete cascade
ALTER TABLE LichSuGia
ADD Constraint fk_LSG_MaHH Foreign Key (MaHH) references HangHoa (MaHH)
									on update cascade on delete cascade	
ALTER TABLE PhieuGiaoHang
ADD Constraint fk_PGH_MaDat Foreign Key (MaDat) references DonDatHang (MaDat)
									on update cascade on delete cascade


--1 b,c
ALTER TABLE HangHoa
ADD CONSTRAINT SLCon_kiemtra 
	CHECK (SLCon >= 0),
	CONSTRAINT TenHH_kiemtra
	UNIQUE(TenHH);
--1d
ALTER TABLE DonDatHang
ADD CONSTRAINT NgayDat_kiemtra
	  DEFAULT GETDATE() FOR NgayDat;
--1e
DROP TABLE KhachHang;
-- Không th? xóa b?ng ???c vì nó có s? bu?c c?a khóa chính khách hàng v?i khóa ngo?i ??n ??t hàng.
--Mu?n xóa ???c ta ph?i xóa ràng bu?c c?a khóa chính khóa ngo?i ??n ??t hàng v?i khách hàng (fk_DDH_MaKH).
--1f
--xoa cot dia chi
ALTER TABLE KhachHang
DROP COLUMN DiaChi;
--them cot dia chi
ALTER TABLE KhachHang
 ADD DiaChi nvarchar(100)
 CONSTRAINT DiaChi_macdinh
    DEFAULT '?à N?ng'
WITH VALUES 
--1g
--xóa ràng bu?c
ALTER TABLE PhieuGiaoHang
DROP CONSTRAINT fk_PGH_MaDat
--them ràng bu?c
ALTER TABLE PhieuGiaoHang
ADD Constraint fk_PGH_MaDat Foreign Key (MaDat) references DonDatHang (MaDat)
									on update cascade on delete cascade

--1h
INSERT INTO HangHoa
VALUES ('BU',N'Bàn ?i Philip',N'Cái',60,350000)
INSERT INTO HangHoa
VALUES ('CD',N'N?i c?m ?i?n Sharp',N'Cái',100,700000)
INSERT INTO HangHoa
VALUES ('DM',N'??u máy Sharp',N'Cái',75,1200000)
INSERT INTO HangHoa
VALUES ('MG',N'Máy gi?t SanYo',N'Cái',10,4700000)
INSERT INTO HangHoa
VALUES ('MQ',N'Máy qu?t ASIA',N'Cái',40,400000)
INSERT INTO HangHoa
VALUES ('TL',N'T? l?nh Hitachi',N'Cái',50,5500000)
INSERT INTO HangHoa
VALUES ('TV',N'TiVi JVC 14WS',N'Cái',33,7800000)

INSERT INTO KhachHang
VALUES ('KH001',N'C?a hàng Phúc L?c',N'?à N?ng','0511.3246135')
INSERT INTO KhachHang
VALUES ('KH002',N'C?a hàng Hoàng Gia',N'Qu?ng Nam','0510.6333444')
INSERT INTO KhachHang
VALUES ('KH003',N'C?a hàng Nguy?n Lan Anh',N'Hu?','0988.148248')
INSERT INTO KhachHang
VALUES ('KH004',N'Công ty TNHH An Ph??c',N'?à N?ng','0511.6987789')
INSERT INTO KhachHang
VALUES ('KH005',N'Hu?nh Ng?c Trung',N'Qu?ng Nam','0905.888555')
INSERT INTO KhachHang
VALUES ('KH006',N'C?a hàng Trung Tín',N'?à N?ng','')

INSERT INTO LichSuGia
VALUES ('BU','2011/01/01',300000)
INSERT INTO LichSuGia
VALUES ('BU','2012/01/01',350000)
INSERT INTO LichSuGia
VALUES ('CD','2011/01/06',650000)
INSERT INTO LichSuGia
VALUES ('CD','2012/01/01',700000)
INSERT INTO LichSuGia
VALUES ('DM','2011/01/01',1000000)
INSERT INTO LichSuGia
VALUES ('DM','2012/01/01',1200000)
INSERT INTO LichSuGia
VALUES ('MG','2011/01/01',4700000)
INSERT INTO LichSuGia
VALUES ('MQ','2011/01/06',400000)
INSERT INTO LichSuGia
VALUES ('TL','2011/01/01',5000000)
INSERT INTO LichSuGia
VALUES ('TL','2012/01/01',5500000)
INSERT INTO LichSuGia
VALUES ('TV','2012/01/01',7800000)

INSERT INTO DonDatHang
VALUES ('DH01','2011/02/02','KH001',1)
INSERT INTO DonDatHang
VALUES ('DH02','2011/02/12','KH003',1)
INSERT INTO DonDatHang
VALUES ('DH03','2012/01/22','KH003',1)
INSERT INTO DonDatHang
VALUES ('DH04','2012/03/22','KH002',0)
INSERT INTO DonDatHang
VALUES ('DH05','2012/04/12','KH005',1)
INSERT INTO DonDatHang
VALUES ('DH06','2012/08/05','KH003',1)
INSERT INTO DonDatHang
VALUES ('DH07','2012/11/25','KH005',0)

INSERT INTO PhieuGiaoHang
VALUES ('GH01','2011/02/02','DH01')
INSERT INTO PhieuGiaoHang
VALUES ('GH02','2011/02/15','DH02')
INSERT INTO PhieuGiaoHang
VALUES ('GH03','2012/01/03','DH03')
INSERT INTO PhieuGiaoHang
VALUES ('GH05','2012/04/20','DH05')
INSERT INTO PhieuGiaoHang
VALUES ('GH06','2012/08/05','DH06')

INSERT INTO ChiTietDatHang
VALUES ('DH01','BU',15)
INSERT INTO ChiTietDatHang
VALUES ('DH01','DM',10)
INSERT INTO ChiTietDatHang
VALUES ('DH01','TL',4)
INSERT INTO ChiTietDatHang
VALUES ('DH02','BU',20)
INSERT INTO ChiTietDatHang
VALUES ('DH02','TL',3)
INSERT INTO ChiTietDatHang
VALUES ('DH03','MG',8)
INSERT INTO ChiTietDatHang
VALUES ('DH04','TL',5)
INSERT INTO ChiTietDatHang
VALUES ('DH04','TV',5)
INSERT INTO ChiTietDatHang
VALUES ('DH05','BU',12)
INSERT INTO ChiTietDatHang
VALUES ('DH05','DM',15)
INSERT INTO ChiTietDatHang
VALUES ('DH05','MG',6)
INSERT INTO ChiTietDatHang
VALUES ('DH05','TL',5)
INSERT INTO ChiTietDatHang
VALUES ('DH06','BU',30)
INSERT INTO ChiTietDatHang
VALUES ('DH06','MG',7)

INSERT INTO ChiTietGiaoHang
VALUES ('GH01','BU',15,300000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH01','BM',10,1000000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH01','TL',4,5000000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH02','BU',10,300000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH03','MG',8,4700000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH05','BU',12,350000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH05','DM',15,1200000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH05','MG',5,4700000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH05','TL',5,5500000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH06','BU',20,350000)
INSERT INTO ChiTietGiaoHang
VALUES ('GH06','MG',7,4700000)