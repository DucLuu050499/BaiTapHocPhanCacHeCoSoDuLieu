USE QLDDH_LuuAnhDuc_3118410088
GO
/*a. Cài đặt ràng buộc sau bằng 2 cách: constraint và trigger
“Số lượng còn của hàng hóa phải >0*/
--constraint
ALTER TABLE HangHoa
ADD CONSTRAINT  check_SoLuong_HangHoa CHECK (SLCon > 0)
GO
--trigger
CREATE TRIGGER trg_SoLuong_HangHoa
ON HangHoa
AFTER INSERT , UPDATE
AS
	DECLARE @mahh char(5),@slcon smallint
	IF NOT EXISTS (SELECT * FROM deleted)
	BEGIN 
		
		SELECT @mahh = MaHH ,@slcon = SLCon
		FROM inserted

		SELECT @slcon = SLCon
		FROM HangHoa
		WHERE MaHH = @mahh
		IF @slcon < 0
		BEGIN
			RAISERROR (N'Số lượng còn của hàng hóa phải >0',16,1)
			ROLLBACK
			RETURN
		END
	END
	ELSE
	BEGIN
		IF UPDATE (SLCon)
		BEGIN 
			SELECT @mahh = MaHH ,@slcon = SLCon
			FROM inserted

			SELECT @slcon = SLCon
			FROM HangHoa
			WHERE MaHH = @mahh
			IF @slcon < 0
			BEGIN
				RAISERROR (N'Số lượng còn của hàng hóa phải >0',16,1)
				ROLLBACK
				RETURN
			END
		END
	END
GO
drop TRIGGER trg_SoLuong_HangHoa
GO
/*b. Cài đặt ràng buộc sau bằng 2 cách: constraint và trigger
“Đơn vị tính của hàng hóa chỉ nhận một trong các giá trị: Cái, Thùng, Chiếc, Chai, Lon”*/
--constraint 
ALTER TABLE HangHoa
ADD CONSTRAINT ckeck_DVT_HH CHECK(DVT='Cái'or DVT='Thùng'or DVT='Chai'or DVT='Lon')
GO
--trigger
CREATE TRIGGER trg_DVT_HH
ON HangHoa
AFTER INSERT, UPDATE
AS
	DECLARE @mahh char(5),@dvt nvarchar(20)
	IF NOT EXISTS (SELECT * FROM deleted)
	BEGIN
 		SELECT @mahh = MaHH, @dvt = DVT
		FROM inserted

		SELECT @dvt = DVT
		FROM HangHoa
		WHERE MaHH=@mahh
		IF(@dvt !='Cái' or @dvt != 'Thùng'or @dvt!='Chai' or @dvt!= 'Lon')
		BEGIN 
			RAISERROR (N'Đơn vị tính của hàng hóa chỉ nhận một trong các giá trị: Cái, Thùng, Chiếc, Chai, Lon',16,1)
			ROLLBACK
			RETURN
		END
	END
	ELSE
	BEGIN
		IF UPDATE(DVT)
		BEGIN
 			SELECT @mahh = MaHH, @dvt = DVT
			FROM inserted

			SELECT @dvt = DVT
			FROM HangHoa
			WHERE MaHH=@mahh
			IF(@dvt !='Cái' or @dvt != 'Thùng'or @dvt!='Chai' or @dvt!= 'Lon')
			BEGIN 
				RAISERROR (N'Đơn vị tính của hàng hóa chỉ nhận một trong các giá trị: Cái, Thùng, Chiếc, Chai, Lon',16,1)
				ROLLBACK
				RETURN
			END
		END
	END
GO
--c. Cài đặt ràng buộc: “Mỗi đơn đặt hàng chỉ có tối đa 1 phiếu giao hàng”
CREATE TRIGGER trg_DDH_1PDH
ON DonDatHang
AFTER INSERT , UPDATE
AS
	DECLARE @madat char(10),@tinhtang bit
	IF NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		SELECT @madat = MADat,@tinhtang = TinhTrang
		FROM inserted
		
		SELECT @tinhtang=TinhTrang
		FROM DonDatHang
		WHERE MaDat=@madat
		IF(@tinhtang >1)
		BEGIN
			RAISERROR (N'Mỗi đơn đặt hàng chỉ có tối đa 1 phiếu giao hàng',16,1)
			ROLLBACK
			RETURN
		END
	END
	ELSE
		BEGIN
			IF UPDATE(TinhTrang)
			BEGIN
				SELECT @madat = MADat,@tinhtang = TinhTrang
				FROM inserted
		
				SELECT @tinhtang=TinhTrang
				FROM DonDatHang
				WHERE MaDat=@madat
				IF(@tinhtang >1)
				BEGIN
					RAISERROR (N'Mỗi đơn đặt hàng chỉ có tối đa 1 phiếu giao hàng',16,1)
					ROLLBACK
					RETURN
				END
			END
		END

