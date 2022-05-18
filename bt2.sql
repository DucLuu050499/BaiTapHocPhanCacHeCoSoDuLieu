USE QLDDH_LuuAnhDuc_3118410088
GO
--2A
SELECT TenHH,SLGiao,DonGiaGiao
FROM (PhieuGiaoHang pg inner join ChiTietGiaoHang ctg on pg.MaGiao = ctg.MaGiao) inner join HangHoa hh on ctg.MaHH = hh.MaHH
WHERE MaDat='DH01'

--2B
SELECT MaDat,NgayDat,TenKH
FROM DonDatHang ddh inner join KhachHang kh on ddh.MaKH=kh.MaKH
WHERE TinhTrang = 0

--2c
SELECT TenHH,DonGiaHH
FROM HangHoa
WHERE DonGiaHH IN (
SELECT MAX(DonGiaHH)
FROM HangHoa
)

--3D
SELECT kh.MaKH,TenKH, COUNT(ddh.MaKH) AS "So lan dat"
FROM KhachHang kh left outer join DonDatHang ddh on kh.MaKH=ddh.MaKH
GROUP BY kh.MaKH,TenKH

--3E
SELECT pgh.MaGiao,NgayGiao, SUM(SLGiao * DonGiaGiao) AS "Tong tien "
FROM PhieuGiaoHang pgh inner join ChiTietGiaoHang ctg on pgh.MaGiao=ctg.MaGiao
WHERE YEAR(NgayGiao) ='2012'
GROUP BY pgh.MaGiao,NgayGiao

--3f
SELECT kh.MaKH,TenKH, COUNT(ddh.MaKH) AS "So lan dat"
FROM KhachHang kh inner join DonDatHang ddh on kh.MaKH=ddh.MaKH
GROUP BY kh.MaKH,TenKH
HAVING COUNT(ddh.MaKH) >= 2

--3g?
SELECT hh.MaHH,TenHH, SUM(SLGiao) AS "Tong so luong da giao"
FROM HangHoa hh inner join ChiTietGiaoHang ctg on hh.MaHH=ctg.MaHH
GROUP BY hh.MaHH,TenHH
HAVING SUM(SLGiao) >=ALL (SELECT SUM(SLGiao)
FROM HangHoa hh inner join ChiTietGiaoHang ctg on hh.MaHH=ctg.MaHH
GROUP BY hh.MaHH,TenHH
 )

--3H
UPDATE HangHoa
SET SLCon = SLCon + 10
WHERE LEFT(MaHH,1) ='M'

--2J
UPDATE KhachHang
SET DienThoai=0824264181
WHERE MaKH='KH006'

--2K
UPDATE DonDatHang
SET TinhTrang = NULL

--2L
ALTER TABLE ChiTietGiaoHang
ADD ThanhTien int ;
GO
UPDATE ChiTietGiaoHang
SET Thanhtien=SLGiao * DonGiaGiao

--2I?
CREATE TABLE HangHoa_copy
(
	MaHH  CHAR(5),
	TenHH NVARCHAR(50),
	DVT   NVARCHAR(20),
	SLCon smallint,
	DonGiaHH int, 
	Constraint pk_HHCP Primary Key (MaHH)
)
GO
INSERT INTO HangHoa_copy SELECT * FROM HangHoa

DELETE FROM HangHoa  
WHERE NOT EXISTS (SELECT MaHH FROM  ChiTietDatHang  WHERE MaHH=HangHoa.MaHH)

INSERT INTO HangHoa SELECT * FROM HangHoa_copy
WHERE NOT EXISTS (SELECT MaHH FROM  ChiTietDatHang  WHERE MaHH=HangHoa_copy.MaHH)

