USE QLDDH_LuuAnhDuc_3118410088
GO

--3a
CREATE VIEW vw_DoanhSoGiaoHang_6thang
as
	SELECT hh.MaHH,TenHH,SUM(SLGiao*DonGiaGiao) AS TongTien
	FROM (PhieuGiaoHang pg inner join ChiTietGiaoHang ctg on pg.MaGiao=ctg.MaGiao) inner join HangHoa hh on ctg.MaHH=hh.MaHH
	WHERE MONTH(NgayGiao) between 1 and 6 and YEAR(NgayGiao)=2012
	GROUP BY hh.MaHH,TenHH

SELECT * FROM vw_DoanhSoGiaoHang_6thang

--3b
CREATE VIEW vw_TongSLDDHLN
as 
	SELECT hh.MaHH,TenHH,SUM(SLDat) AS TongSoLuong
	FROM (HangHoa hh inner join ChiTietDatHang ctd on hh.MaHH=ctd.MaHH) inner join DonDatHang ddh on ctd.MaDat=ddh.MaDat
	WHERE YEAR(NgayDat)=2012
	GROUP BY hh.MaHH,TenHH
	HAVING SUM(SLDat) >=ALL (SELECT SUM(SLDat) 
	FROM (HangHoa hh inner join ChiTietDatHang ctd on hh.MaHH=ctd.MaHH) inner join DonDatHang ddh on ctd.MaDat=ddh.MaDat
	WHERE YEAR(NgayDat)=2012
	GROUP BY hh.MaHH,TenHH
	 )

SELECT * FROM vw_TongSLDDHLN

--3c
CREATE VIEW vw_DSKH
AS 
	SELECT * 
	FROM KhachHang
	WHERE DiaChi=N'Đà Nẵng'
	WITH CHECK OPTION

	INSERT INTO vw_DSKH
	VALUES ('KH007',N'Cửa Hàng Phú Lộc',N'Đà Nẵng','0511.3246135')
	INSERT INTO vw_DSKH
	VALUES ('KH008',N'Cửa Hàng Hoàng Gia',N'Quảng Nam','0510.6333444')
	--trường hợp chèn khách hàng có địa chỉ đà nẵng thì có thể thêm vào được bảng do nó cùng với điều kiện 
	--trường hợp chèn khách hàng có địa chỉ quảng nam thì khồng thể chèn vào được nó báo lổi vì khác với điều kiện địa chỉ ở câu lệnh trên khi có WITH CHECK OPTION
SELECT * FROM vw_DSKH

--cau4a
ALTER TABLE PhieuGiaoHang
ADD TongTien money
GO

--Khai báo biến cursor, các biến cục bộ
DECLARE @magiao char(4), @tongtien  int
DECLARE cur_PG CURSOR
FORWARD_ONLY
FOR
	SELECT MaGiao FROM PhieuGiaoHang
OPEN cur_PG
--Đọc dữ liệu và cập nhập giá trị
FETCH NEXT FROM cur_PG INTO @magiao
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tongtien = SUM(SLGiao*DonGiaGiao)
	FROM ChiTietGiaoHang
	WHERE MaGiao = @magiao

	PRINT N'Đang cập nhật phiếu giao:' + @magiao
	UPDATE PhieuGiaoHang
	SET   TongTien = @tongtien
	WHERE MaGiao=@magiao
	FETCH NEXT FROM cur_PG INTO @magiao
END
CLOSE cur_PG
DEALLOCATE cur_PG

--4b
ALTER TABLE KhachHang
ADD THUONG_2012 money
GO
DECLARE @makh char(5),@madat char(4),@tongtien int,@ngaygiao smalldatetime,@nam int,@tenhh char(50),@thuong money set @nam = year(@ngaygiao)
DECLARE CUR_KH CURSOR
FORWARD_ONLY
FOR
	SELECT kh.MaKH,pg.MaDat,TongTien,NgayGiao,TenHH FROM ((KhachHang kh inner join DonDatHang ddh on kh.MaKH=ddh.MaKH) INNER JOIN 
	(PhieuGiaoHang pg inner join ChiTietGiaoHang ctg on pg.MaGiao=ctg.MaGiao) on ddh.MaDat = pg.MaDat ) 
	inner join HangHoa hh on hh.MaHH=ctg.MaHH 

OPEN CUR_KH
FETCH NEXT FROM CUR_KH INTO @makh,@madat,@tongtien,@ngaygiao,@tenhh
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @tongtien >50000000 AND @nam='2012'
	SET @thuong=3000000
	ELSE IF @tongtien >35000000 and @nam='2012' and @tenhh like N'Máy giặc%'
	SET @thuong=2000000
	ELSE IF @nam ='2011' and @nam='2012'
	SET @thuong=1000000
	ELSE SET @thuong=0
	PRINT N'Đang cập nhật:' + @makh
	UPDATE KhachHang
	set THUONG_2012=@thuong
	WHERE MaKH = @makh
	FETCH NEXT FROM CUR_KH INTO @makh,@madat,@tongtien,@ngaygiao,@tenhh
END
CLOSE CUR_KH
DEALLOCATE CUR_KH