GO
/*d. Cài đặt ràng buộc: “Ngày giao hàng phải bằng hoặc sau ngày đặt hàng nhưng không được quá 30
ngày”*/
CREATE TRIGGER trg_NgayGiao_NgayDat
ON PhieuGiaoHang
AFTER INSERT, UPDATE
AS
	DECLARE @madat char(10),@ngaygiao datetime,@ngaydat datetime
--Trường hợp thêm mới
	IF NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		SELECT @madat = MaDat,@ngaygiao = NgayGiao
		FROM inserted

		SELECT @ngaydat = NgayDat
		FROM DonDatHang
		WHERE MaDat=@madat
		IF @ngaygiao<@ngaydat
		BEGIN
			RAISERROR (N'Ngày giao phải sau ngày đặt',16,1)
			ROLLBACK
			RETURN
		END
		IF DATEDIFF(DD, @ngaydat, @ngaygiao)> 30
		BEGIN
			RAISERROR (N'Ngày giao - ngày đặt <= 30 ngày',16,1)
			ROLLBACK
			RETURN
		END
	END
	ELSE
-- Trường hợp sửa
	BEGIN
		IF UPDATE(NgayGiao)
		BEGIN
			SELECT @madat = MaDat,@ngaygiao = NgayGiao
			FROM inserted
			SELECT @ngaydat = NgayDat
			FROM DonDatHang
			WHERE MaDat=@madat
			IF @ngaygiao<@ngaydat
			BEGIN
				RAISERROR (N'Ngày giao phải sau ngày đặt',16,1)
				ROLLBACK
				RETURN
			END
			IF DATEDIFF(DD, @ngaydat, @ngaygiao)> 30
			BEGIN
				RAISERROR (N'Ngày giao - ngày đặt <= 30 ngày',16,1)
				ROLLBACK
				RETURN
			END
		END
	END
GO


/*f. Cài đặt ràng buộc: “Số lượng hàng hóa được giao không được lớn hơn số lượng hàng hóa được
đặt tương ứng”*/
CREATE TRIGGER trg_SLHHGiao_SLHHDat
ON ChiTietGiaoHang
AFTER INSERT, UPDATE
AS
	DECLARE @madat char(10),@sldat smallint,@magiao char(4),@slgiao smallint
	IF NOT EXISTS(SELECT * FROM deleted)
	BEGIN
		SELECT @magiao= MaGiao ,@slgiao=SLGiao 
		from inserted

		SELECT @sldat=SLDat
		from ChiTietDatHang ctd inner join PhieuGiaoHang pgh on ctd.MaDat=pgh.MaDat
		WHERE pgh.MaDat=@madat and MaGiao =@magiao
		IF (@slgiao>@sldat)
		BEGIN
			RAISERROR (N'Số lượng hàng hóa được giao không được lớn hơn số lượng hàng hóa đượcđặt tương ứng',16,1)
			ROLLBACK
			RETURN
		END
	END 
	ELSE
	BEGIN
		IF UPDATE(SLGiao)
		BEGIN
			SELECT @magiao= MaGiao ,@slgiao=SLGiao 
			from inserted

			SELECT @sldat=SLDat
			from ChiTietDatHang ctd inner join PhieuGiaoHang pgh on ctd.MaDat=pgh.MaDat
			WHERE pgh.MaDat=@madat and MaGiao =@magiao
			IF (@slgiao>@sldat)
			BEGIN
				RAISERROR (N'Số lượng hàng hóa được giao không được lớn hơn số lượng hàng hóa đượcđặt tương ứng',16,1)
				ROLLBACK
				RETURN
			END
		END
	END
GO
