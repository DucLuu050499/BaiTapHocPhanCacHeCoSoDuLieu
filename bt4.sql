USE QLDDH_LuuAnhDuc_3118410088
GO
--5a
CREATE PROC sp_SoLuong_HangHoa
@maddh char(10),@mahh char(10),@soluong int OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT *
					FROM DonDatHang,HangHoa
					WHERE MaDat=@maddh AND MaHH=@mahh)
		RETURN 0
	SELECT @soluong=SUM(SLDat)
	FROM (ChiTietDatHang ctd inner join HangHoa hh on ctd.MaHH=hh.MaHH) inner join DonDatHang ddh on ddh.MaDat=ctd.MaDat
	WHERE ctd.MaHH=@mahh AND ddh.MaDat=@maddh
	return 1
END
DECLARE @sl int
DECLARE @kq tinyint
EXEC @kq = sp_SoLuong_HangHoa 'BU' ,'DH01', @sl output
IF @kq=0
	PRINT N'Mã đơn đặt hàng  và mã khách hàng không tồn tại'
ELSE
	PRINT N'Số lượng là:' + cast(@sl as nvarchar(20))

--5b
CREATE PROC sp_TongTien_PhieuGiao
@mapg char(10), @tongtien money OUTPUT
AS
BEGIN
--Kiểm tra @mapg tồn tại chưa, nếu chưa tồn tại return 0
	IF NOT EXISTS(  SELECT *
					FROM ChiTietGiaoHang
					WHERE MaGiao=@mapg )
	RETURN 0
--Nếu @mapg truyền vào tồn tại thì return 1
	SELECT @tongtien= SUM(SLGiao * DonGiaGiao)
	FROM dbo.ChiTietGiaoHang
	WHERE MaGiao = @mapg
RETURN 1
END
-- Gọi thủ tục vừa tạo
DECLARE @tt money
DECLARE @kq tinyint
EXEC @kq = sp_TongTien_PhieuGiao 'GH0001', @tt OUTPUT
IF @kq=0
	PRINT N'Mã giao hàng không tồn tại'
ELSE
	PRINT N'Tổng tiền là:' + cast(@tt as nvarchar(20))

--5c
CREATE PROC sp_DonDatHang_KhachHang
@makh char(10)
AS
BEGIN
	IF NOT EXISTS ( SELECT *
					FROM KhachHang
					WHERE MaKH=@makh)
		RETURN 0
END

DECLARE @kq tinyint
EXEC @kq = sp_DonDatHang_KhachHang 'KH001'
IF @kq = 0
	PRINT N'Không tồn tại mã khách hàng'
ELSE SELECT ddh.MaDat,NgayDat,MaGiao,NgayGiao
	FROM (KhachHang kh inner join DonDatHang ddh on kh.MaKH=ddh.MaKH) inner join PhieuGiaoHang pgh on ddh.MaDat=pgh.MaDat
	WHERE kh.MaKH=@makh

--DROP PROC sp_DonDatHang_KhachHang 

--5d
CREATE PROC sp_SoLuong_PhieuGiaoHang
@ngaygiao datetime,@soluong int OUTPUT
AS 
BEGIN 
	IF NOT EXISTS (SELECT @ngaygiao
					FROM PhieuGiaoHang
					WHERE DAY(@ngaygiao)=01 OR DAY(@ngaygiao)=02)
		RETURN 0
		SELECT @soluong=SUM(SLGiao)
		FROM ChiTietGiaoHang ctg inner join PhieuGiaoHang pg on ctg.MaGiao=pg.MaGiao
		WHERE DAY(@ngaygiao)=01 OR DAY(@ngaygiao)=02
		RETURN 1
END
DECLARE @sl int 
DECLARE @kq tinyint
EXEC @kq = sp_SoLuong_PhieuGiaoHang '01',@sl output
EXEC @kq = sp_SoLuong_PhieuGiaoHang '02',@sl output
IF @kq = 0 
	PRINT N'Ngày giao không tông tại'
else PRINT  N'Số lần giao ' + cast(@sl as nvarchar(3))
--drop proc sp_SoLuong_PhieuGiaoHang

--5f
/*CREATE PROC sp_Insert_HangHoa
@mahh char(10),@tenhh char(50),@dvt char(5),@soluong int=0,@dongia money=0
as 
begin 
	IF NOT EXISTS (SELECT * FROM HangHoa WHERE MaHH=@mahh)
	return */