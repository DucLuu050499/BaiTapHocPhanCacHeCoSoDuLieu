/*– Hàm đơn trị (Scalar Function).
– Hàm đọc bảng (Inline Table-Valued Function).
– Hàm tạo bảng (Multi-Statement Table-Valued Function).*/
USE QLDDH_LuuAnhDuc_3118410088
GO

--a. Viết lại câu 5a bằng cách dùng 
CREATE FUNCTION udf_SoLuong_HangHoa(@maddh char(5),@mahh char(5))
RETURNS INT
AS
BEGIN 
DECLARE @soluong int
IF NOT EXISTS (SELECT *
				FROM DonDatHang
				WHERE MaDat=@maddh)
				return -1
				SET @soluong=0
				SELECT @soluong=SLDat
				FROM ChiTietDatHang
				WHERE MaHH=@mahh AND MaDat=@maddh
				return @soluong
END
print dbo.udf_SoLuong_HangHoa('DH01','BU')
--b. Viết lại câu 5b bằng cách dùng Function
CREATE FUNCTION udf_TongTien_PhieuGiao(@mapg char(10))
RETURNS money
AS
BEGIN
DECLARE @tongtien money
--Kiểm tra @mapg tồn tại chưa, nếu chưa tồn tại return -1
IF NOT EXISTS( SELECT *
FROM ChiTietGiaoHang
WHERE MaGiao=@mapg )
RETURN -1
--Nếu @mapg truyền vào tồn tại thì return tổng tiền
SELECT @tongtien= SUM(SLGiao * DonGiaGiao)
FROM dbo.ChiTietGiaoHang
WHERE MaGiao = @mapg
RETURN @tongtien
END
PRINT  dbo.udf_TongTien_PhieuGiao('GH01')
--c. Viết lại câu 5c bằng 2 hàm: hàm trả về Inline Table và hàm trả về Multi-statement Table
CREATE FUNCTION udf_DonDatHang_KhachHang(@makh char(10))
RETURNS TABLE AS RETURN
(
SELECT ddh.MaDat,NgayDat,MaGiao,NgayGiao
	FROM (KhachHang kh inner join DonDatHang ddh on kh.MaKH=ddh.MaKH) inner join PhieuGiaoHang pgh on ddh.MaDat=pgh.MaDat
	WHERE kh.MaKH=@makh

);
SELECT * FROM udf_DonDatHang_KhachHang('KH001')

CREATE FUNCTION udf_DonDatHang_KhachHang2(@makh char(5))
RETURNS @bang TABLE (
MaKH CHAR(5), 
MaDat char(10),
NgayDat smalldatetime,
MaGiao char(4),
NgayGiao smalldatetime)
AS
BEGIN
INSERT INTO @bang
SELECT kh.MaKH, ddh.MaDat,NgayDat,MaGiao,NgayGiao
	FROM (KhachHang kh inner join DonDatHang ddh on kh.MaKH=ddh.MaKH) inner join PhieuGiaoHang pgh on ddh.MaDat=pgh.MaDat
	WHERE kh.MaKH=@makh
	RETURN
END
--DROP FUNCTION udf_DonDatHang_KhachHang2
select * from udf_DonDatHang_KhachHang2('KH001')

--d. Viết lại câu 5d bằng cách dùng Function
CREATE FUNCTION udf_SoLuong_PhieuGiaoHang(@ngay1 date,@ngay2 date)
RETURNS INT
AS 
BEGIN
	DECLARE @soluong smallint
	SET @soluong=0
	SELECT @soluong=count(MaGiao)
	FROM PhieuGiaoHang
	WHERE CAST(NgayGiao AS DATE) BETWEEN @ngay1 and @ngay2
	RETURN @soluong
END
print dbo.udf_SoLuong_PhieuGiaoHang('2012-01-23','2012-04-20')
